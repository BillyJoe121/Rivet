enum ResetPasswordStatus { initial, loading, success, failure }

/// Estado del bloque de restablecimiento de contraseña.
class ResetPasswordState {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  final ResetPasswordStatus status;
  final String? errorMessage;

  bool get isLoading => status == ResetPasswordStatus.loading;
  bool get isSuccess => status == ResetPasswordStatus.success;
  bool get isFailure => status == ResetPasswordStatus.failure;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

