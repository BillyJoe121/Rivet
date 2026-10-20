import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'widgets/order_pill.dart';

/// Elección de proveedor para cotizar un proyecto (66:14210).
class ChooseSupplierScreen extends StatelessWidget {
  const ChooseSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final caption = ProText.r(11, color: ProColors.ink500, lineHeight: 13.75);
    final body = ProText.r(12, lineHeight: 15);

    return ProScreen(
      backgroundAsset: ProAssets.headerRoller,
      navWhenPushed: ProNavDestination.proposals,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Elegir proveedor para cotizar',
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            height: 120,
            titleWidth: 364,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                Text('Proyecto · Pintura y estuco interior · 62 m²',
                    style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15)),
                Text('Favoritos', style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
                ProCard(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  color: ProColors.brandLight,
                  borderColor: ProColors.brand700,
                  borderWidth: ProStroke.divider,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          ProImage(ProAssets.ferreCasaStore, width: 40, height: 40, radius: ProRadii.sm),
                          Expanded(
                            child: Text('FerreCasa',
                                style: ProText.serif(18, color: ProColors.ink700, lineHeight: 21.6)),
                          ),
                          const OrderPill('✓ Aprobado',
                              background: ProColors.successLight, foreground: ProColors.brand700),
                        ],
                      ),
                      Text('Medellín · Retiro gratis · Domicilio por confirmar', style: caption),
                      Row(
                        spacing: 8,
                        children: [
                          ProImage(ProAssets.rivetPaint, width: 62, height: 58, fit: BoxFit.contain),
                          Expanded(
                            child: Text(
                              'Pintura vinilo premium · 1 galón\n✓ Seleccionada · Cantidad: 10 galones',
                              style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text('Precio contratista aprobado\n\$ 82.000 COP / galón', style: body),
                          ),
                          Expanded(
                            child: Text('Precio cliente\n\$ 87.000 COP / galón', style: body),
                          ),
                        ],
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: OrderPill('Disponible · Más de 50 unidades',
                            background: ProColors.successLight, foreground: ProColors.brand700),
                      ),
                    ],
                  ),
                ),
                Text('Otros proveedores', style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
                ProCard(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text('Acabados del Norte',
                                style: ProText.serif(18, color: ProColors.ink700, lineHeight: 21.6)),
                          ),
                          const OrderPill('Sin vínculo',
                              background: ProColors.brandLight, foreground: ProColors.brand700),
                        ],
                      ),
                      Text(
                        'Bello · Pintura equivalente · 30 gal disponibles\n'
                        'Retiro gratis · Domicilio en 2–3 días, costo por confirmar',
                        style: caption,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text('Precio cliente\n\$ 92.000 COP / galón', style: body),
                          ),
                          Expanded(
                            child: Text(
                              '🔒 Precio contratista\nAcceso bloqueado',
                              style: ProText.r(12, weight: FontWeight.w600, lineHeight: 15),
                            ),
                          ),
                        ],
                      ),
                      ProOutlineButton('Solicitar acceso', height: 34, trailing: const ProChevron()),
                    ],
                  ),
                ),
                ProNote(
                  text: 'Los precios exclusivos solo se muestran con vínculo aprobado. '
                      'Continúas con 10 galones de FerreCasa; no se genera una compra.',
                  iconSize: 20,
                  textStyle: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                  radius: ProRadii.md,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: ProPrimaryButton(
              'Continuar a crear propuesta',
              height: 48,
              horizontalPadding: 16,
              gap: 6,
              labelStyle: ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8),
            ),
          ),
        ],
      ),
    );
  }
}
