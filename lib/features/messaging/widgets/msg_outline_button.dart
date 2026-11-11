import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Botón secundario de Figma: borde de marca de 1 px, radio 28, texto centrado
/// y chevron de 16 px pegado al borde derecho.
class MsgOutlineButton extends StatelessWidget {
  const MsgOutlineButton({
    super.key,
    required this.label,
    this.onTap,
    this.height = 34,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.paper100,
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            border: Border.all(
              color: AppColors.brand700,
              width: AppSpacing.strokeDivider,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.proportional(
                    12,
                    weight: FontWeight.w600,
                    color: AppColors.brand700,
                    lineHeight: 14.4,
                  ),
                ),
              ),
              const ProIcon(LucideIcon.chevronRight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
