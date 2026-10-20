import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Pestañas en píldora medidas de "Mis propuestas" (nodo 22:145919).
///
/// Cada opción ocupa el mismo ancho, con 4 px entre ellas, alto 36 y
/// radio 24. La activa lleva el gradiente de marca con texto blanco
/// Roboto 600 12/14.4; las demás, fondo `brandLight` y texto `ink500`
/// Roboto 400 12/14.4.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> items;
  final T selected;
  final ValueChanged<T> onChanged;

  static const double _height = 36;
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(24));

  @override
  Widget build(BuildContext context) {
    final entries = items.entries.toList();
    return Row(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(child: _segment(entries[i])),
        ],
      ],
    );
  }

  Widget _segment(MapEntry<T, String> entry) {
    final isCurrent = entry.key == selected;
    return Semantics(
      button: true,
      selected: isCurrent,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: _height,
          decoration: BoxDecoration(
            gradient: isCurrent ? AppColors.brandGradient : null,
            color: isCurrent ? null : AppColors.brandLight,
            borderRadius: _radius,
          ),
          child: InkWell(
            onTap: () => onChanged(entry.key),
            borderRadius: _radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isCurrent
                      ? AppTypography.buttonText.copyWith(color: AppColors.surface0)
                      : AppTypography.label,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

