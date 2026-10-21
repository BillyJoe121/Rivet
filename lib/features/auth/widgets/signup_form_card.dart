import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/models.dart';
import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';
import 'signup_parts.dart';

/// Formateador automático para números de celular colombianos (ej. 300 123 4567).
class ColombianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write(' ');
      }
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Medidor interactivo de fuerza de contraseña según las políticas de seguridad de Rivet.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final hasMinLength = password.length >= 8;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+/\\]'));

    final score = [hasMinLength, hasUpper, hasNumber, hasSpecial].where((b) => b).length;

    final (color, label) = switch (score) {
      1 => (const Color(0xFFE02424), 'Muy débil'),
      2 => (const Color(0xFFFF5A1F), 'Débil'),
      3 => (const Color(0xFFD97706), 'Aceptable'),
      4 => (const Color(0xFF0E9F6E), 'Contraseña segura'),
      _ => (const Color(0xFFE02424), 'Muy débil'),
    };

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 1; i <= 4; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    height: 4,
                    margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i <= score ? color : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                label,
                style: rvText(11, weight: FontWeight.w600, color: color, lineHeight: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _CriterionChip('8+ car.', hasMinLength),
              _CriterionChip('Mayús.', hasUpper),
              _CriterionChip('Número', hasNumber),
              _CriterionChip('Especial', hasSpecial),
            ],
          ),
        ],
      ),
    );
  }
}

class _CriterionChip extends StatelessWidget {
  const _CriterionChip(this.text, this.met);

  final String text;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: met ? const Color(0xFFDEF7EC) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: met ? const Color(0xFF31C48D) : const Color(0xFFE5E7EB),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 11,
            color: met ? const Color(0xFF0E9F6E) : const Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: rvText(
              10,
              weight: FontWeight.w500,
              color: met ? const Color(0xFF03543F) : const Color(0xFF6B7280),
              lineHeight: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta modular de formulario de registro de Rivet con medidor reactivo de contraseña y focus traversal.
class SignupFormCard extends StatefulWidget {
  const SignupFormCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSignup,
    this.nameFocusNode,
    this.emailFocusNode,
    this.phoneFocusNode,
    this.passwordFocusNode,
    this.errorMessage,
    this.onDismissError,
    this.isLoading = false,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode? nameFocusNode;
  final FocusNode? emailFocusNode;
  final FocusNode? phoneFocusNode;
  final FocusNode? passwordFocusNode;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onSignup;
  final String? errorMessage;
  final VoidCallback? onDismissError;
  final bool isLoading;

  @override
  State<SignupFormCard> createState() => _SignupFormCardState();
}

class _SignupFormCardState extends State<SignupFormCard> {
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.passwordController.text;
    widget.passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted && _currentPassword != widget.passwordController.text) {
      setState(() {
        _currentPassword = widget.passwordController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xD6FFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: widget.errorMessage != null
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE8E8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF8B4B4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Color(0xFF9B1C1C), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.errorMessage ?? '',
                              style: rvText(13,
                                  color: const Color(0xFF9B1C1C),
                                  lineHeight: 16),
                            ),
                          ),
                          if (widget.onDismissError != null)
                            GestureDetector(
                              onTap: widget.onDismissError,
                              child: const Icon(Icons.close,
                                  size: 16, color: Color(0xFF9B1C1C)),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              crossFadeState: widget.errorMessage != null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            SignupField(
              icon: RvIcons.nombreCompleto,
              label: 'Nombre completo',
              input: AuthInput(
                controller: widget.nameController,
                focusNode: widget.nameFocusNode,
                hint: 'Juan Pérez',
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => widget.emailFocusNode?.requestFocus(),
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.correoElectronico,
              label: 'Correo electrónico',
              input: AuthInput(
                controller: widget.emailController,
                focusNode: widget.emailFocusNode,
                hint: 'tu@correo.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => widget.phoneFocusNode?.requestFocus(),
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.phone,
              label: 'Número de contacto',
              input: AuthInput(
                controller: widget.phoneController,
                focusNode: widget.phoneFocusNode,
                hint: '300 123 4567',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ColombianPhoneFormatter(),
                ],
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => widget.passwordFocusNode?.requestFocus(),
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.contrasena,
              label: 'Contraseña segura',
              input: AuthInput(
                controller: widget.passwordController,
                focusNode: widget.passwordFocusNode,
                hint: '••••••••••••',
                obscure: widget.obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => widget.onSignup(),
              ),
              trailing: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onToggleObscure,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: RvIcon(
                    widget.obscurePassword
                        ? RvIcons.mostrarContrasena
                        : RvIcons.eye,
                    color: AuthColors.mutedInk,
                  ),
                ),
              ),
            ),
            PasswordStrengthMeter(password: _currentPassword),
            const SizedBox(height: 16),
            AccountTypeSelector(
              selected: widget.selectedRole,
              onChanged: widget.onRoleChanged,
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
              label: 'Crear cuenta',
              height: 56,
              isLoading: widget.isLoading,
              onPressed: widget.onSignup,
            ),
          ],
        ),
      ),
    );
  }
}
