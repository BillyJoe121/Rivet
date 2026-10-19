import 'package:flutter/material.dart';

/// Paleta oficial de tokens de diseño para Rivet refinada según Figma.
/// Tonos orgánicos, marfil cálido, verde petróleo biofílico y acentos suaves.
abstract final class AppColors {
  // Superficies y Lienzo Base
  static const Color paper100 = Color(0xFFF9F7F2); // Marfil cálido exacto de Figma
  static const Color surface0 = Color(0xFFFFFFFF); // Blanco puro para tarjetas elevadas
  static const Color surfaceSubtle = Color(0xFFF3F0E8); // Contenedor sutil cálido

  // Tipografía y Lectura
  static const Color ink900 = Color(0xFF0F2622); // Verde-carbón profundo de alta legibilidad
  static const Color ink700 = Color(0xFF384B46); // Texto secundario suave
  static const Color ink500 = Color(0xFF6B7E79); // Leyendas y captions
  static const Color ink300 = Color(0xFFA5B2AE); // Placeholders

  // Identidad de Marca y Verdes Biofílicos
  static const Color brand700 = Color(0xFF0D544A); // Verde petróleo/esmeralda elegante
  static const Color brand800 = Color(0xFF093B34); // Estado presionado
  static const Color brandLight = Color(0xFFEAF5F0); // Verde salvia suave para badges/píldoras
  static const Color leaf300 = Color(0xFFD4E6DE);
  static const Color clay600 = Color(0xFFB85D28);
  static const Color clayLight = Color(0xFFF9EFE9);
  static const Color sun300 = Color(0xFFF0C76A);
  static const Color sunLight = Color(0xFFFDF8EA);

  // Estructura, Separadores y Sombras
  static const Color line300 = Color(0xFFE8E5DD); // Separador cálido ultrafino
  static const Color lineDark = Color(0xFFD2CEC4);
  static const Color softBorder = Color(0x1A0F2622); // Borde hairline imperceptible

  // Estados Semánticos
  static const Color success700 = Color(0xFF1E6B52);
  static const Color successLight = Color(0xFFE7F6F0);
  static const Color warning800 = Color(0xFF7A5400);
  static const Color warningLight = Color(0xFFFEF7E6);
  static const Color danger700 = Color(0xFFA8362D);
  static const Color dangerLight = Color(0xFFFCEEEB);
  static const Color info700 = Color(0xFF165C74);
  static const Color infoLight = Color(0xFFE8F4F8);

  // Sombras Refinadas de Alta Difusión
  static const Color softShadow = Color(0x0A0F2622);
  static const Color barrier = Color(0x520F2622);
}
