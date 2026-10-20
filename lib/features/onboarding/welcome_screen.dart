import 'package:flutter/material.dart';

import '../projects/widgets/client_kit/client_kit.dart';
import 'role_selection_screen.dart';

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
            Semantics(
              button: true,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                ),
                child: Container(
                  width: 112,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: RvColors.paper100,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(color: Color(0x26000000), offset: Offset(0, 10), blurRadius: 24, spreadRadius: -8),
                    ],
                  ),
                  // Figma usa Inter 600 16/19.36; Inter no está empaquetada.
                  child: Text(
                    'Iniciar',
                    style: rvText(16, weight: FontWeight.w600, lineHeight: 19.36, color: RvColors.brand700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
