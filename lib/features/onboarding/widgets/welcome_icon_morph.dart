import 'dart:async';

import 'package:flutter/material.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Icono único de la portada que cicla entre Proyectos, Contratistas y Bodega.
/// Cada cambio es un morfado: el icono saliente se encoge y gira mientras el
/// entrante crece desde el centro. Con animaciones desactivadas se queda fijo.
class WelcomeIconMorph extends StatefulWidget {
  const WelcomeIconMorph({super.key, this.size = 56});

  final double size;

  @override
  State<WelcomeIconMorph> createState() => _WelcomeIconMorphState();
}

class _WelcomeIconMorphState extends State<WelcomeIconMorph> {
  static const _icons = [RvIcons.proyecto, RvIcons.hardHat, RvIcons.package];
  static const _interval = Duration(milliseconds: 1500);

  Timer? _timer;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _timer?.cancel();
      _timer = null;
    } else {
      _timer ??= Timer.periodic(_interval, (_) {
        setState(() => _index = (_index + 1) % _icons.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: -0.08, end: 0).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
          ),
          child: RvIcon(
            _icons[_index],
            key: ValueKey(_index),
            size: widget.size,
            color: RvColors.paper100,
            strokeWidth: 2.2,
          ),
        ),
      ),
    );
  }
}
