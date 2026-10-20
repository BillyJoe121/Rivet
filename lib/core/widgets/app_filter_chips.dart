import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Grupo de chips de filtro ("Filtros de estado", nodo 22:144854): pastillas
/// de 23 px, padding 5×9, radio 20, Roboto 400 11, separación 8 en ambas
/// direcciones. El diseño solo muestra el estado normal (`successLight` con
/// texto de marca); el chip elegido se resalta con fondo de marca y texto
/// blanco.
class AppFilterChips extends StatelessWidget {
  const AppFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.spacing = AppSpacing.sm,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (var i = 0; i < labels.length; i++)
          AppFilterChip(
            label: labels[i],
            selected: i == selectedIndex,
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}

/// Chip individual de [AppFilterChips].
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.brand700 : AppColors.successLight,
        borderRadius: AppSpacing.roundedXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedXl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: selected ? AppColors.surface0 : AppColors.brand700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
