import 'package:flutter/material.dart';

/// Acercamiento infinito de la fotografía de bienvenida.
///
/// Dos copias de la imagen se acercan muy despacio y desfasadas medio ciclo.
/// La copia más reciente aparece encima con un fundido desde el encuadre
/// abierto mientras la anterior sigue avanzando debajo, así la imagen
/// siempre parece acercarse pero nunca pasa de [maxZoom].
class WelcomeInfiniteZoom extends StatefulWidget {
  const WelcomeInfiniteZoom({
    super.key,
    required this.child,
    this.focus = Alignment.center,
    this.cycle = const Duration(seconds: 20),
    this.maxZoom = 0.12,
  });

  final Widget child;

  /// Punto hacia el que se acerca la imagen.
  final Alignment focus;

  /// Tiempo que tarda cada copia en recorrer todo el acercamiento.
  final Duration cycle;

  /// Escala adicional al final del ciclo (0.12 = 112 %). La copia visible
  /// nunca supera ~70 % de este valor porque la siguiente la cubre antes, y
  /// un valor bajo mantiene casi imperceptible el doble contorno del fundido.
  final double maxZoom;

  @override
  State<WelcomeInfiniteZoom> createState() => _WelcomeInfiniteZoomState();
}

class _WelcomeInfiniteZoomState extends State<WelcomeInfiniteZoom>
    with SingleTickerProviderStateMixin {
  /// Parte del ciclo que dura el fundido de la copia nueva.
  static const double _fade = 0.2;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.cycle,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _layer(double progress, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: 1 + widget.maxZoom * progress,
        alignment: widget.focus,
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final a = _controller.value;
        final b = (a + 0.5) % 1;
        final older = a > b ? a : b;
        final newer = a > b ? b : a;
        final fadeIn = Curves.easeInOut.transform((newer / _fade).clamp(0.0, 1.0));
        return Stack(
          fit: StackFit.expand,
          children: [
            _layer(older, 1),
            _layer(newer, fadeIn),
          ],
        );
      },
    );
  }
}
