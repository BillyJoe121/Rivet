import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/app_shell.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/login_parts.dart';

/// Inicio de sesión (Figma 93:56, idéntico a 5:2): foto de 412×340 con
/// fundido, logotipo y tarjeta blanca con pestañas, campos, recordar sesión,
/// botón principal y accesos sociales.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.role = UserRole.client});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _keepSession = true;
  bool _obscure = true;

  void _enter() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AppShell(initialRole: widget.role)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: RvColors.paper100,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: Image.asset(RvImages.loginScandinavian, fit: BoxFit.cover),
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: top),
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
              const SizedBox(height: 190),
              Expanded(child: _card()),
            ],
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginTabs(
              onCreateAccount: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SignupScreen(initialRole: widget.role),
                ),
              ),
            ),
            Container(height: 1, color: AuthColors.fieldStroke),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginField(
                    icon: RvIcons.mail,
                    label: 'Correo electrónico',
                    input: AuthInput(
                      hint: 'tu@correo.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LoginField(
                    icon: RvIcons.lock,
                    label: 'Contraseña',
                    input: AuthInput(hint: '••••••••', obscure: _obscure),
                    trailing: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: const RvIcon(
                        RvIcons.eye,
                        color: AuthColors.placeholder,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sessionRow(),
                  const SizedBox(height: 12),
                  AuthGradientButton(
                    label: 'Iniciar sesión',
                    onPressed: _enter,
                  ),
                  const SizedBox(height: 12),
                  const OrContinueWith(),
                  const SizedBox(height: 12),
                  SocialButtonsRow(onSelected: _enter),
                ],
              ),
            ),
          ],
        ),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            ),
            child: Text('¿Olvidaste tu contraseña?', style: style),
          ),
        ],
      ),
    );
  }
}
