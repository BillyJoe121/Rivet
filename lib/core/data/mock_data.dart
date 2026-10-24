import '../models/models.dart';

/// Datos mock realistas basados en el contexto del mercado en Colombia y la guía de marca.
abstract final class MockData {
  // Contratistas
  static const List<Contractor> contractors = [
    Contractor(
      id: 'c-1',
      name: 'Carlos Mendoza',
      trade: 'Maestro pintor y estucador',
      rating: 4.9,
      reviewCount: 38,
      completedJobs: 45,
      zone: 'Cali · Valle del Lili y Ciudad Jardín',
      isVerified: true,
      bio: 'Más de 12 años de experiencia en acabados residenciales de alta gama, estuco veneciano e impermeabilización.',
      portfolioImages: [
        'Fondos/Salón Minimalista en Verde y Crema.png',
        'Fondos/Sala escandinava bañada de sol.png',
      ],
    ),
    Contractor(
      id: 'c-2',
      name: 'Jorge Eliécer Silva',
      trade: 'Especialista en interiores y drywall',
      rating: 4.8,
      reviewCount: 24,
      completedJobs: 29,
      zone: 'Cali · San Fernando y Granada',
      isVerified: true,
      bio: 'Enfoque en pulcritud, protección integral de muebles y cumplimiento estricto de fechas de entrega.',
      portfolioImages: [
        'Fondos/Rincón natural de pintura DIY.png',
      ],
    ),
    Contractor(
      id: 'c-3',
      name: 'Alonso Restrepo',
      trade: 'Pintura de fachadas y áreas comunes',
      rating: 4.7,
      reviewCount: 19,
      completedJobs: 22,
      zone: 'Cali y Jamundí',
      isVerified: true,
      bio: 'Trabajo en alturas certificado, pintura impermeable y acabados texturizados de larga duración.',
      portfolioImages: [
        'Fondos/Terraza mediterránea con vista al mar.png',
      ],
    ),
  ];

  // Proyectos
  static final List<Project> projects = [
    Project(
      id: 'proj-101',
      title: 'Pintura y resane en sala y comedor',
      clientName: 'Juan Camilo Pérez',
      city: 'Cali',
      neighborhood: 'Valle del Lili',
      budgetEstimateCop: 1450000,
      description: 'Pared principal con humedad corregida, requiere dos manos de vinilo tipo 1 color Blanco Hueso.',
      status: ProjectStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      imageAsset: 'Fondos/foto_sala_comedor.jpg',
      surfaces: const [
        SurfaceItem(
          id: 's-1',
          name: 'Pared frontal sala',
          widthMeters: 4.5,
          heightMeters: 2.6,
          finishType: 'Vinilo Tipo 1 Blanco Hueso',
          hasDefects: true,
        ),
        SurfaceItem(
          id: 's-2',
          name: 'Pared lateral comedor',
          widthMeters: 3.8,
          heightMeters: 2.6,
          finishType: 'Vinilo Tipo 1 Blanco Hueso',
        ),
        SurfaceItem(
          id: 's-3',
          name: 'Techo área social',
          widthMeters: 5.2,
          heightMeters: 3.5,
          finishType: 'Pintura para cielos antirasguños',
        ),
      ],
    ),
    Project(
      id: 'proj-102',
      title: 'Estuco y acabado en alcoba principal',
      clientName: 'María Fernanda Ruiz',
      city: 'Cali',
      neighborhood: 'Ciudad Jardín',
      budgetEstimateCop: 920000,
      description: 'Acabado liso sobre revoque nuevo en dos muros de la habitación.',
      status: ProjectStatus.negotiating,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      imageAsset: 'Fondos/foto_pared_sin_terminar.jpg',
      surfaces: const [
        SurfaceItem(
          id: 's-4',
          name: 'Muro cabecera',
          widthMeters: 3.6,
          heightMeters: 2.5,
          finishType: 'Estuco plástico y lija fina',
        ),
        SurfaceItem(
          id: 's-5',
          name: 'Muro lateral ventana',
          widthMeters: 3.2,
          heightMeters: 2.5,
          finishType: 'Estuco plástico y lija fina',
        ),
      ],
    ),
  ];

  // Propuestas
  static final List<Proposal> proposals = [
    Proposal(
      id: 'prop-201',
      projectId: 'proj-101',
      contractor: contractors[0],
      laborCostCop: 780000,
      materialsCostCop: 420000,
      estimatedDays: 3,
      status: 'Recibida',
      observations: 'Incluye protección completa de piso con cartón corrugado y plástico, resane con masilla elastomérica.',
    ),
    Proposal(
      id: 'prop-202',
      projectId: 'proj-101',
      contractor: contractors[1],
      laborCostCop: 850000,
      materialsCostCop: 395000,
      estimatedDays: 4,
      status: 'Recibida',
      observations: 'Aplicación con rodillo de microfibra anti-goteo, 2 manos de Viniltex lavable garantizado.',
    ),
  ];

  // Catálogo de Materiales (Bodega FerreCasa)
  static const List<MaterialProduct> materials = [
    MaterialProduct(
      id: 'mat-1',
      name: 'Viniltex Avanzado Blanco Hueso',
      brand: 'Pintuco',
      category: 'Pintura',
      unit: 'Cuñete (5 galones)',
      clientPriceCop: 285000,
      proPriceCop: 252000,
      coverageM2: 85.0,
      supplierName: 'FerreCasa Central',
      imageAsset: 'Fondos/Rodillo sobre pincelada verde.png',
    ),
    MaterialProduct(
      id: 'mat-2',
      name: 'Viniltex Avanzado Verde Botánico',
      brand: 'Pintuco',
      category: 'Pintura',
      unit: 'Galón',
      clientPriceCop: 68000,
      proPriceCop: 59000,
      coverageM2: 25.0,
      supplierName: 'FerreCasa Central',
      imageAsset: 'Fondos/Rodillo sobre pincelada verde.png',
    ),
    MaterialProduct(
      id: 'mat-3',
      name: 'Estuco Acrílico Listo para Usar',
      brand: 'Corona',
      category: 'Estuco',
      unit: 'Balde (20 kg)',
      clientPriceCop: 52000,
      proPriceCop: 44000,
      coverageM2: 18.0,
      supplierName: 'FerreCasa Central',
      imageAsset: 'Fondos/Papeles y plantas sobre fondo crema.png',
    ),
    MaterialProduct(
      id: 'mat-4',
      name: 'Sellador Antihumedad Impermeable',
      brand: 'Sika',
      category: 'Impermeabilizante',
      unit: 'Galón',
      clientPriceCop: 74000,
      proPriceCop: 65000,
      coverageM2: 20.0,
      supplierName: 'FerreCasa Central',
      imageAsset: 'Fondos/Escudo de confianza entre hojas verdes.png',
    ),
    MaterialProduct(
      id: 'mat-5',
      name: 'Kit de Rodillo Profesional + Bandeja + Brocha 2.5"',
      brand: 'Master',
      category: 'Herramientas',
      unit: 'Kit completo',
      clientPriceCop: 38000,
      proPriceCop: 32000,
      coverageM2: 0,
      supplierName: 'FerreCasa Central',
      imageAsset: 'Fondos/Checklist, plantas y cajas sostenibles.png',
    ),
  ];
}
