import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/models.dart';
import '../../domain/estimate_materials_usecase.dart';
import '../../domain/project_draft.dart';
import '../../domain/project_draft_repository.dart';
import '../../domain/publish_project_wizard_usecase.dart';
import 'project_wizard_event.dart';
import 'project_wizard_state.dart';

export 'project_wizard_event.dart';
export 'project_wizard_state.dart';

/// BLoC que gobierna el asistente de 5 pasos de creación/edición de proyecto.
class ProjectWizardBloc extends Bloc<ProjectWizardEvent, ProjectWizardState> {
  ProjectWizardBloc({
    required this.draftRepository,
    required this.estimateMaterialsUseCase,
    required this.publishProjectWizardUseCase,
  }) : super(const ProjectWizardState()) {
    on<WizardInitialized>(_onInitialized);
    on<WizardBasicsChanged>(_onBasicsChanged);
    on<WizardSurfaceAdded>(_onSurfaceAdded);
    on<WizardSurfaceRemoved>(_onSurfaceRemoved);
    on<WizardPhotoAdded>(_onPhotoAdded);
    on<WizardPhotoRemoved>(_onPhotoRemoved);
    on<WizardPhotoToggled>(_onPhotoToggled);
    on<WizardAiConsentChanged>(_onAiConsentChanged);
    on<WizardMaterialQuantityChanged>(_onMaterialQuantityChanged);
    on<WizardStepChangeRequested>(_onStepChangeRequested);
    on<WizardNextStepRequested>(_onNextStepRequested);
    on<WizardPreviousStepRequested>(_onPreviousStepRequested);
    on<WizardPublishRequested>(_onPublishRequested);
    on<WizardErrorDismissed>(_onErrorDismissed);
  }

  final ProjectDraftRepository draftRepository;
  final EstimateMaterialsUseCase estimateMaterialsUseCase;
  final PublishProjectWizardUseCase publishProjectWizardUseCase;

