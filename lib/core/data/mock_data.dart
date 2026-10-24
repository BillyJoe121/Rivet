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
}
