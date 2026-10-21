import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Tarjeta que contiene el formulario de solicitud de restablecimiento de contraseña.
class ForgotPasswordFormCard extends StatelessWidget {
  const ForgotPasswordFormCard({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          AppTextField(
            label: 'Correo electrónico',
            hint: 'ejemplo@correo.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.contact_mail_outlined,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Enviar Instrucciones',
            isLoading: isLoading,
            onPressed: () {
              HapticFeedback.lightImpact();
              onSubmit();
            },
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de confirmación con temporizador de reenvío regresivo (cooldown anti-spam).
class ForgotPasswordSuccessCard extends StatefulWidget {
  const ForgotPasswordSuccessCard({
    super.key,
    required this.onBackToLogin,
    this.onResend,
    this.cooldownSeconds = 60,
  });

  final VoidCallback onBackToLogin;
  final VoidCallback? onResend;
  final int cooldownSeconds;

  @override
  State<ForgotPasswordSuccessCard> createState() => _ForgotPasswordSuccessCardState();
}

class _ForgotPasswordSuccessCardState extends State<ForgotPasswordSuccessCard> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.cooldownSeconds;
    _startCooldown();
  }

  void _startCooldown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remaining > 1) {
        setState(() => _remaining--);
      } else {
        setState(() => _remaining = 0);
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    if (_remaining == 0 && widget.onResend != null) {
      HapticFeedback.lightImpact();
      widget.onResend!();
      setState(() => _remaining = widget.cooldownSeconds);
      _startCooldown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          backgroundColor: AppColors.brandLight,
          borderColor: AppColors.brand700.withValues(alpha: 0.3),
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 44,
                color: AppColors.brand700,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Instrucciones enviadas',
                style: AppTypography.subheading,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Si la cuenta está registrada en Rivet, recibirás un correo con el enlace seguro en los próximos minutos.',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              if (_remaining > 0)
                Text(
                  'Podrás solicitar un nuevo enlace en $_remaining s',
                  style: AppTypography.caption.copyWith(color: AppColors.ink500),
                )
              else if (widget.onResend != null)
                TextButton.icon(
                  onPressed: _handleResend,
                  icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.brand700),
                  label: const Text(
                    'Reenviar correo ahora',
                    style: TextStyle(
                      color: AppColors.brand700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          text: 'Volver al Inicio de Sesión',
          variant: AppButtonVariant.outline,
          onPressed: () {
            HapticFeedback.lightImpact();
            widget.onBackToLogin();
          },
        ),
      ],
    );
  }
}
