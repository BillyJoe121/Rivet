import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'rivet_header.dart';

/// Cabecera para `Scaffold.appBar` con el mismo estilo editorial del Figma
/// que [RivetHeader]: chevron de marca a la izquierda y título Lora 28
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

  static const double _barHeight = 52; // 10 + 33.6 de título + 8

  @override
  Size get preferredSize => Size.fromHeight(
        _barHeight + (subtitle != null ? 20 : 0) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBackButton && (onBack != null || Navigator.canPop(context));

    return Material(
      color: backgroundColor ?? AppColors.paper100,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.headerGutter, 10, AppSpacing.headerGutter, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 10)]
                  else if (canGoBack) ...[RivetBackButton(onPressed: onBack), const SizedBox(width: 10)],
                  Expanded(
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
