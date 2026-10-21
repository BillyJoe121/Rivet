import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';
import '../../domain/entities/rivet_user.dart';
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
      throw Exception('Error al solicitar recuperación: ${e.toString()}');
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

  /// Mapea códigos de error de Supabase a mensajes claros en español.
  Exception _mapAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return Exception('Correo o contraseña incorrectos. Verifica tus datos.');
    }
    if (msg.contains('user already registered') ||
        msg.contains('user_already_exists')) {
      return Exception('Ya existe una cuenta registrada con este correo electrónico.');
    }
    if (msg.contains('password should be at least')) {
      return Exception('La contraseña no cumple con los requisitos mínimos de seguridad.');
    }
    if (msg.contains('email not confirmed')) {
      return Exception('Por favor confirma tu correo electrónico antes de ingresar.');
    }
    return Exception(e.message);
  }
}
