import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Botón píldora estilizado "Iniciar" para la pantalla de bienvenida.
class WelcomeStartButton extends StatelessWidget {
  const WelcomeStartButton({
    super.key,
    required this.onPressed,
    this.text = 'Iniciar',
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      child: Material(
        color: RvColors.paper100,
        borderRadius: BorderRadius.circular(999),
        elevation: 4,
        shadowColor: const Color(0x26000000),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          splashColor: RvColors.brand700.withValues(alpha: 0.15),
          highlightColor: RvColors.brand700.withValues(alpha: 0.08),
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          child: Container(
            width: 140,
            height: 56,
            alignment: Alignment.center,
            child: Text(
              text,
              style: rvText(
                17,
                weight: FontWeight.w700,
                lineHeight: 20,
                color: RvColors.brand700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
