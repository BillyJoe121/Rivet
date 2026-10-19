import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Jerarquía tipográfica dual de Rivet:
/// - Editorial Serif (Newsreader) para títulos y encabezados de impacto.
/// - Sans-serif refinada (Plus Jakarta Sans) para textos de lectura, números y componentes.
abstract final class AppTypography {
  // Editorial Serif para Títulos
  static TextStyle get editorialHeading => GoogleFonts.newsreader(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
        letterSpacing: -0.6,
        height: 1.2,
      );

  static TextStyle get pageTitle => GoogleFonts.newsreader(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
        letterSpacing: -0.4,
        height: 1.25,
      );

  static TextStyle get sectionTitle => GoogleFonts.newsreader(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
        letterSpacing: -0.3,
        height: 1.3,
      );

  // Sans-serif geométrica para Cuerpo y Navegación
  static TextStyle get subheading => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
        letterSpacing: -0.2,
        height: 1.35,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.ink900,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.ink700,
        height: 1.45,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.ink700,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.ink500,
        height: 1.35,
      );

  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get badgeText => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get statNumber => GoogleFonts.newsreader(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
        letterSpacing: -0.5,
      );

  static TextStyle get priceDisplay => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
        letterSpacing: -0.4,
      );
}
