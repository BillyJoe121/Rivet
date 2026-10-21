import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';

/// Campo de texto medido del Registro (nodo 11:220 "Campo de registro").
///
/// Caja blanca de alto mínimo 60, borde interior de 1 px, radio 14,
/// padding horizontal 16 y separación 16 entre icono y contenido. La
/// etiqueta va dentro de la caja (Roboto 500 13/15.2), 3 px sobre el valor
/// (Roboto 400 15/17.6). Ayuda y errores se muestran debajo de la caja.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.maxLines = 1,
    this.enabled = true,
    this.helperText,
    this.onChanged,
    this.autofocus = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final int maxLines;
  final bool enabled;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

// Colores medidos del campo que no tienen token propio en el tema.
const Color _fieldBorder = Color(0xFFE7E8E1); // Borde del campo
const Color _fieldLabel = Color(0xFF607587); // Etiqueta e icono de ojo

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  TextEditingController? _localController;
  final FocusNode _focusNode = FocusNode();

  TextEditingController get _controller =>
      widget.controller ?? (_localController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _localController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      enabled: widget.enabled,
      validator: widget.validator == null
          ? null
          : (_) => widget.validator!(_controller.text),
      builder: (state) => _buildField(state),
    );
  }

  Widget _buildField(FormFieldState<String> state) {
    final multiline = !widget.isPassword && widget.maxLines > 1;
    final borderColor = state.hasError
        ? AppColors.danger700
        : _focusNode.hasFocus
            ? AppColors.brand700
            : _fieldBorder;

    final borderWidth = _focusNode.hasFocus ? 1.5 : AppSpacing.strokeDivider;

    final input = TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: multiline ? TextInputAction.newline : TextInputAction.next,
      obscureText: widget.isPassword && _obscureText,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: (value) {
        state.didChange(value);
        widget.onChanged?.call(value);
      },
      style: AppTypography.bodyLarge.copyWith(
        color: widget.enabled ? AppColors.ink900 : AppColors.ink500,
      ),
      cursorColor: AppColors.brand700,
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
        hintText: widget.hint,
        hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.ink500),
        hintMaxLines: widget.maxLines,
      ),
    );

    Widget? trailing;
    if (widget.isPassword) {
      final tooltip = _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña';
      // Ojo de 20×14 (Lucide `eye` a 24) sin el relleno de un IconButton,
      // para conservar el alto de 60 del campo.
      trailing = Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          label: tooltip,
          child: InkResponse(
            onTap: () => setState(() => _obscureText = !_obscureText),
            radius: 20,
            child: Icon(
              _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
              size: 24,
              color: _fieldLabel,
            ),
          ),
        ),
      );
    } else if (widget.suffixIcon != null) {
      trailing = widget.suffixIcon;
    }

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.enabled ? AppColors.surface0 : AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      // Trazo interior como en Figma: no desplaza el contenido.
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: multiline ? 6 : 0),
              child: Icon(widget.prefixIcon, size: 24, color: AppColors.brand700),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 15.2 / 13,
                      color: _fieldLabel,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                input,
              ],
            ),
          ),
          if (widget.suffixText != null) ...[
            const SizedBox(width: 8),
            Text(
              widget.suffixText!,
              style: AppTypography.bodyStrong.copyWith(color: AppColors.ink700),
            ),
          ],
          // Separación de 16 del diseño menos el margen interno del icono.
          if (trailing != null) ...[const SizedBox(width: 14), trailing],
        ],
      ),
    );

    final message = state.errorText ?? widget.helperText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.enabled ? _focusNode.requestFocus : null,
          child: box,
        ),
        if (message != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              message,
              style: AppTypography.caption.copyWith(
                color: state.hasError ? AppColors.danger700 : AppColors.ink500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
