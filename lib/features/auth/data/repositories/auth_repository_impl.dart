import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';
import '../../domain/entities/rivet_user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/supabase_auth_data_source.dart';

/// Implementación del repositorio de autenticación para Rivet.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final SupabaseAuthDataSource _dataSource;

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    try {
      return await _dataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signIn(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw AuthFailure(
        'No pudimos enviar el correo de recuperación. Revisa tu conexión e intenta de nuevo.',
      );
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _dataSource.updatePassword(newPassword);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(
        'No pudimos actualizar tu contraseña: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<RivetUser?> getCurrentUser() async {
    final user = _dataSource.currentAuthUser;
    if (user == null) return null;
    return await _dataSource.getProfile(user.id);
  }

  @override
  Stream<RivetUser?> get authStateChanges {
    return _dataSource.onAuthStateChange.asyncMap((state) async {
      final user = state.session?.user;
      if (user == null) return null;
      return await _dataSource.getProfile(user.id);
    });
  }

  @override
  Stream<void> get onPasswordRecovery {
    return _dataSource.onAuthStateChange
        .where((state) => state.event == AuthChangeEvent.passwordRecovery)
        .map((_) {});
  }

  /// Mapea códigos de error de Supabase a mensajes claros en español.
  AuthFailure _mapAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return const AuthFailure('Correo o contraseña incorrectos. Verifica tus datos.');
    }
    if (msg.contains('user already registered') ||
        msg.contains('user_already_exists')) {
      return const AuthFailure('Ya existe una cuenta registrada con este correo electrónico.');
    }
    if (msg.contains('password should be at least')) {
      return const AuthFailure('La contraseña no cumple con los requisitos mínimos de seguridad.');
    }
    if (e.statusCode == '429' ||
        msg.contains('rate limit') ||
        msg.contains('for security purposes')) {
      return const AuthFailure(
        'Se enviaron demasiados correos en poco tiempo. Espera unos minutos e intenta de nuevo.',
      );
    }
    if (msg.contains('email not confirmed')) {
      return const AuthFailure('Por favor confirma tu correo electrónico antes de ingresar.');
    }
    return AuthFailure(e.message);
  }
}
