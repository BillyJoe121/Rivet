import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta de precio y disponibilidad medida de "Detalle de material"
/// (nodo 22:144789): fondo `brandLight`, borde interior 0.6 `line300`,
/// radio 16, padding 12 y 9 px entre filas.
///
/// Primera fila: monto Roboto 600 20/24 `ink700` y chip "● Disponible"
/// (`successLight`, padding 5×9, Roboto 400 11/13.2 de marca). Segunda fila:
/// unidad y existencias en dos columnas iguales, Roboto 400 11/13.2 `ink700`.
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
    final detailStyle = AppTypography.caption.copyWith(color: AppColors.ink700);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: AppSpacing.roundedLg,
      ),
      // Trazo interior como en Figma: no desplaza el contenido.
      foregroundDecoration: BoxDecoration(
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.line300, width: AppSpacing.strokeCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  priceCop,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // Roboto 600 20/24: sin token exacto (priceDisplay es 19).
                  style: AppTypography.priceDisplay.copyWith(
                    fontSize: 20,
                    height: 24 / 20,
                    color: AppColors.ink700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppSpacing.roundedXl,
                ),
                child: Text(
                  '● $statusText',
                  style: AppTypography.caption.copyWith(color: AppColors.brand700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(child: Text(unitText, style: detailStyle)),
              const SizedBox(width: 10),
              Expanded(child: Text(stockText, style: detailStyle)),
            ],
          ),
        ],
      ),
    );
  }
}
