import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

/// BLoC que gobierna el ciclo de vida y la persistencia de la sesión en toda la app.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._getCurrentUserUseCase,
    this._signOutUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);

    _authSubscription = _getCurrentUserUseCase.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;
  StreamSubscription? _authSubscription;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _signOutUseCase();
    } finally {
      emit(const AuthState.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

