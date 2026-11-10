import 'package:flutter/material.dart';

/// Oculta el teclado al tocar una zona vacía. Se monta una sola vez sobre toda
/// la app; los toques en botones y campos siguen llegando a su destino.
class KeyboardDismisser extends StatelessWidget {
  const KeyboardDismisser({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
