import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';

/// Pestañas "Iniciar sesión" / "Crear cuenta" (alto 60, padding horizontal 32).
class LoginTabs extends StatelessWidget {
  const LoginTabs({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Iniciar sesión',
                  maxLines: 1,
                  style: rvText(
                    18,
                    weight: FontWeight.w700,
                    lineHeight: 23.04,
                    color: RvColors.brand700,
                    family: RvFonts.serif,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: RvColors.brand700,
                    borderRadius: BorderRadius.circular(1),
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
              style: rvText(
                18,
                lineHeight: 23.04,
                color: AuthColors.placeholder,
                family: RvFonts.serif,
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

/// Separador "o continúa con" con líneas de 1 `#E7E8E1` a ambos lados.
class OrContinueWith extends StatelessWidget {
  const OrContinueWith({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: AuthColors.fieldStroke)),
          const SizedBox(width: 12),
          Text(
            'o continúa con',
            style: rvText(13, lineHeight: 15.23, color: AuthColors.placeholder),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: AuthColors.fieldStroke)),
        ],
      ),
    );
  }
}

/// Fila de accesos sociales: círculos de 52 con etiqueta Roboto 400 11/12.89.
class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key, required this.onSelected});

  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SocialButton(
              icon: const RvIcon(RvIcons.google),
              label: 'Google',
              onTap: onSelected,
            ),
            _SocialButton(
              icon: const RvIcon(RvIcons.apple, color: RvColors.statusInk),
              label: 'Apple',
              onTap: onSelected,
            ),
            _SocialButton(
              icon: const RvIcon(RvIcons.mailOutline, color: AuthColors.mutedInk),
              label: 'Correo',
              onTap: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          HapticFeedback.selectionClick();
          setState(() => _pressed = true);
        },
        onTapUp: (_) {
          if (_pressed) setState(() => _pressed = false);
        },
        onTapCancel: () {
          if (_pressed) setState(() => _pressed = false);
        },
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: 52,
            child: OverflowBox(
              maxWidth: 80,
              maxHeight: 71,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: RvColors.surface0,
                      shape: BoxShape.circle,
                      border: Border.all(color: AuthColors.fieldStroke),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: widget.icon,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.label,
                    style: rvText(
                      11,
                      lineHeight: 12.89,
                      color: AuthColors.placeholder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
