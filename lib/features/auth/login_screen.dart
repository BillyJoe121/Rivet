import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';
import '../home/app_shell.dart';
import '../../core/design_system/design_system.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'forgot_password_screen.dart';
import 'presentation/bloc/login/login_bloc.dart';
import 'signup_screen.dart';
import 'widgets/login_card.dart';

/// Pantalla de inicio de sesión gobernada por [LoginBloc] (Sprint 1).
///
/// Implementa Clean Architecture conectando eventos y estados con el caso de uso
/// de autenticación en Supabase.
class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.role = UserRole.client,
    this.loginBloc,
  });

  final UserRole role;
  final LoginBloc? loginBloc;

  @override
  Widget build(BuildContext context) {
    if (loginBloc != null) {
      return BlocProvider<LoginBloc>.value(
        value: loginBloc!,
        child: _LoginView(role: role),
      );
    }

    try {
      context.read<LoginBloc>();
      return _LoginView(role: role);
    } catch (_) {
      return BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(SignInUseCase(context.read<AuthRepository>())),
        child: _LoginView(role: role),
      );
    }
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({required this.role});

  final UserRole role;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView>
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

  void _handleLogin() {
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
    setState(() => _errorMessage = null);

    context.read<LoginBloc>().add(
          LoginSubmitted(
            email: email,
            password: password,
          ),
        );
  }

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
    context.read<LoginBloc>().add(const LoginErrorDismissed());
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess && state.user != null) {
          context.read<AuthBloc>().add(AuthUserChanged(state.user));
          AppNavigator.pushAndRemoveUntil(
            context,
            AppShell(initialRole: state.user!.role),
          );
        } else if (state.isFailure && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final activeError = _errorMessage ?? state.errorMessage;

        return Scaffold(
          backgroundColor: AppColors.surface0,
          body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ColoredBox(
                  color: AppColors.surface0,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: AppSpacing.authHeroHeight,
                        child: Image.asset(
                          AppImages.loginScandinavian,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        top: AppSpacing.authHeroFadeTop,
                        left: 0,
                        right: 0,
                        height: AppSpacing.authHeroFadeHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.paperTransparent, AppColors.surface0],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.screenGutter,
                              topInset + AppSpacing.sm,
                              AppSpacing.space30,
                              0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppBackButton(),
                                const SizedBox(height: AppSpacing.space10),
                                Padding(
                                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                                  child: Text(
                                    'Rivet',
                                    style: AppTypography.style(
                                      38,
                                      weight: FontWeight.w700,
                                      lineHeight: 48.64,
                                      color: AppColors.brand700,
                                      family: AppTypography.serif,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(
                                        duration: 400.ms,
                                        curve: Curves.easeOutCubic,
                                      )
                                      .slideY(
                                        begin: -0.15,
                                        end: 0,
                                        curve: Curves.easeOutCubic,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.authCardOffset),
                          AnimatedBuilder(
                            animation: _shakeController,
                            builder: (context, child) {
                              final offset = math.sin(
                                    _shakeController.value * math.pi * 4,
                                  ) *
                                  AppSpacing.shakeDistance;
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
                              onToggleObscure: () =>
                                  setState(() => _obscure = !_obscure),
                              keepSession: _keepSession,
                              onKeepSessionChanged: (val) =>
                                  setState(() => _keepSession = val),
                              errorMessage: activeError,
                              onDismissError: _dismissError,
                              isLoading: state.isLoading,
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
                              .fadeIn(
                                duration: 450.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
