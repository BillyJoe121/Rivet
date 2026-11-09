import '../../../../core/models/models.dart';

enum CatalogStatus { initial, loading, success, failure }

/// Estado del bloque de la Bodega Rivet.
class CatalogState {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const [],
    this.selectedCategory = 'Todos',
    this.searchQuery = '',
    this.errorMessage,
  });

  final CatalogStatus status;
  final List<MaterialProduct> products;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  bool get isLoading => status == CatalogStatus.loading;
  bool get isSuccess => status == CatalogStatus.success;
  bool get isFailure => status == CatalogStatus.failure;

  CatalogState copyWith({
    CatalogStatus? status,
    List<MaterialProduct>? products,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

