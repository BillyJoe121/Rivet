import '../../core/config/supabase_config.dart';
import 'data/repositories/project_repository_impl.dart';
import 'data/sources/supabase_project_data_source.dart';
import 'domain/repositories/project_repository.dart';
import 'domain/usecases/usecases.dart';

/// Contenedor de servicios y casos de uso para el módulo de proyectos.
class ProjectsService {
  ProjectsService._();

  static final ProjectsService instance = ProjectsService._();

  ProjectRepository? _repository;

  /// Permite inyectar un repositorio mock para tests.
  void setRepositoryForTesting(ProjectRepository repository) {
    _repository = repository;
  }

  ProjectRepository get repository {
    if (_repository != null) return _repository!;
    try {
      return _repository = ProjectRepositoryImpl(
        SupabaseProjectDataSource(SupabaseConfig.client),
      );
    } catch (_) {
      return _repository = ProjectRepositoryImpl(
        SupabaseProjectDataSource(null),
      );
    }
  }

  CreateProjectUseCase get createProjectUseCase =>
      CreateProjectUseCase(repository);

  GetMyProjectsUseCase get getMyProjectsUseCase =>
      GetMyProjectsUseCase(repository);

  GetProjectDetailUseCase get getProjectDetailUseCase =>
      GetProjectDetailUseCase(repository);
}

