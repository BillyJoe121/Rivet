import '../repositories/auth_repository.dart';

/// Caso de uso: Envío de correo de recuperación de contraseña.
class SendPasswordResetUseCase {
  const SendPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) => _repository.sendPasswordResetEmail(email);
}

