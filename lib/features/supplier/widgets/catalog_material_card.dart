import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import 'catalog_common.dart';

/// Tarjeta de bodega de 78 px: fotografía de 59×60, nombre, líneas y precio opcional.
class CatalogMaterialCard extends StatelessWidget {
  const CatalogMaterialCard({
    super.key,
    required this.title,
    required this.lines,
    this.image,
    this.fit = BoxFit.cover,
    this.price,
    this.onTap,
  });

  final String title;
  final List<String> lines;
  final String? image;
  final BoxFit fit;
  final String? price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      child: Row(
        children: [
          CatalogImage(image: image, width: 59, height: 60, fit: fit, radius: 10),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: ProText.r(14, weight: FontWeight.w600, lineHeight: 16.8)),
                for (final line in lines)
                  Text(line, style: ProText.r(12, color: ProColors.ink500, lineHeight: 14.4)),
                if (price != null)
                  Text(price!, style: ProText.r(13, weight: FontWeight.w600, color: ProColors.ink700, lineHeight: 15.6)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const ProIcon(LucideIcon.chevronRight, size: 15),
        ],
      ),
    );
  }
}
