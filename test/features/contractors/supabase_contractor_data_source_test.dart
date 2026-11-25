import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/contractors/contractors_module.dart';
import 'package:rivet/features/contractors/data/repositories/contractor_repository_impl.dart';
import 'package:rivet/features/contractors/data/sources/supabase_contractor_data_source.dart';
import 'package:rivet/features/projects/data/sources/project_row_mapper.dart';

class _FailingContractorRepository implements ContractorRepository {
  @override
  Future<List<Contractor>> getContractors() async {
    throw const ContractorFailure('Sin conexión con Supabase');
  }

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
    throw const ContractorFailure('Error al guardar visita');
  }
}

void main() {
  group('SupabaseContractorDataSource y mappers', () {
    test('propaga ContractorFailure cuando no hay cliente configurado', () async {
      final repo = ContractorRepositoryImpl(SupabaseContractorDataSource(null));

      await expectLater(
        repo.getContractors(),
        throwsA(
          isA<ContractorFailure>().having(
            (e) => e.message,
            'message',
            SupabaseContractorDataSource.noConnectionMessage,
          ),
        ),
      );

      await expectLater(
        repo.requestVisit(
          contractorId: 'con-1',
          contractorName: 'Carlos Mendoza',
          projectId: 'proj-1',
          address: 'Cra 100 # 11-20',
          preferredDate: '2026-12-01',
          timeSlot: 'Mañana',
          notes: 'Revisar muros',
          feeCop: 45000,
        ),
        throwsA(
          isA<ContractorFailure>().having(
            (e) => e.message,
            'message',
            SupabaseContractorDataSource.noConnectionMessage,
          ),
        ),
      );
    });

    test('contractorFromProfileRow hidrata campos de perfil y calificaciones', () {
      final contractor = contractorFromProfileRow(
        {
          'id': '11111111-1111-4111-8111-111111111101',
          'full_name': 'Carlos Mendoza',
          'trade': 'Pintura arquitectónica y estuco',
          'zone': 'Cali · Sur',
          'bio': 'Maestro pintor residencial',
          'is_verified': true,
          'completed_jobs': 68,
          'portfolio_images': ['assets/hero/hero_living_room.jpg'],
        },
        ratings: {
          '11111111-1111-4111-8111-111111111101': {
            'avg_stars': '4.85',
            'review_count': 27,
          },
        },
      );

      expect(contractor.id, '11111111-1111-4111-8111-111111111101');
      expect(contractor.name, 'Carlos Mendoza');
      expect(contractor.trade, 'Pintura arquitectónica y estuco');
      expect(contractor.zone, 'Cali · Sur');
      expect(contractor.rating, closeTo(4.85, 0.001));
      expect(contractor.reviewCount, 27);
      expect(contractor.completedJobs, 68);
      expect(contractor.isVerified, isTrue);
      expect(contractor.portfolioImages, ['assets/hero/hero_living_room.jpg']);
    });

    test('visitRequestFromRow mapea la fila persistida de visit_requests', () {
      final visit = visitRequestFromRow(
        {
          'id': 'vis-uuid-1',
          'contractor_id': 'con-uuid-1',
          'project_id': null,
          'address': 'Calle 5 # 40-10',
          'preferred_date': 'Sábado 5 de diciembre',
          'time_slot': 'Mañana (9:00 a. m. - 12:00 m.)',
          'notes': 'Humedad en muro norte',
          'fee_cop': 45000,
          'simulated_paid': true,
          'created_at': '2026-11-25T15:00:00Z',
        },
        contractorName: 'Carolina Rivas',
        fallbackProjectId: 'proj-fallback',
      );

      expect(visit.id, 'vis-uuid-1');
      expect(visit.contractorName, 'Carolina Rivas');
      expect(visit.projectId, 'proj-fallback');
      expect(visit.feeCop, 45000);
      expect(visit.simulatedPaid, isTrue);
    });
  });

  group('ContractorsBloc con fallos reales', () {
    test('emite failure sin mostrar contratistas de ejemplo cuando falla', () async {
      final bloc = ContractorsBloc.fromRepository(
        _FailingContractorRepository(),
      );
      addTearDown(bloc.close);

      bloc.add(const LoadContractors());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, ContractorsStatus.failure);
      expect(bloc.state.contractors, isEmpty);
      expect(bloc.state.errorMessage, 'Sin conexión con Supabase');
    });
  });

  group('projectFromRow con project_materials y photo_paths', () {
    test('mapea materiales ordenados por position y photo_paths', () {
      const material = ProjectMaterial(
        productId: 'PV-001',
        name: 'Pintura vinilo premium',
        unit: 'galón',
        unitPriceCop: 87000,
        quantity: 3,
      );
      final rowMat = materialToRow(
        material,
        projectId: 'proj-1',
        position: 0,
      );
      expect(rowMat['product_id'], 'PV-001');
      expect(rowMat['quantity'], 3);

      final project = projectFromRow({
        'id': 'proj-1',
        'title': 'Apartamento Pance',
        'city': 'Cali',
        'neighborhood': 'Pance',
        'status': 'open',
        'budget_estimate_cop': 2500000,
        'photo_paths': ['Fondos/hero-living-room.jpg', 'Fondos/hero-lounge.jpg'],
        'project_spaces': [],
        'project_materials': [
          {
            'id': 'pm-2',
            'product_id': 'AC-006',
            'position': 1,
            'name': 'Cinta de enmascarar',
            'unit': 'rollo',
            'unit_price_cop': 9500,
            'quantity': 2,
          },
          {
            'id': 'pm-1',
            'product_id': 'PV-001',
            'position': 0,
            'name': 'Pintura vinilo premium',
            'unit': 'galón',
            'unit_price_cop': 87000,
            'quantity': 3,
          },
        ],
      });

      expect(project.imageAsset, 'Fondos/hero-living-room.jpg');
      expect(project.photoAssets, hasLength(2));
      expect(project.materials, hasLength(2));
      expect(project.materials.first.productId, 'PV-001');
      expect(project.materials.last.productId, 'AC-006');
    });
  });
}
