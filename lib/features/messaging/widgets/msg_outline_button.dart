import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

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
            color: ProColors.paper100,
            borderRadius: BorderRadius.circular(ProRadii.button),
            border: Border.all(
              color: ProColors.brand700,
              width: ProStroke.divider,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: ProText.r(
                    12,
                    weight: FontWeight.w600,
                    color: ProColors.brand700,
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
