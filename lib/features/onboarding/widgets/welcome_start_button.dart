import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/design_system.dart';

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
          color: AppColors.paper100,
          borderRadius: BorderRadius.circular(32),
          elevation: _isPressed ? 0 : 2,
          shadowColor: AppColors.buttonShadowDeep,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            splashColor: AppColors.brand700.withValues(alpha: 0.12),
            highlightColor: AppColors.brand700.withValues(alpha: 0.06),
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
                        style: AppTypography.style(
                          17,
                          weight: FontWeight.w700,
                          lineHeight: 20,
                          color: AppColors.brand700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      // El chevrón avanza al presionar y regresa al soltar.
                      child: AnimatedSlide(
                        offset: _isPressed
                            ? const Offset(0.35, 0)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: const Icon(
                          LucideIcons.chevronRight,
                          size: 22,
                          color: AppColors.brand700,
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
