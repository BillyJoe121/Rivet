import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Resumen de la persona: nombre en Lora y tres líneas de datos de Figma.
class ProfileSummaryText extends StatelessWidget {
  const ProfileSummaryText({
    super.key,
    required this.name,
    required this.trade,
    required this.zone,
    required this.rating,
  });

  final String name;
  final String trade;
  final String zone;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final small = ProText.r(11, color: ProColors.ink500, lineHeight: 14.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: ProText.serif(16, color: ProColors.ink900, lineHeight: 19.2)),
        Text(trade, style: ProText.r(12, color: ProColors.ink500, lineHeight: 15.6)),
        Text(zone, style: small),
        Text(rating, style: small),
      ],
    );
  }
}

/// Servicio con ícono de trazo, título y alcance centrados.
class ProfileServiceTile extends StatelessWidget {
  const ProfileServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.scope,
    this.height = 76,
    this.iconSize = 28,
    this.gap = 5,
    this.padding = const EdgeInsets.all(8),
    this.titleSize = 12,
    this.scopeSize = 11,
  });

  final LucideIcon icon;
  final String title;
  final String scope;
  final double height;
  final double iconSize;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double titleSize;
  final double scopeSize;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: height,
      radius: ProRadii.card,
      borderWidth: ProStroke.card,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProIcon(icon, size: iconSize),
          SizedBox(height: gap),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: title, style: ProText.r(titleSize, weight: FontWeight.w600, lineHeight: titleSize * 1.2)),
              TextSpan(text: '\n$scope', style: ProText.r(scopeSize, color: ProColors.ink500, lineHeight: scopeSize * 1.2)),
            ]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Foto de portafolio con su descripción debajo.
class ProfileGalleryTile extends StatelessWidget {
  const ProfileGalleryTile({super.key, required this.image, required this.caption, this.imageHeight = 118});

  final String image;
  final String caption;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProImage(image, width: double.infinity, height: imageHeight, radius: ProRadii.sm),
        const SizedBox(height: 5),
        Text(caption, style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2)),
      ],
    );
  }
}
