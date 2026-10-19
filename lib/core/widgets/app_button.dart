import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary, outline, subtle, ghost, danger }
enum AppButtonSize { sm, md, lg }

/// Botón interactivo accesible con forma de píldora elegante (`pill`),
/// tipografía refinada y soporte para icono de avance (`chevron_right`).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      AppButtonSize.sm => 42.0,
      AppButtonSize.md => 52.0, // Altura táctil prémium de Figma
      AppButtonSize.lg => 58.0,
    };

    final fontSize = switch (size) {
      AppButtonSize.sm => 13.0,
      AppButtonSize.md => 15.0,
      AppButtonSize.lg => 16.0,
    };

    final effectiveRadius = BorderRadius.circular(height / 2);

    final textStyle = AppTypography.buttonText.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: _getTextColor(),
    );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ] else if (icon != null) ...[
          Icon(icon, size: fontSize + 4, color: _getTextColor()),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: textStyle),
        if (!isLoading && trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: fontSize + 4, color: _getTextColor()),
        ],
      ],
    );

    final border = _getBorder();
    final background = _getBackgroundColor();

    Widget button = Material(
      color: background,
      borderRadius: effectiveRadius,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: effectiveRadius,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            border: border,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Color _getBackgroundColor() {
    if (onPressed == null && !isLoading) {
      return AppColors.line300;
    }
    return switch (variant) {
      AppButtonVariant.primary => AppColors.brand700,
      AppButtonVariant.secondary => AppColors.surface0,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.subtle => AppColors.brandLight,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => AppColors.danger700,
    };
  }

  Color _getTextColor() {
    if (onPressed == null && !isLoading) {
      return AppColors.ink500;
    }
    return switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => AppColors.brand700,
      AppButtonVariant.outline => AppColors.brand700,
      AppButtonVariant.subtle => AppColors.brand700,
      AppButtonVariant.ghost => AppColors.brand700,
      AppButtonVariant.danger => Colors.white,
    };
  }

  Border? _getBorder() {
    if (variant == AppButtonVariant.outline) {
      return Border.all(color: AppColors.brand700, width: 1.2);
    }
    if (variant == AppButtonVariant.secondary) {
      return Border.all(color: AppColors.line300, width: 1.0);
    }
    return null;
  }
}
