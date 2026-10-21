import 'package:flutter/material.dart';

import '../../core/utils/app_page_route.dart';
import '../auth/login_screen.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'widgets/welcome_start_button.dart';

/// Pantalla inicial editorial (Figma 49:3):
/// Fondo de marca, tipografía serif Lora con animación de entrada y CTA interactivo.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RvColors.brand700,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 8),
                Text(
                  'Obras y acabados con respaldo oficial',
                  textAlign: TextAlign.center,
                  style: rvText(
                    14,
                    weight: FontWeight.w400,
                    lineHeight: 18,
                    color: const Color(0xFFDCE8E4),
                  ),
                ),
                const SizedBox(height: 32),
                WelcomeStartButton(
                  onPressed: () {
                    debugPrint('[WelcomeScreen] Iniciar presionado -> LoginScreen');
                    Navigator.of(context).push(
                      RivetPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
