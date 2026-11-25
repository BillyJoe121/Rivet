import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';

import '../../helpers/local_agreement_repository.dart';

void main() {
  final sampleProposal = Proposal(
    id: 'prop-1',
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
    laborCostCop: 800000,
    materialsCostCop: 400000,
    estimatedDays: 5,
    status: ProposalStatus.accepted,
    observations: 'Todo incluido',
  );

  test('AgreementsBloc prepara acuerdo, registra aceptación mutua y procesa pago', () async {
    final repo = LocalAgreementRepository();
    final bloc = AgreementsBloc.fromRepository(repo);

    bloc.add(
      PrepareAgreementRequested(
        projectId: 'proj-1',
        projectTitle: 'Sala y comedor',
        proposal: sampleProposal,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, AgreementsStatus.success);
    expect(bloc.state.agreement?.status, AgreementStatus.pending);

    bloc.add(const ToggleAgreementTermsAccepted(true));
    bloc.add(const AcceptAgreementRequested(asClient: true));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.agreement?.clientAcceptedAt, isNotNull);
    expect(bloc.state.agreement?.status, AgreementStatus.pending);

    bloc.add(const AcceptAgreementRequested(asClient: false));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.agreement?.contractorAcceptedAt, isNotNull);
    expect(bloc.state.agreement?.status, AgreementStatus.active);

    bloc.add(const SelectSimulatedPaymentMethod(SimulatedPaymentMethod.card));
    bloc.add(const SubmitSimulatedPayment(cardBrand: 'Visa', cardLast4: '4242'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.hasPaymentResult, isTrue);
    expect(bloc.state.agreement?.cardLast4, '4242');
    expect(bloc.state.agreement?.paymentStatus, SimulatedPaymentStatus.held);

    await bloc.close();
  });

  test('PayoutAccountBloc guarda cuenta enmascarada y valida longitud mínima', () async {
    final repo = LocalAgreementRepository();
    final bloc = PayoutAccountBloc.fromRepository(repo);

    bloc.add(const LoadPayoutAccountRequested());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.status, PayoutAccountStatus.success);
    expect(bloc.state.account, isNull);

    bloc.add(
      const SavePayoutAccountRequested(
        bankName: 'Bancolombia',
        accountType: 'ahorros',
        accountNumber: '123',
        holderName: 'Carlos Mendoza',
        documentNumber: '1234567890',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.status, PayoutAccountStatus.failure);

    bloc.add(
      const SavePayoutAccountRequested(
        bankName: 'Bancolombia',
        accountType: 'ahorros',
        accountNumber: '1234567890',
        holderName: 'Carlos Mendoza',
        documentNumber: '9876543210',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, PayoutAccountStatus.success);
    expect(bloc.state.savedSuccessfully, isTrue);
    expect(bloc.state.account?.accountNumberLast4, '7890');
    expect(bloc.state.account?.documentNumberLast4, '3210');

    await bloc.close();
  });
}
