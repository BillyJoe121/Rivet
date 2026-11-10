import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/errors/auth_failure.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:rivet/features/auth/presentation/bloc/login/login_bloc.dart';

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<RivetUser?>.broadcast();
  RivetUser? userToReturn;
  Exception? errorToThrow;

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    return userToReturn ??
        RivetUser(
          id: 'user-1',
          email: email,
          fullName: 'Test User',
          role: UserRole.client,
        );
  }

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<RivetUser?> getCurrentUser() async => userToReturn;

  @override
  Stream<RivetUser?> get authStateChanges => _controller.stream;

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Stream<void> get onPasswordRecovery => const Stream.empty();
}

void main() {
  late FakeAuthRepository authRepo;
  late LoginBloc loginBloc;

  setUp(() {
    authRepo = FakeAuthRepository();
    loginBloc = LoginBloc(SignInUseCase(authRepo));
  });

  tearDown(() => loginBloc.close());

  test('estado inicial es LoginStatus.initial', () {
    expect(loginBloc.state.status, LoginStatus.initial);
    expect(loginBloc.state.user, isNull);
    expect(loginBloc.state.errorMessage, isNull);
  });

  test('emite [loading, success] cuando el inicio de sesión es exitoso', () async {
    loginBloc.add(
      const LoginSubmitted(
        email: 'cliente@rivet.com',
        password: 'Password123!',
      ),
    );

    await expectLater(
      loginBloc.stream,
      emitsInOrder([
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          LoginStatus.loading,
        ),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoginStatus.success)
            .having((s) => s.user?.email, 'email', 'cliente@rivet.com'),
      ]),
    );
  });

  test('emite [loading, failure] con mensaje de error cuando falla la autenticación', () async {
    authRepo.errorToThrow =
        const AuthFailure('Correo o contraseña incorrectos. Verifica tus datos.');

    loginBloc.add(
      const LoginSubmitted(
        email: 'cliente@rivet.com',
        password: 'wrong',
      ),
    );

    await expectLater(
      loginBloc.stream,
      emitsInOrder([
        isA<LoginState>().having(
          (s) => s.status,
          'status',
          LoginStatus.loading,
        ),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoginStatus.failure)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Correo o contraseña incorrectos. Verifica tus datos.',
            ),
      ]),
    );
  });

  test('LoginErrorDismissed limpia el mensaje de error', () async {
    authRepo.errorToThrow = const AuthFailure('Error temporal');
    loginBloc.add(
      const LoginSubmitted(
        email: 'cliente@rivet.com',
        password: 'wrong',
      ),
    );

    await expectLater(
      loginBloc.stream,
      emitsThrough(
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.failure),
      ),
    );

    loginBloc.add(const LoginErrorDismissed());

    await expectLater(
      loginBloc.stream,
      emits(
        isA<LoginState>().having((s) => s.errorMessage, 'errorMessage', isNull),
      ),
    );
  });
}

