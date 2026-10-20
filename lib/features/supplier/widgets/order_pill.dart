import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Pastilla de estado de 11 px con relleno 9/5, usada en pedidos y vínculos.
class OrderPill extends StatelessWidget {
  const OrderPill(this.label, {super.key, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return ProChip(
      label,
      background: background,
      foreground: foreground,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      textStyle: ProText.r(11, color: foreground, lineHeight: 13.2),
    );
  }
}
