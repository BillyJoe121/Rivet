import 'package:flutter/widgets.dart';

/// Valores medidos en el archivo de Figma (frames de 412×868).
///
/// Los nombres replican los tokens de `AppColors`, `AppTypography` y
/// `AppSpacing` publicados para el sistema de diseño, para que el cambio a los
/// tokens globales sea un reemplazo directo cuando estén disponibles.
abstract final class RvColors {
  static const paper100 = Color(0xFFFAF8F3);
  static const surface0 = Color(0xFFFFFFFF);
  static const brand700 = Color(0xFF004E49);
  static const brand800 = Color(0xFF064B45);
  static const brandGradientStart = Color(0xFF08796F);
  static const brandGradientEnd = Color(0xFF003D38);
  static const ink900 = Color(0xFF082A40);
  static const ink700 = Color(0xFF16384D);
  static const ink500 = Color(0xFF638097);
  static const ink300 = Color(0xFF9CA8B1);
  static const line300 = Color(0xFFE6E9E4);
  static const lineDark = Color(0xFFD6D8D7);
  static const brandLight = Color(0xFFEDF4EF);
  static const successLight = Color(0xFFE0F4E8);
  static const success700 = Color(0xFF06A77B);
  static const successText = Color(0xFF2E9B4B);
  static const warningLight = Color(0xFFFFF3D5);
  static const warning800 = Color(0xFF986412);
  static const sun300 = Color(0xFFD89521);
  static const danger700 = Color(0xFF9A423B);
  static const dangerLight = Color(0xFFFDE5E2);
  static const infoLight = Color(0xFFE5F1FB);
  static const statusInk = Color(0xFF111111);
  static const gestureBar = Color(0xFF25312E);

  /// Fondo del círculo de un paso pendiente en el indicador de pasos.
  static const stepIdle = Color(0xFFDFE5E4);

  /// Pista de las barras de progreso.
  static const progressTrack = Color(0xFFDDE7E1);

  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGradientStart, brandGradientEnd],
  );
}

abstract final class RvFonts {
  static const sans = 'Roboto';
  static const serif = 'Lora';
}

/// Estilo de texto con la caja de línea de Figma: alto de línea absoluto y
/// reparto uniforme del interlineado arriba y abajo.
TextStyle rvText(
  double size, {
  FontWeight weight = FontWeight.w400,
  double? lineHeight,
  Color color = RvColors.ink900,
  String family = RvFonts.sans,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    height: (lineHeight ?? size * 1.2) / size,
    leadingDistribution: TextLeadingDistribution.even,
    letterSpacing: 0,
    color: color,
  );
}

/// Escala tipográfica medida (familia / peso / tamaño / alto de línea).
abstract final class RvText {
  static TextStyle get wordmark =>
      rvText(30, weight: FontWeight.w600, lineHeight: 36, color: RvColors.brand700, family: RvFonts.serif);
  static TextStyle get pageTitle => rvText(28, weight: FontWeight.w600, lineHeight: 33.6, family: RvFonts.serif);
  static TextStyle get sectionTitle => rvText(15, weight: FontWeight.w600, lineHeight: 18);
  static TextStyle get titleSmall => rvText(14, weight: FontWeight.w600, lineHeight: 16.8);
  static TextStyle get bodyStrong => rvText(13, weight: FontWeight.w600, lineHeight: 15.6);
  static TextStyle get field => rvText(13, lineHeight: 17.55, color: RvColors.ink500);
  static TextStyle get bodySmall => rvText(12, lineHeight: 15.6);
  static TextStyle get label => rvText(12, lineHeight: 14.4);
  static TextStyle get labelStrong => rvText(12, weight: FontWeight.w600, lineHeight: 14.4);
  static TextStyle get caption => rvText(11, lineHeight: 13.2, color: RvColors.ink500);
  static TextStyle get micro => rvText(10, lineHeight: 12, color: RvColors.ink500);
  static TextStyle get button => rvText(14, weight: FontWeight.w600, lineHeight: 16.8, color: RvColors.surface0);
}

abstract final class RvRadii {
  static const sm = 10.0;
  static const md = 12.0;
  static const card = 14.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const button = 28.0;
}

/// Anatomía de pantalla de Figma.
abstract final class RvLayout {
  static const frameWidth = 412.0;
  static const frameHeight = 868.0;
  static const statusBar = 36.0;
  static const gestureBar = 24.0;
  static const headerImage = 232.0;
  static const bottomNav = 80.0;
  static const sidePadding = 22.0;
  static const headerPadding = 24.0;
  static const cardStroke = 0.6;
}
