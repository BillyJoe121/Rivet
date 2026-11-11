import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

/// Pestañas "Iniciar sesión" / "Crear cuenta" (alto 60, padding horizontal 32).
class LoginTabs extends StatelessWidget {
  const LoginTabs({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.authButtonHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Row(
        children: [
          IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Iniciar sesión',
                  maxLines: 1,
                  style: AppTypography.style(
                    18,
                    weight: FontWeight.w700,
                    lineHeight: 23.04,
                    color: AppColors.brand700,
                    family: AppTypography.serif,
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),
                Container(
                  height: AppSpacing.xxs,
                  decoration: BoxDecoration(
                    color: AppColors.brand700,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusHairline),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onCreateAccount,
            child: Text(
              'Crear cuenta',
              style: AppTypography.style(
                18,
                lineHeight: 23.04,
                color: AppColors.inputPlaceholder,
                family: AppTypography.serif,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo de acceso de 60 de alto: mosaico de ícono 36 `#F2F0EB`, etiqueta
/// Roboto 500 12/14.06 y entrada Roboto 400 15/17.58.
class LoginField extends StatelessWidget {
  const LoginField({
    super.key,
    required this.icon,
    required this.label,
    required this.input,
    this.trailing,
    this.focusNode,
  });

  final RvIconData icon;
  final String label;
  final Widget input;
  final Widget? trailing;

  /// Foco del campo: tocar cualquier parte de la caja lo activa.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: focusNode?.requestFocus,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.authFieldMinHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.space10,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface0,
          border: Border.all(color: AppColors.fieldBorder),
          borderRadius: AppSpacing.roundedCard,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSpacing.iconBox,
              height: AppSpacing.iconBox,
              child: Center(
                child: RvIcon(icon, size: AppSpacing.iconLg, color: AppColors.brand700),
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTypography.style(
                      12,
                      weight: FontWeight.w500,
                      lineHeight: 14.06,
                      color: AppColors.fieldLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  input,
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
