import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rivet/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:rivet/features/auth/presentation/bloc/auth/auth_bloc.dart';

class FakeSessionAuthRepository implements AuthRepository {
  final _controller = StreamController<RivetUser?>.broadcast();
  RivetUser? currentUser;
  bool signOutCalled = false;

  @override
  Future<RivetUser?> getCurrentUser() async => currentUser;

  @override
  Stream<RivetUser?> get authStateChanges => _controller.stream;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    currentUser = null;
    _controller.add(null);
  }

  void emitUser(RivetUser? user) {
    currentUser = user;
    _controller.add(user);
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
  Future<void> sendPasswordResetEmail(String email) async {}
}

void main() {
  late FakeSessionAuthRepository repo;
  late AuthBloc bloc;

  setUp(() {
    repo = FakeSessionAuthRepository();
    bloc = AuthBloc(
      GetCurrentUserUseCase(repo),
      SignOutUseCase(repo),
    );
  });

  tearDown(() => bloc.close());

  test('estado inicial es AuthStatus.initial', () {
    expect(bloc.state.status, AuthStatus.initial);
  });

  test('AuthCheckRequested emite [loading, authenticated] cuando hay usuario previo', () async {
    final user = const RivetUser(
      id: 'stored-1',
      email: 'juan@rivet.com',
      fullName: 'Juan Propietario',
      role: UserRole.client,
    );
    repo.currentUser = user;

    bloc.add(const AuthCheckRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.authenticated)
            .having((s) => s.user?.email, 'email', 'juan@rivet.com'),
      ]),
    );
  });

  test('AuthCheckRequested emite [loading, unauthenticated] cuando no hay sesión', () async {
    repo.currentUser = null;
    bloc.add(const AuthCheckRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.unauthenticated),
      ]),
    );
  });

  test('AuthSignOutRequested cierra la sesión y emite unauthenticated', () async {
    bloc.add(const AuthSignOutRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.unauthenticated),
      ]),
    );

    expect(repo.signOutCalled, isTrue);
  });
}

