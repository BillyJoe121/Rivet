import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'materials_delivery_screen.dart';
import 'orders_mock.dart';
import 'prepare_dispatch_screen.dart';
import 'widgets/order_cards.dart';

/// Lista de pedidos del proveedor: pendientes de despacho y despachados.
/// [dispatched] muestra la variante con un pedido ya despachado (2027:210).
class SupplierOrdersScreen extends StatelessWidget {
  const SupplierOrdersScreen({super.key, this.dispatched = false});

  final bool dispatched;

  static final _sectionStyle = ProText.r(15, weight: FontWeight.w600, lineHeight: 17.578125);

  void _open(BuildContext context, SupplierOrder order) {
    final route = order.tone == OrderTone.ready
        ? const MaterialsDeliveryScreen()
        : PrepareDispatchScreen(order: order);
    Navigator.push(context, MaterialPageRoute(builder: (_) => route));
  }

  Widget _card(BuildContext context, SupplierOrder order) {
    void onAction() => _open(context, order);
    return order.image != null
        ? OrderMaterialCard(order: order, onAction: onAction)
        : OrderCompactCard(order: order, onAction: onAction);
  }

  @override
  Widget build(BuildContext context) {
    final pending = SupplierOrdersMock.pending(dispatched: dispatched);
    final done = SupplierOrdersMock.dispatchedOrders(dispatched: dispatched);

    return ProScreen(
      backgroundAsset: ProAssets.headerPaintCorner,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Pedidos',
            inline: true,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ProLayout.sectionGap,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    ProSectionHeader(
                      'Pendientes de despachar',
                      count: pending.length,
                      titleStyle: _sectionStyle,
                    ),
                    for (final order in pending) _card(context, order),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    ProSectionHeader('Despachados', count: done.length, titleStyle: _sectionStyle),
                    if (done.isEmpty) const OrderEmptyDispatched(),
                    for (final order in done) _card(context, order),
                    if (done.isNotEmpty)
                      ProNote(
                        text: '«Despachado» significa listo para retiro, no entregado. '
                            'La entrega se registra al recoger los materiales.',
                        iconSize: 20,
                        textStyle: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2),
                        radius: ProRadii.md,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
