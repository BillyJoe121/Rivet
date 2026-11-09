import '../repositories/auth_repository.dart';

/// Caso de uso: Cierre de la sesión activa del usuario.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}

