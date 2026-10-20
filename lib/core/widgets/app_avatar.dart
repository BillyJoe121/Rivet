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
    final Widget content = image != null
        ? Image(image: image!, width: size, height: size, fit: BoxFit.cover)
        : Center(
            child: Text(
              initials!,
              maxLines: 1,
              style: textStyle ?? _defaultStyle,
            ),
          );
    return Semantics(
      label: semanticLabel ?? initials,
      image: image != null,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: size,
            height: size,
            color: backgroundColor,
            child: content,
          ),
        ),
      ),
    );
  }
}
