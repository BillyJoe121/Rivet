import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/design_system.dart';

/// Botón principal de acceso con física de pulsación táctil, soporte de carga y micro-animaciones.
class AuthGradientButton extends StatefulWidget {
  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSpacing.authButtonHeight,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool isLoading;

  @override
  State<AuthGradientButton> createState() => _AuthGradientButtonState();
}

class _AuthGradientButtonState extends State<AuthGradientButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.isLoading || widget.onPressed == null) return;
    HapticFeedback.selectionClick();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isLoading && widget.onPressed != null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusPillButton),
              onTap: widget.isLoading ? null : widget.onPressed,
              splashColor: AppColors.surface0.withValues(alpha: 0.15),
              highlightColor: AppColors.surface0.withValues(alpha: 0.08),
              child: Ink(
                height: widget.height,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPillButton),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: const Alignment(0.7, 1),
                    colors: widget.isLoading
                        ? [
                            AppColors.buttonPressedTop,
                            AppColors.buttonPressedMid,
                            AppColors.buttonPressedEnd,
                          ]
                        : [
                            AppColors.buttonGradientTop,
                            AppColors.buttonGradientMid,
                            AppColors.brandGradientEnd,
                          ],
                    stops: const [0, 0.46, 1],
                  ),
                  boxShadow: AppSpacing.shadowBrand,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.iconTileSize),
                    Expanded(
                      child: widget.isLoading
                          ? const Center(
                              child: SizedBox(
                                width: AppSpacing.iconLg,
                                height: AppSpacing.iconLg,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSpacing.strokeSpinner,
                                  color: AppColors.surface0,
                                ),
                              ),
                            )
                          : Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              style: AppTypography.style(
                                17,
                                weight: FontWeight.w600,
                                lineHeight: 19.92,
                                color: AppColors.surface0,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: AppSpacing.iconTileSize,
                      height: AppSpacing.iconTileSize,
                      // El chevrón avanza al presionar y regresa al soltar.
                      child: AnimatedSlide(
                        offset: _isPressed
                            ? const Offset(0.35, 0)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: const Icon(
                          LucideIcons.chevronRight,
                          size: AppSpacing.iconLg,
                          color: AppColors.surface0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().shimmer(
      delay: const Duration(milliseconds: 900),
      duration: const Duration(milliseconds: 1400),
      color: AppColors.surface0.withValues(alpha: 0.15),
    );
  }
}

/// Texto editable con el aspecto de un valor/placeholder de Figma
/// (Roboto 400 15/17.58) sin decoración propia.
class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.style(15, lineHeight: 17.58, color: AppColors.inputInk);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      obscureText: obscure,
      obscuringCharacter: '•',
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: style,
      cursorColor: AppColors.brand700,
      cursorWidth: AppSpacing.cursorWidth,
      cursorRadius: const Radius.circular(AppSpacing.radiusXxs),
      decoration: InputDecoration(
        isCollapsed: true,
        filled: false,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: hint,
        hintStyle: style.copyWith(color: AppColors.inputPlaceholder),
      ),
    );
  }
}
