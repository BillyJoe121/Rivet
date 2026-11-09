import '../../../../core/models/models.dart';
import '../../domain/errors/catalog_failure.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../sources/supabase_catalog_data_source.dart';

/// Implementación del repositorio de Bodega Rivet.
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._dataSource);

  final SupabaseCatalogDataSource _dataSource;

  @override
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    try {
      return await _dataSource.getProducts(
        category: category,
        searchQuery: searchQuery,
      );
    } catch (e) {
      throw CatalogFailure('No fue posible cargar el catálogo: ${e.toString()}');
    }
  }

  @override
  Future<MaterialProduct> getProductDetail(String productId) async {
    try {
      return await _dataSource.getProductDetail(productId);
    } catch (e) {
      throw CatalogFailure('No se encontró el producto: ${e.toString()}');
    }
  }
}

