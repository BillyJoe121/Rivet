import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Título de sección (nodos 2027:226 y "Siguientes pasos" en 22:143552):
/// Roboto 600 15 ink900 con una pastilla de conteo opcional o un enlace
/// opcional a la derecha ("Ver todos").
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
    this.titleColor,
  });

  final String title;

  /// Muestra la pastilla de conteo de 26×22 cuando no es nulo.
  final int? count;

  /// Enlace a la derecha, p. ej. "Ver todos".
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Útil sobre tarjetas oscuras (título en blanco).
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.subheading.copyWith(color: titleColor),
            ),
          ),
          if (count != null) AppCountPill(count: count!),
          if (actionLabel != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAction,
              child: Semantics(
                button: true,
                child: Text(
                  actionLabel!,
                  style: AppTypography.label.copyWith(
                    color: AppColors.brand700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pastilla de conteo: mínimo 26×22, `brandLight`, radio 20, Roboto 600 11.
class AppCountPill extends StatelessWidget {
  const AppCountPill({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 26, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: AppSpacing.roundedXl,
      ),
      child: Text('$count', style: AppTypography.countText),
    );
  }
}
