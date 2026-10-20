import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Escala tipográfica medida del Figma: Lora para títulos editoriales y
/// Roboto para todo lo demás. Las fuentes van empaquetadas en `assets/fonts`.
/// Los `height` reproducen el line-height de Figma (lineHeightPx / fontSize).
abstract final class AppTypography {
  static const String serif = 'Lora';
  static const String sans = 'Roboto';

  static TextStyle _style(
    String family,
    double size,
    FontWeight weight,
    double lineHeight, {
    Color? color,
  }) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        height: lineHeight / size,
        letterSpacing: 0,
        leadingDistribution: TextLeadingDistribution.even,
        color: color,
      );

  // Serif editorial
  static TextStyle get wordmark =>
      _style(serif, 30, FontWeight.w600, 36, color: AppColors.brand700);
  static TextStyle get wordmarkLarge =>
      _style(serif, 38, FontWeight.w700, 48.6, color: AppColors.brand700);
  static TextStyle get editorialHeading =>
      _style(serif, 28, FontWeight.w600, 33.6, color: AppColors.ink900);
  static TextStyle get pageTitle =>
      _style(serif, 28, FontWeight.w600, 33.6, color: AppColors.ink900);
  static TextStyle get sectionTitle =>
      _style(serif, 21, FontWeight.w600, 25.2, color: AppColors.ink900);
  static TextStyle get serifTitle =>
      _style(serif, 18, FontWeight.w600, 21.6, color: AppColors.ink700);
  static TextStyle get serifTitleSmall =>
      _style(serif, 16, FontWeight.w600, 19.2, color: AppColors.ink700);
  static TextStyle get priceHero =>
      _style(serif, 29, FontWeight.w600, 34.8, color: AppColors.ink900);

  // Sans
  static TextStyle get subheading =>
      _style(sans, 15, FontWeight.w600, 17.6, color: AppColors.ink900);
  static TextStyle get titleSmall =>
      _style(sans, 14, FontWeight.w600, 16.8, color: AppColors.ink900);
  static TextStyle get bodyLarge =>
      _style(sans, 15, FontWeight.w400, 17.6, color: AppColors.ink900);
  static TextStyle get bodyStrong =>
      _style(sans, 13, FontWeight.w600, 15.6, color: AppColors.ink700);
  static TextStyle get bodyMedium =>
      _style(sans, 13, FontWeight.w400, 17.6, color: AppColors.ink500);
  static TextStyle get bodySmall =>
      _style(sans, 12, FontWeight.w400, 15.6, color: AppColors.ink500);
  static TextStyle get label =>
      _style(sans, 12, FontWeight.w400, 14.4, color: AppColors.ink500);
  static TextStyle get labelStrong =>
      _style(sans, 12, FontWeight.w600, 14.1, color: AppColors.ink900);
  static TextStyle get caption =>
      _style(sans, 11, FontWeight.w400, 13.2, color: AppColors.ink500);
  static TextStyle get captionStrong =>
      _style(sans, 11, FontWeight.w600, 13.2, color: AppColors.ink900);
  static TextStyle get micro => _style(sans, 10, FontWeight.w400, 12);
  static TextStyle get buttonText => _style(sans, 12, FontWeight.w600, 14.4);
  static TextStyle get badgeText => _style(sans, 10, FontWeight.w400, 12);
  static TextStyle get countText =>
      _style(sans, 11, FontWeight.w600, 12.9, color: AppColors.brand700);
  static TextStyle get statNumber =>
      _style(sans, 18, FontWeight.w600, 21.6, color: AppColors.ink900);
  static TextStyle get priceDisplay =>
      _style(sans, 19, FontWeight.w600, 22.8, color: AppColors.ink900);
}
