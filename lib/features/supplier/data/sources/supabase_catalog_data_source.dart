import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/models.dart';
import '../../catalog_mock.dart';

/// Fuente de datos de la Bodega Rivet.
class SupabaseCatalogDataSource {
  SupabaseCatalogDataSource(this._client);

  final SupabaseClient? _client;

  final List<MaterialProduct> _localProducts = List.from(CatalogMock.products);
  bool _useLocalFastPath = false;

  /// Obtiene los productos aplicando filtros de búsqueda y categoría.
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    final client = _client;
    if (!_useLocalFastPath && client != null) {
      try {
        var query = client.from('materials').select();
        if (category != null && category != 'Todos') {
          query = query.eq('category', category);
        }
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          query = query.ilike('name', '%${searchQuery.trim()}%');
        }
        final data = await query.timeout(const Duration(milliseconds: 900));
        final list = (data as List).map((m) => _mapFromSupabase(m as Map<String, dynamic>)).toList();
        if (list.isNotEmpty) return list;
        _useLocalFastPath = true;
      } catch (_) {
        _useLocalFastPath = true;
      }
    }

    Iterable<MaterialProduct> result = _localProducts;
    if (category != null && category != 'Todos') {
      result = result.where((p) => p.category.toLowerCase() == category.toLowerCase());
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q));
    }
    return result.toList();
  }

  /// Obtiene un producto por ID.
  Future<MaterialProduct> getProductDetail(String productId) async {
    return _localProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => _localProducts.first,
    );
  }

  MaterialProduct _mapFromSupabase(Map<String, dynamic> json) {
    return MaterialProduct(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Insumo',
      brand: json['brand'] as String? ?? 'Rivet',
      category: json['category'] as String? ?? 'General',
      unit: json['unit'] as String? ?? 'unidad',
      clientPriceCop: (json['client_price_cop'] as num?)?.toInt() ?? 0,
      proPriceCop: (json['pro_price_cop'] as num?)?.toInt() ?? 0,
      finish: json['finish'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
    );
  }
}

