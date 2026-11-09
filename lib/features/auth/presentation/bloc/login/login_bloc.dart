import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/sign_in_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

export 'login_event.dart';
export 'login_state.dart';

/// Manejador de estado con BLoC para la pantalla de inicio de sesión.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._signInUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginErrorDismissed>(_onErrorDismissed);
  }

  final SignInUseCase _signInUseCase;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));
    try {
      final user = await _signInUseCase(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        status: LoginStatus.success,
        user: user,
      ));
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: cleanMessage,
      ));
    }
  }

  void _onErrorDismissed(
    LoginErrorDismissed event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}

