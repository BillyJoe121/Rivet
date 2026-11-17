import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';

void main() {
  final sampleProposal = Proposal(
    id: 'prop-prog-1',
    projectId: 'proj-1',
    contractor: const Contractor(
      id: 'c-1',
      name: 'Carlos Mendoza',
      trade: 'Pintor',
      rating: 4.9,
      reviewCount: 12,
      completedJobs: 18,
      zone: 'Cali',
    ),
    laborCostCop: 600000,
    materialsCostCop: 300000,
    estimatedDays: 4,
    status: ProposalStatus.accepted,
    observations: 'Todo incluido',
  );

  test('ProgressBloc carga checklist mutuo, confirma hitos por ambas partes y registra avance', () async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Fachada y sala',
      proposal: sampleProposal,
    );

    final bloc = ProgressBloc.fromRepository(repo);
    bloc.add(LoadProgressRequested(agreement.id));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ProgressStatus.success);
    expect(bloc.state.agreement?.milestoneItems, isNotEmpty);

    final milestoneId = bloc.state.agreement!.milestoneItems.first.id;
    bloc.add(ConfirmMilestoneRequested(milestoneId: milestoneId, asClient: false));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.agreement!.milestoneItems.first.contractorConfirmedAt, isNotNull);
    expect(bloc.state.agreement!.milestoneItems.first.isDone, isFalse);

    bloc.add(ConfirmMilestoneRequested(milestoneId: milestoneId, asClient: true));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.agreement!.milestoneItems.first.isDone, isTrue);

    bloc.add(
      SubmitProgressUpdateRequested(
        agreementId: agreement.id,
        milestoneId: milestoneId,
        percent: 45,
        description: 'Alistamiento y resane terminado en sala.',
        photos: [
          ProgressPhotoUpload(
            fileName: 'sala.jpg',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.submittedSuccessfully, isTrue);
    expect(bloc.state.updates.length, 1);
    expect(bloc.state.updates.first.photoPaths.length, 1);
    expect(bloc.state.latestPercent, 45);

    await bloc.close();
  });

  test('ProgressBloc falla si se envía avance sin descripción', () async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Fachada',
      proposal: sampleProposal,
    );
    final bloc = ProgressBloc.fromRepository(repo);
    bloc.add(
      SubmitProgressUpdateRequested(
        agreementId: agreement.id,
        percent: 20,
        description: '   ',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ProgressStatus.failure);
    await bloc.close();
  });
}
