import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_modal.dart';

/// Fondo de la opción elegida en el modal de precio (#EAF7EF). No existe como
/// token: es un verde más claro que `successLight`.
const Color _selectedFill = Color(0xFFEAF7EF);

/// Opción de precio que se muestra como fila etiqueta / valor.
class AppPriceOption {
  const AppPriceOption({required this.label, required this.value});

  final String label;

  /// Valor ya formateado, p. ej. `$ 103.500`.
  final String value;
}

/// Modal "Selecciona el precio a ofrecer" (nodo 2004:37): resumen del
/// producto, título, mensaje y una lista de precios donde uno queda elegido.
class AppPriceSelectDialog extends StatefulWidget {
  const AppPriceSelectDialog({
    super.key,
    required this.productTitle,
    required this.options,
    this.productSubtitle,
    this.productImage,
    this.title = 'Selecciona el precio a ofrecer',
    this.message,
    this.initialIndex = 0,
    this.confirmLabel = 'Guardar',
    this.cancelLabel = 'Cancelar',
  });

  final String productTitle;
  final String? productSubtitle;
  final ImageProvider? productImage;
  final String title;
  final String? message;
  final List<AppPriceOption> options;
  final int initialIndex;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<AppPriceSelectDialog> createState() => _AppPriceSelectDialogState();
}

class _AppPriceSelectDialogState extends State<AppPriceSelectDialog> {
  late int _selected = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return AppModal(
      children: [
        _ProductSummary(
          title: widget.productTitle,
          subtitle: widget.productSubtitle,
          image: widget.productImage,
        ),
        AppModalTitle(widget.title),
        if (widget.message != null)
          AppModalMessage(widget.message!, fontSize: 12, lineHeight: 16.2),
        Column(
          children: [
            for (var i = 0; i < widget.options.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              AppPriceOptionRow(
                option: widget.options[i],
                selected: i == _selected,
                onTap: () => setState(() => _selected = i),
              ),
            ],
          ],
        ),
        AppModalActions(
          confirmLabel: widget.confirmLabel,
          cancelLabel: widget.cancelLabel,
          onConfirm: () => Navigator.of(context).pop(_selected),
          onCancel: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// Fila de precio de 44 px. Elegida: fondo verde claro, borde 1.5 y texto
/// de éxito, con el valor centrado y una marca vertical a la derecha.
class AppPriceOptionRow extends StatelessWidget {
  const AppPriceOptionRow({
    super.key,
    required this.option,
    this.selected = false,
    this.onTap,
  });

  final AppPriceOption option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.successText : AppColors.ink900;
    final labelStyle = AppTypography.labelStrong.copyWith(
      color: color,
      height: 14.4 / 12,
    );
    final valueStyle = AppTypography.bodyStrong.copyWith(color: color);
    return Semantics(
      selected: selected,
      button: onTap != null,
      child: Material(
        color: selected ? _selectedFill : AppColors.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedMd,
          side: BorderSide(
            color: selected ? AppColors.successText : AppColors.line300,
            width: selected ? 1.5 : 0.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedMd,
          child: SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(option.label, style: labelStyle),
                  Text(option.value, style: valueStyle),
                  if (selected)
                    Opacity(
                      opacity: 0.85,
                      child: Container(
                        width: 2,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.successText,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductSummary extends StatelessWidget {
  const _ProductSummary({required this.title, this.subtitle, this.image});

  final String title;
  final String? subtitle;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        borderRadius: AppSpacing.roundedCard,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: AppSpacing.roundedCard,
        border: Border.all(
          color: AppColors.line300,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.roundedSm,
            child: SizedBox.square(
              dimension: 56,
              child: image == null
                  ? const ColoredBox(color: AppColors.brandLight)
                  : Image(image: image!, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyStrong.copyWith(
                    color: AppColors.ink900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Muestra [AppPriceSelectDialog] y devuelve el índice de la opción elegida
/// al guardar, o `null` si se cancela.
Future<int?> showAppPriceSelectDialog(
  BuildContext context, {
  required String productTitle,
  required List<AppPriceOption> options,
  String? productSubtitle,
  ImageProvider? productImage,
  String title = 'Selecciona el precio a ofrecer',
  String? message,
  int initialIndex = 0,
  String confirmLabel = 'Guardar',
  String cancelLabel = 'Cancelar',
}) {
  return showAppModal<int>(
    context,
    builder: (_) => AppPriceSelectDialog(
      productTitle: productTitle,
      productSubtitle: productSubtitle,
      productImage: productImage,
      title: title,
      message: message,
      options: options,
      initialIndex: initialIndex,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}
