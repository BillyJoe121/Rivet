import 'package:flutter/material.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Colores propios de las pantallas de acceso (Figma 93:56 y 11:196).
abstract final class AuthColors {
  static const fieldStroke = Color(0xFFE7E8E1);
  static const iconTile = Color(0xFFF2F0EB);
  static const softTile = Color(0xFFF3F4F0);
  static const labelInk = Color(0xFF142D3D);
  static const mutedInk = Color(0xFF607587);
  static const placeholder = Color(0xFF9CA8B1);
}

/// Botón principal de acceso: alto 60 (o 56), radio 32, gradiente de tres
/// paradas, sombra de marca, etiqueta Roboto 600 17 centrada y flecha en un
/// círculo blanco al 15 %.
class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 60,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.7, 1),
              colors: [Color(0xFF278D82), Color(0xFF08655D), Color(0xFF003D38)],
              stops: [0, 0.46, 1],
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
                child: Text(
                  label,
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
  });

  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final style = rvText(15, lineHeight: 17.58, color: AuthColors.labelInk);
    return TextField(
      controller: controller,
      obscureText: obscure,
      obscuringCharacter: '•',
      keyboardType: keyboardType,
      style: style,
      cursorColor: RvColors.brand700,
      decoration: InputDecoration.collapsed(
        hintText: hint,
        hintStyle: style.copyWith(color: AuthColors.placeholder),
      ),
    );
  }
}
