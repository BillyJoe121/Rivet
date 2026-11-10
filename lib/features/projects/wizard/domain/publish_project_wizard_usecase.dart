import '../../../../core/models/models.dart';
import '../../domain/errors/project_failure.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/update_project_usecase.dart';
import 'project_draft.dart';
import 'project_draft_repository.dart';

/// Publica un proyecto nuevo o guarda los cambios de uno existente desde el asistente (P-015).
class PublishProjectWizardUseCase {
  const PublishProjectWizardUseCase({
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.draftRepository,
  });

  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final ProjectDraftRepository draftRepository;

  Future<Project> call({
    required ProjectDraft draft,
    Project? originalProject,
  }) async {
    final title = draft.title.trim();
    final city = draft.city.trim();
    final neighborhood = draft.neighborhood.trim();

    if (title.isEmpty) {
      throw const ProjectFailure('Ingresa un título para el proyecto.');
    }
    if (city.isEmpty) {
      throw const ProjectFailure('Ingresa la ciudad del proyecto.');
    }
    if (neighborhood.isEmpty) {
      throw const ProjectFailure('Ingresa el barrio o sector.');
    }
    if (draft.surfaces.isEmpty) {
      throw const ProjectFailure('Agrega al menos una superficie.');
    }
    if (draft.photoAssets.isEmpty) {
      throw const ProjectFailure(
        'Selecciona al menos una foto de las superficies.',
      );
    }

    final budget = draft.budgetEstimateCop > 0
        ? draft.budgetEstimateCop
        : draft.recommendedTotalBudgetCop;
    final cleanMaterials = draft.materials
        .where((m) => m.quantity > 0)
        .toList(growable: false);

    if (originalProject != null) {
      final updated = originalProject.copyWith(
        title: title,
        description: draft.description.trim(),
        city: city,
        neighborhood: neighborhood,
        surfaces: draft.surfaces,
        budgetEstimateCop: budget,
        imageAsset: draft.photoAssets.first,
        photoAssets: draft.photoAssets,
        materials: cleanMaterials,
        aiReviewAuthorized: draft.aiReviewAuthorized,
      );
      final saved = await updateProjectUseCase(updated);
      draftRepository.clearDraft(projectId: originalProject.id);
      return saved;
    }

    final created = await createProjectUseCase(
      title: title,
      description: draft.description.trim(),
      city: city,
      neighborhood: neighborhood,
      surfaces: draft.surfaces,
      budgetEstimateCop: budget,
      imageAsset: draft.photoAssets.first,
    );

    final enriched = created.copyWith(
      photoAssets: draft.photoAssets,
      materials: cleanMaterials,
      aiReviewAuthorized: draft.aiReviewAuthorized,
      budgetEstimateCop: budget,
    );
    final saved = await updateProjectUseCase(enriched);
    draftRepository.clearDraft();
    return saved;
  }
}
