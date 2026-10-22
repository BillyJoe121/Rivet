import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/models/models.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/utils/validators.dart';
import '../home/app_shell.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'auth_service.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'widgets/login_card.dart';

/// Inicio de sesión conectado a Supabase Auth (Sprint 1).
///
/// Protegido contra desbordamientos de teclado mediante viewport adaptable,
/// validación de credenciales estricta, focus traversal fluido y micro-animación de sacudida (shake).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.role = UserRole.client});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late final AnimationController _shakeController;

  bool _keepSession = true;
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailError = Validators.email(email);
    if (emailError != null) {
      _showError(emailError);
      return;
    }

    if (password.isEmpty) {
      _showError('Ingresa tu contraseña');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService.instance.signIn(
        email: email,
        password: password,
      );

      if (!mounted) return;

      AppNavigator.pushAndRemoveUntil(
        context,
        AppShell(initialRole: user.role),
      );
    } catch (e) {
      if (!mounted) return;
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      _showError(cleanMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();
    setState(() => _errorMessage = message);
    _shakeController.forward(from: 0.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: RvColors.ink900,
        behavior: SnackBarBehavior.floating,
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
      backgroundColor: RvColors.paper100,
      body: Stack(
        children: [
          // Imagen decorativa superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: Image.asset(RvImages.loginScandinavian, fit: BoxFit.cover),
          ),
          // Fundido orgánico hacia el color paper100
          const Positioned(
            top: 200,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FAF8F3), RvColors.paper100],
                ),
              ),
            ),
          ),
          // Contenido desplazable seguro contra teclado
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 16, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RvBackButton(),
                        const SizedBox(height: 18),
                        Text(
                          'Rivet',
                          style: rvText(
                            38,
                            weight: FontWeight.w700,
                            lineHeight: 48.64,
                            color: RvColors.brand700,
                            family: RvFonts.serif,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                            .slideY(begin: -0.15, end: 0, curve: Curves.easeOutCubic),
                      ],
                    ),
                  ),
                  const SizedBox(height: 110),
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final offset = math.sin(_shakeController.value * math.pi * 4) * 8.0;
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: child,
                      );
                    },
                    child: LoginCard(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                      obscurePassword: _obscure,
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      keepSession: _keepSession,
                      onKeepSessionChanged: (val) => setState(() => _keepSession = val),
                      errorMessage: _errorMessage,
                      onDismissError: () => setState(() => _errorMessage = null),
                      isLoading: _isLoading,
                      onLogin: _handleLogin,
                      onCreateAccount: () => AppNavigator.push(
                        context,
                        SignupScreen(initialRole: widget.role),
                      ),
                      onForgotPassword: () => AppNavigator.push(
                        context,
                        const ForgotPasswordScreen(),
                      ),
                      onSocialSelected: () => AppNavigator.pushAndRemoveUntil(
                        context,
                        AppShell(initialRole: widget.role),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
