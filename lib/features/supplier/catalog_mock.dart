import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'catalog_product_info.dart';

/// Datos simulados de FerreCasa para la bodega (frame 22:144637).
abstract final class CatalogMock {
  static const String supplierName = 'FerreCasa';
  static const String supplierLocation = 'Medellín, Antioquia';
  static const String supplierType = 'Ferretería y acabados';
  static const String supplierRating = '⭐ 4.8 (126 reseñas)';
  static const String supplierImage = ProAssets.ferreCasaStore;

  static const MaterialProduct paint = MaterialProduct(
    id: 'PV-001',
    name: 'Pintura vinilo premium',
    brand: 'Rivet',
    category: 'Pinturas',
    unit: 'Galón (1 gal)',
    clientPriceCop: 87000,
    proPriceCop: 82000,
    coverageM2: 37.5,
    supplierName: supplierName,
    imageAsset: ProAssets.rivetPaint,
  );

  static const MaterialProduct porcelain = MaterialProduct(
    id: 'PO-004',
    name: 'Porcelanato gris mate',
    brand: 'Cerámica Andina',
    category: 'Acabados',
    unit: 'm²',
    clientPriceCop: 62000,
    proPriceCop: 62000,
    coverageM2: 0,
    supplierName: supplierName,
  );

  static const MaterialProduct stucco = MaterialProduct(
    id: 'EP-002',
    name: 'Estuco plástico blanco',
    brand: 'Sika',
    category: 'Estuco',
    unit: '5 galones',
    clientPriceCop: 120000,
    proPriceCop: 120000,
    coverageM2: 0,
    supplierName: supplierName,
    imageAsset: ProAssets.coronaStucco,
  );

  /// Productos de la bodega en el orden del frame 22:144637.
  static const List<({MaterialProduct product, CatalogProductInfo info})> products = [
    (
      product: paint,
      info: CatalogProductInfo(
        image: ProAssets.rivetPaint,
        imageFit: BoxFit.contain,
        presentation: 'Interior lavable, 1 galón',
      ),
    ),
    (product: porcelain, info: CatalogProductInfo(presentation: '60 × 60 cm', priceSuffix: ' m²')),
    (product: stucco, info: CatalogProductInfo(presentation: 'Acabado profesional, 5 galones')),
  ];
}
