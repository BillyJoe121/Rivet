import 'package:flutter/material.dart';

import '../../core/utils/app_page_route.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'role_selection_screen.dart';
import 'widgets/welcome_start_button.dart';

/// Pantalla inicial (Figma 49:3): fondo de marca, logotipo "Rivet" centrado
/// y botón píldora "Iniciar" que lleva a la selección de rol.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RvColors.brand700,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Desplaza el grupo para que el logotipo quede en y=400.5 del frame de 868.
            const SizedBox(height: 79),
            Text(
              'Rivet',
              textAlign: TextAlign.center,
              style: rvText(
                56,
                weight: FontWeight.w700,
                lineHeight: 67.2,
                color: RvColors.paper100,
                family: RvFonts.serif,
              ),
            ),
            const SizedBox(height: 24),
            WelcomeStartButton(
              onPressed: () {
                debugPrint('[WelcomeScreen] Botón Iniciar presionado');
                Navigator.of(context).push(
                  RivetPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
