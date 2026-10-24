import '../../core/models/models.dart';
import 'material_price_tier.dart';

/// Orden por precio de la lista.
enum MaterialSort {
  none('Sin orden'),
  priceAsc('Menor a mayor'),
  priceDesc('Mayor a menor');

  const MaterialSort(this.label);
  final String label;
}

/// Rango de precio ofrecido en los filtros; [max] nulo no tiene tope.
class PriceRange {
  const PriceRange(this.label, {this.min = 0, this.max});

  final String label;
  final int min;
  final int? max;

  bool contains(int price) => price >= min && (max == null || price <= max!);

  static const List<PriceRange> options = [
    PriceRange('Hasta \$ 50.000', max: 50000),
    PriceRange('\$ 50.000 a \$ 100.000', min: 50000, max: 100000),
    PriceRange('Más de \$ 100.000', min: 100000),
  ];
}

/// Filtros activos de la Bodega. Un campo nulo significa "todos".
class MaterialFilters {
  const MaterialFilters({
    this.category,
    this.brand,
    this.finish,
    this.priceRange,
    this.onlyInStock = false,
    this.sort = MaterialSort.none,
  });

  final String? category;
  final String? brand;
  final String? finish;
  final PriceRange? priceRange;
  final bool onlyInStock;
  final MaterialSort sort;

  /// Cantidad de filtros activos (el orden cuenta como uno).
  int get activeCount => [
        category != null,
        brand != null,
        finish != null,
        priceRange != null,
        onlyInStock,
        sort != MaterialSort.none,
      ].where((active) => active).length;

  bool get isEmpty => activeCount == 0;

  /// Aplica búsqueda, filtros y orden sobre el precio que ve [tier].
  List<MaterialProduct> apply(
    List<MaterialProduct> products,
    MaterialPriceTier tier,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    final result = [
      for (final p in products)
        if ((q.isEmpty ||
                p.name.toLowerCase().contains(q) ||
                p.brand.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q)) &&
            (category == null || p.category == category) &&
            (brand == null || p.brand == brand) &&
            (finish == null || p.finish == finish) &&
            (priceRange == null || priceRange!.contains(tier.priceOf(p))) &&
            (!onlyInStock || p.inStock))
          p,
    ];
    switch (sort) {
      case MaterialSort.priceAsc:
        result.sort((a, b) => tier.priceOf(a).compareTo(tier.priceOf(b)));
      case MaterialSort.priceDesc:
        result.sort((a, b) => tier.priceOf(b).compareTo(tier.priceOf(a)));
      case MaterialSort.none:
        break;
    }
    return result;
  }
}
