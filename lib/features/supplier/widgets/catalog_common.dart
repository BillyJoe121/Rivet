import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Fotografía del catálogo; sin imagen muestra el recuadro gris de Figma.
class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.radius = ProRadii.sm,
  });

  final String? image;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: ProColors.lineDark, borderRadius: BorderRadius.circular(radius)),
      );
    }
    return ProImage(image!, width: width, height: height, radius: radius, fit: fit);
  }
}

/// Campo de búsqueda de 42 px con borde de 1 px y radio de 12 px.
class CatalogSearchField extends StatelessWidget {
  const CatalogSearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.height = 42,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: ProStroke.divider),
      ),
      child: Row(
        children: [
          const ProIcon(LucideIcon.search, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: ProText.r(13, lineHeight: 17.55),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: ProText.r(13, color: ProColors.ink500, lineHeight: 17.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo de filtro de 36 px que muestra un valor fijo (sin acción).
class CatalogStaticField extends StatelessWidget {
  const CatalogStaticField({super.key, required this.icon, required this.label});

  final LucideIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: ProStroke.divider),
      ),
      child: Row(
        spacing: 10,
        children: [
          ProIcon(icon, size: 19),
          Expanded(
            child: Text(
              label,
              style: ProText.r(13, color: ProColors.ink500, lineHeight: 17.55),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pestaña de 36 px con radio 24; la seleccionada usa el degradado de marca.
class CatalogSegment extends StatelessWidget {
  const CatalogSegment({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? null : ProColors.brandLight,
          gradient: selected ? ProColors.brandGradient : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: selected
              ? ProText.r(12, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 14.4)
              : ProText.r(12, color: ProColors.ink500, lineHeight: 14.4),
        ),
      ),
    );
  }
}

/// Campo de formulario: etiqueta de 11 px y valor editable o fijo de 13 px.
class CatalogFormField extends StatelessWidget {
  const CatalogFormField({
    super.key,
    required this.label,
    this.controller,
    this.value,
    this.height = 49,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? value;
  final double height;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final valueStyle = ProText.r(13, lineHeight: 16.25);
    return Container(
      constraints: BoxConstraints(minHeight: height),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ProColors.surface0,
        borderRadius: BorderRadius.circular(ProRadii.md),
        border: Border.all(color: ProColors.line300, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(label, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
          if (controller != null)
            TextField(
              controller: controller,
              maxLines: maxLines,
              style: valueStyle,
              decoration: const InputDecoration(
                isDense: true,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            )
          else
            Text(value ?? '', style: valueStyle),
        ],
      ),
    );
  }
}
