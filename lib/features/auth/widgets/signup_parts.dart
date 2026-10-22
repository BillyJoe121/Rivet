import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          const RvBackButton(),
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
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: RvColors.surface0,
        border: Border.all(color: AuthColors.fieldStroke),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: RvIcon(icon, size: 22, color: RvColors.brand700),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: rvText(
                    12,
                    weight: FontWeight.w500,
                    lineHeight: 14.06,
                    color: AuthColors.mutedInk,
                  ),
                ),
                const SizedBox(height: 3),
                input,
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
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
      desc: 'Publica y gestiona tus proyectos',
      icon: LucideIcons.home,
    ),
    (
      role: UserRole.contractor,
      label: 'Contratista',
      desc: 'Postula y recibe solicitudes',
      icon: LucideIcons.hardHat,
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
              weight: FontWeight.w600,
              lineHeight: 20,
              color: RvColors.brand700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: _option(_options[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _option(
    ({UserRole role, String label, String desc, IconData icon}) o,
  ) {
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
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            decoration: BoxDecoration(
              color: RvColors.surface0,
              border: Border.all(
                color: on ? RvColors.brand700 : const Color(0xFFE5E7EB),
                width: on ? 1.8 : 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: on ? const Color(0x18004E49) : const Color(0x06000000),
                  offset: const Offset(0, 4),
                  blurRadius: on ? 14 : 6,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Checkmark circular superior discreto
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: on ? RvColors.brand700 : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: on ? RvColors.brand700 : const Color(0xFFD1D5DB),
                        width: 1.5,
                      ),
                    ),
                    child: on
                        ? const Icon(
                            Icons.check,
                            size: 13,
                            color: RvColors.surface0,
                          )
                            .animate()
                            .scale(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.elasticOut,
                            )
                        : null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contenedor de icono suavizado
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: on
                            ? const Color(0xFFE6F4F0)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        o.icon,
                        size: 22,
                        color: on
                            ? RvColors.brand700
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      o.label,
                      style: rvText(
                        15,
                        weight: FontWeight.w700,
                        lineHeight: 18,
                        color: on ? RvColors.brand700 : RvColors.ink900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      o.desc,
                      style: rvText(
                        12,
                        lineHeight: 15,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
