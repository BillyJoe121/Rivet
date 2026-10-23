import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Botón principal de la bienvenida: versión clara del botón de acceso
/// (píldora paper100, etiqueta centrada y disco de flecha en verde de marca).
class WelcomeStartButton extends StatefulWidget {
  const WelcomeStartButton({
    super.key,
    required this.onPressed,
    this.label = 'Iniciar',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  State<WelcomeStartButton> createState() => _WelcomeStartButtonState();
}

class _WelcomeStartButtonState extends State<WelcomeStartButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Material(
          color: RvColors.paper100,
          borderRadius: BorderRadius.circular(32),
          elevation: _isPressed ? 0 : 2,
          shadowColor: const Color(0x33001F1C),
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            splashColor: RvColors.brand700.withValues(alpha: 0.12),
            highlightColor: RvColors.brand700.withValues(alpha: 0.06),
            onHighlightChanged: (pressed) {
              if (mounted) setState(() => _isPressed = pressed);
            },
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onPressed();
            },
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const SizedBox(width: 36),
                    Expanded(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: rvText(
                          17,
                          weight: FontWeight.w700,
                          lineHeight: 20,
                          color: RvColors.brand700,
                        ),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: RvColors.brandGradient,
                        shape: BoxShape.circle,
                      ),
                      // La flecha avanza al presionar y regresa al soltar.
                      child: AnimatedSlide(
                        offset: _isPressed
                            ? const Offset(0.35, 0)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: const RvIcon(
                          RvIcons.arrowRight,
                          color: RvColors.surface0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
