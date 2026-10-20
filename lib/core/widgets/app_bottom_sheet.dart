import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Superficie de hoja inferior ("Tarjeta de login" 8:11 / 93:74 y "Tarjeta
/// de registro" 11:211): blanca, esquinas superiores de 28 y sombra hacia
/// arriba (`shadowSheet`). Sirve como panel fijo al pie de la pantalla o
/// como contenido de [showAppBottomSheet].
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.color = AppColors.surface0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// El registro usa blanco al 84 % sobre la ilustración.
  final Color color;

  static const BorderRadius radius = BorderRadius.vertical(
    top: Radius.circular(AppSpacing.radiusButton),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        boxShadow: AppSpacing.shadowSheet,
      ),
      child: child,
    );
  }
}

/// Abre una hoja modal inferior con la superficie [AppBottomSheet].
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.xl),
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.barrier,
    elevation: 0,
    builder: (context) => SafeArea(
      top: false,
      child: AppBottomSheet(padding: padding, child: builder(context)),
    ),
  );
}
