import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/project_failure.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/get_my_projects_usecase.dart';
import '../../domain/usecases/get_project_detail_usecase.dart';
import '../../domain/usecases/update_project_usecase.dart';
import 'projects_event.dart';
import 'projects_state.dart';

export 'projects_event.dart';
export 'projects_state.dart';

/// BLoC que gobierna la creación, consulta y filtrado de proyectos.
///
/// Las cargas pasan por `loading`; los guardados usan [ProjectsState.isSubmitting]
/// para que la información ya mostrada siga en pantalla.
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(
    this._getMyProjectsUseCase,
    this._createProjectUseCase,
    this._getProjectDetailUseCase,
    this._updateProjectUseCase,
  ) : super(const ProjectsState()) {
    on<UpdateProjectSubmitted>(_onUpdateProject);
    on<LoadProjects>(_onLoadProjects);
    on<FilterProjectsByTab>(_onFilterByTab);
    on<CreateProjectSubmitted>(_onCreateProject);
    on<LoadProjectDetail>(_onLoadProjectDetail);
    on<ProjectErrorDismissed>(_onErrorDismissed);
  }

  /// Arma el Bloc con los casos de uso sobre [repository].
  factory ProjectsBloc.fromRepository(ProjectRepository repository) {
    return ProjectsBloc(
      GetMyProjectsUseCase(repository),
      CreateProjectUseCase(repository),
      GetProjectDetailUseCase(repository),
      UpdateProjectUseCase(repository),
    );
  }

  static const _genericError =
      'Algo salió mal con tus proyectos. Inténtalo de nuevo.';

  final GetMyProjectsUseCase _getMyProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final GetProjectDetailUseCase _getProjectDetailUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;

  String _messageOf(Object error) =>
      error is ProjectFailure ? error.message : _genericError;

  Future<void> _onUpdateProject(
    UpdateProjectSubmitted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final saved = await _updateProjectUseCase(event.project);
      final known = state.projects.any((p) => p.id == saved.id);
      emit(state.copyWith(
        status: ProjectsStatus.success,
        isSubmitting: false,
        projects: known
            ? [for (final p in state.projects) p.id == saved.id ? saved : p]
            : [saved, ...state.projects],
        selectedProject: saved,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        isSubmitting: false,
        errorMessage: _messageOf(e),
      ));
    }
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading, clearError: true));
    try {
      final list = await _getMyProjectsUseCase(status: event.status);
      emit(state.copyWith(status: ProjectsStatus.success, projects: list));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: _messageOf(e),
      ));
    }
  }

  void _onFilterByTab(
    FilterProjectsByTab event,
    Emitter<ProjectsState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tabIndex));
  }

  Future<void> _onCreateProject(
    CreateProjectSubmitted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final created = await _createProjectUseCase(
        title: event.title,
        description: event.description,
        city: event.city,
        neighborhood: event.neighborhood,
        surfaces: event.surfaces,
        budgetEstimateCop: event.budgetEstimateCop,
        imageAsset: event.imageAsset,
      );
      emit(state.copyWith(
        status: ProjectsStatus.success,
        isSubmitting: false,
        projects: [created, ...state.projects],
        selectedProject: created,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        isSubmitting: false,
        errorMessage: _messageOf(e),
      ));
    }
  }

  Future<void> _onLoadProjectDetail(
    LoadProjectDetail event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading, clearError: true));
    try {
      final detail = await _getProjectDetailUseCase(event.projectId);
      emit(state.copyWith(
        status: ProjectsStatus.success,
        selectedProject: detail,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: _messageOf(e),
      ));
    }
  }

  void _onErrorDismissed(
    ProjectErrorDismissed event,
    Emitter<ProjectsState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
