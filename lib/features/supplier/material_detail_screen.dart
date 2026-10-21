import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'catalog_product_info.dart';
import 'widgets/catalog_common.dart';
import 'widgets/catalog_detail_parts.dart';

/// Ficha de detalle de material (frame 22:144770). [info] aporta los textos de Figma;
/// sin él se usan los datos del modelo.
class MaterialDetailScreen extends StatelessWidget {
  const MaterialDetailScreen({
    super.key,
    required this.material,
    this.isProRate = false,
    this.info,
  });

  final MaterialProduct material;
  final bool isProRate;
  final CatalogProductInfo? info;

  @override
  Widget build(BuildContext context) {
    final price = isProRate ? material.proPriceCop : material.clientPriceCop;
    final priceText = '\$ ${formatCop(price)}${info?.priceSuffix ?? ''}';
    final coverage = info?.coverageLabel ?? (material.coverageM2 > 0 ? '${material.coverageM2} m² por galón' : '—');

    return ProScreen(
      navWhenPushed: ProNavDestination.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 128,
            child: Stack(
              children: [
                const Positioned(left: 24, top: 8, child: ProBackButton(lucide: true)),
                Positioned(
                  left: 45,
                  top: 12,
                  width: 227,
                  child: Text('Detalle de material', style: ProText.pageTitle),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ProLayout.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                CatalogImage(image: info?.image, width: 368, height: 90, fit: BoxFit.contain, radius: 10),
                Text(material.name, style: ProText.serif(21, color: ProColors.ink700, lineHeight: 25.2)),
                Text('⌂ ${material.brand}', style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4)),
                Text(
                  info?.description ?? material.category,
                  style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
                ),
                CatalogPriceCard(
                  price: priceText,
                  unit: 'por ${material.unit.toLowerCase()}',
                  available: material.inStock,
                  stock: info?.stockLabel,
                ),
                CatalogSpecCard(
                  rows: [
                    CatalogSpecRow(icon: LucideIcon.badge, label: 'Marca', value: material.brand),
                    CatalogSpecRow(icon: LucideIcon.briefcase, label: 'Presentación', value: material.unit),
                    CatalogSpecRow(icon: LucideIcon.shieldCheck, label: 'Rendimiento', value: coverage),
                    CatalogSpecRow(
                      icon: LucideIcon.shield,
                      label: 'Uso recomendado',
                      subtitle: info?.usage ?? material.category,
                    ),
                  ],
                ),
                const CatalogPlainRow(icon: LucideIcon.truck, title: 'Entrega', subtitle: 'A domicilio o retiro en tienda'),
                CatalogPlainRow(
                  icon: LucideIcon.store,
                  title: 'Proveedor',
                  subtitle: 'Bodega Oficial Rivet · Despacho y garantía directa',
                ),
                const CatalogPlainRow(icon: LucideIcon.fileText, title: 'Especificaciones técnicas'),
                const SizedBox(height: 9),
                Row(
                  spacing: 8,
                  children: [
                    const Expanded(child: CatalogActionButton(label: 'Guardar', outlined: true)),
                    Expanded(
                      child: CatalogActionButton(
                        label: 'Agregar al presupuesto',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${material.name} agregado al presupuesto.'),
                            backgroundColor: ProColors.brand700,
                          ),
                        ),
                      ),
                    ),
                  ],
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
