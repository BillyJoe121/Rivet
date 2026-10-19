import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppBadgeVariant { success, warning, danger, info, brand, neutral }

/// Insignia semántica de estado para etiquetas, estados de proyectos y pedidos.
/// Cumple la regla AntiSlop de combinar color, icono y texto explícito.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
  });

  final String text;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, defaultIcon) = switch (variant) {
      AppBadgeVariant.success => (
          AppColors.successLight,
          AppColors.success700.withValues(alpha: 0.3),
          AppColors.success700,
          Icons.check_circle_outline,
        ),
      AppBadgeVariant.warning => (
          AppColors.warningLight,
          AppColors.warning800.withValues(alpha: 0.3),
          AppColors.warning800,
          Icons.schedule,
        ),
      AppBadgeVariant.danger => (
          AppColors.dangerLight,
          AppColors.danger700.withValues(alpha: 0.3),
          AppColors.danger700,
          Icons.error_outline,
        ),
      AppBadgeVariant.info => (
          AppColors.infoLight,
          AppColors.info700.withValues(alpha: 0.3),
          AppColors.info700,
          Icons.info_outline,
        ),
      AppBadgeVariant.brand => (
          AppColors.brandLight,
          AppColors.brand700.withValues(alpha: 0.3),
          AppColors.brand700,
          Icons.verified_outlined,
        ),
      AppBadgeVariant.neutral => (
          AppColors.surfaceSubtle,
          AppColors.line300,
          AppColors.ink700,
          Icons.label_outline,
        ),
    };

    final effectiveIcon = icon ?? defaultIcon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedPill,
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(effectiveIcon, size: 13, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTypography.badgeText.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
