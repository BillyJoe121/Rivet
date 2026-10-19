import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Bloque métrico para mostrar cantidades, totales monetarios o medidas.
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: highlight ? AppColors.brandLight : AppColors.surface0,
        borderRadius: AppSpacing.roundedSm,
        border: Border.all(
          color: highlight ? AppColors.brand700.withValues(alpha: 0.3) : AppColors.line300,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: highlight ? Colors.white : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 20,
                color: highlight ? AppColors.brand700 : AppColors.ink700,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: highlight ? AppColors.brand700 : AppColors.ink700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.subheading.copyWith(
                    color: highlight ? AppColors.brand700 : AppColors.ink900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
