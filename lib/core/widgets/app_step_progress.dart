import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Indicador horizontal de progreso para flujos de varios pasos.
class AppStepProgress extends StatelessWidget {
  const AppStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep; // 0-indexed

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              final stepIndex = index ~/ 2;
              final isPassed = stepIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isPassed ? AppColors.brand700 : AppColors.line300,
                ),
              );
            }

            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            final isCurrent = stepIndex == currentStep;

            return Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.brand700
                    : isCurrent
                        ? AppColors.brandLight
                        : AppColors.surface0,
                border: Border.all(
                  color: (isCompleted || isCurrent)
                      ? AppColors.brand700
                      : AppColors.line300,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '${stepIndex + 1}',
                      style: AppTypography.badgeText.copyWith(
                        color: isCurrent ? AppColors.brand700 : AppColors.ink500,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.asMap().entries.map((entry) {
            final isCurrent = entry.key == currentStep;
            return Expanded(
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  color: isCurrent ? AppColors.brand700 : AppColors.ink500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
