import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/validators.dart';
import '../../../domain/usecases/update_password_usecase.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

export 'reset_password_event.dart';
export 'reset_password_state.dart';

/// Manejador de estado con BLoC para la pantalla de cambio de contraseña tras recuperación.
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(this._updatePasswordUseCase)
      : super(const ResetPasswordState()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
    on<ResetPasswordErrorDismissed>(_onErrorDismissed);
  }

  final UpdatePasswordUseCase _updatePasswordUseCase;

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final passwordError = Validators.password(event.password);
    if (passwordError != null) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: passwordError,
      ));
      return;
    }

    final confirmError =
        Validators.confirmPassword(event.confirmPassword, event.password);
    if (confirmError != null) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: confirmError,
      ));
      return;
    }

    emit(state.copyWith(
      status: ResetPasswordStatus.loading,
      clearError: true,
    ));

    try {
      await _updatePasswordUseCase(event.password);
      emit(state.copyWith(status: ResetPasswordStatus.success));
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  void _onErrorDismissed(
    ResetPasswordErrorDismissed event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
