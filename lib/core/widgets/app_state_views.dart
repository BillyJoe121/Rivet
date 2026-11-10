import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme.dart';
import 'app_empty_state.dart';

/// Indicador de carga centrado para el cuerpo de una pantalla.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key, this.label = 'Cargando'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x5l),
      child: Center(
        child: Semantics(
          label: label,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.brand700),
          ),
        ),
      ),
    );
  }
}

/// Estado de error con opción de reintentar.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.title = 'No pudimos cargar esta información',
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: LucideIcons.cloudOff,
      actionLabel: onRetry == null ? null : 'Reintentar',
      onAction: onRetry,
    );
  }
}
