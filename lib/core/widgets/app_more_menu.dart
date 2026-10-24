import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_bottom_nav.dart';

/// Menú del botón "Más" en abanico: los destinos que no caben en la barra
/// salen como botones circulares repartidos en un arco que nace en "Más"
/// (último destino de la barra) y abre hacia arriba y a la izquierda.
/// Cubre solo el contenido, así la barra sigue visible y "Más" puede
/// cerrarlo de nuevo. Tocar fuera del abanico lo cierra.
class AppMoreMenu extends StatelessWidget {
  const AppMoreMenu({
    super.key,
    required this.open,
    required this.items,
    required this.onSelected,
    required this.onDismiss,
    this.selectedIndex,
  });

  final bool open;
  final List<AppNavDestination> items;
  final ValueChanged<int> onSelected;
  final VoidCallback onDismiss;

  /// Destino del abanico que se muestra en este momento, si lo hay.
  final int? selectedIndex;

  static const Duration _duration = Duration(milliseconds: 220);
  // Con tres destinos el arco necesita más radio para que las etiquetas no
  // se toquen; con menos, el grupo queda más cerca de "Más".
  static const double _radius = 185;
  static const double _compactRadius = 140;
  static const double _button = 52;

  // Arco entre 90° (recto arriba) y 150° (arriba a la izquierda), con 30°
  // entre destinos. Con menos de tres destinos el grupo se centra en el arco
  // en lugar de estirarse hasta sus extremos.
  static const double _arcCenter = math.pi * 2 / 3;
  // Con dos destinos el grupo gira hacia la vertical para quedar más pegado
  // al borde derecho, sobre "Más".
  static const double _compactArcCenter = math.pi * 11 / 18;
  static const double _step = math.pi / 6;

  // Centro del icono de "Más" sobre el borde superior de la barra (padding
  // superior 14 + medio icono).
  static const double _navIconCenter = 24;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !open,
      child: ExcludeSemantics(
        excluding: !open,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: open ? 1 : 0),
          duration: _duration,
          curve: Curves.easeOutCubic,
          builder: (context, t, _) => LayoutBuilder(
            builder: (context, constraints) => _buildFan(constraints.biggest, t),
          ),
        ),
      ),
    );
  }

  Widget _buildFan(Size size, double t) {
    // Centro de "Más": la barra reparte sus destinos en partes iguales
    // dentro de un padding horizontal de 12.
    final slot = (size.width - 24) / AppNavDestinations.client.length;
    final origin = Offset(size.width - 12 - slot / 2, size.height + _navIconCenter);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: Opacity(
              opacity: t,
              child: const ColoredBox(color: AppColors.barrier),
            ),
          ),
        ),
        for (var i = 0; i < items.length; i++)
          _positioned(size, origin, i, t),
      ],
    );
  }

  Widget _positioned(Size size, Offset origin, int i, double t) {
    final compact = items.length <= 2;
    final angle = (compact ? _compactArcCenter : _arcCenter) + _step * (i - (items.length - 1) / 2);
    final distance = (compact ? _compactRadius : _radius) * t;
    final center = origin + Offset(math.cos(angle) * distance, -math.sin(angle) * distance);

    // Se ancla por el centro del círculo; la etiqueta queda debajo.
    return Positioned(
      left: center.dx,
      top: center.dy - _button / 2,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.6 + 0.4 * t,
            alignment: Alignment.topCenter,
            child: _FanItem(
              destination: items[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          ),
        ),
      ),
    );
  }
}

class _FanItem extends StatelessWidget {
  const _FanItem({required this.destination, required this.selected, required this.onTap});

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppMoreMenu._button,
              height: AppMoreMenu._button,
              decoration: BoxDecoration(
                color: selected ? AppColors.brandGradientStart : AppColors.surface0,
                shape: BoxShape.circle,
                boxShadow: AppSpacing.shadowElevated,
              ),
              child: Icon(
                destination.icon,
                size: 22,
                color: selected ? AppColors.surface0 : AppColors.brandGradientStart,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.surface0,
                borderRadius: AppSpacing.roundedPill,
              ),
              child: Text(
                destination.label,
                style: AppTypography.caption.copyWith(
                  color: selected ? AppColors.brandGradientStart : AppColors.ink900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
