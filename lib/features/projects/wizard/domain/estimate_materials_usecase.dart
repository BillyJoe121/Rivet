import '../../../../core/models/models.dart';

/// Estima la lista base de materiales de pintura y preparación según el área (P-014).
class EstimateMaterialsUseCase {
  const EstimateMaterialsUseCase();

  List<ProjectMaterial> call(List<SurfaceItem> surfaces) {
    final totalArea = surfaces.fold<double>(0, (acc, s) => acc + s.areaM2);
    final effectiveArea = totalArea <= 0 ? 10.0 : totalArea;

    final paintGallons = (effectiveArea / 18.0).ceil().clamp(1, 50);
    final stuccoBuckets = (effectiveArea / 22.0).ceil().clamp(1, 30);
    final primerGallons = (effectiveArea / 30.0).ceil().clamp(1, 20);
    final tapeRolls = (surfaces.length).clamp(1, 12);

    return [
      ProjectMaterial(
        productId: 'PV-001',
        name: 'Vinilo Tipo 1 Blanco Puro (2 manos)',
        unit: 'Galón',
        unitPriceCop: 87000,
        quantity: paintGallons,
      ),
      ProjectMaterial(
        productId: 'PV-003',
        name: 'Estuco plástico interior listo',
        unit: 'Cuñete 5 gal',
        unitPriceCop: 129000,
        quantity: stuccoBuckets,
      ),
      ProjectMaterial(
        productId: 'PV-019',
        name: 'Sellador acrílico antialcalino',
        unit: 'Galón',
        unitPriceCop: 68000,
        quantity: primerGallons,
      ),
      ProjectMaterial(
        productId: 'PV-008',
        name: 'Cinta de enmascarar azul 48 mm',
        unit: 'Rollo',
        unitPriceCop: 16900,
        quantity: tapeRolls,
      ),
    ];
  }
}

