import '../../../../core/models/models.dart';
import '../repositories/project_repository.dart';

/// Caso de uso: Consultar los proyectos del usuario autenticado.
class GetMyProjectsUseCase {
  const GetMyProjectsUseCase(this._repository);

  final ProjectRepository _repository;

  Future<List<Project>> call({ProjectStatus? status}) {
    return _repository.getMyProjects(status: status);
  }
}

