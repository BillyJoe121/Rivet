import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Escala tipográfica medida del Figma: Lora para títulos editoriales y
/// Roboto para todo lo demás. Las fuentes van empaquetadas en `assets/fonts`.
/// Los `height` reproducen el line-height de Figma (lineHeightPx / fontSize).
/// Todos los estilos son `const` para evitar asignaciones en cada frame de scroll.
abstract final class AppTypography {
  static const String serif = 'Lora';
  static const String sans = 'Roboto';

  // Serif editorial
  static const TextStyle wordmark = TextStyle(
    fontFamily: serif,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 36 / 30,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.brand700,
  );

  static const TextStyle wordmarkLarge = TextStyle(
    fontFamily: serif,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    height: 48.6 / 38,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.brand700,
  );

  static const TextStyle editorialHeading = TextStyle(
    fontFamily: serif,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 33.6 / 28,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: serif,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 33.6 / 28,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: serif,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 25.2 / 21,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle serifTitle = TextStyle(
    fontFamily: serif,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 21.6 / 18,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink700,
  );

  static const TextStyle serifTitleSmall = TextStyle(
    fontFamily: serif,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 19.2 / 16,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink700,
  );

  static const TextStyle priceHero = TextStyle(
    fontFamily: serif,
    fontSize: 29,
    fontWeight: FontWeight.w600,
    height: 34.8 / 29,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  // Sans
  static const TextStyle subheading = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 17.6 / 15,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16.8 / 14,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 17.6 / 15,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 15.6 / 13,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink700,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 17.6 / 13,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink500,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 15.6 / 12,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink500,
  );

  static const TextStyle label = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 14.4 / 12,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink500,
  );

  static const TextStyle labelStrong = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14.1 / 12,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 13.2 / 11,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink500,
  );

  static const TextStyle captionStrong = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 13.2 / 11,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle micro = TextStyle(
    fontFamily: sans,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 12 / 10,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14.4 / 12,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: sans,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 12 / 10,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle countText = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 12.9 / 11,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.brand700,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 21.6 / 18,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );

  static const TextStyle priceDisplay = TextStyle(
    fontFamily: sans,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 22.8 / 19,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: AppColors.ink900,
  );
}
