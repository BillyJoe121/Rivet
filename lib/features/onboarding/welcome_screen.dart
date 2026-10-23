import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_page_route.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'widgets/welcome_icon_morph.dart';
import 'widgets/welcome_start_button.dart';

/// Pantalla inicial editorial: fotografía a sangre completa con velo de marca,
/// wordmark Lora con icono animado y acciones de entrada.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  /// Entrada escalonada del contenido.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  /// Acercamiento lento de la fotografía de fondo.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
      _drift.stop();
    } else if (_intro.isDismissed) {
      _intro.forward();
      _drift.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _drift.dispose();
    super.dispose();
  }

  Widget _reveal(double start, double end, Widget child) {
    final curve = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: RvColors.brandGradientEnd,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _drift,
              builder: (context, child) => Transform.scale(
                scale: 1 + 0.08 * Curves.easeOut.transform(_drift.value),
                alignment: const Alignment(0.3, -0.4),
                child: child,
              ),
              child: Image.asset(
                RvImages.sofaGreenWall,
                fit: BoxFit.cover,
                alignment: const Alignment(0.15, -0.3),
              ),
            ),
            // Velo de marca: protege la barra de estado arriba y el
            // contenido abajo sin ocultar la fotografía.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x47000000),
                    Color(0x00000000),
                    Color(0x00004E49),
                    Color(0xD9004E49),
                    RvColors.brandGradientEnd,
                  ],
                  stops: [0, 0.18, 0.34, 0.6, 1],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _reveal(
                      0,
                      0.45,
                      Row(
                        children: [
                          const WelcomeIconMorph(),
                          const SizedBox(width: 14),
                          Text(
                            'Rivet',
                            style: rvText(
                              64,
                              weight: FontWeight.w700,
                              lineHeight: 72,
                              color: RvColors.paper100,
                              family: RvFonts.serif,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _reveal(
                      0.45,
                      0.9,
                      WelcomeStartButton(
                        label: 'Crear cuenta',
                        onPressed: () =>
                            AppNavigator.push(context, const SignupScreen()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _reveal(
                      0.55,
                      1,
                      _SignInLink(
                        onTap: () =>
                            AppNavigator.push(context, const LoginScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Acción secundaria para quien ya tiene cuenta: texto claro sobre el velo.
class _SignInLink extends StatelessWidget {
  const _SignInLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ya tengo cuenta',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(32),
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: Center(
              child: Text(
                'Ya tengo cuenta',
                style: rvText(
                  16,
                  weight: FontWeight.w600,
                  lineHeight: 20,
                  color: RvColors.paper100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
