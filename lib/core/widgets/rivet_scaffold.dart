import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'rivet_header.dart';

/// Contenedor de pantalla del Figma (412×868):
/// - Lienzo `#FAF8F3`.
/// - Imagen de cabecera a todo el ancho en proporción 412:232, detrás de la
///   barra de estado; la forma orgánica y el fundido vienen en la imagen.
/// - Cabecera editorial ([RivetHeader]) con título Lora 28.
/// - Cuerpo expandido y barra inferior opcional para CTAs.
class RivetScaffold extends StatelessWidget {
  const RivetScaffold({
    super.key,
    required this.body,
    this.title,
    this.backgroundImagePath = AppHeroImages.home,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.bottomBar,
    this.headerHero,
    this.titleStyle,
    this.showWordmark = false,
    this.showHeroImage = true,
  });

  final Widget body;
  final String? title;

  /// Imagen de cabecera; usar [AppHeroImages] o un archivo de `Fondos/`.
  final String backgroundImagePath;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final Widget? headerHero;
  final TextStyle? titleStyle;

  /// Muestra el logotipo "Rivet" sobre el título (pantallas de inicio).
  final bool showWordmark;
  final bool showHeroImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      body: Stack(
        children: [
          if (showHeroImage)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 412 / AppSpacing.heroHeight,
                child: Image.asset(
                  backgroundImagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RivetHeader(
                  title: title,
                  showBackButton: showBackButton,
                  onBack: onBack,
                  actions: actions,
                  showWordmark: showWordmark,
                  titleStyle: titleStyle,
                ),
                ?headerHero,
                Expanded(child: body),
                ?bottomBar,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
