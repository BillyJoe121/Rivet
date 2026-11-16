import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/models.dart';
import '../../domain/errors/catalog_failure.dart';

/// Fuente de datos de la Bodega Rivet en Supabase (tabla `materials`).
///
/// Cualquier fallo de red o de la base se convierte en [CatalogFailure] con
/// un mensaje listo para mostrar.
class SupabaseCatalogDataSource {
  SupabaseCatalogDataSource(this._client);

  final SupabaseClient? _client;

  static const noConnectionMessage =
      'No pudimos conectarnos con Rivet. Revisa tu conexión e inténtalo de nuevo.';
  static const loadListMessage =
      'No pudimos cargar la Bodega. Inténtalo de nuevo.';
  static const loadDetailMessage =
      'No pudimos cargar este material. Inténtalo de nuevo.';
  static const notFoundMessage = 'No encontramos este material.';

  /// Obtiene los productos aplicando filtros de búsqueda y categoría.
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) {
    return _guard(loadListMessage, () async {
      var query = _requireClient().from('materials').select();
      if (category != null && category != 'Todos') {
        query = query.eq('category', category);
      }
      final search = searchQuery?.trim() ?? '';
      if (search.isNotEmpty) query = query.ilike('name', '%$search%');

      final rows = await query.order('name');
      return [for (final row in rows) materialFromRow(row)];
    });
  }

  /// Obtiene un producto por ID.
  Future<MaterialProduct> getProductDetail(String productId) {
    return _guard(loadDetailMessage, () async {
      final row = await _requireClient()
          .from('materials')
          .select()
          .eq('id', productId)
          .maybeSingle();
      if (row == null) throw const CatalogFailure(notFoundMessage);
      return materialFromRow(row);
    });
  }

  SupabaseClient _requireClient() {
    final client = _client;
    if (client == null) throw const CatalogFailure(noConnectionMessage);
    return client;
  }

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

/// Convierte una fila de `materials` al modelo.
MaterialProduct materialFromRow(Map<String, dynamic> row) {
  return MaterialProduct(
    id: row['id'].toString(),
    name: row['name'] as String? ?? '',
    brand: row['brand'] as String? ?? '',
    category: row['category'] as String? ?? 'General',
    unit: row['unit'] as String? ?? 'unidad',
    clientPriceCop: _toInt(row['client_price_cop']),
    proPriceCop: _toInt(row['pro_price_cop']),
    finish: row['finish'] as String?,
    inStock: row['in_stock'] as bool? ?? true,
  );
}

int _toInt(Object? value) => switch (value) {
  final num n => n.round(),
  final String s => num.tryParse(s)?.round() ?? 0,
  _ => 0,
};
