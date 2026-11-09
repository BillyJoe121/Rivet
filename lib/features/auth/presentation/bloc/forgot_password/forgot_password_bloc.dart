import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_password_reset_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

export 'forgot_password_event.dart';
export 'forgot_password_state.dart';

/// Manejador de estado con BLoC para la pantalla de recuperación de contraseña.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._sendPasswordResetUseCase)
      : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
    on<ForgotPasswordEditRequested>(_onEditRequested);
    on<ForgotPasswordErrorDismissed>(_onErrorDismissed);
  }

  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: ForgotPasswordStatus.loading,
      clearError: true,
    ));

    try {
      await _sendPasswordResetUseCase(event.email);
    } catch (_) {
      // Principio OWASP: confirmar visualmente el envío para mitigar enumeración de cuentas.
    }

    emit(state.copyWith(
      status: ForgotPasswordStatus.success,
      sentToEmail: event.email,
    ));
  }

  void _onEditRequested(
    ForgotPasswordEditRequested event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(
      status: ForgotPasswordStatus.initial,
      clearError: true,
    ));
  }

  void _onErrorDismissed(
    ForgotPasswordErrorDismissed event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}

