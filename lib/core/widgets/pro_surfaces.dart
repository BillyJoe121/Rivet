import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'icons/pro_icon.dart';

/// Tarjeta blanca de Figma: borde interior de 0.6 px y radio 16.
class ProCard extends StatelessWidget {
  const ProCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.radius = AppSpacing.radiusLg,
    this.color = AppColors.surface0,
    this.borderColor = AppColors.line300,
    this.borderWidth = AppSpacing.strokeCard,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!, width: borderWidth),
    );
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: color,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Aviso informativo: fondo verde suave, ícono de 23 px y texto gris.
class ProNote extends StatelessWidget {
  const ProNote({
    super.key,
    required this.text,
    this.icon = LucideIcon.info,
    this.iconSize = 23,
    this.color = AppColors.brandLight,
    this.textStyle,
    this.padding = const EdgeInsets.all(12),
    this.gap = 10,
    this.radius = AppSpacing.radiusMd,
  });

  final String text;
  final LucideIcon? icon;
  final double iconSize;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double gap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            ProIcon(icon!, size: iconSize),
            SizedBox(width: gap),
          ],
          Expanded(child: Text(text, style: textStyle ?? AppTypography.proportional(12, color: AppColors.ink500, lineHeight: 14.4))),
        ],
      ),
    );
  }
}

/// Pastilla de estado ("Nuevo", "En preparación").
class ProChip extends StatelessWidget {
  const ProChip(
    this.label, {
    super.key,
    this.background = AppColors.warningLight,
    this.foreground = AppColors.warning800,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.textStyle,
  });

  final String label;
  final Color background;
  final Color foreground;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Text(label, style: textStyle ?? AppTypography.microProportional.copyWith(color: foreground)),
    );
  }
}

/// Título de sección con enlace o pastilla de conteo a la derecha.
class ProSectionHeader extends StatelessWidget {
  const ProSectionHeader(
    this.title, {
    super.key,
    this.count,
    this.linkLabel,
    this.onLinkTap,
    this.titleStyle,
  });

  final String title;
  final int? count;
  final String? linkLabel;
  final VoidCallback? onLinkTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: titleStyle ?? AppTypography.subheadingProportional)),
        if (count != null) ProCountPill(count!),
        if (linkLabel != null)
          GestureDetector(
            onTap: onLinkTap,
            child: Text(linkLabel!, style: AppTypography.proportional(12, color: AppColors.brand700, lineHeight: 14.4)),
          ),
      ],
    );
  }
}

/// Pastilla de conteo de 26×22.
class ProCountPill extends StatelessWidget {
  const ProCountPill(this.value, {super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 26),
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.brandLight, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Text('$value',
          style: AppTypography.proportional(11, weight: FontWeight.w600, color: AppColors.brand700, lineHeight: 12.890625)),
    );
  }
}

/// Barra de progreso de 7 px.
class ProProgressBar extends StatelessWidget {
  const ProProgressBar({
    super.key,
    required this.value,
    this.height = 7,
    this.track = AppColors.leaf300,
    this.fill = AppColors.success700,
    this.radius = 5,
  });

  final double value;
  final double height;
  final Color track;
  final Color fill;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(radius)),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0, 1),
        child: Container(decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(radius))),
      ),
    );
  }
}

/// Avatar circular con iniciales.
class ProInitialsAvatar extends StatelessWidget {
  const ProInitialsAvatar(
    this.initials, {
    super.key,
    this.size = 36,
    this.color = AppColors.brand700,
    this.textStyle,
  });

  final String initials;
  final double size;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(initials, style: textStyle ?? AppTypography.proportional(12, color: AppColors.surface0, lineHeight: 14.4)),
    );
  }
}

/// Imagen recortada con radio, como los rectángulos con relleno de imagen.
class ProImage extends StatelessWidget {
  const ProImage(
    this.asset, {
    super.key,
    required this.width,
    required this.height,
    this.radius = AppSpacing.radiusSm,
    this.fit = BoxFit.cover,
    this.background,
  });

  final String asset;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        color: background,
        child: Image.asset(asset, fit: fit, errorBuilder: (_, _, _) => const SizedBox.shrink()),
      ),
    );
  }
}

/// Separador horizontal.
class ProDivider extends StatelessWidget {
  const ProDivider({super.key, this.thickness = AppSpacing.strokeHairline, this.color = AppColors.line300});

  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: thickness, color: color);
}
