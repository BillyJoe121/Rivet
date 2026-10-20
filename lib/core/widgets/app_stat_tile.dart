import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta de resumen medida de "Inicio del proveedor" (nodo 22:146136
/// "Resumen"): blanca, borde interior 0.5 `line300`, radio 12, padding 10
/// y 4 px entre el valor (Roboto 600 18/21.6 `ink700`) y la etiqueta
/// (Roboto 400 11/13.2 `ink500`) que va debajo.
///
/// [highlight] cambia el fondo a `brandLight` y el valor al color de marca.
class AppStatTile extends StatelessWidget {
  const AppStatTile({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final accent = highlight ? AppColors.brand700 : AppColors.ink700;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight ? AppColors.brandLight : AppColors.surface0,
        borderRadius: AppSpacing.roundedMd,
      ),
      // Trazo interior de 0.5 como en Figma: no desplaza el contenido.
      foregroundDecoration: BoxDecoration(
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.line300, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.brand700),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.statNumber.copyWith(color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTypography.caption.copyWith(color: AppColors.ink300),
            ),
          ],
        ],
      ),
    );
  }
}
