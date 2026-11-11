import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/models/models.dart';
import '../../../core/design_system/design_system.dart';
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
    final hasSpecial = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+/\\]'),
    );

    final score = [
      hasMinLength,
      hasUpper,
      hasNumber,
      hasSpecial,
    ].where((b) => b).length;

    final (color, label) = switch (score) {
      1 => (AppColors.passwordVeryWeak, 'Muy débil'),
      2 => (AppColors.passwordWeak, 'Débil'),
      3 => (AppColors.passwordFair, 'Aceptable'),
      4 => (AppColors.passwordStrong, 'Contraseña segura'),
      _ => (AppColors.passwordVeryWeak, 'Muy débil'),
    };

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
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
                    height: AppSpacing.xs,
                    margin: EdgeInsets.only(right: i < 4 ? AppSpacing.xs : 0),
                    decoration: BoxDecoration(
                      color: i <= score ? color : AppColors.gray200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXxs),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTypography.style(
                  11,
                  weight: FontWeight.w600,
                  color: color,
                  lineHeight: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          Wrap(
            spacing: AppSpacing.space6,
            runSpacing: AppSpacing.xs,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: met ? AppColors.passwordRuleMetFill : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: met ? AppColors.passwordRuleMetBorder : AppColors.gray200,
          width: AppSpacing.strokeChip,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: AppSpacing.iconXxs,
            color: met ? AppColors.passwordStrong : AppColors.gray400,
          ),
          const SizedBox(width: AppSpacing.space3),
          Text(
            text,
            style: AppTypography.style(
              10,
              weight: FontWeight.w500,
              color: met ? AppColors.passwordRuleMetInk : AppColors.gray500,
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
        color: AppColors.surfaceFrosted,
        borderRadius: AppSpacing.roundedSheetTop,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: widget.errorMessage != null
                  ? Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: AppSpacing.roundedSm,
                        border: Border.all(color: AppColors.errorBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.errorInk,
                            size: AppSpacing.iconMd,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              widget.errorMessage ?? '',
                              style: AppTypography.style(
                                13,
                                color: AppColors.errorInk,
                                lineHeight: 16,
                              ),
                            ),
                          ),
                          if (widget.onDismissError != null)
                            GestureDetector(
                              onTap: widget.onDismissError,
                              child: const Icon(
                                Icons.close,
                                size: AppSpacing.iconXs,
                                color: AppColors.errorInk,
                              ),
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
                  focusNode: widget.nameFocusNode,
                  icon: RvIcons.nombreCompleto,
                  label: 'Nombre completo',
                  input: AuthInput(
                    controller: widget.nameController,
                    focusNode: widget.nameFocusNode,
                    hint: 'Juan Pérez',
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => widget.emailFocusNode?.requestFocus(),
                  ),
                )
                .animate()
                .fadeIn(
                  duration: 350.ms,
                  delay: 60.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.sm),
            SignupField(
                  focusNode: widget.emailFocusNode,
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
                )
                .animate()
                .fadeIn(
                  duration: 350.ms,
                  delay: 110.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.sm),
            SignupField(
                  focusNode: widget.phoneFocusNode,
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
                    onSubmitted: (_) =>
                        widget.passwordFocusNode?.requestFocus(),
                  ),
                )
                .animate()
                .fadeIn(
                  duration: 350.ms,
                  delay: 160.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.sm),
            SignupField(
                  focusNode: widget.passwordFocusNode,
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
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: RvIcon(
                        widget.obscurePassword ? RvIcons.eye : RvIcons.eyeOff,
                        color: AppColors.fieldLabel,
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(
                  duration: 350.ms,
                  delay: 210.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            PasswordStrengthMeter(password: _currentPassword).animate().fadeIn(
              duration: 300.ms,
              delay: 250.ms,
              curve: Curves.easeOutCubic,
            ),
            const SizedBox(height: AppSpacing.lg),
            AccountTypeSelector(
                  selected: widget.selectedRole,
                  onChanged: widget.onRoleChanged,
                )
                .animate()
                .fadeIn(
                  duration: 400.ms,
                  delay: 290.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.xl),
            AuthGradientButton(
                  label: 'Crear cuenta',
                  height: AppSpacing.authCompactButtonHeight,
                  isLoading: widget.isLoading,
                  onPressed: widget.onSignup,
                )
                .animate()
                .fadeIn(
                  duration: 400.ms,
                  delay: 340.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}
