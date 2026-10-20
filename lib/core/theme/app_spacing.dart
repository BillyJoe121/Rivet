import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Espaciado, radios, trazos y sombras medidos del Figma.
abstract final class AppSpacing {
  // Escala modular de espaciado
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double x4l = 40.0;
  static const double x5l = 48.0;
  static const double x6l = 64.0;

  // Medidas de pantalla del Figma (412 × 868)
  static const double screenGutter = 22.0; // Margen lateral del contenido
  static const double headerGutter = 24.0; // Margen lateral de la cabecera
  static const double sectionGap = 14.0; // Separación entre secciones
  static const double heroHeight = 232.0; // Imagen superior de cada pantalla
  static const double statusBarHeight = 36.0;
  static const double headerHeight = 100.0;
  static const double navBarHeight = 80.0;
  static const double gestureBarHeight = 24.0;

  // Radios de curvatura
  static const double radiusSm = 10.0; // Fotos y chips pequeños
  static const double radiusMd = 12.0; // Avisos y campos
  static const double radiusCard = 14.0; // Tarjetas compactas
  static const double radiusLg = 16.0; // Tarjetas de lista
  static const double radiusXl = 20.0; // Chips y pastillas
  static const double radiusButton = 28.0; // Botón píldora
  static const double radiusFrame = 30.0; // Modales y contenedor de pantalla
  static const double radiusPill = 999.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius roundedFrame = BorderRadius.all(Radius.circular(radiusFrame));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));

  // Trazos
  static const double strokeIcon = 1.7; // Iconos de línea
  static const double strokeCard = 0.6; // Borde de tarjeta
  static const double strokeDivider = 1.0; // Separadores y barra de navegación

  // Sombras (el diseño es mayormente plano)
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: AppColors.softShadow, offset: Offset(0, 2), blurRadius: 8),
  ];
  static const List<BoxShadow> shadowElevated = [
    BoxShadow(color: AppColors.elevatedShadow, offset: Offset(0, 10), blurRadius: 24),
  ];
  static const List<BoxShadow> shadowBrand = [
    BoxShadow(color: AppColors.brandShadow, offset: Offset(0, 5), blurRadius: 16),
  ];
  static const List<BoxShadow> shadowSheet = [
    BoxShadow(color: AppColors.sheetShadow, offset: Offset(0, -4), blurRadius: 20),
  ];

  // Accesibilidad táctil
  static const double minTouchTarget = 48.0;

  // Paddings habituales
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: screenGutter, vertical: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(10);
  static const EdgeInsets dialogPadding = EdgeInsets.all(xxl);
}
