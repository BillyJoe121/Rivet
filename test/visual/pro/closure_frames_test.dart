import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/agreements/agreements_screens.dart';

import '../../helpers/repositories_test_harness.dart';
import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  final sampleProposal = Proposal(
    id: 'prop-close-vis-1',
    projectId: 'proj-1',
    contractor: const Contractor(
      id: 'c-1',
      name: 'Carlos Mendoza',
      trade: 'Pintor profesional',
      rating: 4.9,
      reviewCount: 24,
      completedJobs: 30,
      zone: 'Cali',
    ),
    laborCostCop: 950000,
    materialsCostCop: 450000,
    estimatedDays: 6,
    status: ProposalStatus.accepted,
    observations: 'Incluye resanes.',
  );

  testWidgets('22-145526 Cierre de obra', skip: !fontsAvailable, (tester) async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y comedor',
      proposal: sampleProposal,
    );

    await renderFrame(
      tester,
      withRepositories(
        JobClosureScreen.withBloc(agreementId: agreement.id),
        agreements: repo,
      ),
      name: '22-145526',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66-14883 Pago recibido', skip: !fontsAvailable, (tester) async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y comedor',
      proposal: sampleProposal,
    );

    await renderFrame(
      tester,
      withRepositories(
        PaymentReceivedScreen.withBloc(agreementId: agreement.id),
        agreements: repo,
      ),
      name: '66-14883',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66-14092 Cancelación y reembolso', skip: !fontsAvailable, (tester) async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y comedor',
      proposal: sampleProposal,
    );

    await renderFrame(
      tester,
      withRepositories(
        CancellationRefundScreen.withBloc(agreementId: agreement.id),
        agreements: repo,
      ),
      name: '66-14092',
    );
    expect(tester.takeException(), isNull);
  });
}
