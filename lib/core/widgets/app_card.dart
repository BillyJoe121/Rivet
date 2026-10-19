import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta flotante orgánica con bordes redondeados (18-20px),
/// superficie blanca pura y sombra difusa cálida sin bordes duros.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.backgroundColor = AppColors.surface0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.isSelected = false,
    this.hasShadow = true,
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
    final effectiveRadius = borderRadius ?? BorderRadius.circular(18);
    final effectiveBorderColor = isSelected
        ? AppColors.brand700
        : (borderColor ?? AppColors.line300.withValues(alpha: 0.5));
    final effectiveBorderWidth = isSelected ? 2.0 : (borderColor != null ? borderWidth : 0.8);

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.softShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: card,
        ),
      );
    }

    return card;
  }
}
