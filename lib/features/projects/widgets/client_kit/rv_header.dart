import 'package:flutter/material.dart';
import '../../../../core/widgets/app_back_button.dart';
import 'rv_tokens.dart';

/// Cabecera de pantalla de Figma: [AppBackButton] común (caja de 48×48) y
/// título Lora 600 28/33.6. Debajo admite contenido extra ([children]).
class RvHeader extends StatelessWidget {
  const RvHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.keepBackSpace = true,
    this.onBack,
    this.padding = const EdgeInsets.fromLTRB(24, 8, 24, 8),
    this.gap = 4,
    this.trailing,
    this.titleStyle,
    this.children = const [],
  });

  final String title;
  final bool showBack;

  /// Si el volver está oculto, conserva su alto (como en Figma con la capa oculta).
  final bool keepBackSpace;
  final VoidCallback? onBack;
  final EdgeInsets padding;

  /// Separación vertical entre los hijos del auto-layout de la cabecera.
  final double gap;

  /// Contenido a la derecha de la fila del volver.
  final Widget? trailing;
  final TextStyle? titleStyle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // La caja de 48 sobresale del padding izquierdo y del superior para que el
    // círculo quede donde estaba el chevron (centro y≈padding.top + 14).
    final bleed = padding.left < AppBackButton.bleed ? padding.left : AppBackButton.bleed;
    final top = padding.top > 10 ? padding.top - 10 : 0.0;
    // Tras la fila del volver (48 en vez de 28) el título conserva su y.
    final afterBack = padding.top - top + gap - 20 > 0 ? padding.top - top + gap - 20 : 0.0;
    final rows = <Widget>[
      if (showBack || keepBackSpace || trailing != null)
        SizedBox(
          height: 48,
          child: Row(
            children: [
              if (showBack) AppBackButton(onPressed: onBack),
              const Spacer(),
              ?trailing,
            ],
          ),
        ),
      Padding(
        padding: EdgeInsets.only(left: bleed),
        child: Text(title, style: titleStyle ?? RvText.pageTitle),
      ),
      ...children.map((c) => Padding(padding: EdgeInsets.only(left: bleed), child: c)),
    ];
    return Padding(
      padding: padding.copyWith(left: padding.left - bleed, top: top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: i == 1 ? afterBack : gap),
            rows[i],
          ],
        ],
      ),
    );
  }
}
