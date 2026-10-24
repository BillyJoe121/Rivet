import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'catalog_mock.dart';
import 'catalog_product_info.dart';
import 'widgets/catalog_common.dart';
import 'widgets/catalog_material_card.dart';

/// Bodega de materiales (frame 22:144637). Con [isProRateView] muestra el precio profesional.
class MaterialsCatalogScreen extends StatefulWidget {
  const MaterialsCatalogScreen({
    super.key,
    this.isProRateView = false,
  });

  final bool isProRateView;

  @override
  State<MaterialsCatalogScreen> createState() => _MaterialsCatalogScreenState();
}

class _MaterialsCatalogScreenState extends State<MaterialsCatalogScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(String name, String brand) {
    final query = _query.trim().toLowerCase();
    return query.isEmpty || name.toLowerCase().contains(query) || brand.toLowerCase().contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final products = [
      for (final item in CatalogMock.products)
        if (_matches(item.product.name, item.product.brand)) item,
    ];
    final showSupplier = _matches(CatalogMock.supplierName, CatalogMock.supplierType);

    return ProScreen(
      backgroundAsset: ProAssets.headerPaintCorner,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(title: 'Bodega', lucideChevron: true, height: 155),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                CatalogSearchField(
                  controller: _searchController,
                  hint: 'Buscar materiales, marcas o proveedores...',
                  onChanged: (value) => setState(() => _query = value),
                ),
                const Row(
                  spacing: 10,
                  children: [
                    Expanded(child: CatalogStaticField(icon: LucideIcon.package, label: 'Categoría')),
                    Expanded(child: CatalogStaticField(icon: LucideIcon.shield, label: 'Marca')),
                  ],
                ),
                const Row(
                  spacing: 10,
                  children: [
                    Expanded(child: CatalogStaticField(icon: LucideIcon.mapPin, label: 'Ubicación')),
                    Expanded(child: CatalogStaticField(icon: LucideIcon.circleCheck, label: 'Disponibilidad')),
                  ],
                ),
                const Row(
                  spacing: 4,
                  children: [
                    CatalogSegment(label: 'Materiales', selected: true),
                    CatalogSegment(label: 'Proveedores'),
                  ],
                ),
                if (showSupplier)
                  CatalogMaterialCard(
                    image: CatalogMock.supplierImage,
                    title: CatalogMock.supplierName,
                    lines: [CatalogMock.supplierLocation, CatalogMock.supplierType, CatalogMock.supplierRating],
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bodega Oficial Rivet · Materiales certificados')),
                    ),
                  ),
                for (final item in products)
                  CatalogMaterialCard(
                    image: item.info.image,
                    fit: item.info.imageFit,
                    title: item.product.name,
                    lines: [item.product.brand, item.info.presentation],
                    price: '\$ ${formatCop(widget.isProRateView ? item.product.proPriceCop : item.product.clientPriceCop)}'
                        '${item.info.priceSuffix}',
                  ),
                const ProNote(text: 'Los precios pueden variar según si eres cliente o contratista y la ubicación.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
