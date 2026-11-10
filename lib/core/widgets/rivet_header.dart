import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_back_button.dart';

/// Cabecera editorial de las pantallas del Figma.
///
/// - Con botón volver (nodo "Cabecera" de Pedidos): título Lora 28 en x=64 y
///   [AppBackButton] (48×48) cuyo círculo queda centrado donde estaba el chevron.
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
        : ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 225),
            child: Text(
              title!,
              style: style,
              maxLines: titleMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          );

    if (showBackButton) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.headerGutter - AppBackButton.bleed,
          0,
          AppSpacing.headerGutter,
          8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppBackButton(onPressed: onBack),
                const Spacer(),
                if (actions != null)
                  Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ],
            ),
            if (titleText != null)
              Padding(
                padding: const EdgeInsets.only(left: AppBackButton.bleed),
                child: titleText,
              ),
          ],
        ),
      );
    }

    final hasBrandRow = showWordmark || (actions?.isNotEmpty ?? false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.headerGutter,
        14,
        AppSpacing.headerGutter,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            )
          else
            const SizedBox(height: 30),
          if (hasBrandRow && titleText != null) const SizedBox(height: 8),
          ?titleText,
        ],
      ),
    );
  }
}
