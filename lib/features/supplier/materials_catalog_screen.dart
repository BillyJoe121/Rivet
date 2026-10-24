import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'catalog_filters.dart';
import 'catalog_mock.dart';
import 'material_price_tier.dart';
import 'widgets/catalog_filter_sheet.dart';
import 'widgets/catalog_material_card.dart';

/// Bodega Rivet: materiales con buscador y filtros. El precio que se muestra
/// depende de [priceTier] y los filtros operan sobre ese mismo precio.
class MaterialsCatalogScreen extends StatefulWidget {
  const MaterialsCatalogScreen({
    super.key,
    this.priceTier = MaterialPriceTier.client,
    this.products = CatalogMock.products,
  });

  final MaterialPriceTier priceTier;
  final List<MaterialProduct> products;

  @override
  State<MaterialsCatalogScreen> createState() => _MaterialsCatalogScreenState();
}

class _MaterialsCatalogScreenState extends State<MaterialsCatalogScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  MaterialFilters _filters = const MaterialFilters();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _options(String? Function(MaterialProduct p) pick) =>
      ({for (final p in widget.products) ?pick(p)}.toList()..sort());

  Future<void> _openFilters() async {
    final result = await showCatalogFilterSheet(
      context,
      current: _filters,
      categories: _options((p) => p.category),
      brands: _options((p) => p.brand),
      finishes: _options((p) => p.finish),
    );
    if (result != null) setState(() => _filters = result);
  }

  void _clearAll() => setState(() {
        _filters = const MaterialFilters();
        _query = '';
        _searchController.clear();
      });

  @override
  Widget build(BuildContext context) {
    final tier = widget.priceTier;
    final results = _filters.apply(widget.products, tier, _query);
    final activeCount = _filters.activeCount;

    return RivetScaffold(
      title: 'Bodega',
      showBackButton: false,
      backgroundImagePath: AppHeroImages.paintShelf,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppSearchBar(
            controller: _searchController,
            hintText: 'Buscar por nombre, marca o categoría',
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 6),
          AppFilterField(
            icon: LucideIcons.slidersHorizontal,
            label: 'Filtros',
            value: activeCount == 0
                ? null
                : activeCount == 1
                    ? '1 filtro activo'
                    : '$activeCount filtros activos',
            onTap: _openFilters,
          ),
          if (tier.isUnverifiedPro) ...[
            const SizedBox(height: AppSpacing.md),
            const AppInfoBanner(
              compact: true,
              message: 'Verifica tu cuenta para acceder a precios de contratista.',
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: AppSectionHeader(title: 'Materiales', count: results.length)),
              if (tier.isVerifiedPro)
                const AppBadge(
                  text: 'Precios de contratista',
                  variant: AppBadgeVariant.success,
                  icon: LucideIcons.badgeCheck,
                  compact: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (results.isEmpty)
            AppEmptyState(
              title: 'Sin resultados',
              message: 'Ningún material coincide con tu búsqueda o filtros.',
              icon: LucideIcons.searchX,
              actionLabel: 'Limpiar filtros',
              onAction: _clearAll,
            )
          else
            for (final product in results)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: CatalogMaterialCard(product: product, tier: tier),
              ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
