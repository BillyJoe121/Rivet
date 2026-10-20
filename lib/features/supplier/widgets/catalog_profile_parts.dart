import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import 'catalog_common.dart';

/// Tarjeta con fotografía circular de 60 px y datos profesionales del proveedor.
class CatalogProfileHeader extends StatelessWidget {
  const CatalogProfileHeader({
    super.key,
    required this.image,
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
  });

  final String image;
  final String name;
  final String type;
  final String location;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final style = ProText.r(11, color: ProColors.ink500, lineHeight: 13.2);
    return ProCard(
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(10),
      child: Row(
        spacing: 10,
        children: [
          CatalogImage(image: image, width: 60, height: 60, radius: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: ProText.serif(16, color: ProColors.ink700, lineHeight: 19.2)),
                Text(type, style: ProText.r(12, color: ProColors.ink500, lineHeight: 15.6)),
                Text('♧ $location', style: style),
                Text(rating, style: style),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Acceso informativo de 90 px con ícono de 27 px y texto centrado.
class CatalogInfoTile extends StatelessWidget {
  const CatalogInfoTile({super.key, required this.icon, required this.label});

  final LucideIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.card),
        border: Border.all(color: ProColors.line300, width: ProStroke.hairline),
      ),
      // El texto de Horarios supera la altura de Figma: se muestra desde arriba sin recortar el contorno.
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 9,
          children: [
            ProIcon(icon, size: 27),
            Text(
              label,
              textAlign: TextAlign.center,
              style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Producto destacado: fotografía de 117×80 y nombre con precio en 11 px.
class CatalogHighlightTile extends StatelessWidget {
  const CatalogHighlightTile({
    super.key,
    required this.image,
    required this.fit,
    required this.name,
    required this.price,
  });

  final String image;
  final BoxFit fit;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 5,
      children: [
        CatalogImage(image: image, width: double.infinity, height: 80, fit: fit, radius: 10),
        Text(
          '$name\n$price',
          style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2),
        ),
      ],
    );
  }
}
