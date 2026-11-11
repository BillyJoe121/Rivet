import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/usecases.dart';
import 'package:rivet/features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Repositorio de autenticación en memoria para pruebas de widgets.
class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({this.currentUser});

  final _controller = StreamController<RivetUser?>.broadcast();
  RivetUser? currentUser;

  static const validPassword = 'Password123!';

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    if (password != validPassword) {
      throw Exception('Correo o contraseña incorrectos. Verifica tus datos.');
    }
    final user = RivetUser(
      id: 'user-123',
      email: email,
      fullName: 'Juan Pérez',
      role: UserRole.client,
    );
    currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    final user = RivetUser(
      id: 'user-new',
      email: email,
      fullName: fullName,
      role: role,
      phone: phone,
    );
    currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> signOut() async {
    currentUser = null;
    _controller.add(null);
  }

  @override
  Future<RivetUser?> getCurrentUser() async => currentUser;

  @override
  Stream<RivetUser?> get authStateChanges => _controller.stream;

  @override
  Stream<void> get onPasswordRecovery => const Stream.empty();
}

/// Envuelve [child] con el repositorio de autenticación y el [AuthBloc] que la
/// raíz de la app inyecta en producción.
Widget withAuth(Widget child, {AuthRepository? repository}) {
  final repo = repository ?? InMemoryAuthRepository();
  return RepositoryProvider<AuthRepository>.value(
    value: repo,
    child: BlocProvider<AuthBloc>(
      create: (_) =>
          AuthBloc(GetCurrentUserUseCase(repo), SignOutUseCase(repo))
            ..add(const AuthCheckRequested()),
      child: child,
    ),
  );
}
