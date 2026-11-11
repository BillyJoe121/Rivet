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
import 'presentation/bloc/signup/signup_bloc.dart';
import 'widgets/signup_form_card.dart';
import 'widgets/signup_parts.dart';

/// Registro de usuarios conectado a Supabase y gestionado por [SignUpBloc] (Sprint 1).
class SignupScreen extends StatelessWidget {
  const SignupScreen({
    super.key,
    this.initialRole = UserRole.client,
    this.signUpBloc,
  });

  final UserRole initialRole;
  final SignUpBloc? signUpBloc;

  @override
  Widget build(BuildContext context) {
    final role = initialRole == UserRole.supplier
        ? UserRole.client
        : initialRole;

    if (signUpBloc != null) {
      return BlocProvider<SignUpBloc>.value(
        value: signUpBloc!,
        child: _SignupView(initialRole: role),
      );
    }

    try {
      context.read<SignUpBloc>();
      return _SignupView(initialRole: role);
    } catch (_) {
      return BlocProvider<SignUpBloc>(
        create: (_) =>
            SignUpBloc(
              SignUpUseCase(context.read<AuthRepository>()),
              initialRole: role,
            ),
        child: _SignupView(initialRole: role),
      );
    }
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView({required this.initialRole});

  final UserRole initialRole;

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late final AnimationController _shakeController;

  /// Oculta el error automáticamente tras [_errorDuration].
  Timer? _errorTimer;
  static const _errorDuration = Duration(seconds: 5);

  late UserRole _role = widget.initialRole;

  bool _obscure = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    for (final node in _focusNodes) {
      node.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final nameError = Validators.fullName(name);
    if (nameError != null) {
      _showError(nameError);
      _nameFocusNode.requestFocus();
      return;
    }

    final emailError = Validators.email(email);
    if (emailError != null) {
      _showError(emailError);
      _emailFocusNode.requestFocus();
      return;
    }

    final phoneError = Validators.phone(phone);
    if (phoneError != null) {
      _showError(phoneError);
      _phoneFocusNode.requestFocus();
      return;
    }

    final passwordError = Validators.password(password);
    if (passwordError != null) {
      _showError(passwordError);
      _passwordFocusNode.requestFocus();
      return;
    }

    _errorTimer?.cancel();
    setState(() => _errorMessage = null);

    final sanitizedPhone = Validators.sanitizePhone(phone);
    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        name: name,
        email: email,
        phone: sanitizedPhone,
        password: password,
        role: _role,
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
    context.read<SignUpBloc>().add(const SignUpErrorDismissed());
  }

  List<FocusNode> get _focusNodes => [
    _nameFocusNode,
    _emailFocusNode,
    _phoneFocusNode,
    _passwordFocusNode,
  ];

  void _onFocusChanged() {
    if (!_focusNodes.any((node) => node.hasFocus)) return;
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

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return BlocConsumer<SignUpBloc, SignUpState>(
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
          backgroundColor: AppColors.paper100,
          body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ColoredBox(
                  color: AppColors.paper100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: AppSpacing.signupHeroHeight,
                        child: Image.asset(
                          AppImages.headerRoller,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        top: AppSpacing.signupHeroFadeTop,
                        left: 0,
                        right: 0,
                        height: AppSpacing.signupHeroFadeHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.paperTransparent, AppColors.paper100],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: topInset),
                            child: const SignupHeader()
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
                          const SizedBox(height: AppSpacing.space18),
                          AnimatedBuilder(
                                animation: _shakeController,
                                builder: (context, child) {
                                  final offset =
                                      math.sin(
                                        _shakeController.value * math.pi * 4,
                                      ) *
                                      AppSpacing.shakeDistance;
                                  return Transform.translate(
                                    offset: Offset(offset, 0),
                                    child: child,
                                  );
                                },
                                child: SignupFormCard(
                                  nameController: _nameController,
                                  emailController: _emailController,
                                  phoneController: _phoneController,
                                  passwordController: _passwordController,
                                  nameFocusNode: _nameFocusNode,
                                  emailFocusNode: _emailFocusNode,
                                  phoneFocusNode: _phoneFocusNode,
                                  passwordFocusNode: _passwordFocusNode,
                                  obscurePassword: _obscure,
                                  onToggleObscure: () =>
                                      setState(() => _obscure = !_obscure),
                                  selectedRole: _role,
                                  onRoleChanged: (r) {
                                    setState(() => _role = r);
                                    context.read<SignUpBloc>().add(
                                      SignUpRoleChanged(r),
                                    );
                                  },
                                  errorMessage: activeError,
                                  onDismissError: _dismissError,
                                  isLoading: state.isLoading,
                                  onSignup: _handleSignup,
                                ),
                              )
                              .animate()
                              .fadeIn(
                                duration: 450.ms,
                                delay: 100.ms,
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
