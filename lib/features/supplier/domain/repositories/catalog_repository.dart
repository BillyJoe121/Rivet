import '../../../../core/models/models.dart';

/// Contrato del repositorio para la Bodega Rivet.
abstract interface class CatalogRepository {
  /// Obtiene los productos del catálogo, opcionalmente filtrados por categoría y búsqueda.
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  });

  /// Obtiene el detalle de un producto por ID.
  Future<MaterialProduct> getProductDetail(String productId);
}

