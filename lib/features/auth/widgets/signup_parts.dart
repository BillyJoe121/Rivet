import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/design_system/design_system.dart';

/// Cabecera del registro: [AppBackButton] y título Lora 700 32/40.
class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Caja de 48 con el círculo donde estaba el de 32: sobresale 8 px a la
      // izquierda y arriba, y el título conserva su posición.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        AppSpacing.sm,
        AppSpacing.space30,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          const SizedBox(height: AppSpacing.space10),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Text(
              'Crear tu cuenta',
              style: AppTypography.style(
                32,
                weight: FontWeight.w700,
                lineHeight: 40,
                color: AppColors.brand700,
                family: AppTypography.serif,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Indicador de tres pasos con líneas de 82×1 entre círculos de 28.
class SignupSteps extends StatelessWidget {
  const SignupSteps({super.key, required this.current});

  final int current;

  static const _labels = ['Datos', 'Rol', 'Confirmar'];

  @override
  Widget build(BuildContext context) {
    Widget line(double left, bool done) => Positioned(
      left: left,
      top: AppSpacing.signupStepLineTop,
      child: Container(
        width: AppSpacing.signupStepLineWidth,
        height: AppSpacing.strokeDivider,
        decoration: BoxDecoration(
          color: done ? AppColors.brand700 : AppColors.fieldBorder,
          borderRadius: BorderRadius.circular(AppSpacing.radiusHairline),
        ),
      ),
    );
    Widget step(int i) {
      final active = i <= current;
      return Positioned(
        left: AppSpacing.signupStepStart + i * AppSpacing.signupStepWidth,
        top: AppSpacing.signupStepTop,
        width: AppSpacing.signupStepWidth,
        child: Column(
          children: [
            Container(
              width: AppSpacing.stepCircleSize,
              height: AppSpacing.stepCircleSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.brand700 : AppColors.fieldBorder,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${i + 1}',
                style: AppTypography.style(
                  12,
                  weight: FontWeight.w700,
                  lineHeight: 14.06,
                  color: active ? AppColors.surface0 : AppColors.inputPlaceholder,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space6),
            Text(
              _labels[i],
              style: AppTypography.style(
                11,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                lineHeight: 12.89,
                color: active ? AppColors.brand700 : AppColors.inputPlaceholder,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: AppSpacing.signupStepperHeight,
      child: Stack(
        children: [
          step(0),
          line(AppSpacing.signupStepLineFirstStart, current >= 1),
          step(1),
          line(AppSpacing.signupStepLineSecondStart, current >= 2),
          step(2),
        ],
      ),
    );
  }
}

/// Campo del registro: 60 de alto, ícono de 24 en marca, etiqueta
/// Roboto 500 13/15.23 `#607587` y entrada Roboto 400 15/17.58.
class SignupField extends StatelessWidget {
  const SignupField({
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

/// Selector "¿Qué tipo de cuenta quieres crear?" con dos opciones de 70 de alto.
class AccountTypeSelector extends StatelessWidget {
  const AccountTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  static const _options = [
    (role: UserRole.client, label: 'Cliente', icon: LucideIcons.home),
    (
      role: UserRole.contractor,
      label: 'Contratista',
      icon: LucideIcons.hardHat,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué tipo de cuenta quieres crear?',
            style: AppTypography.style(
              16,
              weight: FontWeight.w600,
              lineHeight: 20,
              color: AppColors.brand700,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              for (var i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: _option(_options[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _option(({UserRole role, String label, IconData icon}) o) {
    final on = o.role == selected;
    return Semantics(
      button: true,
      selected: on,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(o.role);
        },
        child: AnimatedScale(
          scale: on ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            height: AppSpacing.authRoleCardHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface0,
              border: Border.all(
                color: on ? AppColors.brand700 : AppColors.gray200,
                width: on ? AppSpacing.strokeSelected : AppSpacing.strokeDivider,
              ),
              borderRadius: AppSpacing.roundedCard,
              boxShadow: on
                  ? AppSpacing.shadowOptionSelected
                  : AppSpacing.shadowOptionIdle,
            ),
            child: Row(
              children: [
                // Contenedor de icono suavizado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppSpacing.optionIconTileSize,
                  height: AppSpacing.optionIconTileSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on
                        ? AppColors.selectedTint
                        : AppColors.gray100,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Icon(
                    o.icon,
                    size: AppSpacing.iconMd,
                    color: on ? AppColors.brand700 : AppColors.gray500,
                  ),
                ),
                const SizedBox(width: AppSpacing.space10),
                Expanded(
                  child: Text(
                    o.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.style(
                      15,
                      weight: FontWeight.w700,
                      lineHeight: 18,
                      color: on ? AppColors.brand700 : AppColors.ink900,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Marca de selección al final de la fila, centrada en vertical
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppSpacing.radioSize,
                  height: AppSpacing.radioSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on ? AppColors.brand700 : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: on ? AppColors.brand700 : AppColors.gray300,
                      width: AppSpacing.strokeControl,
                    ),
                  ),
                  child: on
                      ? const Icon(
                          Icons.check,
                          size: AppSpacing.iconXxs,
                          color: AppColors.surface0,
                        ).animate().scale(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.elasticOut,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
