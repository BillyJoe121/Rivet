import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Ítem de lista de especificación técnica o detalle estructurado con
/// icono lineal, título, valor alineado y chevron de navegación fino.
class AppSpecRow extends StatelessWidget {
  const AppSpecRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.brand700),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink900,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.ink700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.ink500,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 0.8,
            color: AppColors.line300,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
