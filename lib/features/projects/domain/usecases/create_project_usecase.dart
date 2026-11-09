import '../../../../core/models/models.dart';
import '../errors/project_failure.dart';
import '../repositories/project_repository.dart';

/// Caso de uso: Crear un nuevo proyecto con validaciones de negocio.
class CreateProjectUseCase {
  const CreateProjectUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Project> call({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw const ProjectFailure('Ingresa un título para el proyecto.');
    }

    if (city.trim().isEmpty) {
      throw const ProjectFailure('Selecciona la ciudad del proyecto.');
    }

    if (neighborhood.trim().isEmpty) {
      throw const ProjectFailure('Indica el barrio o sector.');
    }

    if (surfaces.isEmpty) {
      throw const ProjectFailure('Agrega al menos una superficie o pared a intervenir.');
    }

    return _repository.createProject(
      title: cleanTitle,
      description: description.trim(),
      city: city.trim(),
      neighborhood: neighborhood.trim(),
      surfaces: surfaces,
      budgetEstimateCop: budgetEstimateCop,
      imageAsset: imageAsset,
    );
  }
}

