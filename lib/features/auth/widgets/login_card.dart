import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/design_system/design_system.dart';
import 'auth_widgets.dart';
import 'login_parts.dart';

/// Fila para alternar "Mantener sesión iniciada" y acceder a "¿Olvidaste tu contraseña?".
class KeepSessionRow extends StatelessWidget {
  const KeepSessionRow({
    super.key,
    required this.keepSession,
    required this.onKeepSessionChanged,
    required this.onForgotPassword,
  });

  final bool keepSession;
  final ValueChanged<bool> onKeepSessionChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.style(13, lineHeight: 15.23, color: AppColors.fieldLabel);

    return SizedBox(
      height: 44, // WCAG 2.5.5: Touch Target Size mínimo de 44px
      child: Row(
        children: [
          Semantics(
            checked: keepSession,
            label: 'Mantener sesión iniciada',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onKeepSessionChanged(!keepSession),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: AppSpacing.checkboxSize,
                    height: AppSpacing.checkboxSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keepSession
                          ? AppColors.brand700
                          : AppColors.surface0,
                      border: Border.all(
                        color: keepSession
                            ? AppColors.brand700
                            : AppColors.fieldBorder,
                        width: AppSpacing.strokeControl,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCheckbox),
                    ),
                    child: keepSession
                        ? const RvIcon(
                            RvIcons.check,
                            color: AppColors.surface0,
                          ).animate().scale(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.elasticOut,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Mantener sesión iniciada', style: style),
                ],
              ),
            ),
          ),
          const Spacer(),
          Semantics(
            button: true,
            label: '¿Olvidaste tu contraseña?',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusTight),
              onTap: onForgotPassword,
              hoverColor: AppColors.brand700.withValues(alpha: 0.06),
              highlightColor: AppColors.brand700.withValues(alpha: 0.08),
              splashColor: AppColors.brand700.withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: style.copyWith(
                    color: AppColors.brand700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta principal de inicio de sesión de Rivet con pestañas, campos y acciones.
class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.keepSession,
    required this.onKeepSessionChanged,
    required this.onLogin,
    required this.onCreateAccount,
    required this.onForgotPassword,
    this.emailFocusNode,
    this.passwordFocusNode,
    this.errorMessage,
    this.onDismissError,
    this.isLoading = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final bool keepSession;
  final ValueChanged<bool> onKeepSessionChanged;
  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;
  final String? errorMessage;
  final VoidCallback? onDismissError;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppSpacing.roundedSheetTop,
        boxShadow: AppSpacing.shadowSheet,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTabs(onCreateAccount: onCreateAccount),
          Container(height: AppSpacing.strokeDivider, color: AppColors.fieldBorder),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: errorMessage != null
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
                                  errorMessage ?? '',
                                  style: AppTypography.style(
                                    13,
                                    color: AppColors.errorInk,
                                    lineHeight: 16,
                                  ),
                                ),
                              ),
                              if (onDismissError != null)
                                GestureDetector(
                                  onTap: onDismissError,
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
                  crossFadeState: errorMessage != null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
                LoginField(
                      focusNode: emailFocusNode,
                      icon: RvIcons.mail,
                      label: 'Correo electrónico',
                      input: AuthInput(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        hint: 'tu@correo.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => passwordFocusNode?.requestFocus(),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: 350.ms,
                      delay: 60.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: AppSpacing.md),
                LoginField(
                      focusNode: passwordFocusNode,
                      icon: RvIcons.lock,
                      label: 'Contraseña',
                      input: AuthInput(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        hint: '••••••••',
                        obscure: obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => onLogin(),
                      ),
                      trailing: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onToggleObscure,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: RvIcon(
                            obscurePassword ? RvIcons.eye : RvIcons.eyeOff,
                            color: AppColors.inputPlaceholder,
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: 350.ms,
                      delay: 120.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: AppSpacing.md),
                KeepSessionRow(
                  keepSession: keepSession,
                  onKeepSessionChanged: onKeepSessionChanged,
                  onForgotPassword: onForgotPassword,
                ).animate().fadeIn(
                  duration: 350.ms,
                  delay: 180.ms,
                  curve: Curves.easeOutCubic,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthGradientButton(
                      label: 'Iniciar sesión',
                      isLoading: isLoading,
                      onPressed: onLogin,
                    )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: 240.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
