import '../../core/config/supabase_config.dart';
import 'data/repositories/catalog_repository_impl.dart';
import 'data/sources/supabase_catalog_data_source.dart';
import 'domain/repositories/catalog_repository.dart';
import 'domain/usecases/get_catalog_materials_usecase.dart';

/// Contenedor de servicios y casos de uso para la Bodega Rivet.
class CatalogService {
  CatalogService._();

  static final CatalogService instance = CatalogService._();

  CatalogRepository? _repository;

  void setRepositoryForTesting(CatalogRepository repository) {
    _repository = repository;
  }

  CatalogRepository get repository {
    if (_repository != null) return _repository!;
    try {
      return _repository = CatalogRepositoryImpl(
        SupabaseCatalogDataSource(SupabaseConfig.client),
      );
    } catch (_) {
      return _repository = CatalogRepositoryImpl(
        SupabaseCatalogDataSource(null),
      );
    }
  }

  GetCatalogMaterialsUseCase get getCatalogMaterialsUseCase =>
      GetCatalogMaterialsUseCase(repository);
}

