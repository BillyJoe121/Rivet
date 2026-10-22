import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Colores propios de las pantallas de acceso (Figma 93:56 y 11:196).
abstract final class AuthColors {
  static const fieldStroke = Color(0xFFE7E8E1);
  static const iconTile = Color(0xFFF2F0EB);
  static const softTile = Color(0xFFF3F4F0);
  static const labelInk = Color(0xFF142D3D);
  static const mutedInk = Color(0xFF607587);
  // Contraste mejorado para accesibilidad WCAG 2.2
  static const placeholder = Color(0xFF6E7E8B);
}

/// Botón principal de acceso con física de pulsación táctil, soporte de carga y micro-animaciones.
class AuthGradientButton extends StatefulWidget {
  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 60,
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
              borderRadius: BorderRadius.circular(32),
              onTap: widget.isLoading ? null : widget.onPressed,
              splashColor: Colors.white.withValues(alpha: 0.15),
              highlightColor: Colors.white.withValues(alpha: 0.08),
              child: Ink(
                height: widget.height,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: const Alignment(0.7, 1),
                    colors: widget.isLoading
                        ? [
                            const Color(0xFF1A6B63),
                            const Color(0xFF064F48),
                            const Color(0xFF002B27)
                          ]
                        : [
                            const Color(0xFF278D82),
                            const Color(0xFF08655D),
                            const Color(0xFF003D38)
                          ],
                    stops: const [0, 0.46, 1],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F004E49),
                      offset: Offset(0, 5),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: widget.isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: RvColors.surface0,
                                ),
                              ),
                            )
                          : Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              style: rvText(
                                17,
                                weight: FontWeight.w600,
                                lineHeight: 19.92,
                                color: RvColors.surface0,
                              ),
                            ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x26FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const RvIcon(
                        RvIcons.arrowRight,
                        color: RvColors.surface0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .shimmer(
          delay: const Duration(milliseconds: 900),
          duration: const Duration(milliseconds: 1400),
          color: Colors.white.withValues(alpha: 0.15),
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
    final style = rvText(15, lineHeight: 17.58, color: AuthColors.labelInk);
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
      cursorColor: RvColors.brand700,
      cursorWidth: 2.0,
      cursorRadius: const Radius.circular(2.0),
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
        hintStyle: style.copyWith(color: AuthColors.placeholder),
      ),
    );
  }
}
