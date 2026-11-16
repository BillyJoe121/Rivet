import '../../../../core/models/models.dart';
import '../../domain/errors/project_failure.dart';
import '../../domain/repositories/project_repository.dart';
import '../sources/supabase_project_data_source.dart';

/// Implementación concreta del repositorio de proyectos.
///
/// La fuente de datos ya entrega [ProjectFailure]; cualquier otro error se
/// envuelve con un mensaje genérico para no mostrar detalles técnicos.
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._dataSource);

  final SupabaseProjectDataSource _dataSource;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) => _guard(
    SupabaseProjectDataSource.loadListMessage,
    () => _dataSource.getMyProjects(status: status),
  );

  @override
  Future<Project> getProjectDetail(String projectId) => _guard(
    SupabaseProjectDataSource.loadDetailMessage,
    () => _dataSource.getProjectDetail(projectId),
  );

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) => _guard(
    SupabaseProjectDataSource.createMessage,
    () => _dataSource.createProject(
      title: title,
      description: description,
      city: city,
      neighborhood: neighborhood,
      surfaces: surfaces,
      budgetEstimateCop: budgetEstimateCop,
      imageAsset: imageAsset,
    ),
  );

  @override
  Future<Project> updateProject(Project project) => _guard(
    SupabaseProjectDataSource.updateMessage,
    () => _dataSource.updateProject(project),
  );

  Future<T> _guard<T>(String message, Future<T> Function() run) async {
    try {
      return await run();
    } on ProjectFailure {
      rethrow;
    } catch (_) {
      throw ProjectFailure(message);
    }
  }
}
