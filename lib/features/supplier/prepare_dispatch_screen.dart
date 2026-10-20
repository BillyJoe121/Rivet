import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'orders_mock.dart';
import 'widgets/order_cards.dart';
import 'widgets/order_inline_header.dart';
import 'widgets/order_pill.dart';

/// Preparar y despachar un pedido de materiales (66:14749).
class PrepareDispatchScreen extends StatelessWidget {
  const PrepareDispatchScreen({super.key, this.order = SupplierOrdersMock.juanPreparing});

  final SupplierOrder order;

  @override
  Widget build(BuildContext context) {
    final caption = ProText.r(11, color: ProColors.ink500, lineHeight: 13.75);
    return ProScreen(
      backgroundAsset: ProAssets.headerPaintCorner,
      navWhenPushed: ProNavDestination.projects,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrderInlineHeader('Preparar y despachar', width: 207),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                const Row(
                  spacing: 8,
                  children: [
                    OrderPill('✓ Pedido confirmado',
                        background: ProColors.successLight, foreground: ProColors.brand700),
                    OrderPill('En preparación',
                        background: ProColors.warningLight, foreground: ProColors.warning800),
                  ],
                ),
                Text('${order.client} · Total aprobado: \$ 348.000 COP', style: caption),
                ProCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: OrderMaterialSummary(order: order),
                ),
                ProCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          const ProIcon(LucideIcon.store, size: 20),
                          Expanded(
                            child: Text('Retiro en tienda · \$ 0 COP',
                                style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
                          ),
                        ],
                      ),
                      Text(
                        'FerreCasa · Medellín, Antioquia Lun–sáb 8:00–18:00 · '
                        'Sin dirección privada del cliente.',
                        style: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                      ),
                    ],
                  ),
                ),
                ProCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      Text('Estado de preparación',
                          style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
                      Text('◉ En preparación    ○ Despachado', style: ProText.r(13, lineHeight: 16.25)),
                      const _DispatchField(label: 'Fecha prevista para retiro *', value: '16 de mayo de 2024'),
                      const _DispatchField(label: 'Referencia de preparación *', value: 'FC-1605 · 4 galones'),
                      Text('☐ Materiales revisados y listos para retiro', style: ProText.r(12, lineHeight: 15)),
                    ],
                  ),
                ),
                ProNote(
                  text: 'Para retiro, confirmar despacho significa «Listo para retiro», no entregado. '
                      'Aún no se ha confirmado; no requiere transportador.',
                  iconSize: 20,
                  textStyle: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                  radius: ProRadii.md,
                ),
                Text(
                  'El cliente recibirá el aviso de retiro cuando confirmes. '
                  'La entrega se registra al recoger los materiales.',
                  style: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: ProPrimaryButton(
              'Confirmar despacho',
              height: 48,
              horizontalPadding: 16,
              gap: 6,
              labelStyle: ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8),
              onTap: () => Navigator.maybePop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo de solo lectura de 49 px con etiqueta gris y valor.
class _DispatchField extends StatelessWidget {
  const _DispatchField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        border: Border.all(color: ProColors.line300, width: 0.8),
        borderRadius: BorderRadius.circular(ProRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
          Text(value, style: ProText.r(13, color: ProColors.ink900, lineHeight: 16.25)),
        ],
      ),
    );
  }
}
