import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';
import 'app_button.dart';

/// Aviso de lista vacía medido de "Pedidos · Sin despachos" (nodo 2027:181
/// "Sin pedidos despachados"): bloque `brandLight` de radio 12, padding 12
/// y 10 px entre el icono de línea (28, color de marca) y el texto. Título
/// Roboto 600 13/15.6 `ink900` y mensaje Roboto 400 11/13.2 `ink500`, con
/// 4 px entre ellos. La acción opcional va debajo del mensaje.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.inbox,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: AppSpacing.roundedMd,
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: AppColors.brand700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyStrong.copyWith(color: AppColors.ink900),
                ),
                const SizedBox(height: 4),
                Text(message, style: AppTypography.caption),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    text: actionLabel!,
                    onPressed: onAction,
                    isFullWidth: false,
                    size: AppButtonSize.sm,
                    showChevron: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
