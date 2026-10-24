import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'app_back_button.dart';

/// Cabecera para `Scaffold.appBar` con el mismo estilo editorial del Figma
/// que [RivetHeader]: [AppBackButton] a la izquierda y título Lora 28
/// alineado a la izquierda, sin imagen de fondo.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.leading,
    this.bottom,
    this.backgroundColor,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;

  static const double _barHeight = 52; // 2 + 48 del botón volver + 2

  @override
  Size get preferredSize => Size.fromHeight(
        _barHeight + (subtitle != null ? 20 : 0) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBackButton && (onBack != null || Navigator.canPop(context));
    final withBack = canGoBack && leading == null;

    return Material(
      color: backgroundColor ?? AppColors.paper100,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              // Con el botón volver, la caja de 48 sobresale 8 px del gutter y el
              // título conserva su posición (x=64, y≈10).
              padding: EdgeInsets.fromLTRB(
                AppSpacing.headerGutter - (withBack ? AppBackButton.bleed : 0),
                withBack ? 2 : 10,
                AppSpacing.headerGutter,
                withBack ? 2 : 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 10)]
                  else if (canGoBack) AppBackButton(onPressed: onBack),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: withBack ? 8 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title, style: AppTypography.pageTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(subtitle!, style: AppTypography.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ],
                      ),
                    ),
                  ),
                  ...?actions,
                ],
              ),
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }
}
