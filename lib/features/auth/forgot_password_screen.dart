import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/app_back_button.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'auth_service.dart';
import 'presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'widgets/forgot_password_cards.dart';

/// Pantalla de recuperación de acceso (P-003) gestionada por [ForgotPasswordBloc].
///
/// Envía instrucciones por correo mediante el caso de uso sin revelar si el usuario
/// existe (principio OWASP de privacidad y prevención de enumeración).
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
    this.forgotPasswordBloc,
  });

  final ForgotPasswordBloc? forgotPasswordBloc;

  @override
  Widget build(BuildContext context) {
    if (forgotPasswordBloc != null) {
      return BlocProvider<ForgotPasswordBloc>.value(
        value: forgotPasswordBloc!,
        child: const _ForgotPasswordView(),
      );
    }

    try {
      context.read<ForgotPasswordBloc>();
      return const _ForgotPasswordView();
    } catch (_) {
      return BlocProvider<ForgotPasswordBloc>(
        create: (_) => ForgotPasswordBloc(
          AuthService.instance.sendPasswordResetUseCase,
        ),
        child: const _ForgotPasswordView(),
      );
    }
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(RvImages.mailEnvelope), context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final email = _emailController.text.trim();
    final emailError = Validators.email(email);

    if (emailError != null) {
      _showError(emailError);
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(email));
  }

  void _editEmail() {
    context.read<ForgotPasswordBloc>().add(const ForgotPasswordEditRequested());
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'OK',
            textColor: const Color(0xFFEAF5F0),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.isFailure && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isSubmitted = state.isSuccess;
        final sentTo = state.sentToEmail ?? _emailController.text.trim();

        return Scaffold(
          backgroundColor: RvColors.surface0,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 380,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOutCubic,
                  child: Image.asset(
                    isSubmitted
                        ? RvImages.mailEnvelope
                        : RvImages.headerPrivacy,
                    key: ValueKey(isSubmitted),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 380,
                    alignment: isSubmitted
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
                          padding: EdgeInsets.fromLTRB(22, 8, 30, 0),
                          child: AppBackButton(),
                        ),
                      ),
                      const SizedBox(height: 192),
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          final offset = math.sin(
                                _shakeController.value * math.pi * 4,
                              ) *
                              8.0;
                          return Transform.translate(
                            offset: Offset(offset, 0),
                            child: child,
                          );
                        },
                        child: ForgotPasswordSheet(
                          sent: isSubmitted,
                          child: isSubmitted
                              ? ForgotPasswordSent(
                                  key: const ValueKey('forgot_sent'),
                                  email: sentTo,
                                  onEditEmail: _editEmail,
                                  onResend: _handleSubmit,
                                  onBackToLogin: () => Navigator.pop(context),
                                )
                              : ForgotPasswordForm(
                                  key: const ValueKey('forgot_form'),
                                  emailController: _emailController,
                                  emailFocusNode: _emailFocusNode,
                                  isLoading: state.isLoading,
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
      },
    );
  }
}
