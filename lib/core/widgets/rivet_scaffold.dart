import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Clipper para crear la silueta biofílica fluida en la esquina superior derecha.
class _OrganicCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Inicia en la esquina superior izquierda del recorte
    path.moveTo(size.width * 0.25, 0);
    // Curva suave hacia abajo y a la derecha
    path.cubicTo(
      size.width * 0.05, size.height * 0.35,
      size.width * 0.2, size.height * 0.85,
      size.width, size.height * 0.95,
    );
    // Cierra en la esquina superior derecha
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Contenedor de pantalla unificado con:
/// - Fondo crema marfil cálido (`#F9F7F2`).
/// - Silueta curva biofílica en la esquina superior derecha con la imagen temática.
/// - Encabezado editorial con título en Serif y flecha estilizada de navegación.
/// - Barra inferior de acciones (CTAs) flotante con degradado suave.
class RivetScaffold extends StatelessWidget {
  const RivetScaffold({
    super.key,
    required this.body,
    this.title,
    this.backgroundImagePath = 'Fondos/Sala minimalista con plantas y luz suave.png',
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.bottomBar,
    this.headerHero,
    this.titleStyle,
  });

  final Widget body;
  final String? title;
  final String backgroundImagePath;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final Widget? headerHero;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      body: Stack(
        children: [
          // 1. Imagen biofílica en la esquina superior derecha con recorte orgánico
          Positioned(
            top: 0,
            right: 0,
            width: math.min(screenWidth * 0.65, 300.0),
            height: 240,
            child: ClipPath(
              clipper: _OrganicCornerClipper(),
              child: Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),

          // 2. Degradado suave para fundir la imagen con el fondo crema
          Positioned(
            top: 0,
            right: 0,
            width: math.min(screenWidth * 0.65, 300.0),
            height: 240,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppColors.paper100.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Contenido Principal y Cabecera Editorial
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Barra superior limpia y editorial
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink900),
                          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                        )
                      else
                        const SizedBox(width: AppSpacing.sm),
                      if (title != null) ...[
                        Expanded(
                          child: Text(
                            title!,
                            style: titleStyle ?? AppTypography.pageTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      ...?actions,
                    ],
                  ),
                ),

                ?headerHero,

                // Cuerpo desplazable
                Expanded(child: body),

                // Barra inferior de acciones fija
                ?bottomBar,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
