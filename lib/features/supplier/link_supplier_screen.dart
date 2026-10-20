import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'linking_mock.dart';
import 'widgets/linking_status_card.dart';
import 'widgets/order_pill.dart';

/// Búsqueda y solicitud de vinculación con un proveedor (66:14148).
class LinkSupplierScreen extends StatelessWidget {
  const LinkSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerShop,
      navWhenPushed: ProNavDestination.more,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Vincular proveedor',
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            height: 86,
            titleWidth: 364,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                Container(
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
                      Text('Buscar proveedores', style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
                      Text('Nombre, ciudad o especialidad', style: ProText.r(13, lineHeight: 16.25)),
                    ],
                  ),
                ),
                ProCard(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          ProImage(ProAssets.ferreCasaStore, width: 52, height: 52, radius: ProRadii.sm),
                          Expanded(
                            child: Text('FerreCasa',
                                style: ProText.serif(18, color: ProColors.ink700, lineHeight: 21.6)),
                          ),
                          const OrderPill('Sin vínculo',
                              background: ProColors.brandLight, foreground: ProColors.brand700),
                        ],
                      ),
                      Text(
                        'Ferretería y acabados · Medellín, Antioquia 4.8 (126 reseñas) · '
                        'Medellín y área metropolitana',
                        style: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                      ),
                      Text('Lun–sáb 8–18 h · Domicilio / retiro en tienda',
                          style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            flex: 169,
                            child: ProOutlineButton(
                              'Consultar perfil',
                              height: 34,
                              trailing: const ProChevron(),
                            ),
                          ),
                          Expanded(
                            flex: 167,
                            child: ProPrimaryButton('Solicitar acceso', height: 34, horizontalPadding: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text('Estado de tus solicitudes', style: ProText.r(13, weight: FontWeight.w600, lineHeight: 16.25)),
                for (final status in LinkingMock.statuses) LinkingStatusCard(status: status),
                ProNote(
                  text: 'Una solicitud no crea un vínculo. '
                      'Solo la aprobación del proveedor habilita sus precios exclusivos.',
                  iconSize: 20,
                  textStyle: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                  radius: ProRadii.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
