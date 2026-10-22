import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// Botón volver circular de 32×32 con fondo suave, chevron centrado y micro-escala táctil.
class RvBackButton extends StatefulWidget {
  const RvBackButton({super.key, this.onTap, this.color = RvColors.brand700});

  final VoidCallback? onTap;
  final Color color;

  @override
  State<RvBackButton> createState() => _RvBackButtonState();
}

class _RvBackButtonState extends State<RvBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Volver',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          HapticFeedback.selectionClick();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          if (_isPressed) setState(() => _isPressed = false);
        },
        onTapCancel: () {
          if (_isPressed) setState(() => _isPressed = false);
        },
        onTap: widget.onTap ?? () => Navigator.maybePop(context),
        child: AnimatedScale(
          scale: _isPressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F0),
              shape: BoxShape.circle,
            ),
            child: const RvIcon(RvIcons.chevronLeft),
          ),
        ),
      ),
    );
  }
}
