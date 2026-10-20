import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import '../orders_mock.dart';

/// Colores de la etiqueta de estado según el tono del pedido.
({Color background, Color foreground}) orderToneColors(OrderTone tone) => switch (tone) {
      OrderTone.preparing => (background: ProColors.warningLight, foreground: ProColors.warning800),
      OrderTone.pending => (background: ProColors.surface0, foreground: ProColors.warning800),
      OrderTone.ready => (background: ProColors.successLight, foreground: ProColors.brand700),
    };

/// Etiqueta de estado: pastilla o texto ámbar según el tono.
class OrderStatusLabel extends StatelessWidget {
  const OrderStatusLabel(this.label, this.tone, {super.key});

  final String label;
  final OrderTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = orderToneColors(tone);
    if (tone == OrderTone.pending) {
      return Text(label, style: ProText.r(10, color: colors.foreground, lineHeight: 11.71875));
    }
    return ProChip(
      label,
      background: colors.background,
      foreground: colors.foreground,
      textStyle: ProText.micro.copyWith(color: colors.foreground),
    );
  }
}

/// Tarjeta compacta de pedido: cliente, material, cantidad y entrega.
class OrderCompactCard extends StatelessWidget {
  const OrderCompactCard({super.key, required this.order, this.onAction});

  final SupplierOrder order;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final caption = ProText.r(11, color: ProColors.ink500, lineHeight: 13.2);
    return ProCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 5,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.client,
                    style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.0625)),
              ),
              OrderStatusLabel(order.statusLabel, order.tone),
            ],
          ),
          Text(order.material, style: ProText.r(13, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 16)),
          Text(order.summary ?? '', style: caption),
          Text(order.delivery ?? '', style: caption),
          ProPrimaryButton(order.action, onTap: onAction),
        ],
      ),
    );
  }
}

/// Tarjeta de pedido con fotografía del material, total y nota de retiro.
class OrderMaterialCard extends StatelessWidget {
  const OrderMaterialCard({super.key, required this.order, this.onAction});

  final SupplierOrder order;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 5,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.client,
                    style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.0625)),
              ),
              OrderStatusLabel(order.statusLabel, order.tone),
            ],
          ),
          OrderMaterialBlock(order: order),
          Text(order.total ?? '', style: ProText.r(11, weight: FontWeight.w600, lineHeight: 13.2)),
          Text(order.detail ?? '', style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
          ProPrimaryButton(order.action, onTap: onAction),
        ],
      ),
    );
  }
}

/// Fotografía de 66×60 con título Lora, datos y cantidad del material.
class OrderMaterialBlock extends StatelessWidget {
  const OrderMaterialBlock({super.key, required this.order});

  final SupplierOrder order;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        ProImage(order.image ?? '', width: 66, height: 60, radius: 10, fit: BoxFit.contain),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(order.material, style: ProText.serif(16, color: ProColors.ink700, lineHeight: 19.2)),
              Text(order.materialInfo ?? '', style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
              Text(
                '${order.quantity ?? ''}\n${order.unitPrice ?? ''}',
                style: ProText.r(11, weight: FontWeight.w600, lineHeight: 13.2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Aviso de pedidos despachados vacío.
class OrderEmptyDispatched extends StatelessWidget {
  const OrderEmptyDispatched({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ProColors.brandLight, borderRadius: BorderRadius.circular(ProRadii.md)),
      child: Row(
        spacing: 10,
        children: [
          const ProIcon(LucideIcon.truck, size: 28),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text('Aún no hay pedidos despachados',
                    style: ProText.r(13, weight: FontWeight.w600, lineHeight: 15.6)),
                Text(
                  'Cuando confirmes un despacho, aparecerá aquí para hacer seguimiento.',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fotografía de 76 px con título Lora 18 y datos del material (ficha de detalle).
class OrderMaterialSummary extends StatelessWidget {
  const OrderMaterialSummary({super.key, required this.order});

  final SupplierOrder order;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        ProImage(order.image ?? '', width: 76, height: 76, radius: 10, fit: BoxFit.contain),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(order.material, style: ProText.serif(18, color: ProColors.ink700, lineHeight: 21.6)),
              Text(order.materialInfo ?? '', style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
              Text(order.quantity ?? '', style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
              Text(order.unitPrice ?? '', style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
