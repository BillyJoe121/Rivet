import '../../../../core/models/models.dart';

/// Contrato del repositorio de proyectos.
abstract interface class ProjectRepository {
  /// Obtiene los proyectos del cliente actual, opcionalmente filtrados por estado.
  Future<List<Project>> getMyProjects({ProjectStatus? status});

  /// Obtiene el detalle completo de un proyecto por su identificador.
  Future<Project> getProjectDetail(String projectId);

  /// Crea y publica un nuevo proyecto de pintura o estuco.
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  });

  /// Guarda los cambios de un proyecto existente y lo devuelve actualizado.
  Future<Project> updateProject(Project project);
}

