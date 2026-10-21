import 'package:flutter/material.dart';

/// Ruta de transición suave con efecto combinado de Fade y Slide sutil (Curva easeOutCubic).
/// Proporciona una experiencia de navegación premium y fluida sin saltos bruscos.
class RivetPageRoute<T> extends PageRouteBuilder<T> {
  RivetPageRoute({
    required WidgetBuilder builder,
    super.settings,
    Duration duration = const Duration(milliseconds: 260),
    Duration reverseDuration = const Duration(milliseconds: 220),
    Offset slideOffset = const Offset(0.04, 0.0), // Slide sutil del 4%
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            final slideAnimation = Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ).animate(curved);

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curved);

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Helper para navegación fluida con [RivetPageRoute].
abstract final class AppNavigator {
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      RivetPageRoute<T>(builder: (_) => screen),
    );
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, TO>(
      context,
      RivetPageRoute<T>(builder: (_) => screen),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget screen) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      RivetPageRoute<T>(builder: (_) => screen),
      (_) => false,
    );
  }
}
