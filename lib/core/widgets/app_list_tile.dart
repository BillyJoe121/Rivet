import 'package:flutter/material.dart';
// Trazo 1.7 a 15 px se acerca más al peso 500 de Lucide.
import 'package:lucide_icons_flutter/lucide_icons_500.dart';

import '../theme/theme.dart';

/// Fila de opción (nodos "Opción" de 22:143552 y 22:146416): ícono de línea
/// de 23 px, título Roboto 600 12, subtítulo Roboto 400 11 ink500 con un
/// metadato opcional, chevron a la derecha y separador inferior de 1 px.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.meta,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.showChevron = true,
    this.showDivider = true,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  /// Dato secundario alineado en la mitad derecha del subtítulo
  /// (p. ej. "Hace 1 h").
  final String? meta;
  final IconData? leadingIcon;

  /// Reemplaza a [leadingIcon] (p. ej. un [AppAvatar]).
  final Widget? leading;

  /// Reemplaza al chevron (p. ej. un [AppSwitch]).
  final Widget? trailing;
  final bool showChevron;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lead =
        leading ??
        (leadingIcon == null
            ? null
            : Icon(leadingIcon, size: 23, color: AppColors.brand700));
    final trail =
        trailing ??
        (showChevron
            ? const Icon(
                LucideIcons500.chevronRight,
                size: 15,
                color: AppColors.brand700,
              )
            : null);
    // El texto usa interlineado de 130 % del tamaño: 11 px -> 14.3.
    final subtitleStyle = AppTypography.caption.copyWith(height: 1.3);

    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          // El separador se pinta encima (trazo interior) sin sumar alto.
          foregroundDecoration: showDivider
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.line300,
                      width: AppSpacing.strokeDivider,
                    ),
                  ),
                )
              : null,
          child: Row(
            children: [
              if (lead != null) ...[lead, const SizedBox(width: 10)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelStrong.copyWith(
                        height: 15.6 / 12,
                      ),
                    ),
                    if (subtitle != null || meta != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: subtitleStyle,
                            ),
                          ),
                          if (meta != null)
                            Expanded(
                              child: Text(
                                meta!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: subtitleStyle,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              if (trail != null) ...[const SizedBox(width: 10), trail],
            ],
          ),
        ),
      ),
    );
  }
}

/// Interruptor de 36×21 (nodo "Interruptor" de 22:146416): pista de marca
/// con perilla blanca de 15 px y padding 3.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 36,
          height: 21,
          padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? AppColors.brand700 : AppColors.lineDark,
            borderRadius: AppSpacing.roundedXl,
          ),
          child: Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: AppColors.surface0,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
