import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/errors/auth_failure.dart';
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
    } catch (e) {
      // Supabase responde con éxito aunque el correo no exista, así que un
      // error aquí nunca revela si la cuenta existe (límite de envíos, red,
      // configuración). Se informa para no mostrar un envío que no ocurrió.
      debugPrint('[ForgotPasswordBloc] Error al solicitar recuperación: $e');
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: e is AuthFailure
            ? e.message
            : 'No pudimos enviar el correo de recuperación. Intenta de nuevo en unos minutos.',
      ));
      return;
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

