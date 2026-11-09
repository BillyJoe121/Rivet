import '../../../../../core/models/models.dart';
import '../../../domain/entities/rivet_user.dart';

enum SignUpStatus { initial, loading, success, failure }

/// Estado del bloque de registro.
class SignUpState {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.role = UserRole.client,
    this.user,
    this.errorMessage,
  });

  final SignUpStatus status;
  final UserRole role;
  final RivetUser? user;
  final String? errorMessage;

  bool get isLoading => status == SignUpStatus.loading;
  bool get isSuccess => status == SignUpStatus.success;
  bool get isFailure => status == SignUpStatus.failure;

  SignUpState copyWith({
    SignUpStatus? status,
    UserRole? role,
    RivetUser? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      status: status ?? this.status,
      role: role ?? this.role,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

