import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import 'catalog_common.dart';

/// Tarjeta de material administrado de 91 px: fotografía, SKU, estado y precios.
class CatalogManagedRow extends StatelessWidget {
  const CatalogManagedRow({
    super.key,
    required this.name,
    required this.sku,
    required this.detail,
    required this.status,
    required this.cost,
    required this.price,
    required this.image,
    this.fit = BoxFit.cover,
  });

  final String name;
  final String sku;
  final String detail;
  final String status;
  final String cost;
  final String price;
  final String image;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final muted = ProText.r(11, color: ProColors.ink500, lineHeight: 13.2);
    final priceStyle = ProText.r(12, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 13.2);
    final labelStyle = ProText.r(10, color: ProColors.ink500, lineHeight: 13.2);
    return Container(
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.card),
        border: Border.all(color: ProColors.line300, width: ProStroke.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CatalogImage(image: image, width: 51, height: 48, fit: fit, radius: 10),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: ProText.r(12, weight: FontWeight.w600, lineHeight: 13.2)),
                Text('SKU: $sku', style: muted),
                Text(detail, style: muted),
                Text(status, style: ProText.r(11, color: ProColors.successText, lineHeight: 13.2)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Costo contratista', style: labelStyle),
                          Text(cost, style: priceStyle),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precio al cliente', style: labelStyle),
                          Text(price, style: priceStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}

/// Resumen numérico de 59 px (cifra y etiqueta) para la administración del catálogo.
class CatalogCountTile extends StatelessWidget {
  const CatalogCountTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.md,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(value, style: ProText.r(18, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 21.6)),
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2)),
        ],
      ),
    );
  }
}
