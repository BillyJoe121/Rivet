import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'material_price_tier.dart';

/// Ficha técnica y detalle de un producto de la Bodega Rivet (P-024).
class MaterialDetailScreen extends StatelessWidget {
  const MaterialDetailScreen({
    super.key,
    required this.product,
    this.tier = MaterialPriceTier.client,
  });

  final MaterialProduct product;
  final MaterialPriceTier tier;

  @override
  Widget build(BuildContext context) {
    final effectivePrice = tier.isVerifiedPro
        ? product.proPriceCop
        : product.clientPriceCop;

    return RivetScaffold(
      title: product.name,
      backgroundImagePath: product.imageAsset ?? AppHeroImages.paintShelf,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: AppTypography.subheading.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppBadge(
                      text: product.inStock ? 'Disponible' : 'Agotado',
                      variant: product.inStock
                          ? AppBadgeVariant.success
                          : AppBadgeVariant.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.tag,
                        color: AppColors.brand700,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio por ${product.unit}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink700,
                            ),
                          ),
                          Text(
                            '\$ ${formatCop(effectivePrice)} COP',
                            style: AppTypography.sectionTitle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Especificaciones',
                  style: AppTypography.subheading.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppSpecRow(
                  icon: LucideIcons.layers,
                  label: 'Categoría',
                  value: product.category,
                ),
                AppSpecRow(
                  icon: LucideIcons.package,
                  label: 'Presentación',
                  value: product.unit,
                ),
                if (product.finish != null)
                  AppSpecRow(
                    icon: LucideIcons.sparkles,
                    label: 'Acabado',
                    value: product.finish!,
                  ),
                AppSpecRow(
                  icon: LucideIcons.shieldCheck,
                  label: 'Distribución',
                  value: 'Bodega Rivet Directo',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

