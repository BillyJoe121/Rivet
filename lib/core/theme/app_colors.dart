import 'package:flutter/material.dart';

/// Paleta oficial de tokens de diseño para Rivet.
/// Basada en la guía de identidad de marca del proyecto.
abstract final class AppColors {
  // Superficies y Fondos
  static const Color paper100 = Color(0xFFF6F4EF);
  static const Color surface0 = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1EFEA);

  // Tipografía y Lectura
  static const Color ink900 = Color(0xFF182D33);
  static const Color ink700 = Color(0xFF495B61);
  static const Color ink500 = Color(0xFF75858B);
  static const Color ink300 = Color(0xFFA4AFB3);

  // Identidad de Marca y Acentos
  static const Color brand700 = Color(0xFF164B42);
  static const Color brand800 = Color(0xFF0F362F);
  static const Color brandLight = Color(0xFFE9F1EF);
  static const Color leaf300 = Color(0xFFD9E3DE);
  static const Color clay600 = Color(0xFFB65D25);
  static const Color clayLight = Color(0xFFF9EFE9);
  static const Color sun300 = Color(0xFFF0C76A);
  static const Color sunLight = Color(0xFFFDF8EA);

  // Estructura y Divisores
  static const Color line300 = Color(0xFFD5D8D0);
  static const Color lineDark = Color(0xFFB8BCB2);

  // Estados Semánticos
  static const Color success700 = Color(0xFF28664C);
  static const Color successLight = Color(0xFFEAF4EE);
  static const Color warning800 = Color(0xFF795100);
  static const Color warningLight = Color(0xFFFEF8E7);
  static const Color danger700 = Color(0xFFA33A32);
  static const Color dangerLight = Color(0xFFFCEEED);
  static const Color info700 = Color(0xFF1E5B70);
  static const Color infoLight = Color(0xFFEAF3F6);

  // Superposiciones
  static const Color barrier = Color(0x66182D33);
  static const Color shadow = Color(0x0F182D33);
}
