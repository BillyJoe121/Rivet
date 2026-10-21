import 'package:flutter/material.dart';

import '../../../core/models/models.dart';
import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';
import 'signup_parts.dart';

/// Tarjeta modular de formulario de registro de Rivet.
class SignupFormCard extends StatelessWidget {
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
    this.errorMessage,
    this.isLoading = false,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onSignup;
  final String? errorMessage;
  final bool isLoading;

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
            SignupField(
              icon: RvIcons.nombreCompleto,
              label: 'Nombre completo',
              input: AuthInput(
                controller: nameController,
                hint: 'Juan Pérez',
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.correoElectronico,
              label: 'Correo electrónico',
              input: AuthInput(
                controller: emailController,
                hint: 'tu@correo.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.phone,
              label: 'Número de contacto',
              input: AuthInput(
                controller: phoneController,
                hint: '300 123 4567',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.contrasena,
              label: 'Contraseña (mínimo 8 car., Mayús, Núm, Especial)',
              input: AuthInput(
                controller: passwordController,
                hint: '••••••••••••',
                obscure: obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSignup(),
              ),
              trailing: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToggleObscure,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: RvIcon(
                    obscurePassword ? RvIcons.mostrarContrasena : RvIcons.eye,
                    color: AuthColors.mutedInk,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AccountTypeSelector(
              selected: selectedRole,
              onChanged: onRoleChanged,
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
              label: 'Crear cuenta',
              height: 56,
              isLoading: isLoading,
              onPressed: onSignup,
            ),
          ],
        ),
      ),
    );
  }
}