  void _onInitialized(
    WizardInitialized event,
    Emitter<ProjectWizardState> emit,
  ) {
    final existing = event.initialProject;
    final saved = draftRepository.loadDraft(projectId: existing?.id);
    var draft = saved ??
        (existing != null
            ? ProjectDraft.fromProject(existing)
            : const ProjectDraft());

    if (draft.materials.isEmpty) {
      final estimated = estimateMaterialsUseCase(draft.surfaces);
      draft = draft.copyWith(
        materials: estimated,
        budgetEstimateCop: draft.budgetEstimateCop > 0
            ? draft.budgetEstimateCop
            : estimated.fold<int>(0, (a, b) => a + b.subtotalCop) +
                  draft.recommendedLaborCop,
      );
    }

    draftRepository.saveDraft(draft);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: draft,
        initialProject: existing,
        clearError: true,
      ),
    );
  }

  void _onBasicsChanged(
    WizardBasicsChanged event,
    Emitter<ProjectWizardState> emit,
  ) {
    final nextMaterialsBudget =
        event.materialsBudgetCop ?? state.draft.materialsBudgetCop;
    final nextLaborBudget =
        event.laborBudgetCop ?? state.draft.laborBudgetCop;
    final computedTotal =
        (nextMaterialsBudget ?? state.draft.materialsTotalCop) +
        (nextLaborBudget ?? state.draft.recommendedLaborCop);
    final updated = state.draft.copyWith(
      title: event.title,
      description: event.description,
      city: event.city,
      neighborhood: event.neighborhood,
      materialsBudgetCop: nextMaterialsBudget,
      laborBudgetCop: nextLaborBudget,
      budgetEstimateCop: event.budgetEstimateCop ?? computedTotal,
    );
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onSurfaceAdded(
    WizardSurfaceAdded event,
    Emitter<ProjectWizardState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty || event.widthMeters <= 0 || event.heightMeters <= 0) {
      emit(
        state.copyWith(
          status: ProjectWizardStatus.failure,
          errorMessage: 'Ingresa nombre y medidas válidas para la superficie.',
        ),
      );
      return;
    }

    final surfaces = [
      ...state.draft.surfaces,
      SurfaceItem(
        id: 's-${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        widthMeters: event.widthMeters,
        heightMeters: event.heightMeters,
        finishType: event.finishType,
      ),
    ];
    final materials = estimateMaterialsUseCase(surfaces);
    final updated = state.draft.copyWith(
      surfaces: surfaces,
      materials: materials,
    );
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onSurfaceRemoved(
    WizardSurfaceRemoved event,
    Emitter<ProjectWizardState> emit,
  ) {
    if (state.draft.surfaces.length <= 1) {
      emit(
        state.copyWith(
          status: ProjectWizardStatus.failure,
          errorMessage: 'El proyecto debe tener al menos una superficie.',
        ),
      );
      return;
    }
    final surfaces = [...state.draft.surfaces]..removeAt(event.index);
    final materials = estimateMaterialsUseCase(surfaces);
    final updated = state.draft.copyWith(
      surfaces: surfaces,
      materials: materials,
    );
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onPhotoAdded(
    WizardPhotoAdded event,
    Emitter<ProjectWizardState> emit,
  ) {
    final path = event.photoPath.trim();
    if (path.isEmpty) return;
    final current = [...state.draft.photoAssets, path];
    final updated = state.draft.copyWith(photoAssets: current);
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onPhotoRemoved(
    WizardPhotoRemoved event,
    Emitter<ProjectWizardState> emit,
  ) {
    if (state.draft.photoAssets.length <= 1) {
      emit(
        state.copyWith(
          status: ProjectWizardStatus.failure,
          errorMessage: 'Conserva al menos una foto de las superficies.',
        ),
      );
      return;
    }
    final current = [...state.draft.photoAssets]..removeAt(event.index);
    final updated = state.draft.copyWith(photoAssets: current);
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onPhotoToggled(
    WizardPhotoToggled event,
    Emitter<ProjectWizardState> emit,
  ) {
    final current = [...state.draft.photoAssets];
    if (current.contains(event.assetPath)) {
      if (current.length <= 1) {
        emit(
          state.copyWith(
            status: ProjectWizardStatus.failure,
            errorMessage: 'Conserva al menos una foto de referencia.',
          ),
        );
        return;
      }
      current.remove(event.assetPath);
    } else {
      current.add(event.assetPath);
    }
    final updated = state.draft.copyWith(photoAssets: current);
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onAiConsentChanged(
    WizardAiConsentChanged event,
    Emitter<ProjectWizardState> emit,
  ) {
    final updated = state.draft.copyWith(aiReviewAuthorized: event.authorized);
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onMaterialQuantityChanged(
    WizardMaterialQuantityChanged event,
    Emitter<ProjectWizardState> emit,
  ) {
    final updatedList = <ProjectMaterial>[];
    for (final item in state.draft.materials) {
      if (item.productId == event.productId) {
        if (event.quantity > 0) {
          updatedList.add(item.withQuantity(event.quantity));
        }
      } else {
        updatedList.add(item);
      }
    }
    final newMatsTotal = updatedList.fold<int>(
      0,
      (sum, item) => sum + item.subtotalCop,
    );
    final updated = state.draft.copyWith(
      materials: updatedList,
      materialsBudgetCop: newMatsTotal,
      budgetEstimateCop: newMatsTotal + state.draft.effectiveLaborBudgetCop,
    );
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  String? _validateCurrentStep(int step, ProjectDraft draft) {
    if (step == 0) {
      if (draft.title.trim().isEmpty) {
        return 'Ingresa un título para el proyecto.';
      }
      if (draft.city.trim().isEmpty) {
        return 'Ingresa la ciudad del proyecto.';
      }
      if (draft.neighborhood.trim().isEmpty) {
        return 'Ingresa el barrio o sector.';
      }
    } else if (step == 1 && draft.surfaces.isEmpty) {
      return 'Agrega al menos una superficie.';
    } else if (step == 2 && draft.photoAssets.isEmpty) {
      return 'Toma al menos una foto de las superficies.';
    }
    return null;
  }

  void _onStepChangeRequested(
    WizardStepChangeRequested event,
    Emitter<ProjectWizardState> emit,
  ) {
    final target = event.targetStep.clamp(
      0,
      ProjectWizardState.stepLabels.length - 1,
    );
    if (target > state.draft.currentStep) {
      final error = _validateCurrentStep(state.draft.currentStep, state.draft);
      if (error != null) {
        emit(
          state.copyWith(
            status: ProjectWizardStatus.failure,
            errorMessage: error,
          ),
        );
        return;
      }
    }
    final updated = state.draft.copyWith(currentStep: target);
    draftRepository.saveDraft(updated);
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        draft: updated,
        clearError: true,
      ),
    );
  }

  void _onNextStepRequested(
    WizardNextStepRequested event,
    Emitter<ProjectWizardState> emit,
  ) {
    final current = state.draft.currentStep;
    final error = _validateCurrentStep(current, state.draft);
    if (error != null) {
      emit(
        state.copyWith(
          status: ProjectWizardStatus.failure,
          errorMessage: error,
        ),
      );
      return;
    }
    if (current < ProjectWizardState.stepLabels.length - 1) {
      final updated = state.draft.copyWith(currentStep: current + 1);
      draftRepository.saveDraft(updated);
      emit(
        state.copyWith(
          status: ProjectWizardStatus.editing,
          draft: updated,
          clearError: true,
        ),
      );
    }
  }

  void _onPreviousStepRequested(
    WizardPreviousStepRequested event,
    Emitter<ProjectWizardState> emit,
  ) {
    final current = state.draft.currentStep;
    if (current > 0) {
      final updated = state.draft.copyWith(currentStep: current - 1);
      draftRepository.saveDraft(updated);
      emit(
        state.copyWith(
          status: ProjectWizardStatus.editing,
          draft: updated,
          clearError: true,
        ),
      );
    }
  }

  Future<void> _onPublishRequested(
    WizardPublishRequested event,
    Emitter<ProjectWizardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProjectWizardStatus.publishing,
        clearError: true,
      ),
    );
    try {
      final saved = await publishProjectWizardUseCase(
        draft: state.draft,
        originalProject: state.initialProject,
      );
      emit(
        state.copyWith(
          status: ProjectWizardStatus.published,
          publishedProject: saved,
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: ProjectWizardStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  void _onErrorDismissed(
    WizardErrorDismissed event,
    Emitter<ProjectWizardState> emit,
  ) {
    emit(
      state.copyWith(
        status: ProjectWizardStatus.editing,
        clearError: true,
      ),
    );
  }
}
