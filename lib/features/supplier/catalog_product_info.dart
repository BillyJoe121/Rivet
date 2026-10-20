import 'package:flutter/material.dart';

/// Textos de presentación de un producto del catálogo que no están en [MaterialProduct].
class CatalogProductInfo {
  const CatalogProductInfo({
    this.image,
    this.imageFit = BoxFit.cover,
    required this.presentation,
    this.priceSuffix = '',
    this.description,
    this.coverageLabel,
    this.stockLabel,
    this.usage,
  });

  /// Ruta de la fotografía; null muestra el recuadro gris de Figma.
  final String? image;

  /// BoxFit de Figma: contain para IMAGE(FIT), cover para IMAGE(FILL).
  final BoxFit imageFit;

  /// Segunda línea de la tarjeta de bodega (presentación o medida).
  final String presentation;

  /// Sufijo del precio, por ejemplo " m²".
  final String priceSuffix;

  /// Línea descriptiva de la ficha de detalle.
  final String? description;

  /// Rendimiento mostrado en la ficha de detalle.
  final String? coverageLabel;

  /// Disponibilidad en unidades mostrada junto al precio.
  final String? stockLabel;

  /// Uso recomendado mostrado en la ficha de detalle.
  final String? usage;
}

/// Formatea pesos colombianos con punto de miles: 87000 → "87.000".
String formatCop(int amount) {
  return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}
