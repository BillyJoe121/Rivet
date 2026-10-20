import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/app_shell.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/signup_parts.dart';

/// Registro (Figma 11:196): cabecera con foto del rodillo, indicador de
/// tres pasos, tarjeta con cuatro campos, selector de tipo de cuenta y
/// botón "Continuar".
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, this.initialRole = UserRole.client});

  final UserRole initialRole;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late UserRole _role = widget.initialRole;
  bool _obscure = true;

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
            height: 309,
            child: Image.asset(RvImages.headerRoller, fit: BoxFit.cover),
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: top),
              const SignupHeader(),
              const SignupSteps(current: 0),
              // La cabecera de Figma mide 272 en total: la tarjeta empieza en y=272.
              const SizedBox(height: 59),
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
        color: Color(0xD6FFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignupField(
              icon: RvIcons.nombreCompleto,
              label: 'Nombre completo',
              input: AuthInput(hint: 'Juan Pérez'),
            ),
            const SizedBox(height: 8),
            const SignupField(
              icon: RvIcons.correoElectronico,
              label: 'Correo electrónico',
              input: AuthInput(
                hint: 'tu@correo.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 8),
            const SignupField(
              icon: RvIcons.phone,
              label: 'Número de contacto',
              input: AuthInput(
                hint: '+57 300 123 4567',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(height: 8),
            SignupField(
              icon: RvIcons.contrasena,
              label: 'Contraseña',
              input: AuthInput(hint: '••••••••••••', obscure: _obscure),
              trailing: GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: const RvIcon(
                  RvIcons.mostrarContrasena,
                  color: AuthColors.mutedInk,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AccountTypeSelector(
              selected: _role,
              onChanged: (r) => setState(() => _role = r),
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
              label: 'Continuar',
              height: 56,
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AppShell(initialRole: _role)),
                (_) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
