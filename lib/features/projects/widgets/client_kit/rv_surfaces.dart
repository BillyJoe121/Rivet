import 'package:flutter/material.dart';

import 'rv_icon_data.dart';
import 'rv_tokens.dart';

/// Tarjeta blanca de Figma con trazo interior (0.6 `#E6E9E4` por defecto).
class RvCard extends StatelessWidget {
  const RvCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.radius = RvRadii.lg,
    this.color = RvColors.surface0,
    this.borderColor = RvColors.line300,
    this.borderWidth = RvLayout.cardStroke,
    this.width,
    this.height,
    this.onTap,
    this.shadow,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: width,
      height: height,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor!, width: borderWidth),
        boxShadow: shadow,
      ),
      child: child,
    );
    if (onTap == null) return box;
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: box);
  }
}

/// Pastilla de estado (r20, padding 5×9, Roboto 400 11/13.2 por defecto).
class RvChip extends StatelessWidget {
  const RvChip({
    super.key,
    required this.label,
    this.background = RvColors.warningLight,
    this.foreground = RvColors.sun300,
    this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    this.textStyle,
    this.radius = RvRadii.xl,
  });

  final String label;
  final Color background;
  final Color foreground;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius)),
      child: Text(label, style: textStyle ?? rvText(11, lineHeight: 13.2, color: foreground)),
    );
  }
}

/// Título de sección: Roboto 600 15/18 `#082A40` con acción opcional a la derecha.
class RvSectionTitle extends StatelessWidget {
  const RvSectionTitle(this.title, {super.key, this.trailing, this.style});

  final String title;
  final Widget? trailing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: style ?? RvText.sectionTitle)),
        ?trailing,
      ],
    );
  }
}

/// Campo de formulario de Figma: 54 de alto, blanco, trazo 1, r12, padding
/// horizontal 12, ícono de 19 y texto Roboto 400 13/17.55.
class RvField extends StatelessWidget {
  const RvField({
    super.key,
    required this.text,
    this.icon,
    this.height = 54,
    this.textColor = RvColors.ink500,
    this.trailing,
    this.iconSize = 19,
    this.onTap,
  });

  final String text;
  final RvIconData? icon;
  final double height;
  final Color textColor;
  final Widget? trailing;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RvCard(
      height: height,
      radius: RvRadii.md,
      borderWidth: 1,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (icon != null) ...[RvIcon(icon!, size: iconSize), const SizedBox(width: 10)],
          Expanded(child: Text(text, style: RvText.field.copyWith(color: textColor))),
          ?trailing,
        ],
      ),
    );
  }
}

/// Barra de progreso: pista `#DDE7E1`, avance `#06A77B`, radio 5.
class RvProgressBar extends StatelessWidget {
  const RvProgressBar({super.key, required this.width, required this.progress, this.height = 7});

  final double width;
  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: RvColors.progressTrack, borderRadius: BorderRadius.circular(5)),
      child: Container(
        width: width * progress,
        decoration: BoxDecoration(color: RvColors.success700, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

/// Indicador de pasos: círculos de 28 (activo con gradiente), número
/// Roboto 600 14 y etiqueta Roboto 400 10/12 debajo con gap 5.
class RvStepIndicator extends StatelessWidget {
  const RvStepIndicator({super.key, required this.labels, required this.current});

  final List<String> labels;

  /// Índice (desde 0) del paso activo; los anteriores también se resaltan.
  final int current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: i <= current ? RvColors.brandGradient : null,
                      color: i <= current ? null : RvColors.stepIdle,
                      borderRadius: BorderRadius.circular(RvRadii.xl),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: RvText.titleSmall.copyWith(color: i <= current ? RvColors.surface0 : RvColors.ink900),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: RvText.micro.copyWith(color: i <= current ? RvColors.brand700 : RvColors.ink500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
