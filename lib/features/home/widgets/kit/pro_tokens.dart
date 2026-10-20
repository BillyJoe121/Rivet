import 'package:flutter/painting.dart';

/// Valores medidos en Figma para las pantallas profesionales y de proveedor.
/// Los nombres siguen los tokens de diseño compartidos para poder
/// reemplazarlos por los del sistema central sin cambiar las pantallas.
abstract final class ProColors {
  static const Color paper100 = Color(0xFFFAF8F3);
  static const Color surface0 = Color(0xFFFFFFFF);
  static const Color brand700 = Color(0xFF004E49);
  static const Color brand800 = Color(0xFF064B45);
  static const Color brandGradientStart = Color(0xFF08796F);
  static const Color brandGradientEnd = Color(0xFF003D38);
  static const Color ink900 = Color(0xFF082A40);
  static const Color ink700 = Color(0xFF16384D);
  static const Color ink500 = Color(0xFF638097);
  static const Color ink300 = Color(0xFF9CA8B1);
  static const Color line300 = Color(0xFFE6E9E4);
  static const Color lineDark = Color(0xFFD6D8D7);
  static const Color brandLight = Color(0xFFEDF4EF);
  static const Color successLight = Color(0xFFE0F4E8);
  static const Color success700 = Color(0xFF06A77B);
  static const Color successText = Color(0xFF2E9B4B);
  static const Color progressTrack = Color(0xFFDDE7E1);
  static const Color warningLight = Color(0xFFFFF3D5);
  static const Color warning800 = Color(0xFF986412);
  static const Color sun300 = Color(0xFFD89521);
  static const Color danger700 = Color(0xFF9A423B);
  static const Color dangerLight = Color(0xFFFDE5E2);
  static const Color infoLight = Color(0xFFE5F1FB);
  static const Color statusInk = Color(0xFF111111);
  static const Color gestureBar = Color(0xFF25312E);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGradientStart, brandGradientEnd],
  );
}

abstract final class ProFonts {
  static const String serif = 'Lora';
  static const String sans = 'Roboto';
}

/// Estilos tipográficos de Figma. [r] y [serif] construyen estilos con la
/// altura de línea exacta de un nodo cuando difiere de los estilos nombrados.
abstract final class ProText {
  static TextStyle r(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = ProColors.ink900,
    double? lineHeight,
  }) =>
      TextStyle(
        fontFamily: ProFonts.sans,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: (lineHeight ?? size * 1.2) / size,
        letterSpacing: 0,
      );

  static TextStyle serif(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = ProColors.ink900,
    double? lineHeight,
  }) =>
      TextStyle(
        fontFamily: ProFonts.serif,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: (lineHeight ?? size * 1.2) / size,
        letterSpacing: 0,
      );

  static TextStyle get wordmark => serif(30, color: ProColors.brand700, lineHeight: 36);
  static TextStyle get pageTitle => serif(28, lineHeight: 33.6);
  static TextStyle get sectionTitle => serif(21, lineHeight: 25.2);
  static TextStyle get serifTitle => serif(18, lineHeight: 21.6);
  static TextStyle get serifTitleSmall => serif(16, color: ProColors.ink700, lineHeight: 19.2);
  static TextStyle get subheading => r(15, weight: FontWeight.w600, lineHeight: 18);
  static TextStyle get titleSmall => r(14, weight: FontWeight.w600, lineHeight: 16.8);
  static TextStyle get bodyStrong => r(13, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 15.6);
  static TextStyle get bodyMedium => r(13, lineHeight: 17.6);
  static TextStyle get bodySmall => r(12, color: ProColors.ink500, lineHeight: 15.6);
  static TextStyle get label => r(12, lineHeight: 14.4);
  static TextStyle get labelStrong => r(12, weight: FontWeight.w600, lineHeight: 14.4);
  static TextStyle get buttonText => r(12, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 14.4);
  static TextStyle get caption => r(11, color: ProColors.ink500, lineHeight: 13.2);
  static TextStyle get captionStrong => r(11, weight: FontWeight.w600, lineHeight: 13.2);
  static TextStyle get micro => r(10, lineHeight: 12);
}

abstract final class ProRadii {
  static const double sm = 10;
  static const double md = 12;
  static const double card = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double button = 28;
}

abstract final class ProStroke {
  static const double icon = 1.7;
  static const double card = 0.6;
  static const double hairline = 0.5;
  static const double divider = 1.0;
}

/// Medidas de la anatomía de pantalla de 412×868.
abstract final class ProLayout {
  static const double frameWidth = 412;
  static const double frameHeight = 868;
  static const double headerImageHeight = 232;
  static const double screenPadding = 22;
  static const double headerPadding = 24;
  static const double sectionGap = 14;
  static const double navHeight = 80;
}
