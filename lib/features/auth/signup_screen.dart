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
import 'widgets/signup_form_card.dart';
import 'widgets/signup_parts.dart';

/// Registro de usuarios conectado a Supabase (Sprint 1).
///
/// Aplica validaciones estrictas (RFC 5322, contraseña segura, teléfono colombiano),
/// medidor interactivo de contraseña, focus traversal fluido, retroalimentación háptica y sacudida en error.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, this.initialRole = UserRole.client});

  final UserRole initialRole;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
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

  late UserRole _role = widget.initialRole == UserRole.supplier
      ? UserRole.client
      : widget.initialRole;

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

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    // Validación estricta paso a paso
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

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sanitizedPhone = Validators.sanitizePhone(phone);
      final user = await AuthService.instance.signUp(
        email: email,
        password: password,
        fullName: name,
        role: _role,
        phone: sanitizedPhone,
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
            height: 309,
            child: Image.asset(RvImages.headerRoller, fit: BoxFit.cover),
          ),
          // Fundido orgánico
          const Positioned(
            top: 230,
            left: 0,
            right: 0,
            height: 42,
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
          // Viewport adaptable seguro contra el teclado
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignupHeader()
                      .animate()
                      .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                      .slideY(begin: -0.15, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 18),
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final offset = math.sin(_shakeController.value * math.pi * 4) * 8.0;
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
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      selectedRole: _role,
                      onRoleChanged: (r) => setState(() => _role = r),
                      errorMessage: _errorMessage,
                      onDismissError: () => setState(() => _errorMessage = null),
                      isLoading: _isLoading,
                      onSignup: _handleSignup,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 450.ms, delay: 100.ms, curve: Curves.easeOutCubic)
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
