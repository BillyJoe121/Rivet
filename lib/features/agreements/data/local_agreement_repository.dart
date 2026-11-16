import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';

class LocalAgreementRepository implements AgreementRepository {
  final Map<String, WorkAgreement> _byProposalId = {};

  @override
  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  }) async {
    final existing = _byProposalId[proposal.id];
    if (existing != null) return existing;

    final created = WorkAgreement(
      id: 'agr-${proposal.id}',
      projectId: projectId,
      projectTitle: projectTitle,
      proposalId: proposal.id,
      contractorName: proposal.contractor.name,
      laborAmountCop: proposal.laborCostCop,
      materialsAmountCop: proposal.materialsCostCop,
      estimatedDays: proposal.estimatedDays,
      milestones: const [
        'Hito 1 · Alistamiento, protección de pisos y resanes de superficies',
        'Hito 2 · Aplicación de estuco plástico y lijado uniforme',
        'Hito 3 · Dos manos de pintura, revisión conjunta y entrega limpia',
      ],
    );
    _byProposalId[proposal.id] = created;
    return created;
  }

  @override
  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    bool simulateFailure = false,
  }) async {
    if (simulateFailure) {
      final rejected = agreement.copyWith(
        paymentStatus: SimulatedPaymentStatus.rejected,
      );
      _byProposalId[agreement.proposalId] = rejected;
      throw const AgreementFailure(
        'Pago simulado rechazado en la prueba. Puedes reintentar con otro método.',
      );
    }
    final approved = agreement.copyWith(
      paymentStatus: SimulatedPaymentStatus.approved,
      receiptCode:
          'SIM-${agreement.proposalId.toUpperCase()}-${DateTime.now().millisecond}',
    );
    _byProposalId[agreement.proposalId] = approved;
    return approved;
  }

  @override
  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement) async {
    final completed = agreement.copyWith(workCompletedConfirmed: true);
    _byProposalId[agreement.proposalId] = completed;
    return completed;
  }
}
