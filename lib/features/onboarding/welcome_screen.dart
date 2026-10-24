import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_page_route.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../projects/widgets/client_kit/client_kit.dart';
import 'widgets/welcome_icon_morph.dart';
import 'widgets/welcome_infinite_zoom.dart';
import 'widgets/welcome_start_button.dart';

/// Pantalla inicial editorial: fotografía a sangre completa con velo de marca,
/// wordmark Lora con icono animado y acciones de entrada.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  /// Entrada escalonada del contenido.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
    } else if (_intro.isDismissed) {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
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
            WelcomeInfiniteZoom(
              focus: const Alignment(0.3, -0.4),
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
            // Wordmark e icono centrados en la mitad de la pantalla.
            Center(
              child: _reveal(
                0,
                0.45,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(width: 14),
                    const WelcomeIconMorph(),
                  ],
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
                    const SizedBox(height: 40),
                    _reveal(
                      0.45,
                      0.9,
                      WelcomeStartButton(
                        label: 'Iniciar Sesión',
                        onPressed: () =>
                            AppNavigator.push(context, const LoginScreen()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _reveal(
                      0.55,
                      1,
                      _SignUpLink(
                        onTap: () =>
                            AppNavigator.push(context, const SignupScreen()),
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

/// Acción secundaria para quien aún no tiene cuenta: texto claro sobre el velo.
class _SignUpLink extends StatelessWidget {
  const _SignUpLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Aún no tengo una cuenta',
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
                'Aún no tengo una cuenta',
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
