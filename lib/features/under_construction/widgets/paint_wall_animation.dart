import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/theme.dart';

/// Pared que se pinta por franjas: un rodillo recorre cada franja en zigzag y
/// deja detrás el relleno de marca. Al terminar, la pintura se desvanece y el
/// ciclo vuelve a empezar sin saltos.
///
/// Con [animate] en falso (animaciones del sistema desactivadas) muestra un
/// estado fijo a medio pintar.
class PaintWallAnimation extends StatefulWidget {
  const PaintWallAnimation({
    super.key,
    this.animate = true,
    this.duration = const Duration(milliseconds: 3600),
  });

  final bool animate;
  final Duration duration;

  @override
  State<PaintWallAnimation> createState() => _PaintWallAnimationState();
}

class _PaintWallAnimationState extends State<PaintWallAnimation> with SingleTickerProviderStateMixin {
  // Cuánto del ciclo se dedica a pintar; el resto desvanece la pintura.
  static const _paintShare = 0.86;
  // Avance fijo del estado estático (a medio pintar).
  static const _staticPhase = 0.6;
  static const _badge = 34.0;

  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(PaintWallAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.animate) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final v = widget.animate ? _controller.value : 0.0;
          final phase = widget.animate ? math.min(v / _paintShare, 1.0) : _staticPhase;
          final fade = widget.animate && v > _paintShare ? 1 - (v - _paintShare) / (1 - _paintShare) : 1.0;
          final geometry = _WallGeometry(phase);
          final wobble = widget.animate ? math.sin(phase * math.pi * 2 * 10) : 0.0;
          return LayoutBuilder(
            builder: (context, box) {
              final center = geometry.rollerCenter(box.maxWidth, box.maxHeight);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: AppSpacing.roundedMd,
                      child: CustomPaint(painter: _WallPainter(geometry, fade)),
                    ),
                  ),
                  Positioned(
                    left: center.dx.clamp(_badge / 2, box.maxWidth - _badge / 2) - _badge / 2,
                    top: center.dy - _badge / 2 + wobble * 2,
                    child: Opacity(
                      opacity: fade,
                      child: Transform.rotate(
                        angle: wobble * 0.1,
                        child: Container(
                          width: _badge,
                          height: _badge,
                          decoration: const BoxDecoration(
                            color: AppColors.surface0,
                            shape: BoxShape.circle,
                            boxShadow: AppSpacing.shadowElevated,
                          ),
                          child: const Icon(LucideIcons.paintRoller, size: 18, color: AppColors.brand700),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Reparto de la pintura por franjas a partir del avance total (0 a 1).
class _WallGeometry {
  _WallGeometry(double phase)
      : active = math.min((phase * bands).floor(), bands - 1),
        local = phase * bands - math.min((phase * bands).floor(), bands - 1);

  static const bands = 4;

  final int active;
  final double local;

  /// Fracción pintada de la franja [i] (con aceleración y frenado suaves).
  double fill(int i) {
    if (i < active) return 1;
    if (i > active) return 0;
    return Curves.easeInOut.transform(local.clamp(0.0, 1.0));
  }

  /// Franjas pares avanzan de izquierda a derecha; las impares, al revés.
  Rect stripe(int i, Size size) {
    final bandH = size.height / bands;
    final width = size.width * fill(i);
    final left = i.isEven ? 0.0 : size.width - width;
    return Rect.fromLTWH(left, bandH * i, width, bandH);
  }

  /// Centro del rodillo: el borde de la franja activa; al terminarla baja a
  /// la siguiente para empezar justo en el extremo donde acabó.
  Offset rollerCenter(double w, double h) {
    final bandH = h / bands;
    final p = fill(active);
    final x = active.isEven ? w * p : w - w * p;
    final drop = active < bands - 1 ? Curves.easeInOut.transform(((local - 0.8) / 0.2).clamp(0.0, 1.0)) : 0.0;
    return Offset(x, bandH * (active + 0.5 + drop));
  }
}

class _WallPainter extends CustomPainter {
  _WallPainter(this.geometry, this.fade);

  final _WallGeometry geometry;
  final double fade;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.surfaceSubtle);

    final paint = Paint()..color = AppColors.brandGradientStart.withValues(alpha: fade);
    for (var i = 0; i < _WallGeometry.bands; i++) {
      final rect = geometry.stripe(i, size);
      if (rect.width > 0) canvas.drawRect(rect, paint);
    }

    // Juntas finas entre franjas, como los pasos del rodillo en la pared.
    final seam = Paint()
      ..color = AppColors.line300
      ..strokeWidth = AppSpacing.strokeCard;
    final bandH = size.height / _WallGeometry.bands;
    for (var i = 1; i < _WallGeometry.bands; i++) {
      canvas.drawLine(Offset(0, bandH * i), Offset(size.width, bandH * i), seam);
    }
  }

  @override
  bool shouldRepaint(_WallPainter old) =>
      old.geometry.active != geometry.active || old.geometry.local != geometry.local || old.fade != fade;
}
