import '../../../../core/models/models.dart';
import '../errors/project_failure.dart';
import '../repositories/project_repository.dart';

/// Caso de uso: guardar los cambios de un proyecto existente.
class UpdateProjectUseCase {
  const UpdateProjectUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Project> call(Project project) async {
    if (project.title.trim().isEmpty) {
      throw const ProjectFailure('Ingresa un título para el proyecto.');
    }
    if (project.city.trim().isEmpty) {
      throw const ProjectFailure('Selecciona la ciudad del proyecto.');
    }
    if (project.neighborhood.trim().isEmpty) {
      throw const ProjectFailure('Indica el barrio o sector.');
    }
    if (project.surfaces.isEmpty) {
      throw const ProjectFailure('Agrega al menos una superficie o pared a intervenir.');
    }

    final materials =
        project.materials.where((m) => m.quantity > 0).toList(growable: false);

    return _repository.updateProject(
      project.copyWith(
        title: project.title.trim(),
        city: project.city.trim(),
        neighborhood: project.neighborhood.trim(),
        description: project.description.trim(),
        materials: materials,
      ),
    );
  }
}
