import 'package:flutter/material.dart';

import '../../projects/widgets/client_kit/client_kit.dart';
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
    final style = rvText(13, lineHeight: 15.23, color: AuthColors.mutedInk);

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
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keepSession ? RvColors.brand700 : RvColors.surface0,
                      border: Border.all(color: RvColors.brand700),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: keepSession
                        ? const RvIcon(RvIcons.check, color: RvColors.surface0)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text('Mantener sesión iniciada', style: style),
                ],
              ),
            ),
          ),
          const Spacer(),
          Semantics(
            button: true,
            label: '¿Olvidaste tu contraseña?',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onForgotPassword,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('¿Olvidaste tu contraseña?', style: style),
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
    required this.onSocialSelected,
    this.errorMessage,
    this.isLoading = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final bool keepSession;
  final ValueChanged<bool> onKeepSessionChanged;
  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;
  final VoidCallback onSocialSelected;
  final String? errorMessage;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: RvColors.surface0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTabs(onCreateAccount: onCreateAccount),
          Container(height: 1, color: AuthColors.fieldStroke),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF8B4B4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFF9B1C1C), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: rvText(13, color: const Color(0xFF9B1C1C), lineHeight: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                LoginField(
                  icon: RvIcons.mail,
                  label: 'Correo electrónico',
                  input: AuthInput(
                    controller: emailController,
                    hint: 'tu@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 12),
                LoginField(
                  icon: RvIcons.lock,
                  label: 'Contraseña',
                  input: AuthInput(
                    controller: passwordController,
                    hint: '••••••••',
                    obscure: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onLogin(),
                  ),
                  trailing: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onToggleObscure,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: RvIcon(
                        obscurePassword ? RvIcons.eye : RvIcons.mostrarContrasena,
                        color: AuthColors.placeholder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                KeepSessionRow(
                  keepSession: keepSession,
                  onKeepSessionChanged: onKeepSessionChanged,
                  onForgotPassword: onForgotPassword,
                ),
                const SizedBox(height: 16),
                AuthGradientButton(
                  label: 'Iniciar sesión',
                  isLoading: isLoading,
                  onPressed: onLogin,
                ),
                const SizedBox(height: 16),
                const OrContinueWith(),
                const SizedBox(height: 12),
                SocialButtonsRow(onSelected: onSocialSelected),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
