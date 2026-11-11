import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'catalog_filters.dart';
import 'catalog_mock.dart';
import 'domain/repositories/catalog_repository.dart';
import 'domain/usecases/get_catalog_materials_usecase.dart';
import 'material_detail_screen.dart';
import 'material_price_tier.dart';
import 'presentation/bloc/catalog_bloc.dart';
import 'widgets/catalog_filter_sheet.dart';
import 'widgets/catalog_material_card.dart';

/// Bodega Rivet: catálogo de materiales gestionado por [CatalogBloc] (P-023).
class MaterialsCatalogScreen extends StatelessWidget {
  const MaterialsCatalogScreen({
    super.key,
    this.priceTier = MaterialPriceTier.client,
    this.products = CatalogMock.products,
    this.catalogBloc,
    this.preselectedProjectId,
  });

  final MaterialPriceTier priceTier;
  final List<MaterialProduct> products;
  final CatalogBloc? catalogBloc;
  final String? preselectedProjectId;

  @override
  Widget build(BuildContext context) {
    if (catalogBloc != null) {
      return BlocProvider<CatalogBloc>.value(
        value: catalogBloc!,
        child: _MaterialsCatalogView(
          priceTier: priceTier,
          initialProducts: products,
          preselectedProjectId: preselectedProjectId,
        ),
      );
    }

    try {
      context.read<CatalogBloc>();
      return _MaterialsCatalogView(
        priceTier: priceTier,
        initialProducts: products,
        preselectedProjectId: preselectedProjectId,
      );
    } catch (_) {
      return BlocProvider<CatalogBloc>(
        create: (context) => CatalogBloc(
          GetCatalogMaterialsUseCase(context.read<CatalogRepository>()),
        )..add(const LoadCatalogProducts()),
        child: _MaterialsCatalogView(
          priceTier: priceTier,
          initialProducts: products,
          preselectedProjectId: preselectedProjectId,
        ),
      );
    }
  }
}

class _MaterialsCatalogView extends StatefulWidget {
  const _MaterialsCatalogView({
    required this.priceTier,
    required this.initialProducts,
    this.preselectedProjectId,
  });

  final MaterialPriceTier priceTier;
  final List<MaterialProduct> initialProducts;
  final String? preselectedProjectId;

  @override
  State<_MaterialsCatalogView> createState() => _MaterialsCatalogViewState();
}

class _MaterialsCatalogViewState extends State<_MaterialsCatalogView> {
  final _searchController = TextEditingController();
  String _query = '';
  MaterialFilters _filters = const MaterialFilters();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _options(
    List<MaterialProduct> list,
    String? Function(MaterialProduct p) pick,
  ) => ({for (final p in list) ?pick(p)}.toList()..sort());

  Future<void> _openFilters(List<MaterialProduct> list) async {
    final result = await showCatalogFilterSheet(
      context,
      current: _filters,
      categories: _options(list, (p) => p.category),
      brands: _options(list, (p) => p.brand),
      finishes: _options(list, (p) => p.finish),
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

    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final availableProducts = state.products.isNotEmpty
            ? state.products
            : widget.initialProducts;

        final results = _filters.apply(availableProducts, tier, _query);
        final activeCount = _filters.activeCount;

        return RivetScaffold(
          title: 'Bodega',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.paintShelf,
          body: AppPageBody(
            fixedHeader: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  onTap: () => _openFilters(availableProducts),
                ),
                if (tier.isUnverifiedPro) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const AppInfoBanner(
                    compact: true,
                    message:
                        'Verifica tu cuenta para acceder a precios de contratista.',
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppSectionHeader(
                        title: 'Materiales',
                        count: results.length,
                      ),
                    ),
                    if (tier.isVerifiedPro)
                      const AppBadge(
                        text: 'Precios de contratista',
                        variant: AppBadgeVariant.success,
                        icon: LucideIcons.badgeCheck,
                        compact: true,
                      ),
                  ],
                ),
              ],
            ),
            children: [
              if (state.isLoading && availableProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.brand700),
                    ),
                  ),
                )
              else if (results.isEmpty)
                AppEmptyState(
                  title: 'Sin resultados',
                  message:
                      'Ningún material coincide con tu búsqueda o filtros.',
                  icon: LucideIcons.searchX,
                  actionLabel: 'Limpiar filtros',
                  onAction: _clearAll,
                )
              else
                for (var i = 0; i < results.length; i++) ...[
                  CatalogMaterialCard(
                    product: results[i],
                    tier: tier,
                    preselectedProjectId: widget.preselectedProjectId,
                    onTap: () => AppNavigator.push(
                      context,
                      MaterialDetailScreen(
                        product: results[i],
                        tier: tier,
                        preselectedProjectId: widget.preselectedProjectId,
                      ),
                    ),
                  ),
                  if (i < results.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}
