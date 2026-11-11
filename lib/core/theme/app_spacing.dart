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

  // Pasos intermedios medidos en Figma que no caen en la escala de 4
  static const double space3 = 3.0;
  static const double space6 = 6.0;
  static const double space10 = 10.0;
  static const double space18 = 18.0;
  static const double space28 = 28.0;
  static const double space30 = 30.0;

  // Medidas de pantalla del Figma (412 × 868)
  static const double frameWidth = 412.0;
  static const double frameHeight = 868.0;
  static const double screenGutter = 22.0; // Margen lateral del contenido
  static const double headerGutter = 24.0; // Margen lateral de la cabecera
  static const double sectionGap = 14.0; // Separación entre secciones
  static const double heroHeight = 232.0; // Imagen superior de cada pantalla
  static const double statusBarHeight = 36.0;
  static const double headerHeight = 100.0;
  static const double navBarHeight = 80.0;
  static const double gestureBarHeight = 24.0;

  // Radios de curvatura
  static const double radiusHairline = 1.0; // Extremos de líneas finas
  static const double radiusXxs = 2.0; // Cursor y barras de fuerza
  static const double radiusXs = 4.0; // Chips de requisito y puntos de paso
  static const double radiusCheckbox = 5.0;
  static const double radiusTight = 8.0; // Zona de toque de enlaces de texto
  static const double radiusSm = 10.0; // Fotos y chips pequeños
  static const double radiusMd = 12.0; // Avisos y campos
  static const double radiusCard = 14.0; // Tarjetas compactas
  static const double radiusLg = 16.0; // Tarjetas de lista
  static const double radiusXl = 20.0; // Chips y pastillas
  static const double radiusButton = 28.0; // Botón píldora
  static const double radiusFrame = 30.0; // Modales y contenedor de pantalla
  static const double radiusPillButton = 32.0; // Botón de acceso de 60 px
  static const double radiusPill = 999.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius roundedFrame = BorderRadius.all(Radius.circular(radiusFrame));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));
  static const BorderRadius roundedSheetTop = BorderRadius.vertical(top: Radius.circular(radiusButton));

  // Trazos
  static const double strokeIcon = 1.7; // Iconos de línea
  static const double strokeCard = 0.6; // Borde de tarjeta
  static const double strokeDivider = 1.0; // Separadores y barra de navegación
  static const double strokeHairline = 0.5; // Separadores finos de filas
  static const double strokeChip = 0.8; // Borde de chip de requisito
  static const double strokeControl = 1.5; // Casillas y radios
  static const double strokeSelected = 1.8; // Borde de opción elegida
  static const double strokeSpinner = 2.5; // Indicador de carga del botón
  static const double strokeRing = 3.0; // Anillo de cuenta regresiva
  static const double cursorWidth = 2.0;

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

  static const List<BoxShadow> shadowOptionSelected = [
    BoxShadow(color: AppColors.brandShadowSoft, offset: Offset(0, 4), blurRadius: 14),
  ];
  static const List<BoxShadow> shadowOptionIdle = [
    BoxShadow(color: AppColors.faintShadow, offset: Offset(0, 4), blurRadius: 6),
  ];

  // Accesibilidad táctil
  static const double minTouchTarget = 48.0;

  // Tamaños de iconos
  static const double iconXxs = 11.0;
  static const double iconXs = 16.0;
  static const double iconSm = 18.0;
  static const double iconMd = 20.0;
  static const double iconLg = 22.0;
  static const double iconBox = 24.0; // Caja del icono de un campo

  // Controles
  static const double checkboxSize = 20.0;
  static const double radioSize = 18.0;
  static const double iconTileSize = 32.0; // Icono en recuadro y flecha del botón
  static const double optionIconTileSize = 36.0;
  static const double stepCircleSize = 28.0;
  static const double stepDotSize = 8.0;
  static const double stepDotActiveWidth = 24.0;
  static const double resendButtonSize = 44.0;
  static const double shakeDistance = 8.0; // Vaivén del formulario ante un error

  // Pantallas de acceso (Figma 93:56, 11:196 y recuperación de contraseña)
  static const double authButtonHeight = 60.0;
  static const double authCompactButtonHeight = 56.0;
  static const double authFieldMinHeight = 62.0;
  static const double authRoleCardHeight = 70.0;
  static const double authHeroHeight = 340.0;
  static const double authHeroFadeTop = 200.0;
  static const double authHeroFadeHeight = 160.0;
  static const double authCardOffset = 110.0; // Espacio entre la marca y la tarjeta
  static const double forgotHeroHeight = 380.0;
  static const double forgotCardOffset = 192.0;
  static const double resetCardOffset = 170.0;
  static const double signupHeroHeight = 309.0;
  static const double signupHeroFadeTop = 230.0;
  static const double signupHeroFadeHeight = 42.0;

  // Indicador de pasos del registro
  static const double signupStepperHeight = 71.0;
  static const double signupStepWidth = 110.67;
  static const double signupStepStart = 40.0;
  static const double signupStepTop = 24.0;
  static const double signupStepLineTop = 38.0;
  static const double signupStepLineWidth = 82.0;
  static const double signupStepLineFirstStart = 94.0;
  static const double signupStepLineSecondStart = 236.0;

  // Paddings habituales
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: screenGutter, vertical: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(10);
  static const EdgeInsets dialogPadding = EdgeInsets.all(xxl);
}
