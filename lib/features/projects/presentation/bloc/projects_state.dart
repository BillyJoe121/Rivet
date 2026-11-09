import '../../../../core/models/models.dart';

enum ProjectsStatus { initial, loading, success, failure }

/// Estado del bloque de gestión de proyectos.
class ProjectsState {
  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.selectedTab = 0,
    this.selectedProject,
    this.errorMessage,
  });

  final ProjectsStatus status;
  final List<Project> projects;
  final int selectedTab;
  final Project? selectedProject;
  final String? errorMessage;

  bool get isLoading => status == ProjectsStatus.loading;
  bool get isSuccess => status == ProjectsStatus.success;
  bool get isFailure => status == ProjectsStatus.failure;

  /// Retorna los proyectos filtrados según la pestaña activa:
  /// 0: Todos, 1: En curso o cotización, 2: Completados
  List<Project> get filteredProjects {
    switch (selectedTab) {
      case 1:
        return projects
            .where((p) =>
                p.status == ProjectStatus.published ||
                p.status == ProjectStatus.inProgress ||
                p.status == ProjectStatus.negotiating ||
                p.status == ProjectStatus.underReview ||
                p.status == ProjectStatus.agreed)
            .toList();
      case 2:
        return projects
            .where((p) => p.status == ProjectStatus.completed)
            .toList();
      case 0:
      default:
        return projects;
    }
  }

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? projects,
    int? selectedTab,
    Project? selectedProject,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedProject: selectedProject ?? this.selectedProject,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

