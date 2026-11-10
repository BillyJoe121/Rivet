import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_button.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'presentation/bloc/reset_password/reset_password_bloc.dart';
import 'widgets/signup_form_card.dart';

/// Pantalla para definir una nueva contraseña tras abrir el enlace de recuperación.
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    this.resetPasswordBloc,
  });

  final ResetPasswordBloc? resetPasswordBloc;

  @override
  Widget build(BuildContext context) {
    if (resetPasswordBloc != null) {
      return BlocProvider<ResetPasswordBloc>.value(
        value: resetPasswordBloc!,
        child: const _ResetPasswordView(),
      );
    }

    try {
      context.read<ResetPasswordBloc>();
      return const _ResetPasswordView();
    } catch (_) {
      return BlocProvider<ResetPasswordBloc>(
        create: (_) => ResetPasswordBloc(
          AuthService.instance.updatePasswordUseCase,
        ),
        child: const _ResetPasswordView(),
      );
    }
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView();

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    final passwordError = Validators.password(password);
    if (passwordError != null) {
      _showError(passwordError);
      return;
    }

    final confirmError = Validators.confirmPassword(confirm, password);
    if (confirmError != null) {
      _showError(confirmError);
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<ResetPasswordBloc>().add(
          ResetPasswordSubmitted(
            password: password,
            confirmPassword: confirm,
          ),
        );
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();
    _shakeController.forward(from: 0.0);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.ink900,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: AppColors.surface0,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Contraseña actualizada con éxito. Inicia sesión con tu nueva clave.',
        ),
        backgroundColor: AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.isFailure && state.errorMessage != null) {
          _showError(state.errorMessage!);
        } else if (state.isSuccess) {
          _onSuccess();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface0,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 340,
                child: Image.asset(
                  RvImages.headerPrivacy,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 340,
                  alignment: Alignment.centerRight,
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
                      const SizedBox(height: 170),
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
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.surface0,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x14000000),
                                offset: Offset(0, -4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Nueva contraseña',
                                style: rvText(
                                  22,
                                  weight: FontWeight.w700,
                                  lineHeight: 28,
                                ).copyWith(
                                  fontFamily: 'Lora',
                                  color: AppColors.ink900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Escribe tu nueva clave segura para volver a entrar a tu cuenta.',
                                style: rvText(
                                  13,
                                  weight: FontWeight.w400,
                                  lineHeight: 18,
                                  color: AppColors.ink500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Campo Contraseña
                              _buildPasswordField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                label: 'Nueva contraseña',
                                obscure: _obscurePassword,
                                onToggleObscure: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                onSubmitted: (_) =>
                                    _confirmFocusNode.requestFocus(),
                              ),
                              const SizedBox(height: 10),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _passwordController,
                                builder: (context, val, _) {
                                  return PasswordStrengthMeter(
                                    password: val.text,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              // Campo Confirmar
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmFocusNode,
                                label: 'Confirma la contraseña',
                                obscure: _obscureConfirm,
                                onToggleObscure: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  });
                                },
                                onSubmitted: (_) => _handleSubmit(),
                              ),
                              const SizedBox(height: 28),
                              AppButton(
                                text: 'Guardar contraseña',
                                onPressed:
                                    state.isLoading ? null : _handleSubmit,
                                isLoading: state.isLoading,
                                showChevron: true,
                              ),
                            ],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
    required ValueChanged<String> onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.line300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            LucideIcons.lock,
            size: 20,
            color: AppColors.ink500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscure,
              cursorColor: AppColors.brand700,
              cursorWidth: 2,
              style: rvText(
                15,
                weight: FontWeight.w400,
                color: AppColors.ink900,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                labelText: label,
                labelStyle: rvText(
                  13,
                  weight: FontWeight.w500,
                  color: AppColors.ink500,
                ),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(
              obscure ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 20,
              color: AppColors.ink500,
            ),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            splashRadius: 24,
            tooltip: obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
            onPressed: onToggleObscure,
          ),
        ],
      ),
    );
  }
}
