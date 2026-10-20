import 'package:flutter/material.dart';

/// Paleta de Rivet medida del archivo de Figma "Rivet v2".
/// Cada valor indica su uso principal en las pantallas.
abstract final class AppColors {
  // Superficies y lienzo base
  static const Color paper100 = Color(0xFFFAF8F3); // Fondo de pantalla
  static const Color surface0 = Color(0xFFFFFFFF); // Tarjetas y barra de navegación
  static const Color surfaceSubtle = Color(0xFFF3F4F0); // Contenedor neutro sutil

  // Tipografía
  static const Color ink900 = Color(0xFF082A40); // Títulos y texto principal
  static const Color ink700 = Color(0xFF16384D); // Texto fuerte secundario
  static const Color ink500 = Color(0xFF638097); // Metadatos e iconos inactivos
  static const Color ink300 = Color(0xFF9CA8B1); // Placeholders

  // Marca
  static const Color brand700 = Color(0xFF004E49); // Acento: iconos, enlaces, nav activa
  static const Color brand800 = Color(0xFF064B45); // Tarjeta destacada oscura
  static const Color brandLight = Color(0xFFEDF4EF); // Pastillas de conteo y avisos
  static const Color brandGradientStart = Color(0xFF08796F); // Botón primario (inicio)
  static const Color brandGradientEnd = Color(0xFF003D38); // Botón primario (fin)
  static const Color leaf300 = Color(0xFFDDE7E1); // Verde grisáceo de apoyo
  static const Color clay600 = Color(0xFFB85D28);
  static const Color clayLight = Color(0xFFF9EFE9);
  static const Color sun300 = Color(0xFFD89521); // Acento ámbar
  static const Color sunLight = Color(0xFFFFF3D5);

  // Estructura
  static const Color line300 = Color(0xFFE6E9E4); // Bordes de tarjeta y separadores
  static const Color lineDark = Color(0xFFD6D8D7);
  static const Color softBorder = Color(0xFFE6E9E4);

  // Estados semánticos
  static const Color success700 = Color(0xFF06A77B); // Barra de progreso
  static const Color successText = Color(0xFF2E9B4B);
  static const Color successLight = Color(0xFFE0F4E8); // Chip de estado positivo
  static const Color warning800 = Color(0xFF986412); // Texto de estado pendiente
  static const Color warningLight = Color(0xFFFFF3D5); // Chip "En curso"
  static const Color danger700 = Color(0xFF9A423B);
  static const Color dangerLight = Color(0xFFFDE5E2);
  static const Color info700 = Color(0xFF165C74);
  static const Color infoLight = Color(0xFFE5F1FB);

  // Sistema
  static const Color statusInk = Color(0xFF111111); // Barra de estado
  static const Color gestureBar = Color(0xFF25312E); // Indicador de gestos

  // Sombras y velos
  static const Color softShadow = Color(0x0A000000); // #000 al 4 %
  static const Color elevatedShadow = Color(0x14082A40); // #082A40 al 8 %
  static const Color brandShadow = Color(0x1F004E49); // #004E49 al 12 %
  static const Color sheetShadow = Color(0x14000000); // #000 al 8 %
  static const Color barrier = Color(0x52082A40);

  /// Gradiente vertical de los botones primarios (medido en los exports:
  /// el color no cambia a lo ancho, solo de arriba abajo).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandGradientStart, brandGradientEnd],
  );
}
