import '../../../core/config/supabase_config.dart';
import '../domain/repositories/project_repository.dart';
import 'repositories/project_repository_impl.dart';
import 'sources/supabase_project_data_source.dart';

/// Arma el repositorio de proyectos que la raíz de la app inyecta.
///
/// Si Supabase no quedó inicializado (sin `.env`), la fuente de datos responde
/// con un error de conexión en cada consulta en lugar de inventar datos.
ProjectRepository createProjectRepository() {
  try {
    return ProjectRepositoryImpl(
      SupabaseProjectDataSource(SupabaseConfig.client),
    );
  } catch (_) {
    return ProjectRepositoryImpl(SupabaseProjectDataSource(null));
  }
}
