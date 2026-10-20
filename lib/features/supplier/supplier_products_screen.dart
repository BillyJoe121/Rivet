import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'catalog_mock.dart';
import 'widgets/catalog_common.dart';
import 'widgets/catalog_product_tile.dart';

/// Productos de FerreCasa (frame 53:137): buscador, categorías y cuadrícula de 2 columnas.
class SupplierProductsScreen extends StatefulWidget {
  const SupplierProductsScreen({super.key});

  @override
  State<SupplierProductsScreen> createState() => _SupplierProductsScreenState();
}

class _SupplierProductsScreenState extends State<SupplierProductsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final products = [
      for (final item in CatalogMock.productGrid)
        if (query.isEmpty || item.name.toLowerCase().contains(query)) item,
    ];

    return ProScreen(
      backgroundAsset: ProAssets.headerShop,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 116,
            child: Stack(
              children: [
                const Positioned(left: 24, top: 8, child: ProBackButton()),
                const Positioned(left: 24, top: 28, child: ProPageTitle('Productos')),
                Positioned(
                  left: 24,
                  top: 62,
                  child: Row(
                    children: [
                      CatalogImage(image: CatalogMock.supplierImage, width: 32, height: 32, radius: 16),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(CatalogMock.supplierName, style: ProText.serif(14, color: ProColors.ink900, lineHeight: 17.9)),
                            Text(
                              CatalogMock.supplierType,
                              style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                CatalogSearchField(
                  controller: _searchController,
                  hint: 'Buscar productos',
                  height: 38,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 0),
                const Row(
                  spacing: 6,
                  children: [
                    _CategoryPill('Todos', selected: true),
                    _CategoryPill('Pinturas'),
                    _CategoryPill('Acabados'),
                    _CategoryPill('Herramientas'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${products.length} productos',
                      style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.4),
                    ),
                    const Spacer(),
                    Text(
                      CatalogMock.supplierLocation,
                      style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.9),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                for (var i = 0; i < products.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: 4),
                  Row(
                    spacing: 8,
                    children: [
                      for (final item in products.skip(i).take(2))
                        Expanded(
                          child: CatalogProductTile(
                            name: item.name,
                            presentation: item.presentation,
                            price: item.price,
                            image: item.image,
                            fit: item.fit,
                          ),
                        ),
                      if (products.length - i == 1) const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Filtro de categoría de 28 px con borde; el seleccionado usa el color de marca.
class _CategoryPill extends StatelessWidget {
  const _CategoryPill(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? ProColors.brand700 : ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.button),
        border: Border.all(color: selected ? ProColors.brand700 : ProColors.line300, width: 0.7),
      ),
      child: Text(
        label,
        style: ProText.r(
          12,
          weight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? ProColors.surface0 : ProColors.brand700,
          lineHeight: 14.1,
        ),
      ),
    );
  }
}
