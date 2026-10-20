import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Botón de pie de 48 px con degradado de marca y chevron de 4×8 dentro de
/// una caja de 16 px, como en los frames de contratista.
class AccountGradientButton extends StatelessWidget {
  const AccountGradientButton(this.label, {super.key, this.onTap, this.height = 48});

  final String label;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ProPrimaryButton(
      label,
      onTap: onTap,
      height: height,
      horizontalPadding: 16,
      labelStyle: ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8),
      trailing: const _PillChevron(color: ProColors.surface0),
      gap: 0,
    );
  }
}

/// Botón de contorno: fondo marfil y borde de marca de 1 px.
class AccountOutlineButton extends StatelessWidget {
  const AccountOutlineButton(this.label, {super.key, this.onTap, this.height = 48, this.background = ProColors.paper100});

  final String label;
  final VoidCallback? onTap;
  final double height;
  final Color background;

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
            color: background,
            borderRadius: BorderRadius.circular(ProRadii.button),
            border: Border.all(color: ProColors.brand700, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: ProText.r(14, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 16.8),
                ),
              ),
              const _PillChevron(color: ProColors.brand700),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillChevron extends StatelessWidget {
  const _PillChevron({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: Center(child: ProChevron(width: 4, height: 8, color: color)),
    );
  }
}
