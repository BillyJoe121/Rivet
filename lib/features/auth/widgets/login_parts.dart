import 'package:flutter/material.dart';

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
          SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Iniciar sesión',
                  style: rvText(
                    18,
                    weight: FontWeight.w700,
                    lineHeight: 23.04,
                    color: RvColors.brand700,
                    family: RvFonts.serif,
                  ),
                ),
                const SizedBox(height: 8),
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
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AuthColors.fieldStroke),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AuthColors.iconTile,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RvIcon(icon, size: 20, color: AuthColors.mutedInk),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: rvText(
                    12,
                    weight: FontWeight.w500,
                    lineHeight: 14.06,
                    color: AuthColors.labelInk,
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
            _social(const RvIcon(RvIcons.google), 'Google'),
            _social(
              const RvIcon(RvIcons.apple, color: RvColors.statusInk),
              'Apple',
            ),
            _social(
              const RvIcon(RvIcons.mailOutline, color: AuthColors.mutedInk),
              'Correo',
            ),
          ],
        ),
      ),
    );
  }

  Widget _social(Widget icon, String label) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onSelected,
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
                  child: icon,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
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
    );
  }
}
