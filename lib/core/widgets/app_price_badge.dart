import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Píldora de precio y disponibilidad idéntica a Figma:
/// Monto destacado en grande, estado con punto de color (`• Disponible`),
/// unidad y disponibilidad en texto secundario.
class AppPriceBadge extends StatelessWidget {
  const AppPriceBadge({
    super.key,
    required this.priceCop,
    this.unitText = 'por galón (1 gal)',
    this.statusText = 'Disponible',
    this.stockText = 'Más de 50 unidades',
  });

  final String priceCop;
  final String unitText;
  final String statusText;
  final String stockText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                priceCop,
                style: AppTypography.priceDisplay,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.brand700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.brand700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(unitText, style: AppTypography.caption),
              Text(stockText, style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}
