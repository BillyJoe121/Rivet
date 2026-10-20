import 'package:flutter/material.dart';

import 'rv_icon_data.dart';
import 'rv_icons.dart';
import 'rv_tokens.dart';

/// Cabecera de pantalla de Figma: botón volver de 30×28 con chevron de 21
/// y título Lora 600 28/33.6. Debajo admite contenido extra ([children]).
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
    final rows = <Widget>[
      if (showBack || keepBackSpace || trailing != null)
        SizedBox(
          height: 28,
          child: Row(
            children: [
              if (showBack) RvBackButton(onTap: onBack),
              const Spacer(),
              ?trailing,
            ],
          ),
        ),
      Text(title, style: titleStyle ?? RvText.pageTitle),
      ...children,
    ];
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// Botón volver de 30×28 (chevron-left de 21, trazo 1.7).
class RvBackButton extends StatelessWidget {
  const RvBackButton({super.key, this.onTap, this.color = RvColors.brand700});

  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Volver',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () => Navigator.maybePop(context),
        // Caja de 30×28 con el chevron-left de 21 tal como se exporta de Figma.
        child: RvIcon(RvIcons.backChevron, color: color),
      ),
    );
  }
}
