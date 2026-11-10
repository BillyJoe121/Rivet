import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../material_price_tier.dart';
import 'catalog_order_sheets.dart';

/// Tarjeta de un material de la Bodega: fotografía, ficha resumida, precio
/// según [tier] y acciones directas para agregar a proyecto o pedir ahora.
class CatalogMaterialCard extends StatelessWidget {
  const CatalogMaterialCard({
    super.key,
    required this.product,
    required this.tier,
    this.preselectedProjectId,
    this.onTap,
  });

  final MaterialProduct product;
  final MaterialPriceTier tier;
  final String? preselectedProjectId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final detail = [
      product.brand,
      product.category,
      if (product.finish != null) product.finish!,
    ].join(' · ');

    final hasProject = preselectedProjectId != null;

    return AppCard(
      backgroundColor: AppColors.paper100,
      borderRadius: AppSpacing.roundedCard,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Photo(asset: product.imageAsset),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.titleSmall,
                          ),
                        ),
                        if (!product.inStock)
                          const AppBadge(
                            text: 'Agotado',
                            variant: AppBadgeVariant.neutral,
                            compact: true,
                          )
                        else
                          const Icon(
                            LucideIcons.chevronRight,
                            size: 16,
                            color: AppColors.brand700,
                          ),
                      ],
                    ),
                    Text(detail, style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xxs),
                    _PriceLine(product: product, tier: tier),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: AppButton(
                  text: hasProject
                      ? 'Agregar al proyecto actual'
                      : 'Agregar a un proyecto',
                  size: AppButtonSize.sm,
                  onPressed: () => showAddMaterialToProjectSheet(
                    context,
                    product: product,
                    tier: tier,
                    preselectedProjectId: preselectedProjectId,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                flex: 5,
                child: AppButton(
                  text: 'Pedir ahora mismo',
                  size: AppButtonSize.sm,
                  variant: AppButtonVariant.outline,
                  onPressed: product.inStock
                      ? () => showOrderMaterialNowSheet(
                          context,
                          product: product,
                          tier: tier,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Precio visible; al contratista verificado se le muestra el de cliente
/// tachado como referencia.
class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.product, required this.tier});

  final MaterialProduct product;
  final MaterialPriceTier tier;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          '\$ ${formatCop(tier.priceOf(product))}',
          style: AppTypography.bodyStrong,
        ),
        Text('por ${product.unit}', style: AppTypography.caption),
        if (tier.isVerifiedPro)
          Text(
            '\$ ${formatCop(product.clientPriceCop)}',
            style: AppTypography.caption.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.ink300,
            ),
          ),
      ],
    );
  }
}

/// Fotografía de 59×60; sin imagen muestra un recuadro de marca con ícono.
class _Photo extends StatelessWidget {
  const _Photo({required this.asset});

  final String? asset;

  static const double _width = 59;
  static const double _height = 60;

  Widget get _placeholder => Container(
    width: _width,
    height: _height,
    decoration: const BoxDecoration(
      color: AppColors.brandLight,
      borderRadius: AppSpacing.roundedSm,
    ),
    child: const Icon(LucideIcons.package, size: 22, color: AppColors.brand700),
  );

  @override
  Widget build(BuildContext context) {
    if (asset == null) return _placeholder;
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: AppSpacing.roundedSm,
        image: DecorationImage(
          image: ResizeImage(AssetImage(asset!), width: 160),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
