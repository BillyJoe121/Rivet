import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';
import 'forgot_password_parts.dart';
import 'login_parts.dart';

/// Hoja blanca de recuperación (misma anatomía que la tarjeta de inicio de
/// sesión): título Lora con indicador de pasos, separador y contenido.
class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({
    super.key,
    required this.sent,
    required this.child,
  });

  final bool sent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = sent ? 'Revisa tu correo' : 'Recuperar acceso';

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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.centerLeft,
                      children: [...previous, ?current],
                    ),
                    child: Text(
                      title,
                      key: ValueKey(title),
                      maxLines: 1,
                      style: rvText(
                        22,
                        weight: FontWeight.w700,
                        lineHeight: 28,
                        color: RvColors.brand700,
                        family: RvFonts.serif,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ForgotStepBar(step: sent ? 2 : 1),
              ],
            ),
          ),
          Container(height: 1, color: AuthColors.fieldStroke),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paso 1: correo de la cuenta y envío del enlace.
class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
    this.emailFocusNode,
  });

  final TextEditingController emailController;
  final FocusNode? emailFocusNode;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginField(
          focusNode: emailFocusNode,
          icon: RvIcons.mail,
          label: 'Correo electrónico',
          input: AuthInput(
            controller: emailController,
            focusNode: emailFocusNode,
            hint: 'tu@correo.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(height: 20),
        AuthGradientButton(
          label: 'Enviar enlace',
          isLoading: isLoading,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

/// Paso 2: confirmación con el correo usado y reenvío con enfriamiento
/// (cooldown anti-spam).
class ForgotPasswordSent extends StatefulWidget {
  const ForgotPasswordSent({
    super.key,
    required this.email,
    required this.onEditEmail,
    required this.onBackToLogin,
    this.onResend,
    this.cooldownSeconds = 60,
  });

  final String email;
  final VoidCallback onEditEmail;
  final VoidCallback onBackToLogin;
  final VoidCallback? onResend;
  final int cooldownSeconds;

  @override
  State<ForgotPasswordSent> createState() => _ForgotPasswordSentState();
}

class _ForgotPasswordSentState extends State<ForgotPasswordSent> {
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
        SentEmailChip(email: widget.email, onEdit: widget.onEditEmail),
        const SizedBox(height: 12),
        ResendCountdownTile(
          remaining: _remaining,
          total: widget.cooldownSeconds,
          onResend: widget.onResend == null ? null : _handleResend,
        ),
        const SizedBox(height: 20),
        AuthGradientButton(
          label: 'Volver a iniciar sesión',
          onPressed: widget.onBackToLogin,
        ),
      ],
    );
  }
}
