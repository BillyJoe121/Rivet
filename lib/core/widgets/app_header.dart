import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Barra de navegación superior unificada para todas las vistas.
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

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (subtitle != null ? 14 : 0) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && showBackButton) {
      final canPop = Navigator.canPop(context);
      if (canPop || onBack != null) {
        effectiveLeading = IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
          tooltip: 'Volver',
          onPressed: onBack ?? () => Navigator.maybePop(context),
        );
      }
    }

    Widget titleWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.subheading.copyWith(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: AppTypography.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.paper100,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: effectiveLeading,
      title: titleWidget,
      actions: actions,
      bottom: bottom,
    );
  }
}
