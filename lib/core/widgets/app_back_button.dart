import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme.dart';

/// Botón volver único de la app: misma apariencia y misma área táctil en todas
/// las pantallas.
///
/// - Área táctil de 48×48 ([AppSpacing.minTouchTarget]), toda ella sensible.
/// - Visual: círculo suave de 40 con chevron-left de Lucide de 22 centrado.
/// - Al presionar se reduce ligeramente y muestra una onda recortada al círculo.
/// - Sin [onPressed] hace `Navigator.maybePop`.
///
/// La caja de 48 sobresale [bleed] a la izquierda del contenido: las cabeceras
/// restan ese valor a su padding para que el título no se desplace.
class AppBackButton extends StatefulWidget {
  const AppBackButton({super.key, this.onPressed, this.color = AppColors.brand700});

  /// Lo que la caja táctil sobresale del borde del contenido (el círculo queda
  /// 4 px por fuera del borde y el resto es aire táctil).
  static const double bleed = 8;

  /// Diámetro del círculo visible.
  static const double circleSize = 40;

  /// Acción al tocar; por defecto cierra la ruta actual.
  final VoidCallback? onPressed;
  final Color color;

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _activate() {
    HapticFeedback.selectionClick();
    final onPressed = widget.onPressed;
    if (onPressed != null) {
      onPressed();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const circle = CircleBorder();
    return Semantics(
      button: true,
      label: 'Volver',
      onTap: _activate,
      excludeSemantics: true,
      child: SizedBox(
        width: AppSpacing.minTouchTarget,
        height: AppSpacing.minTouchTarget,
        // Capa opaca de 48×48: recoge los toques del aire que rodea al círculo.
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: _activate,
          child: Center(
            child: AnimatedScale(
              scale: _pressed ? 0.92 : 1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: AppBackButton.circleSize,
                height: AppBackButton.circleSize,
                child: Material(
                  color: AppColors.surfaceSubtle,
                  shape: circle,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: circle,
                    splashColor: widget.color.withValues(alpha: 0.14),
                    highlightColor: widget.color.withValues(alpha: 0.06),
                    onTap: _activate,
                    child: Center(
                      child: Icon(LucideIcons.chevronLeft, size: 22, color: widget.color),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
