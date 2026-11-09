import '../entities/rivet_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: Consulta del usuario actualmente autenticado y su perfil.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<RivetUser?> call() => _repository.getCurrentUser();

  Stream<RivetUser?> get authStateChanges => _repository.authStateChanges;
}

