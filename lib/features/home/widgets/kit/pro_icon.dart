import 'package:flutter/widgets.dart';

import 'lucide_icons.dart';
import 'pro_tokens.dart';

export 'lucide_icons.dart';

/// Ícono de línea Lucide dibujado como en Figma: la geometría se escala al
/// tamaño pedido y el trazo conserva su grosor absoluto (1.7 px por defecto).
class ProIcon extends StatelessWidget {
  const ProIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color = ProColors.brand700,
    this.strokeWidth = ProStroke.icon,
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

/// Intérprete mínimo de datos de trayectoria SVG (M L H V C S Q T A Z,
/// absolutos y relativos), suficiente para los íconos Lucide.
class SvgPathParser {
  SvgPathParser(this.source);

  final String source;
  int _i = 0;

  static final RegExp _number = RegExp(r'[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?');

  Path parse() {
    final path = Path();
    var cmd = '';
    var cx = 0.0, cy = 0.0, sx = 0.0, sy = 0.0;
    var lastCtrlX = 0.0, lastCtrlY = 0.0;
    var lastCmd = '';
    while (true) {
      _skipSeparators();
      if (_i >= source.length) break;
      final ch = source[_i];
      if (RegExp(r'[A-Za-z]').hasMatch(ch)) {
        cmd = ch;
        _i++;
      } else if (cmd == 'M') {
        cmd = 'L';
      } else if (cmd == 'm') {
        cmd = 'l';
      }
      final rel = cmd.toLowerCase() == cmd;
      final ox = rel ? cx : 0.0, oy = rel ? cy : 0.0;
      switch (cmd.toUpperCase()) {
        case 'M':
          cx = ox + _n();
          cy = oy + _n();
          sx = cx;
          sy = cy;
          path.moveTo(cx, cy);
        case 'L':
          cx = ox + _n();
          cy = oy + _n();
          path.lineTo(cx, cy);
        case 'H':
          cx = ox + _n();
          path.lineTo(cx, cy);
        case 'V':
          cy = (rel ? cy : 0.0) + _n();
          path.lineTo(cx, cy);
        case 'C':
          final x1 = ox + _n(), y1 = oy + _n();
          lastCtrlX = ox + _n();
          lastCtrlY = oy + _n();
          cx = ox + _n();
          cy = oy + _n();
          path.cubicTo(x1, y1, lastCtrlX, lastCtrlY, cx, cy);
        case 'S':
          final reflect = 'CcSs'.contains(lastCmd);
          final x1 = reflect ? 2 * cx - lastCtrlX : cx;
          final y1 = reflect ? 2 * cy - lastCtrlY : cy;
          lastCtrlX = ox + _n();
          lastCtrlY = oy + _n();
          cx = ox + _n();
          cy = oy + _n();
          path.cubicTo(x1, y1, lastCtrlX, lastCtrlY, cx, cy);
        case 'Q':
          lastCtrlX = ox + _n();
          lastCtrlY = oy + _n();
          cx = ox + _n();
          cy = oy + _n();
          path.quadraticBezierTo(lastCtrlX, lastCtrlY, cx, cy);
        case 'T':
          final reflect = 'QqTt'.contains(lastCmd);
          lastCtrlX = reflect ? 2 * cx - lastCtrlX : cx;
          lastCtrlY = reflect ? 2 * cy - lastCtrlY : cy;
          cx = ox + _n();
          cy = oy + _n();
          path.quadraticBezierTo(lastCtrlX, lastCtrlY, cx, cy);
        case 'A':
          final rx = _n(), ry = _n(), rot = _n();
          final large = _flag(), sweep = _flag();
          cx = ox + _n();
          cy = oy + _n();
          path.arcToPoint(
            Offset(cx, cy),
            radius: Radius.elliptical(rx, ry),
            rotation: rot,
            largeArc: large,
            clockwise: sweep,
          );
        case 'Z':
          path.close();
          cx = sx;
          cy = sy;
      }
      lastCmd = cmd;
    }
    return path;
  }

  void _skipSeparators() {
    while (_i < source.length && ' ,\n\t'.contains(source[_i])) {
      _i++;
    }
  }

  double _n() {
    _skipSeparators();
    final m = _number.matchAsPrefix(source, _i)!;
    _i = m.end;
    return double.parse(m.group(0)!);
  }

  bool _flag() {
    _skipSeparators();
    return source[_i++] == '1';
  }
}
