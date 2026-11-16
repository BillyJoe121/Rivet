import '../../../../core/models/models.dart';
import '../repositories/project_repository.dart';

/// Obtiene los proyectos abiertos disponibles para cotizar.
class GetOpenProjectsUseCase {
  const GetOpenProjectsUseCase(this._repository);
  final ProjectRepository _repository;

  Future<List<Project>> call() => _repository.getOpenProjects();
}
