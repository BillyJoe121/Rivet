import 'package:flutter/material.dart';

import 'pro_icon.dart';
import 'pro_tokens.dart';

/// Fila de opción: ícono de 23 px, título en negrita y subtítulo gris en un
/// mismo bloque de texto, acción a la derecha y separador inferior de 0.5 px.
class ProOptionRow extends StatelessWidget {
  const ProOptionRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing = const ProIcon(LucideIcon.chevronRight, size: 15),
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
    this.iconSize = 23,
    this.showDivider = true,
    this.titleStyle,
    this.subtitleStyle,
    this.lineHeight = 15.6,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final LucideIcon? icon;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final bool showDivider;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double lineHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lead = leading ?? (icon == null ? null : ProIcon(icon!, size: iconSize));
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: showDivider
            ? const BoxDecoration(
                border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
              )
            : null,
        child: Row(
          children: [
            if (lead != null) ...[lead, const SizedBox(width: 10)],
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: titleStyle ?? ProText.r(12, weight: FontWeight.w600, lineHeight: lineHeight),
                    ),
                    if (subtitle != null)
                      TextSpan(
                        text: '\n$subtitle',
                        style: subtitleStyle ?? ProText.r(11, color: ProColors.ink500, lineHeight: lineHeight),
                      ),
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 10), trailing!],
          ],
        ),
      ),
    );
  }
}

/// Acceso rápido de inicio: tarjeta de 86×90 con ícono de 27 px y etiqueta.
class ProQuickAccess extends StatelessWidget {
  const ProQuickAccess({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.height = 90,
  });

  final LucideIcon icon;
  final String label;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProColors.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProRadii.card),
        side: const BorderSide(color: ProColors.line300, width: ProStroke.hairline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProRadii.card),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProIcon(icon, size: 27),
                const SizedBox(height: 9),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
