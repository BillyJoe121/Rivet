import '../../../../core/models/models.dart';
import '../repositories/project_repository.dart';

/// Caso de uso: Consultar el expediente completo de un proyecto.
class GetProjectDetailUseCase {
  const GetProjectDetailUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Project> call(String projectId) {
    return _repository.getProjectDetail(projectId);
  }
}

