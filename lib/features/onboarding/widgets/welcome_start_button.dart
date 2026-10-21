import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Botón píldora interactivo con micro-escala táctil y accesibilidad WCAG para WelcomeScreen.
class WelcomeStartButton extends StatefulWidget {
  const WelcomeStartButton({
    super.key,
    required this.onPressed,
    this.text = 'Iniciar',
  });

  final VoidCallback onPressed;
  final String text;

  @override
  State<WelcomeStartButton> createState() => _WelcomeStartButtonState();
}

class _WelcomeStartButtonState extends State<WelcomeStartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Iniciar experiencia Rivet',
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Material(
          color: RvColors.paper100,
          borderRadius: BorderRadius.circular(999),
          elevation: _isPressed ? 2 : 5,
          shadowColor: const Color(0x33000000),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            splashColor: RvColors.brand700.withValues(alpha: 0.15),
            highlightColor: RvColors.brand700.withValues(alpha: 0.08),
            onHighlightChanged: (pressed) {
              if (mounted) setState(() => _isPressed = pressed);
            },
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onPressed();
            },
            child: Container(
              width: 156,
              height: 56,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: rvText(
                      17,
                      weight: FontWeight.w700,
                      lineHeight: 20,
                      color: RvColors.brand700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: RvColors.brand700,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
