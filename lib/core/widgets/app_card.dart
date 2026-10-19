import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Tarjeta base estandarizada con superficie blanca y borde sutil.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
    this.backgroundColor = AppColors.surface0,
    this.borderColor = AppColors.line300,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.isSelected = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppSpacing.roundedMd;
    final effectiveBorderColor = isSelected ? AppColors.brand700 : borderColor;
    final effectiveBorderWidth = isSelected ? 2.0 : borderWidth;

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
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
