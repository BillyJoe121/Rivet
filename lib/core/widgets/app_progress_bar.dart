import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Barra de avance delgada ("Progreso" en 22:143552, 22:145635, 22:144907…):
/// pista `leaf300` de 7 px con radio 5, relleno `success700` y una etiqueta
/// opcional a la derecha ("2 de 4 etapas", Roboto 400 9 ink500).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.height = 7,
  });

  /// Avance entre 0 y 1.
  final double value;
  final String? label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    final bar = Semantics(
      value: '${(progress * 100).round()} %',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: AppColors.leaf300),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.success700,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (label == null) return bar;
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label!,
          // Roboto 400 9/10.8: tamaño sin token propio en la escala.
          style: AppTypography.caption.copyWith(fontSize: 9, height: 10.8 / 9),
        ),
      ],
    );
  }
}
