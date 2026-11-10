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
            final curved = animation.drive(
              CurveTween(curve: Curves.easeOutCubic),
            );
            final slideAnimation = curved.drive(
              Tween<Offset>(begin: slideOffset, end: Offset.zero),
            );

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: curved,
                child: RepaintBoundary(child: child),
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

  /// Reemplaza toda la app por [screen] (inicio y cierre de sesión): usa el
  /// navegador raíz para salir también de la pila de la pestaña actual.
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget screen) {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil<T>(
      RivetPageRoute<T>(builder: (_) => screen),
      (_) => false,
    );
  }

  /// Abre [screen] sobre toda la app, cubriendo la barra de navegación.
  static Future<T?> pushRoot<T>(BuildContext context, Widget screen) {
    return Navigator.of(context, rootNavigator: true).push<T>(
      RivetPageRoute<T>(builder: (_) => screen),
    );
  }
}
