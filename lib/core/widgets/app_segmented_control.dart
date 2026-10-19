import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Control segmentado estándar para alternar pestañas y filtros sin saltos visuales.
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppSpacing.roundedSm,
        border: Border.all(color: AppColors.line300, width: 1),
      ),
      child: Row(
        children: items.entries.map((entry) {
          final isCurrent = entry.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.surface0 : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 1),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.ink900.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  entry.value,
                  style: AppTypography.buttonText.copyWith(
                    fontSize: 13,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    color: isCurrent ? AppColors.ink900 : AppColors.ink700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
