import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../material_price_tier.dart';

/// Tarjeta de un material de la Bodega: fotografía de 59×60, nombre, marca,
/// categoría y precio según [tier]. No es tocable: no hay pantalla de detalle.
class CatalogMaterialCard extends StatelessWidget {
  const CatalogMaterialCard({super.key, required this.product, required this.tier});

  final MaterialProduct product;
  final MaterialPriceTier tier;

  @override
  Widget build(BuildContext context) {
    final detail = [
      product.brand,
      product.category,
      if (product.finish != null) product.finish!,
    ].join(' · ');

    return AppCard(
      borderRadius: AppSpacing.roundedCard,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          _Photo(asset: product.imageAsset),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.name, style: AppTypography.titleSmall),
                Text(detail, style: AppTypography.label),
                const SizedBox(height: AppSpacing.xxs),
                _PriceLine(product: product, tier: tier),
              ],
            ),
          ),
          if (!product.inStock) ...[
            const SizedBox(width: AppSpacing.sm),
            const AppBadge(text: 'Agotado', variant: AppBadgeVariant.neutral, compact: true),
          ],
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
        Text('\$ ${formatCop(tier.priceOf(product))}', style: AppTypography.bodyStrong),
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
    return ClipRRect(
      borderRadius: AppSpacing.roundedSm,
      child: Image.asset(
        asset!,
        width: _width,
        height: _height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder,
      ),
    );
  }
}
