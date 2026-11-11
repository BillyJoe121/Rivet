import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'icons/pro_icon.dart';

/// Destinos de la navegación principal de Figma.
enum ProNavDestination {
  home('Inicio', LucideIcon.house),
  projects('Proyectos', LucideIcon.files),
  proposals('Propuestas', LucideIcon.tag),
  messages('Mensajes', LucideIcon.messageSquare),
  more('Más', LucideIcon.ellipsis);

  const ProNavDestination(this.label, this.icon);
  final String label;
  final LucideIcon icon;
}

/// Navegación inferior de 80 px con borde superior de 1 px y zona de gestos
/// blanca. [centered] reproduce la variante con destinos centrados.
class ProBottomNav extends StatelessWidget {
  const ProBottomNav({
    super.key,
    required this.active,
    this.onSelect,
    this.centered = false,
  });

  final ProNavDestination? active;
  final ValueChanged<ProNavDestination>? onSelect;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        border: Border(
          top: BorderSide(
            color: AppColors.line300,
            width: AppSpacing.strokeDivider,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: AppSpacing.navBarHeight - AppSpacing.strokeDivider,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            12,
            14 - AppSpacing.strokeDivider,
            12,
            0,
          ),
          child: Row(
            crossAxisAlignment: centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              for (final d in ProNavDestination.values)
                Expanded(
                  child: _NavItem(
                    d,
                    selected: d == active,
                    onTap: () => _select(context, d),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(BuildContext context, ProNavDestination d) {
    if (onSelect != null) {
      onSelect!(d);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
    this.destination, {
    required this.selected,
    required this.onTap,
  });

  final ProNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brand700 : AppColors.ink500;
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProIcon(destination.icon, size: 21, color: color),
            const SizedBox(height: 8),
            Text(
              destination.label,
              style: AppTypography.microProportional.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
