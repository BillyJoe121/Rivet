import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../catalog_filters.dart';

/// Hoja de filtros de la Bodega. Devuelve los filtros elegidos al aplicar.
Future<MaterialFilters?> showCatalogFilterSheet(
  BuildContext context, {
  required MaterialFilters current,
  required List<String> categories,
  required List<String> brands,
  required List<String> finishes,
}) {
  return showAppBottomSheet<MaterialFilters>(
    context,
    builder: (_) => _FilterSheet(
      initial: current,
      categories: categories,
      brands: brands,
      finishes: finishes,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initial,
    required this.categories,
    required this.brands,
    required this.finishes,
  });

  final MaterialFilters initial;
  final List<String> categories;
  final List<String> brands;
  final List<String> finishes;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  // Borrador: no afecta la lista hasta pulsar "Aplicar".
  late String? _category = widget.initial.category;
  late String? _brand = widget.initial.brand;
  late String? _finish = widget.initial.finish;
  late PriceRange? _range = widget.initial.priceRange;
  late bool _onlyInStock = widget.initial.onlyInStock;
  late MaterialSort _sort = widget.initial.sort;

  MaterialFilters get _draft => MaterialFilters(
        category: _category,
        brand: _brand,
        finish: _finish,
        priceRange: _range,
        onlyInStock: _onlyInStock,
        sort: _sort,
      );

  void _clear() => setState(() {
        _category = _brand = _finish = null;
        _range = null;
        _onlyInStock = false;
        _sort = MaterialSort.none;
      });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filtros', style: AppTypography.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _group('Categoría', [
                    for (final v in widget.categories)
                      _chip(v, v == _category, () => _category = v == _category ? null : v),
                  ]),
                  _group('Marca', [
                    for (final v in widget.brands)
                      _chip(v, v == _brand, () => _brand = v == _brand ? null : v),
                  ]),
                  _group('Tipo de acabado', [
                    for (final v in widget.finishes)
                      _chip(v, v == _finish, () => _finish = v == _finish ? null : v),
                  ]),
                  _group('Rango de precio', [
                    for (final r in PriceRange.options)
                      _chip(r.label, r == _range, () => _range = r == _range ? null : r),
                  ]),
                  _group('Disponibilidad', [
                    _chip('Solo disponibles', _onlyInStock, () => _onlyInStock = !_onlyInStock),
                  ]),
                  _group('Ordenar por precio', [
                    for (final s in MaterialSort.values.skip(1))
                      _chip(
                        s.label,
                        s == _sort,
                        () => _sort = s == _sort ? MaterialSort.none : s,
                      ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Limpiar',
                  variant: AppButtonVariant.outline,
                  onPressed: _clear,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  text: 'Aplicar',
                  onPressed: () => Navigator.of(context).pop(_draft),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _group(String title, List<Widget> chips) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.labelStrong),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: chips),
          ],
        ),
      );

  Widget _chip(String label, bool selected, VoidCallback change) => AppFilterChip(
        label: label,
        selected: selected,
        onTap: () => setState(change),
      );
}
