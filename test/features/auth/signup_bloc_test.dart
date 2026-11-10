import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/errors/auth_failure.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:rivet/features/auth/presentation/bloc/signup/signup_bloc.dart';

class FakeSignUpAuthRepository implements AuthRepository {
  final _controller = StreamController<RivetUser?>.broadcast();
  Exception? errorToThrow;

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    return RivetUser(
      id: 'new-user-123',
      email: email,
      fullName: fullName,
      role: role,
      phone: phone,
    );
  }

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

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
  late FakeSignUpAuthRepository repo;
  late SignUpBloc bloc;

  setUp(() {
    repo = FakeSignUpAuthRepository();
    bloc = SignUpBloc(SignUpUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('estado inicial con rol cliente por defecto', () {
    expect(bloc.state.status, SignUpStatus.initial);
    expect(bloc.state.role, UserRole.client);
    expect(bloc.state.user, isNull);
    expect(bloc.state.errorMessage, isNull);
  });

  test('SignUpRoleChanged actualiza el rol en el estado', () async {
    bloc.add(const SignUpRoleChanged(UserRole.contractor));

    await expectLater(
      bloc.stream,
      emits(
        isA<SignUpState>().having((s) => s.role, 'role', UserRole.contractor),
      ),
    );
  });

  test('emite [loading, success] tras un registro válido', () async {
    bloc.add(
      const SignUpSubmitted(
        name: 'Carlos Pintor',
        email: 'carlos@obra.co',
        phone: '3001234567',
        password: 'Password123!',
        role: UserRole.contractor,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SignUpState>().having(
          (s) => s.status,
          'status',
          SignUpStatus.loading,
        ),
        isA<SignUpState>()
            .having((s) => s.status, 'status', SignUpStatus.success)
            .having((s) => s.user?.fullName, 'fullName', 'Carlos Pintor')
            .having((s) => s.user?.role, 'role', UserRole.contractor),
      ]),
    );
  });

  test('emite [loading, failure] cuando el correo ya existe', () async {
    repo.errorToThrow = const AuthFailure(
      'Ya existe una cuenta registrada con este correo electrónico.',
    );

    bloc.add(
      const SignUpSubmitted(
        name: 'Carlos Pintor',
        email: 'carlos@obra.co',
        phone: '3001234567',
        password: 'Password123!',
        role: UserRole.contractor,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SignUpState>().having(
          (s) => s.status,
          'status',
          SignUpStatus.loading,
        ),
        isA<SignUpState>()
            .having((s) => s.status, 'status', SignUpStatus.failure)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Ya existe una cuenta registrada con este correo electrónico.',
            ),
      ]),
    );
  });
}

