import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta de lista medida del Figma (nodo 2027:231 "Pedido"): superficie
/// blanca, borde interior de 0.6 en `line300`, radio 16, padding 18 y sin
/// sombra. El diseño es plano; la sombra solo aparece con [hasShadow].
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
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
    final side = isSelected
        ? const BorderSide(
            color: AppColors.brand700,
            width: AppSpacing.strokeDivider,
          )
        : BorderSide(
            color: borderColor ?? AppColors.line300,
            width: borderWidth,
          );

    final stroke = BoxDecoration(
      borderRadius: effectiveRadius,
      border: Border.fromBorderSide(side),
    );
    final surface = BoxDecoration(
      color: backgroundColor,
      borderRadius: effectiveRadius,
      boxShadow: hasShadow ? AppSpacing.shadowCard : null,
    );

    final card = Container(
      padding: padding,
      decoration: surface,
      foregroundDecoration: stroke,
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: card,
    );
  }
}
