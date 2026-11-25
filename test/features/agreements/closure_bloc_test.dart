import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';

import '../../helpers/local_agreement_repository.dart';

void main() {
  final sampleProposal = Proposal(
    id: 'prop-close-1',
    projectId: 'proj-1',
    contractor: const Contractor(
      id: 'c-1',
      name: 'Carlos Mendoza',
      trade: 'Pintor',
      rating: 4.9,
      reviewCount: 15,
      completedJobs: 20,
      zone: 'Cali',
    ),
    laborCostCop: 700000,
    materialsCostCop: 300000,
    estimatedDays: 4,
    status: ProposalStatus.accepted,
    observations: 'Todo incluido',
  );

  test('ClosureBloc cierra obra, registra calificación, libera pago y gestiona cancelación', () async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y cocina',
      proposal: sampleProposal,
    );
    await repo.acceptAgreement(agreementId: agreement.id, asClient: true);
    await repo.acceptAgreement(agreementId: agreement.id, asClient: false);
    await repo.processSimulatedPayment(agreement: agreement);

    final bloc = ClosureBloc.fromRepository(repo);
    bloc.add(LoadClosureRequested(agreement.id));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ClosureStatus.success);
    expect(bloc.state.payments, isNotEmpty);

    bloc.add(const CompleteAgreementRequested());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.agreement?.status, AgreementStatus.completed);

    bloc.add(
      const SubmitRatingRequested(
        rateeId: 'c-1',
        stars: 5,
        review: 'Excelente acabado y limpieza.',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.ratings.length, 1);
    expect(bloc.state.ratings.first.stars, 5);

    bloc.add(ReleasePaymentRequested(bloc.state.payments.first.id));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.payments.first.status, SimulatedPaymentStatus.released);

    bloc.add(
      RequestCancellationRequested(
        reason: 'Ajuste de alcance',
        description: 'Acordamos suspender el último ambiente.',
        photos: [
          ProgressPhotoUpload(
            fileName: 'soporte.jpg',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.cancellations.length, 1);
    expect(bloc.state.cancellations.first.status, CancellationStatus.requested);

    bloc.add(
      ResolveCancellationRequested(
        cancellationId: bloc.state.cancellations.first.id,
        approved: true,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.cancellations.first.status, CancellationStatus.approved);
    expect(bloc.state.agreement?.status, AgreementStatus.cancelled);

    await bloc.close();
  });
}
