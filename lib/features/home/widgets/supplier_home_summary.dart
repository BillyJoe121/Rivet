import 'package:flutter/material.dart';

import 'kit/kit.dart';
import 'supplier_home_cards.dart';
import 'supplier_home_mock.dart';

/// Contenido de "Inicio del proveedor" (frame 22:146094) dentro del lienzo de Figma.
class SupplierHomeSummary extends StatelessWidget {
  const SupplierHomeSummary({
    super.key,
    required this.onProfileTap,
    required this.onQuickAccessTap,
    required this.onManageTap,
  });

  final VoidCallback onProfileTap;
  final ValueChanged<int> onQuickAccessTap;
  final VoidCallback onManageTap;

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerBotanical,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBrandHeader(initials: SupplierHomeMock.initials, title: 'Inicio del proveedor'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                SupplierProfileCard(
                  name: SupplierHomeMock.profileName,
                  type: SupplierHomeMock.profileType,
                  location: SupplierHomeMock.profileLocation,
                  initial: 'R',
                  onTap: onProfileTap,
                ),
                Row(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < SupplierHomeMock.quickAccess.length; i++)
                      Expanded(
                        child: ProQuickAccess(
                          icon: SupplierHomeMock.quickAccess[i].icon,
                          label: SupplierHomeMock.quickAccess[i].label,
                          onTap: () => onQuickAccessTap(i),
                        ),
                      ),
                  ],
                ),
                const ProSectionHeader('Resumen del negocio', linkLabel: 'Últimos 30 días'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 7,
                  children: [
                    for (final item in SupplierHomeMock.summary)
                      Expanded(child: SupplierSummaryTile(value: item.value, label: item.label)),
                  ],
                ),
                const ProSectionHeader('Actividad reciente', linkLabel: 'Ver todas'),
                SupplierActivityCard(
                  rows: [
                    for (final item in SupplierHomeMock.activity)
                      SupplierListRow(
                        icon: item.icon,
                        title: item.title,
                        detail: item.detail,
                        trailingText: item.time,
                      ),
                  ],
                ),
                ProSectionHeader('Estado de productos', linkLabel: 'Ver todos', onLinkTap: onManageTap),
                SupplierStockCard(
                  rows: [
                    for (final item in SupplierHomeMock.stock)
                      SupplierListRow(
                        icon: item.icon,
                        title: item.title,
                        detail: item.detail,
                        trailingText: item.status,
                        trailingStyle: ProText.r(12, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 14.4),
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
