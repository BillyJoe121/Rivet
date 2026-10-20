import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla de recuperación de acceso (P-003).
/// Envía instrucciones sin revelar si el usuario existe (seguridad y privacidad).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _contactController = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final contact = _contactController.text.trim();
    if (contact.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
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
                'Ingresa tu correo electrónico o número de celular registrado para recibir un enlace de restablecimiento seguro.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              if (!_submitted) ...[
                AppCard(
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Correo o número de teléfono',
                        hint: 'ejemplo@correo.com o 3101234567',
                        controller: _contactController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.contact_mail_outlined,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        text: 'Enviar Instrucciones',
                        isLoading: _isLoading,
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                AppCard(
                  backgroundColor: AppColors.brandLight,
                  borderColor: AppColors.brand700.withValues(alpha: 0.3),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mark_email_read_outlined,
                        size: 40,
                        color: AppColors.brand700,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Solicitud procesada',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Si la cuenta se encuentra registrada en Rivet, recibirás las instrucciones en unos minutos. Por privacidad, no revelamos públicamente la existencia de cuentas.',
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Volver al Inicio',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
