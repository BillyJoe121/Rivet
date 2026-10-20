import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';

/// Cabecera editorial de las pantallas del Figma.
///
/// - Con botón volver (nodo "Cabecera" de Pedidos): padding 10/24/8, chevron
///   de 21 px en una caja de 30×28 en x=24 y título Lora 28 en x=64.
/// - Sin botón volver (nodo "Cabecera" de Hola, Juan): padding 14/24/0/24,
///   fila de marca de 36 px opcional, separación de 8 y título Lora 28.
class RivetHeader extends StatelessWidget {
  const RivetHeader({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.showWordmark = false,
    this.titleStyle,
    this.titleMaxLines = 2,
  });

  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showWordmark;
  final TextStyle? titleStyle;
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final style = titleStyle ?? AppTypography.pageTitle;
    final titleText = title == null
        ? null
        : Text(title!, style: style, maxLines: titleMaxLines, overflow: TextOverflow.ellipsis);

    if (showBackButton) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.headerGutter, 10, AppSpacing.headerGutter, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RivetBackButton(onPressed: onBack),
            const SizedBox(width: 10),
            Expanded(child: titleText ?? const SizedBox(height: 28)),
            if (actions != null) ...[const SizedBox(width: 8), ...actions!],
          ],
        ),
      );
    }

    final hasBrandRow = showWordmark || (actions?.isNotEmpty ?? false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.headerGutter, 14, AppSpacing.headerGutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasBrandRow)
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  if (showWordmark) Text('Rivet', style: AppTypography.wordmark),
                  const Spacer(),
                  ...?actions,
                ],
              ),
            ),
          if (hasBrandRow && titleText != null) const SizedBox(height: 8),
          ?titleText,
        ],
      ),
    );
  }
}

/// Botón volver del Figma: chevron-left de 21 px, trazo de marca, caja de 30×28.
class RivetBackButton extends StatelessWidget {
  const RivetBackButton({super.key, this.onPressed, this.color = AppColors.brand700});

  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Volver',
      child: InkResponse(
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        radius: 22,
        child: SizedBox(
          width: 30,
          height: 28,
          child: Align(
            alignment: Alignment.centerLeft,
            // El glifo de Lucide trae ~8 px de aire a la izquierda; el trazo
            // del Figma empieza justo en el borde de la caja.
            child: Transform.translate(
              offset: const Offset(-8, 0),
              child: Icon(LucideIcons.chevronLeft, size: 21, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
