import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/utils/validators.dart';
import '../home/app_shell.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'auth_service.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/login_parts.dart';

/// Inicio de sesión conectado a Supabase Auth (Sprint 1).
///
/// Protegido contra desbordamientos de teclado mediante viewport adaptable,
/// validación de credenciales estricta y transiciones fluidas.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.role = UserRole.client});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _keepSession = true;
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
    setState(() => _errorMessage = message);
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
                  const RvBackButton(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Text(
                      'Rivet',
                      style: rvText(
                        38,
                        weight: FontWeight.w700,
                        lineHeight: 48.64,
                        color: RvColors.brand700,
                        family: RvFonts.serif,
                      ),
                    ),
                  ),
                  const SizedBox(height: 130),
                  _card(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
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
          LoginTabs(
            onCreateAccount: () => AppNavigator.push(
              context,
              SignupScreen(initialRole: widget.role),
            ),
          ),
          Container(height: 1, color: AuthColors.fieldStroke),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF8B4B4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFF9B1C1C), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: rvText(13, color: const Color(0xFF9B1C1C), lineHeight: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                LoginField(
                  icon: RvIcons.mail,
                  label: 'Correo electrónico',
                  input: AuthInput(
                    controller: _emailController,
                    hint: 'tu@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 12),
                LoginField(
                  icon: RvIcons.lock,
                  label: 'Contraseña',
                  input: AuthInput(
                    controller: _passwordController,
                    hint: '••••••••',
                    obscure: _obscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(),
                  ),
                  trailing: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: RvIcon(
                        _obscure ? RvIcons.eye : RvIcons.mostrarContrasena,
                        color: AuthColors.placeholder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _sessionRow(),
                const SizedBox(height: 16),
                AuthGradientButton(
                  label: 'Iniciar sesión',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 16),
                const OrContinueWith(),
                const SizedBox(height: 12),
                SocialButtonsRow(
                  onSelected: () => AppNavigator.pushAndRemoveUntil(
                    context,
                    AppShell(initialRole: widget.role),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionRow() {
    final style = rvText(13, lineHeight: 15.23, color: AuthColors.mutedInk);
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _keepSession = !_keepSession),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _keepSession ? RvColors.brand700 : RvColors.surface0,
                    border: Border.all(color: RvColors.brand700),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _keepSession
                      ? const RvIcon(RvIcons.check, color: RvColors.surface0)
                      : null,
                ),
                const SizedBox(width: 8),
                Text('Mantener sesión iniciada', style: style),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => AppNavigator.push(
              context,
              const ForgotPasswordScreen(),
            ),
            child: Text('¿Olvidaste tu contraseña?', style: style),
          ),
        ],
      ),
    );
  }
}
