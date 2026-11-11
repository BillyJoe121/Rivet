import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Lienzo de pantalla de Figma: imagen de cabecera de 412×232 al fondo,
/// zona de barra de estado, cabecera, cuerpo desplazable, acciones al pie
/// y zona de la barra de gestos. La navegación principal la pone el shell.
class RvPage extends StatelessWidget {
  const RvPage({
    super.key,
    required this.body,
    this.header,
    this.headerImage,
    this.headerImageHeight = AppSpacing.heroHeight,
    this.footer,
    this.footerPadding = const EdgeInsets.fromLTRB(22, 0, 22, 6),
    this.background = AppColors.paper100,
    this.scrollable = true,
  });

  final Widget body;
  final Widget? header;

  /// Ruta del asset de la ilustración superior (`BoxFit.cover`).
  final String? headerImage;
  final double headerImageHeight;

  /// Acciones fijas sobre la navegación (en Figma, y=710 con alto 48).
  final Widget? footer;
  final EdgeInsets footerPadding;

  final Color background;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (headerImage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerImageHeight,
              child: Image.asset(headerImage!, fit: BoxFit.cover),
            ),
          Column(
            children: [
              SizedBox(height: padding.top),
              ?header,
              Expanded(
                child: scrollable
                    ? SingleChildScrollView(padding: EdgeInsets.zero, child: body)
                    : body,
              ),
              if (footer != null) Padding(padding: footerPadding, child: footer),
              Container(height: padding.bottom, color: AppColors.surface0),
            ],
          ),
        ],
      ),
    );
  }
}
