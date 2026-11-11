import 'package:flutter/widgets.dart';

import 'lucide_icons.dart';
import '../../theme/theme.dart';
import 'svg_path_parser.dart';

export 'lucide_icons.dart';

/// Ícono de línea Lucide dibujado como en Figma: la geometría se escala al
/// tamaño pedido y el trazo conserva su grosor absoluto (1.7 px por defecto).
class ProIcon extends StatelessWidget {
  const ProIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color = AppColors.brand700,
    this.strokeWidth = AppSpacing.strokeIcon,
  });

  final LucideIcon icon;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _LucidePainter(icon, color, strokeWidth)),
    );
  }
}

class _LucidePainter extends CustomPainter {
  _LucidePainter(this.icon, this.color, this.strokeWidth);

  final LucideIcon icon;
  final Color color;
  final double strokeWidth;

  static final Map<LucideIcon, Path> _cache = {};

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final path = _cache.putIfAbsent(icon, () {
      final p = Path();
      for (final d in icon.paths) {
        p.addPath(SvgPathParser(d).parse(), Offset.zero);
      }
      return p;
    });
    canvas.save();
    canvas.scale(scale);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth / scale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LucidePainter old) =>
      old.icon != icon || old.color != color || old.strokeWidth != strokeWidth;
}
