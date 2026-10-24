import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme.dart';

/// Campana de notificaciones de las cabeceras de inicio: círculo blanco con
/// sombra suave para que se lea sobre la ilustración de fondo. Área de toque
/// de 48 de ancho con el círculo pegado al borde derecho.
class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const double _circle = 36;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notificaciones',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        child: SizedBox(
          width: AppSpacing.minTouchTarget,
          height: _circle,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: _circle,
              height: _circle,
              decoration: const BoxDecoration(
                color: AppColors.surface0,
                shape: BoxShape.circle,
                boxShadow: AppSpacing.shadowCard,
              ),
              child: const Icon(LucideIcons.bell, size: 18, color: AppColors.brand700),
            ),
          ),
        ),
      ),
    );
  }
}
