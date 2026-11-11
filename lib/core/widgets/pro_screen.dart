import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pro_bottom_nav.dart';

/// Contenedor de pantalla de Figma: lienzo marfil, ilustración de cabecera
/// de 412×232 detrás de la barra de estado, cuerpo desplazable y, si aplica,
/// pie fijo y navegación inferior.
class ProScreen extends StatelessWidget {
  const ProScreen({
    super.key,
    required this.body,
    this.backgroundAsset,
    this.footer,
    this.background = AppColors.paper100,
    this.scrollable = true,
    this.navWhenPushed,
  });

  final Widget body;
  final String? backgroundAsset;
  final Widget? footer;
  final Color background;
  final bool scrollable;

  /// Destino activo de la navegación inferior cuando la pantalla se abre con
  /// push; dentro del shell (ruta raíz) la navegación la pone el shell.
  final ProNavDestination? navWhenPushed;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final pushed = ModalRoute.of(context)?.canPop ?? false;
    final bottomNav = navWhenPushed != null && pushed
        ? ProBottomNav(active: navWhenPushed)
        : null;
    final content = Stack(
      children: [
        if (backgroundAsset != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: AppSpacing.heroHeight,
            child: RepaintBoundary(
              child: Image.asset(
                backgroundAsset!,
                fit: BoxFit.cover,
                cacheWidth: 824,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: top),
          child: body,
        ),
      ],
    );
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: bottomNav != null || footer != null,
              child: scrollable
                  ? SingleChildScrollView(child: content)
                  : content,
            ),
          ),
          ?footer,
          ?bottomNav,
        ],
      ),
    );
  }
}
