import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/models.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

export 'signup_event.dart';
export 'signup_state.dart';

/// Manejador de estado con BLoC para la pantalla de registro.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(
    this._signUpUseCase, {
    UserRole initialRole = UserRole.client,
  }) : super(SignUpState(role: initialRole)) {
    on<SignUpRoleChanged>(_onRoleChanged);
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpErrorDismissed>(_onErrorDismissed);
  }

  final SignUpUseCase _signUpUseCase;

  void _onRoleChanged(
    SignUpRoleChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(role: event.role));
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: SignUpStatus.loading, clearError: true));
    try {
      final user = await _signUpUseCase(
        email: event.email,
        password: event.password,
        fullName: event.name,
        role: event.role,
        phone: event.phone,
      );
      emit(state.copyWith(
        status: SignUpStatus.success,
        user: user,
      ));
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: cleanMessage,
      ));
    }
  }

  void _onErrorDismissed(
    SignUpErrorDismissed event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}

