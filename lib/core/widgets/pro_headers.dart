import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_back_button.dart';
import 'app_notification_button.dart';

/// Cabecera de inicio: logotipo "Rivet", campana y saludo.
class ProBrandHeader extends StatelessWidget {
  const ProBrandHeader({super.key, required this.title, this.onBellTap});

  final String title;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rivet',
                      style: AppTypography.wordmarkProportional,
                    ),
                  ),
                  if (onBellTap != null)
                    AppNotificationButton(onPressed: onBellTap!),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.pageTitleProportional),
          ],
        ),
      ),
    );
  }
}

/// Título de página Lora 600 28.
class ProPageTitle extends StatelessWidget {
  const ProPageTitle(this.text, {super.key, this.maxWidth});

  final String text;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final title = Text(text, style: AppTypography.pageTitleProportional);
    return maxWidth == null ? title : SizedBox(width: maxWidth, child: title);
  }
}

/// Cabecera de regreso con el [AppBackButton] común (caja táctil de 48×48).
/// [inline] coloca el título a la derecha del botón (x = 64); si no, el título
/// va debajo. Los valores por defecto son los de la cabecera de pantallas de
/// detalle (padding 14/24/0/24 y gap 8). La caja de 48 sobresale del padding
/// izquierdo y del superior para que el círculo quede donde estaba el chevron
/// y el título no se desplace de forma apreciable.
class ProBackHeader extends StatelessWidget {
  const ProBackHeader({
    super.key,
    required this.title,
    this.inline = false,
    this.padding = const EdgeInsets.fromLTRB(24, 14, 24, 0),
    this.gap = 8,
    this.height,
    this.titleWidth,
    this.onBack,
  });

  final String title;
  final bool inline;
  final EdgeInsets padding;
  final double gap;
  final double? height;
  final double? titleWidth;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final back = AppBackButton(onPressed: onBack);
    // Compensa la caja de 48 frente a la de 28 de antes (centro del círculo
    // = centro del antiguo chevron).
    final bleed = padding.left < AppBackButton.bleed
        ? padding.left
        : AppBackButton.bleed;
    final top = padding.top > 10 ? padding.top - 10 : 0.0;
    final inner = padding.copyWith(left: padding.left - bleed, top: top);
    final titleBox = Padding(
      padding: EdgeInsets.only(left: inline ? 0 : bleed),
      child: ProPageTitle(title, maxWidth: titleWidth),
    );
    final child = inline
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              back,
              // Antes: caja de 30 + 10 de separación; ahora 48 - 8 de sobresalido.
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: padding.top - top),
                  child: titleBox,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              back,
              // El título queda donde estaba: padding + 28 + gap - (48 + top).
              SizedBox(height: _max0(padding.top + 28 + gap - top - 48)),
              titleBox,
            ],
          );
    return SizedBox(
      height: height,
      child: Padding(padding: inner, child: child),
    );
  }

  static double _max0(double v) => v > 0 ? v : 0;
}
