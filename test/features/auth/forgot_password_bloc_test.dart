import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/errors/auth_failure.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:rivet/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';

class FakeResetAuthRepository implements AuthRepository {
  final _controller = StreamController<RivetUser?>.broadcast();
  String? lastEmailSent;
  Object? errorToThrow;

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    lastEmailSent = email;
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<RivetUser> signIn({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<RivetUser?> getCurrentUser() async => null;

  @override
  Stream<RivetUser?> get authStateChanges => _controller.stream;

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Stream<void> get onPasswordRecovery => const Stream.empty();
}

void main() {
  late FakeResetAuthRepository repo;
  late ForgotPasswordBloc bloc;

  setUp(() {
    repo = FakeResetAuthRepository();
    bloc = ForgotPasswordBloc(SendPasswordResetUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('estado inicial es ForgotPasswordStatus.initial', () {
    expect(bloc.state.status, ForgotPasswordStatus.initial);
    expect(bloc.state.sentToEmail, isNull);
  });

  test('emite [loading, success] y registra el correo enviado', () async {
    bloc.add(const ForgotPasswordSubmitted('usuario@rivet.com'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.loading,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.status, 'status', ForgotPasswordStatus.success)
            .having((s) => s.sentToEmail, 'sentToEmail', 'usuario@rivet.com'),
      ]),
    );

    expect(repo.lastEmailSent, 'usuario@rivet.com');
  });

  test('ForgotPasswordEditRequested regresa al estado initial para corregir el correo', () async {
    bloc.add(const ForgotPasswordSubmitted('usuario@rivet.com'));
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.success,
        ),
      ),
    );

    bloc.add(const ForgotPasswordEditRequested());

    await expectLater(
      bloc.stream,
      emits(
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.initial,
        ),
      ),
    );
  });

  test('emite [loading, failure] con el mensaje cuando el envío falla', () async {
    repo.errorToThrow = const AuthFailure('Se enviaron demasiados correos.');
    bloc.add(const ForgotPasswordSubmitted('usuario@rivet.com'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ForgotPasswordState>()
            .having((s) => s.status, 'status', ForgotPasswordStatus.loading),
        isA<ForgotPasswordState>()
            .having((s) => s.status, 'status', ForgotPasswordStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage',
                'Se enviaron demasiados correos.'),
      ]),
    );
  });

  test('un error inesperado muestra un mensaje genérico, no éxito', () async {
    repo.errorToThrow = Exception('socket');
    bloc.add(const ForgotPasswordSubmitted('usuario@rivet.com'));

    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<ForgotPasswordState>()
            .having((s) => s.status, 'status', ForgotPasswordStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
      ),
    );
  });
}
