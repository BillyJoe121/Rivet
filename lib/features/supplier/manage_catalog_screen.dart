import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'add_catalog_product_screen.dart';
import 'catalog_mock.dart';
import 'widgets/catalog_common.dart';
import 'widgets/catalog_detail_parts.dart';
import 'widgets/catalog_managed_row.dart';

/// Administrar catálogo y precios (frame 22:146203): resumen, búsqueda y materiales.
class ManageCatalogScreen extends StatefulWidget {
  const ManageCatalogScreen({super.key});

  @override
  State<ManageCatalogScreen> createState() => _ManageCatalogScreenState();
}

class _ManageCatalogScreenState extends State<ManageCatalogScreen> {
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
    final items = [
      for (final item in CatalogMock.managed)
        if (query.isEmpty || item.name.toLowerCase().contains(query) || item.sku.toLowerCase().contains(query)) item,
    ];

    return ProScreen(
      backgroundAsset: ProAssets.headerPaintCorner,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 118,
            child: Stack(
              children: [
                const Positioned(left: 24, top: 8, child: ProBackButton(lucide: true)),
                const Positioned(left: 60, top: 2, child: SizedBox(width: 180, child: ProPageTitle('Administrar catálogo'))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                const Row(
                  spacing: 4,
                  children: [
                    CatalogSegment(label: 'Materiales', selected: true),
                    CatalogSegment(label: 'Precios'),
                    CatalogSegment(label: 'Disponibilidad'),
                  ],
                ),
                const Row(
                  spacing: 7,
                  children: [
                    Expanded(child: CatalogCountTile(value: '42', label: 'materiales')),
                    Expanded(child: CatalogCountTile(value: '8', label: 'sin stock')),
                    Expanded(child: CatalogCountTile(value: '3', label: 'pendientes')),
                  ],
                ),
                CatalogSearchField(
                  controller: _searchController,
                  hint: 'Buscar material',
                  height: 38,
                  onChanged: (value) => setState(() => _query = value),
                ),
                for (final item in items)
                  CatalogManagedRow(
                    name: item.name,
                    sku: item.sku,
                    detail: item.detail,
                    status: item.status,
                    cost: item.cost,
                    price: item.price,
                    image: item.image,
                    fit: item.fit,
                  ),
                const ProNote(text: 'Puedes manejar precios diferentes para clientes y contratistas.'),
                const SizedBox(height: 56),
                CatalogActionButton(
                  label: 'Añadir material',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCatalogProductScreen()),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
