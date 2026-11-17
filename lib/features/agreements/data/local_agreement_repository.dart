import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';

class LocalAgreementRepository implements AgreementRepository {
  final Map<String, WorkAgreement> _byProposalId = {};
  final Map<String, WorkAgreement> _byId = {};
  PayoutAccount? _payoutAccount;

  @override
  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  }) async {
    final existing = _byProposalId[proposal.id];
    if (existing != null) return existing;

    final id = 'agr-${proposal.id}';
    const milestoneTitles = [
      'Hito 1 · Alistamiento, protección de pisos y resanes de superficies',
      'Hito 2 · Aplicación de estuco plástico y lijado uniforme',
      'Hito 3 · Dos manos de pintura, revisión conjunta y entrega limpia',
    ];
    final items = [
      for (var i = 0; i < milestoneTitles.length; i++)
        AgreementMilestone(
          id: '$id-m-$i',
          agreementId: id,
          position: i,
          title: milestoneTitles[i],
        ),
    ];

    final created = WorkAgreement(
      id: id,
      projectId: projectId,
      projectTitle: projectTitle,
      proposalId: proposal.id,
      clientId: 'client-local',
      contractorId: proposal.contractor.id,
      contractorName: proposal.contractor.name,
      clientName: 'Propietario',
      laborAmountCop: proposal.laborCostCop,
      materialsAmountCop: proposal.materialsCostCop,
      estimatedDays: proposal.estimatedDays,
      milestones: milestoneTitles,
      milestoneItems: items,
    );
    _byProposalId[proposal.id] = created;
    _byId[id] = created;
    return created;
  }

  @override
  Future<WorkAgreement> getAgreementById(String agreementId) async {
    final found = _byId[agreementId];
    if (found == null) {
      throw const AgreementFailure('No encontramos el acuerdo solicitado.');
    }
    return found;
  }

  @override
  Future<WorkAgreement?> getAgreementForProject(String projectId) async {
    return _byId.values.where((a) => a.projectId == projectId).firstOrNull;
  }

  @override
  Future<List<WorkAgreement>> getMyAgreements() async =>
      List<WorkAgreement>.unmodifiable(_byId.values);

  @override
  Future<WorkAgreement> acceptAgreement({
    required String agreementId,
    required bool asClient,
  }) async {
    final current = await getAgreementById(agreementId);
    final now = DateTime.now();
    final updatedClientAt = asClient ? (current.clientAcceptedAt ?? now) : current.clientAcceptedAt;
    final updatedContractorAt =
        !asClient ? (current.contractorAcceptedAt ?? now) : current.contractorAcceptedAt;
    final bothAccepted = updatedClientAt != null && updatedContractorAt != null;

    final updated = current.copyWith(
      clientAcceptedAt: updatedClientAt,
      contractorAcceptedAt: updatedContractorAt,
      clientAcceptedTerms: updatedClientAt != null,
      contractorAcceptedTerms: updatedContractorAt != null,
      status: bothAccepted ? AgreementStatus.active : AgreementStatus.pending,
    );
    _byId[agreementId] = updated;
    _byProposalId[updated.proposalId] = updated;
    return updated;
  }

  @override
  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    String? cardBrand,
    String? cardLast4,
    bool simulateFailure = false,
  }) async {
    if (simulateFailure) {
      final rejected = agreement.copyWith(
        paymentStatus: SimulatedPaymentStatus.rejected,
      );
      _byProposalId[agreement.proposalId] = rejected;
      _byId[agreement.id] = rejected;
      throw const AgreementFailure(
        'Pago simulado rechazado en la prueba. Puedes reintentar con otro método.',
      );
    }
    final approved = agreement.copyWith(
      paymentStatus: SimulatedPaymentStatus.held,
      cardBrand: cardBrand,
      cardLast4: cardLast4,
      receiptCode:
          'SIM-${agreement.proposalId.toUpperCase()}-${DateTime.now().millisecond}',
    );
    _byProposalId[agreement.proposalId] = approved;
    _byId[agreement.id] = approved;
    return approved;
  }

  @override
  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement) async {
    final completed = agreement.copyWith(
      workCompletedConfirmed: true,
      status: AgreementStatus.completed,
    );
    _byProposalId[agreement.proposalId] = completed;
    _byId[agreement.id] = completed;
    return completed;
  }

  @override
  Future<PayoutAccount?> getPayoutAccount() async => _payoutAccount;

  @override
  Future<PayoutAccount> savePayoutAccount({
    required String bankName,
    required String accountType,
    required String accountNumberLast4,
    required String holderName,
    required String documentNumberLast4,
  }) async {
    final saved = PayoutAccount(
      id: _payoutAccount?.id ?? 'payout-local-1',
      contractorId: 'contractor-local',
      bankName: bankName,
      accountType: accountType,
      accountNumberLast4: accountNumberLast4,
      holderName: holderName,
      documentNumberLast4: documentNumberLast4,
      verificationStatus: 'pending',
      createdAt: _payoutAccount?.createdAt ?? DateTime.now(),
    );
    _payoutAccount = saved;
    return saved;
  }
}
