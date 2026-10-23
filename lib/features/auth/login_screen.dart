import 'dart:async';
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

  /// Oculta el error automáticamente tras [_errorDuration].
  Timer? _errorTimer;
  static const _errorDuration = Duration(seconds: 5);

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
    _emailFocusNode.addListener(_onFocusChanged);
    _passwordFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// Cuando un campo recibe el foco, lo desplaza a la vista por encima del
  /// teclado. Espera a que termine la animación del teclado.
  void _onFocusChanged() {
    if (!_emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus) return;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _revealFocusedField();
    });
  }

  void _revealFocusedField() {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) return;
    Scrollable.ensureVisible(
      focusContext,
      alignment: 0.4,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
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

    _errorTimer?.cancel();
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

  /// Muestra el error una sola vez, en el banner de la tarjeta, y lo quita a
  /// los 5 segundos. Un error nuevo reinicia el temporizador.
  void _showError(String message) {
    HapticFeedback.mediumImpact();
    _errorTimer?.cancel();
    setState(() => _errorMessage = message);
    _errorTimer = Timer(_errorDuration, _dismissError);
    _shakeController.forward(from: 0.0);
  }

  void _dismissError() {
    _errorTimer?.cancel();
    if (!mounted) return;
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: RvColors.surface0,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          // La página completa (foto y fondo blanco) se desplaza junta. Así no
          // quedan huecos ni franjas de foto al abrir el teclado.
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: ColoredBox(
              color: RvColors.surface0,
              child: Stack(
                children: [
                  // Imagen decorativa superior
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 340,
                    child: Image.asset(RvImages.loginScandinavian, fit: BoxFit.cover),
                  ),
                  // Fundido orgánico hacia el blanco de la hoja
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
                          colors: [Color(0x00FAF8F3), RvColors.surface0],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, topInset + 16, 30, 0),
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
                          onDismissError: _dismissError,
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
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                          .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
