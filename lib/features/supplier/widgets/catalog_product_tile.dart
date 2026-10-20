import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import 'catalog_common.dart';

/// Tarjeta de producto de 124 px para la cuadrícula de "Productos".
class CatalogProductTile extends StatelessWidget {
  const CatalogProductTile({
    super.key,
    required this.name,
    required this.presentation,
    required this.price,
    required this.image,
    this.fit = BoxFit.cover,
  });

  final String name;
  final String presentation;
  final String price;
  final String image;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 124),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.card),
        border: Border.all(color: ProColors.line300, width: ProStroke.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CatalogImage(image: image, width: double.infinity, height: 48, fit: fit, radius: 9),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: ProText.r(13, weight: FontWeight.w500, lineHeight: 14),
            ),
          ),
          const SizedBox(height: 2),
          Text(presentation, style: ProText.r(10, color: ProColors.ink500, lineHeight: 12), maxLines: 1),
          const SizedBox(height: 2),
          Text(price, style: ProText.r(12, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 14)),
        ],
      ),
    );
  }
}
