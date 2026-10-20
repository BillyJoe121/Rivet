import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppBadgeVariant { success, warning, danger, info, brand, neutral }

/// Chip de estado medido del Figma: píldora de radio 20 sin borde.
///
/// - Estándar (45 usos, p. ej. "Listo para retiro" en tarjetas): alto 23,
///   padding 5×9, Roboto 400 11/13.2.
/// - [compact] (nodo 2027:259): alto 20, padding 4×8, Roboto 400 10/12.
/// - [AppBadge.count] (nodo 2027:228): pastilla de conteo 26×22 en
///   `brandLight`, Roboto 600 11 en color de marca.
///
/// El texto siempre explica el estado; el icono es opcional ([icon]).
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
    this.compact = false,
  }) : _isCount = false;

  /// Pastilla de conteo junto a los títulos de sección.
  const AppBadge.count({
    super.key,
    required this.text,
  })  : variant = AppBadgeVariant.brand,
        icon = null,
        compact = false,
        _isCount = true;

  final String text;
  final AppBadgeVariant variant;
  final IconData? icon;

  /// Versión de 20 px de alto usada dentro de tarjetas densas.
  final bool compact;

  final bool _isCount;

  @override
  Widget build(BuildContext context) {
    if (_isCount) {
      return Container(
        constraints: const BoxConstraints(minWidth: 26, minHeight: 22),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: const BoxDecoration(
          color: AppColors.brandLight,
          borderRadius: AppSpacing.roundedXl,
        ),
        // Centrado sin expandirse al espacio disponible.
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Text(text, style: AppTypography.countText),
        ),
      );
    }

    // Colores medidos: los chips informativos usan texto de marca.
    final (bg, fg) = switch (variant) {
      AppBadgeVariant.success => (AppColors.successLight, AppColors.brand700),
      AppBadgeVariant.warning => (AppColors.warningLight, AppColors.warning800),
      AppBadgeVariant.danger => (AppColors.dangerLight, AppColors.danger700),
      AppBadgeVariant.info => (AppColors.infoLight, AppColors.brand700),
      AppBadgeVariant.brand => (AppColors.brandLight, AppColors.brand700),
      AppBadgeVariant.neutral => (AppColors.surfaceSubtle, AppColors.ink700),
    };

    final textStyle = (compact ? AppTypography.badgeText : AppTypography.caption)
        .copyWith(color: fg);

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 11 : 12, color: fg),
            const SizedBox(width: AppSpacing.xs),
          ],
          // Sin flex: el chip suele vivir en filas sin límite de ancho.
          Text(text, style: textStyle, maxLines: 1),
        ],
      ),
    );
  }
}
