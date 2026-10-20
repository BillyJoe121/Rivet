import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme.dart';

enum AppInfoBannerVariant {
  /// Fondo `brandLight` con ícono `info` de marca (la mayoría de avisos).
  info,

  /// Fondo `warningLight` con ícono `circle-alert` ámbar (p. ej. 66:14130).
  warning,

  /// Fondo `dangerLight` con ícono de alerta en `danger700`.
  danger,
}

/// Aviso informativo (nodo 2027:272 y "Aviso" en 22:146466, 22:144582…):
/// radio 12, padding 12, separación 10, ícono de línea y texto ink500.
///
/// [compact] reproduce 2027:272 (ícono 20, texto 11/13.2); por defecto se usa
/// la variante más frecuente (ícono 23, texto 12/14.4).
class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    super.key,
    required this.message,
    this.variant = AppInfoBannerVariant.info,
    this.compact = false,
    this.icon,
    this.iconSize,
  });

  final String message;
  final AppInfoBannerVariant variant;
  final bool compact;

  /// Reemplaza el ícono por defecto de la variante.
  final IconData? icon;

  /// Tamaño del ícono; por defecto 20 en [compact] y 23 en el resto
  /// (algunos avisos de alerta usan 20 con texto de 12).
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final (
      Color background,
      Color iconColor,
      IconData defaultIcon,
    ) = switch (variant) {
      AppInfoBannerVariant.info => (
        AppColors.brandLight,
        AppColors.brand700,
        LucideIcons.info,
      ),
      AppInfoBannerVariant.warning => (
        AppColors.warningLight,
        AppColors.warning800,
        LucideIcons.circleAlert,
      ),
      AppInfoBannerVariant.danger => (
        AppColors.dangerLight,
        AppColors.danger700,
        LucideIcons.circleAlert,
      ),
    };
    final textStyle = compact ? AppTypography.caption : AppTypography.label;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppSpacing.roundedMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? defaultIcon,
            size: iconSize ?? (compact ? 20 : 23),
            color: iconColor,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: textStyle)),
        ],
      ),
    );
  }
}
