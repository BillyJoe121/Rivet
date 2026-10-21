import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/account/edit_professional_profile_screen.dart';
import 'package:rivet/features/account/job_closure_screen.dart';
import 'package:rivet/features/account/my_proposals_screen.dart';
import 'package:rivet/features/account/professional_profile_screen.dart';
import 'package:rivet/features/finance/payout_account_screen.dart';
import 'package:rivet/features/home/contractor_home_view.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';
import 'package:rivet/features/proposals/create_proposal_screen.dart';

import 'pro_harness.dart';

/// Proyecto de muestra con los datos que muestra el frame de cotización.
final _proposalProject = Project(
  id: 'frame-22-145820',
  title: 'Remodelación de sala',
  clientName: 'Juan Pérez',
  city: 'Bogotá D.C.',
  neighborhood: 'Cedritos',
  surfaces: const [],
  status: ProjectStatus.published,
  createdAt: DateTime(2024, 4, 15),
);

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('22:145582 Hola, Carlos', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      ContractorHomeView(onSwitchRole: (_) {}),
      name: '22-145582',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:145820 Crear y enviar propuesta', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, CreateProposalScreen(project: _proposalProject), name: '22-145820');
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:143685 Perfil profesional', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, const ProfessionalProfileScreen(), name: '22-143685');
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:146001 Editar perfil profesional', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, const EditProfessionalProfileScreen(), name: '22-146001');
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:145904 Mis propuestas y trabajos', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, const MyProposalsScreen(), name: '22-145904');
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:145526 Cierre y calificación', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, const JobClosureScreen(), name: '22-145526');
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14323 Cuenta para recibir pagos', skip: !fontsAvailable, (tester) async {
    await renderFrame(tester, const PayoutAccountScreen(), name: '66-14323');
    expect(tester.takeException(), isNull);
  });
}
