import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Indicador de pasos medido de "Crear proyecto" (nodo 22:143813) y
/// "Superficies" (nodo 22:143884).
///
/// Cada paso ocupa el mismo ancho: círculo de 28 con el número en
/// Roboto 600 14/16.8 y, 5 px debajo, la etiqueta Roboto 400 10/12
/// centrada. El paso actual lleva el gradiente de marca (número blanco,
/// etiqueta de marca); los demás, fondo neutro y etiqueta `ink500`.
class AppStepProgress extends StatelessWidget {
  const AppStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep; // 0-indexed

  // Fondo de los pasos no activos; sin token propio en el tema.
  static const Color _idleFill = Color(0xFFDFE5E4);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++) Expanded(child: _step(i)),
        ],
      ),
    );
  }

  Widget _step(int index) {
    final isCurrent = index == currentStep;
    final isCompleted = index < currentStep;
    return Semantics(
      label: 'Paso ${index + 1} de ${steps.length}: ${steps[index]}'
          '${isCurrent ? ', actual' : isCompleted ? ', completado' : ''}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isCurrent ? AppColors.brandGradient : null,
              color: isCurrent ? null : _idleFill,
            ),
            child: Text(
              '${index + 1}',
              style: AppTypography.titleSmall.copyWith(
                color: isCurrent ? AppColors.surface0 : AppColors.ink900,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            steps[index],
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.badgeText.copyWith(
              color: isCurrent ? AppColors.brand700 : AppColors.ink500,
            ),
          ),
        ],
      ),
    );
  }
}
