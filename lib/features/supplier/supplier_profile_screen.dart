import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'catalog_mock.dart';
import 'supplier_products_screen.dart';
import 'widgets/catalog_detail_parts.dart';
import 'widgets/catalog_profile_parts.dart';

/// Perfil de proveedor (frame 22:144701): datos, contacto, accesos y productos destacados.
class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});

  void _openProducts(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierProductsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerShop,
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Perfil de proveedor',
            lucideChevron: true,
            height: 128,
            padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
            gap: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                CatalogProfileHeader(
                  image: CatalogMock.supplierImage,
                  name: CatalogMock.supplierName,
                  type: CatalogMock.supplierType,
                  location: CatalogMock.supplierLocation,
                  rating: '${CatalogMock.supplierRating}     ◇ Más de 4 años',
                ),
                const ProNote(text: 'Proveedor verificado. Información comercial validada por Rivet.'),
                const ProSectionHeader('Información de contacto'),
                ProCard(
                  radius: ProRadii.lg,
                  borderWidth: ProStroke.card,
                  padding: const EdgeInsets.all(4),
                  child: const Column(
                    children: [
                      CatalogSpecRow(icon: LucideIcon.phone, label: '+57 300 123 4567'),
                      CatalogSpecRow(icon: LucideIcon.mail, label: 'ventas@ferrecasa.com'),
                      CatalogSpecRow(icon: LucideIcon.mapPin, label: CatalogMock.supplierLocation),
                    ],
                  ),
                ),
                const Row(
                  spacing: 8,
                  children: [
                    Expanded(child: CatalogInfoTile(icon: LucideIcon.truck, label: 'Cobertura\nMedellín y área metropolitana')),
                    Expanded(child: CatalogInfoTile(icon: LucideIcon.clock, label: 'Horarios\nLun – Sáb\n8:00 a.m. – 6:00 p.m.')),
                    Expanded(child: CatalogInfoTile(icon: LucideIcon.package, label: 'Entrega\nA domicilio y retiro en tienda')),
                  ],
                ),
                ProSectionHeader(
                  'Productos destacados',
                  linkLabel: 'Ver todos',
                  onLinkTap: () => _openProducts(context),
                ),
                Row(
                  spacing: 8,
                  children: [
                    for (final item in CatalogMock.highlights)
                      Expanded(
                        child: CatalogHighlightTile(
                          image: item.image,
                          fit: item.fit,
                          name: item.name,
                          price: item.price,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 7),
                CatalogActionButton(
                  label: 'Ver catálogo completo',
                  onTap: () => _openProducts(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
