import 'package:flutter/widgets.dart';

/// Un trazo o relleno de un icono vectorial, en coordenadas de su caja original.
///
/// `d` usa la sintaxis de path SVG con comandos absolutos M/L/H/V/C/Q/Z
/// (los que produce Figma). `RR x y w h r` describe un rectángulo redondeado
/// y `OV x y w h` un óvalo.
class RvIconPath {
  const RvIconPath(
    this.d, {
    this.stroke = true,
    this.strokeWidth = 1.7,
    this.roundCap = false,
    this.roundJoin = false,
    this.color,
    this.opacity = 1,
    this.evenOdd = false,
  });

  final String d;
  final bool stroke;
  final double strokeWidth;
  final bool roundCap;
  final bool roundJoin;

  /// Color fijo (iconos multicolor). Si es null se usa el color del widget.
  final Color? color;
  final double opacity;
  final bool evenOdd;
}

/// Geometría de un icono tal como sale de Figma: caja original y sus paths.
class RvIconData {
  const RvIconData(this.width, this.height, this.paths, {this.clip});

  final double width;
  final double height;
  final List<RvIconPath> paths;

  /// Máscara opcional (path SVG) que recorta todo el icono.
  final String? clip;
}

/// Pinta un [RvIconData] escalado a [size] (lado mayor) conservando el grosor
/// de trazo absoluto de Figma, salvo que se indique [strokeWidth].
class RvIcon extends StatelessWidget {
  const RvIcon(
    this.data, {
    super.key,
    this.size,
    this.color = const Color(0xFF004E49),
    this.strokeWidth,
  });

  final RvIconData data;

  /// Lado del cuadro del icono. Por defecto, el tamaño original de Figma.
  final double? size;
  final Color color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final scale = size == null ? 1.0 : size! / (data.width > data.height ? data.width : data.height);
    return CustomPaint(
      size: Size(data.width * scale, data.height * scale),
      painter: _RvIconPainter(data, color, scale, strokeWidth),
    );
  }
}

class _RvIconPainter extends CustomPainter {
  _RvIconPainter(this.data, this.color, this.scale, this.strokeWidth);

  final RvIconData data;
  final Color color;
  final double scale;
  final double? strokeWidth;

  static final Map<String, Path> _cache = {};

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(scale);
    if (data.clip != null) canvas.clipPath(_parse(data.clip!));
    for (final p in data.paths) {
      final base = p.color ?? color;
      final paint = Paint()
        ..isAntiAlias = true
        ..color = base.withValues(alpha: base.a * p.opacity);
      if (p.stroke) {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = (strokeWidth ?? p.strokeWidth) / scale
          ..strokeCap = p.roundCap ? StrokeCap.round : StrokeCap.butt
          ..strokeJoin = p.roundJoin ? StrokeJoin.round : StrokeJoin.miter;
      }
      final path = _parse(p.d);
      canvas.drawPath(p.evenOdd ? (Path.from(path)..fillType = PathFillType.evenOdd) : path, paint);
    }
    canvas.restore();
  }

  static Path _parse(String d) => _cache.putIfAbsent(d, () => parseSvgPath(d));

  @override
  bool shouldRepaint(_RvIconPainter old) =>
      old.data != data || old.color != color || old.scale != scale || old.strokeWidth != strokeWidth;
}

/// Convierte un path SVG con comandos absolutos (M L H V C Q Z) en [Path].
Path parseSvgPath(String d) {
  final path = Path();
  if (d.startsWith('RR ') || d.startsWith('OV ')) {
    final v = d.substring(3).split(' ').map(double.parse).toList();
    final rect = Rect.fromLTWH(v[0], v[1], v[2], v[3]);
    return d.startsWith('OV ')
        ? (path..addOval(rect))
        : (path..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(v[4]))));
  }
  final tokens = RegExp(r'[MLHVCQZmlhvcqz]|-?\d*\.?\d+(?:e-?\d+)?').allMatches(d).map((m) => m[0]!).toList();
  var i = 0;
  var cmd = 'M';
  var x = 0.0, y = 0.0;
  double next() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    final t = tokens[i];
    if (RegExp(r'^[A-Za-z]$').hasMatch(t)) {
      cmd = t;
      i++;
      if (cmd == 'Z' || cmd == 'z') {
        path.close();
        continue;
      }
    }
    switch (cmd) {
      case 'M':
        x = next();
        y = next();
        path.moveTo(x, y);
        cmd = 'L';
      case 'L':
        x = next();
        y = next();
        path.lineTo(x, y);
      case 'H':
        x = next();
        path.lineTo(x, y);
      case 'V':
        y = next();
        path.lineTo(x, y);
      case 'C':
        final x1 = next(), y1 = next(), x2 = next(), y2 = next();
        x = next();
        y = next();
        path.cubicTo(x1, y1, x2, y2, x, y);
      case 'Q':
        final x1 = next(), y1 = next();
        x = next();
        y = next();
        path.quadraticBezierTo(x1, y1, x, y);
      default:
        throw FormatException('Comando SVG no soportado: $cmd');
    }
  }
  return path;
}
