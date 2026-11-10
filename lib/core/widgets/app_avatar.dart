import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Avatar circular con iniciales o foto. Iniciales sobre fondo de marca:
/// 36 px con Roboto 400 12 (nodo "Cuenta" de 22:143552) y, desde 56 px,
/// Lora 600 28 (nodo "Iniciales" de 22:146416).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.initials,
    this.image,
    this.size = 36,
    this.backgroundColor = AppColors.brand700,
    this.textStyle,
    this.onTap,
    this.semanticLabel,
  }) : assert(initials != null || image != null);

  final String? initials;
  final ImageProvider? image;
  final double size;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final String? semanticLabel;

  TextStyle get _defaultStyle {
    if (size >= 56) {
      return AppTypography.editorialHeading.copyWith(color: AppColors.surface0);
    }
    return AppTypography.label.copyWith(color: AppColors.surface0);
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        image: image != null
            ? DecorationImage(image: image!, fit: BoxFit.cover)
            : null,
      ),
      alignment: image == null ? Alignment.center : null,
      child: image == null
          ? Text(
              initials!,
              maxLines: 1,
              style: textStyle ?? _defaultStyle,
            )
          : null,
    );

    return Semantics(
      label: semanticLabel ?? initials,
      image: image != null,
      button: onTap != null,
      child: onTap != null
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: avatar,
            )
          : avatar,
    );
  }
}
