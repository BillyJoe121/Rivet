import '../../../core/models/models.dart';
import '../domain/contractors_domain.dart';

class LocalContractorRepository implements ContractorRepository {
  final List<VisitRequest> _visits = [];

  static const List<Contractor> _seedContractors = [
    Contractor(
      id: 'con-001',
      name: 'Andrés Felipe Montoya',
      trade: 'Pintura arquitectónica y estuco',
      zone: 'Cali · Sur (Ciudad Jardín, Pance)',
      rating: 4.9,
      reviewCount: 54,
      completedJobs: 68,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_living_room.jpg',
        'assets/hero/hero_greenery.jpg',
      ],
      bio:
          'Maestro pintor con 12 años en acabados residenciales, estuco plástico, veneciano y recuperación de muros con humedad.',
    ),
    Contractor(
      id: 'con-002',
      name: 'Carolina Rivas & Equipo',
      trade: 'Acabados interiores y drywall',
      zone: 'Cali · Oeste (El Peñón, Cristales)',
      rating: 4.8,
      reviewCount: 41,
      completedJobs: 52,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_lounge.jpg',
        'assets/hero/hero_planning.jpg',
      ],
      bio:
          'Cuadrilla especializada en remodelación limpia de apartamentos ocupados, encintado láser y entrega con aseo.',
    ),
    Contractor(
      id: 'con-003',
      name: 'Julián Darío Sinisterra',
      trade: 'Impermeabilización y fachadas',
      zone: 'Cali · Norte (Granada, La Flora)',
      rating: 4.7,
      reviewCount: 33,
      completedJobs: 44,
      isVerified: true,
      portfolioImages: ['assets/hero/hero_paint_roller.jpg'],
      bio:
          'Técnico en tratamiento de filtraciones, koraza elastomérica, sellado de fisuras y pintura de fachadas.',
    ),
    Contractor(
      id: 'con-004',
      name: 'Héctor Fabio Mosquera',
      trade: 'Estuco liso y pintura epóxica',
      zone: 'Cali · Sur (Valle del Lili, Bochalema)',
      rating: 4.9,
      reviewCount: 62,
      completedJobs: 81,
      isVerified: true,
      portfolioImages: ['assets/hero/hero_home.jpg'],
      bio:
          'Especialista en nivelación de muros nuevos en obra gris, aplicación de vinilo tipo 1 y esmaltes lavables.',
    ),
    Contractor(
      id: 'con-005',
      name: 'Natalia Gómez Restrepo',
      trade: 'Pintura decorativa y microcemento',
      zone: 'Cali · Oeste (San Antonio, Normandía)',
      rating: 4.8,
      reviewCount: 29,
      completedJobs: 37,
      isVerified: true,
      portfolioImages: ['assets/hero/hero_living_room.jpg'],
      bio:
          'Restauración de muros patrimoniales, paletas cálidas, tierras minerales y acabados satinados.',
    ),
    Contractor(
      id: 'con-006',
      name: 'Mauricio Caicedo',
      trade: 'Pintura general y resanes',
      zone: 'Cali · Centro y Oriente',
      rating: 4.5,
      reviewCount: 19,
      completedJobs: 26,
      isVerified: false,
      portfolioImages: ['assets/hero/hero_paint_shelf.jpg'],
      bio:
          'Pintura rápida para entregas de arrendamiento, resane de perforaciones y mantenimiento de puertas.',
    ),
  ];

  @override
  Future<List<Contractor>> getContractors() async => _seedContractors;

  @override
  Future<VisitRequest> requestVisit({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  }) async {
    final visit = VisitRequest(
      id: 'vis-${DateTime.now().millisecondsSinceEpoch}',
      contractorId: contractorId,
      contractorName: contractorName,
      projectId: projectId,
      address: address,
      preferredDate: preferredDate,
      timeSlot: timeSlot,
      notes: notes,
      feeCop: feeCop,
      createdAt: DateTime.now(),
    );
    _visits.insert(0, visit);
    return visit;
  }
}
