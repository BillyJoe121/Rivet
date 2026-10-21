import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';
import 'auth_service.dart';
import 'widgets/forgot_password_cards.dart';

/// Pantalla de recuperación de acceso (P-003).
/// Envía instrucciones por correo mediante Supabase Auth sin revelar si el usuario existe (seguridad y privacidad).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final emailError = Validators.email(email);

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailError),
          backgroundColor: AppColors.ink900,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.sendPasswordResetEmail(email);
    } catch (_) {
      // Principio OWASP de privacidad: siempre confirmamos el envío para evitar enumeración de cuentas.
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(title: 'Recuperar Acceso'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.brandLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lock_reset,
                  size: 28,
                  color: AppColors.brand700,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '¿Olvidaste tu contraseña?',
                style: AppTypography.pageTitle.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Ingresa tu correo electrónico registrado para recibir un enlace de restablecimiento seguro.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: !_submitted
                    ? ForgotPasswordFormCard(
                        key: const ValueKey('forgot_form'),
                        emailController: _emailController,
                        isLoading: _isLoading,
                        onSubmit: _handleSubmit,
                      )
                    : ForgotPasswordSuccessCard(
                        key: const ValueKey('forgot_success'),
                        onResend: _handleSubmit,
                        onBackToLogin: () => Navigator.pop(context),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
