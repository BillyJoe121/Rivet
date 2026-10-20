import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Ancho fijo de los modales del diseño (nodos 2004:37, 2004:167, 2006:5).
const double kAppModalWidth = 320;

/// Contenedor base de los modales: tarjeta blanca de 320 px, borde 0.8,
/// radio 16, padding 16, separación vertical 12 y sombra elevada.
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.children,
    this.width = kAppModalWidth,
    this.gap = AppSpacing.md,
  });

  final List<Widget> children;
  final double width;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) spaced.add(SizedBox(height: gap));
      spaced.add(children[i]);
    }
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface0,
          borderRadius: AppSpacing.roundedLg,
          boxShadow: AppSpacing.shadowElevated,
        ),
        // Trazo interior pintado encima para que no sume al alto.
        foregroundDecoration: BoxDecoration(
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(
            color: AppColors.line300,
            width: 0.8, // Borde propio de los modales en el diseño
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: spaced,
        ),
      ),
    );
  }
}

/// Título centrado de modal: Roboto 600 16/20 ink900.
class AppModalTitle extends StatelessWidget {
  const AppModalTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTypography.titleSmall.copyWith(fontSize: 16, height: 20 / 16),
    );
  }
}

/// Mensaje centrado de modal: Roboto 400 ink500. El tamaño cambia según el
/// modal (13/18.2 en confirmación, 12/16.2 en selección de precio).
class AppModalMessage extends StatelessWidget {
  const AppModalMessage(
    this.text, {
    super.key,
    this.fontSize = 13,
    this.lineHeight = 18.2,
  });

  final String text;
  final double fontSize;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTypography.bodyMedium.copyWith(
        fontSize: fontSize,
        height: lineHeight / fontSize,
      ),
    );
  }
}

/// Fila de acciones del pie del modal: botón secundario con borde y botón
/// primario con degradado, ambos de 40 px de alto y separados 8 px.
class AppModalActions extends StatelessWidget {
  const AppModalActions({
    super.key,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancelar',
    this.onCancel,
  });

  final String confirmLabel;
  final VoidCallback? onConfirm;
  final String cancelLabel;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppModalButton(
            label: cancelLabel,
            primary: false,
            onPressed: onCancel ?? () => Navigator.of(context).maybePop(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppModalButton(
            label: confirmLabel,
            primary: true,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}

/// Botón píldora de 40 px usado en los modales. El primario lleva el
/// degradado de marca; el secundario, fondo papel y borde de marca de 1 px.
class AppModalButton extends StatelessWidget {
  const AppModalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final textColor = primary ? AppColors.surface0 : AppColors.brand700;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: primary ? null : AppColors.paper100,
            gradient: primary ? AppColors.brandGradient : null,
            borderRadius: AppSpacing.roundedButton,
            border: primary
                ? null
                : Border.all(color: AppColors.brand700, width: 1),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: AppSpacing.roundedButton,
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyStrong.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Presenta [child] centrado sobre el velo de marca y devuelve el valor con
/// el que se cierre el modal.
Future<T?> showAppModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: AppColors.barrier,
    builder: (context) => Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: builder(context),
      ),
    ),
  );
}
