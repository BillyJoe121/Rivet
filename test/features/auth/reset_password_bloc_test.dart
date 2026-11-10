import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:rivet/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';

class FakeUpdatePasswordAuthRepository implements AuthRepository {
  String? updatedPassword;
  Exception? errorToThrow;

  @override
  Future<void> updatePassword(String newPassword) async {
    if (errorToThrow != null) throw errorToThrow!;
    updatedPassword = newPassword;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

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
  Stream<RivetUser?> get authStateChanges => const Stream.empty();

  @override
  Stream<void> get onPasswordRecovery => const Stream.empty();
}

void main() {
  late FakeUpdatePasswordAuthRepository repo;
  late ResetPasswordBloc bloc;

  setUp(() {
    repo = FakeUpdatePasswordAuthRepository();
    bloc = ResetPasswordBloc(UpdatePasswordUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('estado inicial es ResetPasswordStatus.initial', () {
    expect(bloc.state.status, ResetPasswordStatus.initial);
    expect(bloc.state.errorMessage, isNull);
  });

  test('falla si la contraseña es menor a 8 caracteres', () async {
    bloc.add(const ResetPasswordSubmitted(
      password: 'Short1!',
      confirmPassword: 'Short1!',
    ));

    await expectLater(
      bloc.stream,
      emits(predicate<ResetPasswordState>(
        (s) =>
            s.isFailure &&
            s.errorMessage!.contains('al menos 8 caracteres'),
      )),
    );
  });

  test('falla si las contraseñas no coinciden', () async {
    bloc.add(const ResetPasswordSubmitted(
      password: 'StrongPassword1!',
      confirmPassword: 'DifferentPassword1!',
    ));

    await expectLater(
      bloc.stream,
      emits(predicate<ResetPasswordState>(
        (s) =>
            s.isFailure &&
            s.errorMessage!.contains('no coinciden'),
      )),
    );
  });

  test('emite loading y luego success si las contraseñas son válidas', () async {
    final expectedStates = [
      predicate<ResetPasswordState>((s) => s.isLoading),
      predicate<ResetPasswordState>((s) => s.isSuccess),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const ResetPasswordSubmitted(
      password: 'StrongPassword1!',
      confirmPassword: 'StrongPassword1!',
    ));

    await pumpEventQueue();
    expect(repo.updatedPassword, 'StrongPassword1!');
  });

  test('emite failure cuando el repositorio lanza excepción', () async {
    repo.errorToThrow = Exception('Error de red al actualizar');

    final expectedStates = [
      predicate<ResetPasswordState>((s) => s.isLoading),
      predicate<ResetPasswordState>(
        (s) => s.isFailure && s.errorMessage!.contains('Error de red'),
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const ResetPasswordSubmitted(
      password: 'StrongPassword1!',
      confirmPassword: 'StrongPassword1!',
    ));
  });

  test('ResetPasswordErrorDismissed limpia el mensaje de error', () async {
    bloc.add(const ResetPasswordSubmitted(
      password: 'short',
      confirmPassword: 'short',
    ));
    await pumpEventQueue();
    expect(bloc.state.isFailure, isTrue);

    bloc.add(const ResetPasswordErrorDismissed());
    await pumpEventQueue();
    expect(bloc.state.errorMessage, isNull);
  });
}
