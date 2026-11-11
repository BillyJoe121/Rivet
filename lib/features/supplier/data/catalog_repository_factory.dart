import '../../../core/config/supabase_config.dart';
import '../domain/repositories/catalog_repository.dart';
import 'repositories/catalog_repository_impl.dart';
import 'sources/supabase_catalog_data_source.dart';

/// Arma el repositorio de la Bodega Rivet que la raíz de la app inyecta.
///
/// Si Supabase no quedó inicializado (sin `.env`), la fuente de datos trabaja
/// con su catálogo local para que la app siga abriendo.
CatalogRepository createCatalogRepository() {
  try {
    return CatalogRepositoryImpl(
      SupabaseCatalogDataSource(SupabaseConfig.client),
    );
  } catch (_) {
    return CatalogRepositoryImpl(SupabaseCatalogDataSource(null));
  }
}
