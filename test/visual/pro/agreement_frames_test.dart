import 'package:flutter_bloc/flutter_bloc.dart';
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
    id: 'prop-visual-1',
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
    observations: 'Incluye protección de pisos y resanes.',
  );

  testWidgets('22-145284 Acuerdo mutuo', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      withRepositories(
        AgreementSummaryScreen.withBloc(
          proposal: sampleProposal,
          projectTitle: 'Sala y comedor principal',
        ),
      ),
      name: '22-145284',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22-145357 Pago de anticipo', skip: !fontsAvailable, (tester) async {
    final repo = LocalAgreementRepository();
    await renderFrame(
      tester,
      withRepositories(
        BlocProvider<AgreementsBloc>(
          create: (_) => AgreementsBloc.fromRepository(repo)
            ..add(
              PrepareAgreementRequested(
                projectId: 'proj-1',
                projectTitle: 'Sala y comedor principal',
                proposal: sampleProposal,
              ),
            ),
          child: const ProjectPaymentScreen(),
        ),
        agreements: repo,
      ),
      name: '22-145357',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66-14323 Cuenta para recibir pagos', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      withRepositories(PayoutAccountScreen.withBloc()),
      name: '66-14323',
    );
    expect(tester.takeException(), isNull);
  });
}
