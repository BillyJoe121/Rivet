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
