import 'package:flutter/material.dart';

import 'rv_icon_data.dart';
import 'rv_icons.dart';
import 'rv_tokens.dart';

enum RvButtonVariant { primary, outline }

/// Botón píldora de Figma: alto 48, radio 28, padding horizontal 16, texto
/// Roboto 600 14 centrado y chevron-right de 16 a la derecha.
/// `primary` usa el gradiente de marca; `outline` fondo papel y trazo de 1.
class RvButton extends StatelessWidget {
  const RvButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = RvButtonVariant.primary,
    this.height = 48,
    this.width,
    this.horizontalPadding = 16,
    this.textStyle,
    this.showChevron = true,
    this.chevronSize = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final RvButtonVariant variant;
  final double height;
  final double? width;
  final double horizontalPadding;
  final TextStyle? textStyle;
  final bool showChevron;
  final double chevronSize;

  @override
  Widget build(BuildContext context) {
    final primary = variant == RvButtonVariant.primary;
    final fg = primary ? RvColors.surface0 : RvColors.brand700;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            gradient: primary ? RvColors.brandGradient : null,
            color: primary ? null : RvColors.paper100,
            borderRadius: BorderRadius.circular(RvRadii.button),
            border: primary ? null : Border.all(color: RvColors.brand700, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textStyle ?? RvText.button.copyWith(color: fg),
                ),
              ),
              if (showChevron) RvIcon(RvIcons.chevronRight, size: chevronSize, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}
