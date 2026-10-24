import 'package:flutter/material.dart';

import 'pro_icon.dart';
import 'pro_tokens.dart';

enum ProChevronDirection { left, right, down, up }

/// Chevron vectorial de Figma (6×11 por defecto, trazo 1.7 interior).
class ProChevron extends StatelessWidget {
  const ProChevron({
    super.key,
    this.direction = ProChevronDirection.right,
    this.width = 6,
    this.height = 11,
    this.color = ProColors.brand700,
    this.strokeWidth = ProStroke.icon,
  });

  final ProChevronDirection direction;
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final vertical = direction == ProChevronDirection.up || direction == ProChevronDirection.down;
    return SizedBox(
      width: vertical ? height : width,
      height: vertical ? width : height,
      child: CustomPaint(painter: _ChevronPainter(direction, color, strokeWidth)),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  _ChevronPainter(this.direction, this.color, this.strokeWidth);

  final ProChevronDirection direction;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Trazo interior: la línea se mantiene dentro de la caja del vector.
    final i = strokeWidth / 2;
    final w = size.width, h = size.height;
    final points = switch (direction) {
      ProChevronDirection.right => [Offset(i, i), Offset(w - i, h / 2), Offset(i, h - i)],
      ProChevronDirection.left => [Offset(w - i, i), Offset(i, h / 2), Offset(w - i, h - i)],
      ProChevronDirection.down => [Offset(i, i), Offset(w / 2, h - i), Offset(w - i, i)],
      ProChevronDirection.up => [Offset(i, h - i), Offset(w / 2, i), Offset(w - i, h - i)],
    };
    final path = Path()..addPolygon(points, false);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ChevronPainter old) =>
      old.direction != direction || old.color != color || old.strokeWidth != strokeWidth;
}

/// Botón píldora con gradiente de marca.
/// Compacto: alto 32, texto 12, chevron 6×11 (por defecto).
/// Pie de pantalla: [ProPrimaryButton.large] alto 48, texto 14, chevron Lucide 16.
class ProPrimaryButton extends StatelessWidget {
  const ProPrimaryButton(
    this.label, {
    super.key,
    this.onTap,
    this.height = 32,
    this.horizontalPadding = 14,
    this.labelStyle,
    this.trailing = const ProChevron(color: ProColors.surface0),
    this.gap = 6,
    this.gradient = ProColors.brandGradient,
    this.width,
  });

  const ProPrimaryButton.large(
    this.label, {
    super.key,
    this.onTap,
    this.width,
    this.gradient = ProColors.brandGradient,
  })  : height = 48,
        horizontalPadding = 16,
        labelStyle = null,
        trailing = const ProIcon(LucideIcon.chevronRight, size: 16, color: ProColors.surface0),
        gap = 0;

  final String label;
  final VoidCallback? onTap;
  final double height;
  final double horizontalPadding;
  final TextStyle? labelStyle;
  final Widget? trailing;
  final double gap;
  final Gradient gradient;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final style = labelStyle ??
        (height >= 48
            ? ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8)
            : ProText.buttonText);
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(ProRadii.button)),
          child: Row(
            children: [
              Expanded(child: Text(label, style: style, textAlign: TextAlign.center, maxLines: 1)),
              if (trailing != null) ...[SizedBox(width: gap), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón píldora secundario: fondo blanco y borde de marca.
class ProOutlineButton extends StatelessWidget {
  const ProOutlineButton(
    this.label, {
    super.key,
    this.onTap,
    this.height = 32,
    this.labelStyle,
    this.borderColor = ProColors.brand700,
    this.borderWidth = 1,
    this.background = ProColors.surface0,
    this.leading,
    this.trailing,
    this.width,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;
  final TextStyle? labelStyle;
  final Color borderColor;
  final double borderWidth;
  final Color background;
  final Widget? leading;
  final Widget? trailing;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(ProRadii.button),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 6)],
              Flexible(
                child: Text(
                  label,
                  style: labelStyle ?? ProText.r(12, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 14.4),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
