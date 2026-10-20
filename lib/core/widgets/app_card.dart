import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta de lista medida del Figma (nodo 2027:231 "Pedido"): superficie
/// blanca, borde interior de 0.6 en `line300`, radio 16, padding 10 y sin
/// sombra. El diseño es plano; la sombra solo aparece con [hasShadow].
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
    this.backgroundColor = AppColors.surface0,
    this.borderColor,
    this.borderWidth = AppSpacing.strokeCard,
    this.borderRadius,
    this.isSelected = false,
    this.hasShadow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppSpacing.roundedLg;
    // Selección medida en el selector de rol del Registro (nodo 14:30):
    // borde de marca de 1 px.
    final side = isSelected
        ? const BorderSide(color: AppColors.brand700, width: AppSpacing.strokeDivider)
        : BorderSide(color: borderColor ?? AppColors.line300, width: borderWidth);

    // El trazo es interior (como en Figma) y se pinta encima sin desplazar
    // el contenido.
    final stroke = BoxDecoration(
      borderRadius: effectiveRadius,
      border: Border.fromBorderSide(side),
    );
    final surface = BoxDecoration(
      color: backgroundColor,
      borderRadius: effectiveRadius,
    );
    final shadow = hasShadow ? AppSpacing.shadowCard : null;

    if (onTap == null) {
      return Container(
        padding: padding,
        decoration: surface.copyWith(boxShadow: shadow),
        foregroundDecoration: stroke,
        child: child,
      );
    }

    // Con acción, la onda se pinta dentro de la superficie y respeta el radio.
    return Container(
      decoration: BoxDecoration(borderRadius: effectiveRadius, boxShadow: shadow),
      foregroundDecoration: stroke,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: surface,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
