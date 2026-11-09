import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/get_my_projects_usecase.dart';
import '../../domain/usecases/get_project_detail_usecase.dart';
import 'projects_event.dart';
import 'projects_state.dart';

export 'projects_event.dart';
export 'projects_state.dart';

/// BLoC que gobierna la creación, consulta y filtrado de proyectos.
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(
    this._getMyProjectsUseCase,
    this._createProjectUseCase,
    this._getProjectDetailUseCase,
  ) : super(const ProjectsState()) {
    on<LoadProjects>(_onLoadProjects);
    on<FilterProjectsByTab>(_onFilterByTab);
    on<CreateProjectSubmitted>(_onCreateProject);
    on<LoadProjectDetail>(_onLoadProjectDetail);
    on<ProjectErrorDismissed>(_onErrorDismissed);
  }

  final GetMyProjectsUseCase _getMyProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final GetProjectDetailUseCase _getProjectDetailUseCase;

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading, clearError: true));
    try {
      final list = await _getMyProjectsUseCase(status: event.status);
      emit(state.copyWith(
        status: ProjectsStatus.success,
        projects: list,
      ));
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: clean,
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
    emit(state.copyWith(status: ProjectsStatus.loading, clearError: true));
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

      final updated = [created, ...state.projects];
      emit(state.copyWith(
        status: ProjectsStatus.success,
        projects: updated,
        selectedProject: created,
      ));
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: clean,
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
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ProjectsStatus.failure,
        errorMessage: clean,
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

