import 'package:flutter/material.dart';

import 'app_modal.dart';

/// Modal de confirmación (nodo 2006:5): título, mensaje y dos acciones.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Si se omiten, cierran la ruta devolviendo `true` / `false`.
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return AppModal(
      children: [
        AppModalTitle(title),
        AppModalMessage(message),
        AppModalActions(
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
          onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

/// Muestra [AppConfirmDialog]. Devuelve `true` al confirmar, `false` al
/// cancelar y `null` si se cierra tocando fuera.
Future<bool?> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  bool barrierDismissible = true,
}) {
  return showAppModal<bool>(
    context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AppConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}
