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
  static const Color avatarShadow = Color(0x26000000); // #000 al 15 %
  static const Color buttonShadowDeep = Color(0x33001F1C); // Botón de inicio
  static const Color brandShadowSoft = Color(0x18004E49); // Tarjeta de rol activa
  static const Color faintShadow = Color(0x06000000); // Tarjeta de rol inactiva
  static const Color heroScrimTop = Color(0x47000000); // Velo superior de la portada
  static const Color brandScrim = Color(0xD9004E49); // Velo inferior de la portada
  static const Color brandTransparent = Color(0x00004E49);
  static const Color paperTransparent = Color(0x00FAF8F3); // Fundido de la imagen al lienzo
  static const Color surfaceFrosted = Color(0xD6FFFFFF); // Tarjeta translúcida

  // Indicadores
  static const Color stepIdle = Color(0xFFDFE5E4); // Paso pendiente del indicador de pasos

  // Botones con relieve (gradiente de tres paradas)
  static const Color buttonGradientTop = Color(0xFF278D82);
  static const Color buttonGradientMid = Color(0xFF08655D);
  static const Color buttonPressedTop = Color(0xFF1A6B63); // Estado de carga
  static const Color buttonPressedMid = Color(0xFF064F48);
  static const Color buttonPressedEnd = Color(0xFF002B27);

  // Formularios
  static const Color fieldBorder = Color(0xFFE7E8E1); // Borde del campo
  static const Color fieldLabel = Color(0xFF607587); // Etiqueta e icono de ojo
  static const Color inputInk = Color(0xFF142D3D); // Texto escrito en el campo
  static const Color inputPlaceholder = Color(0xFF6E7E8B); // Contraste WCAG 2.2
  static const Color iconTile = Color(0xFFF2F0EB); // Fondo del icono del campo
  static const Color selectedTint = Color(0xFFE6F4F0); // Icono de opción elegida
  static const Color selectedFill = Color(0xFFEAF7EF); // Opción de precio elegida
  static const Color disabledFill = Color(0xFFE3E6E6); // Día no disponible
  static const Color disabledInk = Color(0xFF7B8588);
  static const Color snackActionInk = Color(0xFFEAF5F0); // Acción sobre aviso oscuro

  // Avisos de error
  static const Color errorSurface = Color(0xFFFDE8E8);
  static const Color errorBorder = Color(0xFFF8B4B4);
  static const Color errorInk = Color(0xFF9B1C1C);

  // Neutros
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);

  // Fuerza y requisitos de la contraseña
  static const Color passwordVeryWeak = Color(0xFFE02424);
  static const Color passwordWeak = Color(0xFFFF5A1F);
  static const Color passwordFair = Color(0xFFD97706);
  static const Color passwordStrong = Color(0xFF0E9F6E);
  static const Color passwordRuleMetFill = Color(0xFFDEF7EC);
  static const Color passwordRuleMetBorder = Color(0xFF31C48D);
  static const Color passwordRuleMetInk = Color(0xFF03543F);

  // Logotipo de Google (colores de marca de terceros)
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  /// Gradiente vertical de los botones primarios (medido en los exports:
  /// el color no cambia a lo ancho, solo de arriba abajo).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandGradientStart, brandGradientEnd],
  );

  /// Gradiente de marca en diagonal (de arriba a la izquierda hacia abajo a
  /// la derecha), usado por botones píldora, pasos activos e insignias.
  static const LinearGradient brandGradientDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGradientStart, brandGradientEnd],
  );
}
