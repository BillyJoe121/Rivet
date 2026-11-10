import '../../../../core/models/models.dart';
import '../../domain/errors/project_failure.dart';
import '../../domain/repositories/project_repository.dart';
import '../sources/supabase_project_data_source.dart';

/// Implementación concreta del repositorio de proyectos.
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._dataSource);

  final SupabaseProjectDataSource _dataSource;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async {
    try {
      return await _dataSource.getMyProjects(status: status);
    } catch (e) {
      throw ProjectFailure('No se pudieron cargar tus proyectos: ${e.toString()}');
    }
  }

  @override
  Future<Project> getProjectDetail(String projectId) async {
    try {
      return await _dataSource.getProjectDetail(projectId);
    } catch (e) {
      throw ProjectFailure('No se encontró la información del proyecto: ${e.toString()}');
    }
  }

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) async {
    try {
      return await _dataSource.createProject(
        title: title,
        description: description,
        city: city,
        neighborhood: neighborhood,
        surfaces: surfaces,
        budgetEstimateCop: budgetEstimateCop,
        imageAsset: imageAsset,
      );
    } catch (e) {
      throw ProjectFailure('No fue posible guardar el proyecto: ${e.toString()}');
    }
  }

  @override
  Future<Project> updateProject(Project project) async {
    try {
      return await _dataSource.updateProject(project);
    } catch (e) {
      throw ProjectFailure('No fue posible guardar los cambios: ${e.toString()}');
    }
  }
}

