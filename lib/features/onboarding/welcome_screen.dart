import 'package:flutter/material.dart';

import '../../core/utils/app_page_route.dart';
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
            Material(
              color: RvColors.paper100,
              borderRadius: BorderRadius.circular(999),
              elevation: 4,
              shadowColor: const Color(0x26000000),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                splashColor: RvColors.brand700.withValues(alpha: 0.15),
                highlightColor: RvColors.brand700.withValues(alpha: 0.08),
                onTap: () {
                  debugPrint('[WelcomeScreen] Botón Iniciar presionado');
                  Navigator.of(context).push(
                    RivetPageRoute(
                      builder: (_) => const RoleSelectionScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    'Iniciar',
                    style: rvText(
                      17,
                      weight: FontWeight.w700,
                      lineHeight: 20,
                      color: RvColors.brand700,
                    ),
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
