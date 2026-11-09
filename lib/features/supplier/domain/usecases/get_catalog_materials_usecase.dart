import '../../../../core/models/models.dart';
import '../repositories/catalog_repository.dart';

/// Caso de uso: Consultar y buscar insumos en la Bodega Rivet.
class GetCatalogMaterialsUseCase {
  const GetCatalogMaterialsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<List<MaterialProduct>> call({
    String? category,
    String? searchQuery,
  }) {
    return _repository.getProducts(
      category: category,
      searchQuery: searchQuery,
    );
  }
}

