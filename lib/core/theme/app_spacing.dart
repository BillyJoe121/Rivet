import 'package:flutter/material.dart';

/// Tokens de espaciado, radios y dimensiones de control táctil.
abstract final class AppSpacing {
  // Escala modular de espaciado
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

  // Radios de curvatura
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusPill = 999.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));

  // Accesibilidad táctil WCAG (mínimo 48x48 px)
  static const double minTouchTarget = 48.0;

  // Paddings habituales
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: lg, vertical: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets dialogPadding = EdgeInsets.all(xxl);
}
