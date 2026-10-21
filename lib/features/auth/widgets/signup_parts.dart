import 'package:flutter/material.dart';

import '../../../core/models/models.dart';
import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';

/// Cabecera del registro: volver circular de 32 y título Lora 700 32/40.
class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 16, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            label: 'Volver',
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AuthColors.softTile,
                  shape: BoxShape.circle,
                ),
                child: const RvIcon(RvIcons.chevronLeft),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Crear tu cuenta',
            style: rvText(
              32,
              weight: FontWeight.w700,
              lineHeight: 40,
              color: RvColors.brand700,
              family: RvFonts.serif,
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
  static const _stepWidth = 110.67;

  @override
  Widget build(BuildContext context) {
    Widget line(double left, bool done) => Positioned(
      left: left,
      top: 38,
      child: Container(
        width: 82,
        height: 1,
        decoration: BoxDecoration(
          color: done ? RvColors.brand700 : AuthColors.fieldStroke,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
    Widget step(int i) {
      final active = i <= current;
      return Positioned(
        left: 40 + i * _stepWidth,
        top: 24,
        width: _stepWidth,
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? RvColors.brand700 : AuthColors.fieldStroke,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${i + 1}',
                style: rvText(
                  12,
                  weight: FontWeight.w700,
                  lineHeight: 14.06,
                  color: active ? RvColors.surface0 : AuthColors.placeholder,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _labels[i],
              style: rvText(
                11,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                lineHeight: 12.89,
                color: active ? RvColors.brand700 : AuthColors.placeholder,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 71,
      child: Stack(
        children: [
          step(0),
          line(94, current >= 1),
          step(1),
          line(236, current >= 2),
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
  });

  final RvIconData icon;
  final String label;
  final Widget input;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: RvColors.surface0,
        border: Border.all(color: AuthColors.fieldStroke),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Center(child: RvIcon(icon))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: rvText(
                    13,
                    weight: FontWeight.w500,
                    lineHeight: 15.23,
                    color: AuthColors.mutedInk,
                  ),
                ),
                const SizedBox(height: 3),
                input,
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 16), trailing!],
        ],
      ),
    );
  }
}

/// Selector "¿Qué tipo de cuenta quieres crear?" con tres opciones de 132.
class AccountTypeSelector extends StatelessWidget {
  const AccountTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  static const _options = [
    (
      role: UserRole.client,
      label: 'Cliente',
      desc: 'Publica\nproyectos',
      icon: RvIcons.user18x20,
    ),
    (
      role: UserRole.contractor,
      label: 'Contratista',
      desc: 'Recibe\nsolicitudes',
      icon: RvIcons.toolbox,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué tipo de cuenta quieres crear?',
            style: rvText(
              16,
              weight: FontWeight.w500,
              lineHeight: 18.75,
              color: RvColors.brand700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(child: _option(_options[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _option(
    ({UserRole role, String label, String desc, RvIconData icon}) o,
  ) {
    final on = o.role == selected;
    return Semantics(
      button: true,
      selected: on,
      child: GestureDetector(
        onTap: () => onChanged(o.role),
        child: Container(
          height: 132,
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          decoration: BoxDecoration(
            color: on ? const Color(0x0D004E49) : RvColors.surface0,
            border: Border.all(
              color: on ? RvColors.brand700 : AuthColors.fieldStroke,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: on ? RvColors.brand700 : AuthColors.softTile,
                        shape: BoxShape.circle,
                      ),
                      child: RvIcon(
                        o.icon,
                        color: on ? RvColors.surface0 : AuthColors.mutedInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      o.label,
                      style: rvText(
                        12,
                        weight: on ? FontWeight.w600 : FontWeight.w500,
                        lineHeight: 14.06,
                        color: on ? RvColors.brand700 : AuthColors.mutedInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      o.desc,
                      textAlign: TextAlign.center,
                      style: rvText(
                        13,
                        lineHeight: 18,
                        color: AuthColors.mutedInk,
                      ),
                    ),
                  ],
                ),
              ),
              if (on)
                Positioned(
                  top: -7,
                  right: 3.3,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: RvColors.brand700,
                      shape: BoxShape.circle,
                    ),
                    child: const RvIcon(
                      RvIcons.check8x6,
                      color: RvColors.surface0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
