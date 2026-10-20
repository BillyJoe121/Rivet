import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'catalog_product_info.dart';

/// Datos simulados de FerreCasa para bodega, ficha, perfil, productos y administración
/// (frames 22:144637, 22:144770, 22:144701, 53:137, 22:146203 y 66:14377).
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
        description: 'Interior lavable · Blanco mate',
        coverageLabel: '35 – 40 m² por galón',
        stockLabel: 'Más de 50 unidades',
        usage: 'Interiores (muros y cielos)',
      ),
    ),
    (product: porcelain, info: CatalogProductInfo(presentation: '60 × 60 cm', priceSuffix: ' m²')),
    (product: stucco, info: CatalogProductInfo(presentation: 'Acabado profesional, 5 galones')),
  ];

  /// Productos de la pantalla "Productos" (frame 53:137), con texto de precio tal como aparece.
  static const List<({String name, String presentation, String price, String image, BoxFit fit})> productGrid = [
    (
      name: 'Pintura vinilo premium',
      presentation: '1 galón',
      price: '\$ 87.000',
      image: ProAssets.rivetPaint,
      fit: BoxFit.contain
    ),
    (
      name: 'Porcelanato gris mate',
      presentation: '60 × 60 cm',
      price: '\$ 62.000 m²',
      image: ProAssets.drywallBoards,
      fit: BoxFit.cover
    ),
    (
      name: 'Estuco plástico',
      presentation: '5 galones',
      price: '\$ 120.000',
      image: ProAssets.coronaStucco,
      fit: BoxFit.contain
    ),
    (
      name: 'Sellador acrílico',
      presentation: 'Envase',
      price: 'Consultar precio',
      image: ProAssets.sealer,
      fit: BoxFit.cover
    ),
    (
      name: 'Cinta de enmascarar',
      presentation: 'Paquete · medida a consultar',
      price: 'Consultar precio',
      image: ProAssets.maskingTape,
      fit: BoxFit.cover
    ),
    (
      name: 'Adhesivo para piso y pared',
      presentation: 'Saco',
      price: 'Consultar precio',
      image: ProAssets.cement,
      fit: BoxFit.cover
    ),
    (
      name: 'Perfil metálico para drywall',
      presentation: 'Unidad',
      price: 'Consultar precio',
      image: ProAssets.metalProfiles,
      fit: BoxFit.cover
    ),
    (
      name: 'Brocha para pintura',
      presentation: 'Unidad',
      price: 'Consultar precio',
      image: ProAssets.brush,
      fit: BoxFit.cover
    ),
  ];

  /// Materiales de "Administrar catálogo y precios" (frame 22:146203).
  static const List<
      ({String name, String sku, String detail, String status, String cost, String price, String image, BoxFit fit})> managed = [
    (
      name: 'Pintura vinilo premium',
      sku: 'PV-001',
      detail: 'Interior lavable, 1 galón',
      status: '● Disponible',
      cost: '\$ 87.000',
      price: '\$ 79.000',
      image: ProAssets.rivetPaint,
      fit: BoxFit.contain
    ),
    (
      name: 'Estuco plástico blanco',
      sku: 'EP-002',
      detail: 'Acabado profesional, 5 galones',
      status: '● 12 unidades',
      cost: '\$ 120.000',
      price: '\$ 109.000',
      image: ProAssets.coronaStucco,
      fit: BoxFit.contain
    ),
    (
      name: 'Sellador acrílico',
      sku: 'SA-010',
      detail: 'Base preparadora, 1 galón',
      status: '● Bajo',
      cost: '\$ 54.000',
      price: '\$ 49.000',
      image: ProAssets.sealer,
      fit: BoxFit.cover
    ),
  ];

  /// Productos destacados del perfil (frame 22:144701).
  static const List<({String name, String price, String image, BoxFit fit})> highlights = [
    (name: 'Pintura vinilo premium', price: '\$ 87.000', image: ProAssets.rivetPaint, fit: BoxFit.contain),
    (name: 'Porcelanato gris mate', price: '\$ 62.000 m²', image: '', fit: BoxFit.cover),
    (name: 'Estuco plástico', price: '\$ 120.000', image: ProAssets.coronaStucco, fit: BoxFit.contain),
  ];
}
