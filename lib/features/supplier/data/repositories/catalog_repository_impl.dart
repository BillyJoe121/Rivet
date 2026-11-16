import '../../../../core/models/models.dart';
import '../../domain/errors/catalog_failure.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../sources/supabase_catalog_data_source.dart';

/// Implementación del repositorio de Bodega Rivet.
///
/// La fuente de datos ya entrega [CatalogFailure]; cualquier otro error se
/// envuelve con un mensaje genérico para no mostrar detalles técnicos.
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._dataSource);

  final SupabaseCatalogDataSource _dataSource;

  @override
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) => _guard(
    SupabaseCatalogDataSource.loadListMessage,
    () => _dataSource.getProducts(category: category, searchQuery: searchQuery),
  );

  @override
  Future<MaterialProduct> getProductDetail(String productId) => _guard(
    SupabaseCatalogDataSource.loadDetailMessage,
    () => _dataSource.getProductDetail(productId),
  );

  Future<T> _guard<T>(String message, Future<T> Function() run) async {
    try {
      return await run();
    } on CatalogFailure {
      rethrow;
    } catch (_) {
      throw CatalogFailure(message);
    }
  }
}
