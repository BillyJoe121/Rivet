import '../repositories/auth_repository.dart';

/// Caso de uso: Actualización de la contraseña tras recuperación de acceso.
class UpdatePasswordUseCase {
  const UpdatePasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String newPassword) =>
      _repository.updatePassword(newPassword);
}

