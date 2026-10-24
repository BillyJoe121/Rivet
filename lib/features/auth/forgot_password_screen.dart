import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/app_back_button.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'auth_service.dart';
import 'widgets/forgot_password_cards.dart';

/// Pantalla de recuperación de acceso (P-003).
/// Envía instrucciones por correo mediante Supabase Auth sin revelar si el usuario existe (seguridad y privacidad).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  bool _submitted = false;
  bool _isLoading = false;
  String _sentTo = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // La ilustración del paso 2 se decodifica antes para que el cambio de
    // cabecera no muestre un hueco.
    precacheImage(const AssetImage(RvImages.mailEnvelope), context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final emailError = Validators.email(email);

    if (emailError != null) {
      _showError(emailError);
      return;
    }

    FocusScope.of(context).unfocus();
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
      _sentTo = email;
    });
  }

  void _editEmail() {
    setState(() => _submitted = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _emailFocusNode.requestFocus();
    });
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();
    _shakeController.forward(from: 0.0);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: RvColors.ink900,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'OK',
            textColor: const Color(0xFFEAF5F0),
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: RvColors.surface0,
      body: Stack(
        children: [
          // Cabecera ilustrada: escudo mientras se solicita, sobre al enviar.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOutCubic,
              child: Image.asset(
                _submitted ? RvImages.mailEnvelope : RvImages.headerPrivacy,
                key: ValueKey(_submitted),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 380,
                alignment: _submitted
                    ? const Alignment(0.2, 0)
                    : Alignment.centerRight,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      // Caja de 48 con el círculo donde estaba el de 32.
                      padding: EdgeInsets.fromLTRB(22, 8, 30, 0),
                      child: AppBackButton(),
                    ),
                  ),
                  const SizedBox(height: 192),
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final offset =
                          math.sin(_shakeController.value * math.pi * 4) * 8.0;
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: child,
                      );
                    },
                    child: ForgotPasswordSheet(
                      sent: _submitted,
                      child: _submitted
                          ? ForgotPasswordSent(
                              key: const ValueKey('forgot_sent'),
                              email: _sentTo,
                              onEditEmail: _editEmail,
                              onResend: _handleSubmit,
                              onBackToLogin: () => Navigator.pop(context),
                            )
                          : ForgotPasswordForm(
                              key: const ValueKey('forgot_form'),
                              emailController: _emailController,
                              emailFocusNode: _emailFocusNode,
                              isLoading: _isLoading,
                              onSubmit: _handleSubmit,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
