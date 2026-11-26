import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_screens.dart';
import 'package:rivet/features/messaging/messaging_screens.dart';

import '../../helpers/local_agreement_repository.dart';
import '../../helpers/repositories_test_harness.dart';
import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  final sampleProposal = Proposal(
    id: 'prop-exec-1',
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

  testWidgets('66-14265 Registrar avance', skip: !fontsAvailable, (
    tester,
  ) async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y comedor',
      proposal: sampleProposal,
    );

    await renderFrame(
      tester,
      withRepositories(
        RegisterProgressScreen.withBloc(agreementId: agreement.id),
        agreements: repo,
      ),
      name: '66-14265',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22-145438 Seguimiento de obra', skip: !fontsAvailable, (
    tester,
  ) async {
    final repo = LocalAgreementRepository();
    final agreement = await repo.prepareAgreement(
      projectId: 'proj-1',
      projectTitle: 'Sala y comedor',
      proposal: sampleProposal,
    );

    await renderFrame(
      tester,
      withRepositories(
        ProgressTrackingScreen.withBloc(agreementId: agreement.id),
        agreements: repo,
      ),
      name: '22-145438',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22-145219 Chat de proyecto', skip: !fontsAvailable, (
    tester,
  ) async {
    await renderFrame(
      tester,
      withRepositories(
        ProjectChatScreen.withBloc(
          conversationId: 'conv-001',
          contractorName: 'Andrés Felipe Montoya',
          projectTitle: 'Pintura sala y comedor',
        ),
      ),
      name: '22-145219',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22-146347 Mensajes', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      withRepositories(ConversationsListScreen.withBloc()),
      name: '22-146347',
    );
    expect(tester.takeException(), isNull);
  });
}
