import '../../../../core/models/models.dart';

/// Eventos del bloque de proyectos.
sealed class ProjectsEvent {
  const ProjectsEvent();
}

/// Carga los proyectos del usuario actual.
final class LoadProjects extends ProjectsEvent {
  const LoadProjects({this.status});

  final ProjectStatus? status;
}

/// Aplica filtro por índice en la pestaña segmentada (0: Todos, 1: En curso, 2: Finalizados).
final class FilterProjectsByTab extends ProjectsEvent {
  const FilterProjectsByTab(this.tabIndex);

  final int tabIndex;
}

/// Solicitud de creación de un nuevo proyecto.
final class CreateProjectSubmitted extends ProjectsEvent {
  const CreateProjectSubmitted({
    required this.title,
    required this.description,
    required this.city,
    required this.neighborhood,
    required this.surfaces,
    required this.budgetEstimateCop,
    this.imageAsset,
  });

  final String title;
  final String description;
  final String city;
  final String neighborhood;
  final List<SurfaceItem> surfaces;
  final int budgetEstimateCop;
  final String? imageAsset;
}

/// Guarda los cambios de un proyecto existente.
final class UpdateProjectSubmitted extends ProjectsEvent {
  const UpdateProjectSubmitted(this.project);

  final Project project;
}

/// Consulta el detalle de un proyecto específico.
final class LoadProjectDetail extends ProjectsEvent {
  const LoadProjectDetail(this.projectId);

  final String projectId;
}

/// Descarta el error mostrado en pantalla.
final class ProjectErrorDismissed extends ProjectsEvent {
  const ProjectErrorDismissed();
}

