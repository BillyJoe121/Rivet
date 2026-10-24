import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';

/// Destino de la barra de navegación principal.
class AppNavDestination {
  const AppNavDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Destinos por rol. El último de cada barra es "Más", que abre el panel con
/// los destinos de la lista `...More` sin cambiar de pantalla.
abstract final class AppNavDestinations {
  static const AppNavDestination _more = AppNavDestination(icon: LucideIcons.ellipsis, label: 'Más');
  static const AppNavDestination _profile = AppNavDestination(icon: LucideIcons.circleUser, label: 'Mi perfil');

  /// Propietario: Inicio · Proyectos · Contratistas · Bodega · Más.
  static const List<AppNavDestination> client = [
    AppNavDestination(icon: LucideIcons.house, label: 'Inicio'),
    AppNavDestination(icon: LucideIcons.files, label: 'Proyectos'),
    AppNavDestination(icon: LucideIcons.hardHat, label: 'Contratistas'),
    AppNavDestination(icon: LucideIcons.warehouse, label: 'Bodega'),
    _more,
  ];

  /// Panel "Más" del propietario.
  static const List<AppNavDestination> clientMore = [
    AppNavDestination(icon: LucideIcons.tag, label: 'Propuestas'),
    AppNavDestination(icon: LucideIcons.messageSquare, label: 'Mensajes'),
    _profile,
  ];

  /// Contratista: Inicio · Proyectos · Propuestas · Mensajes · Más.
  static const List<AppNavDestination> professional = [
    AppNavDestination(icon: LucideIcons.house, label: 'Inicio'),
    AppNavDestination(icon: LucideIcons.files, label: 'Proyectos'),
    AppNavDestination(icon: LucideIcons.tag, label: 'Propuestas'),
    AppNavDestination(icon: LucideIcons.messageSquare, label: 'Mensajes'),
    _more,
  ];

  /// Panel "Más" del contratista.
  static const List<AppNavDestination> professionalMore = [
    AppNavDestination(icon: LucideIcons.warehouse, label: 'Bodega'),
    _profile,
  ];
}

/// Barra de navegación principal del Figma (nodo "Navegación principal"):
/// alto 80 + margen inferior del sistema, fondo blanco, borde superior de
/// 1 px `#E6E9E4`, padding 14/12/0/12, iconos Lucide de 21 px, separación 8 y
/// etiqueta Roboto 400 10/12. Activo `#08796F` (verde de marca, para que se note la pantalla actual),
/// inactivo `#638097`.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<AppNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        border: Border(top: BorderSide(color: AppColors.line300, width: AppSpacing.strokeDivider)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: AppSpacing.navBarHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _NavItem(
                      destination: destinations[i],
                      selected: i == currentIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, required this.onTap});

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandGradientStart : AppColors.ink500;
    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(destination.icon, size: 21, color: color),
            const SizedBox(height: 8),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.micro.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
