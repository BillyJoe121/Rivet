enum ForgotPasswordStatus { initial, loading, success, failure }

/// Estado del bloque de recuperación de contraseña.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.sentToEmail,
    this.errorMessage,
  });

  final ForgotPasswordStatus status;
  final String? sentToEmail;
  final String? errorMessage;

  bool get isLoading => status == ForgotPasswordStatus.loading;
  bool get isSuccess => status == ForgotPasswordStatus.success;
  bool get isFailure => status == ForgotPasswordStatus.failure;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? sentToEmail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      sentToEmail: sentToEmail ?? this.sentToEmail,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

