import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';
import '../domain/closure_domain.dart';
import '../domain/progress_domain.dart';

class LocalAgreementRepository implements AgreementRepository {
  final Map<String, WorkAgreement> _byProposalId = {};
  final Map<String, WorkAgreement> _byId = {};
  final Map<String, List<ProgressUpdate>> _updatesByAgreement = {};
  final Map<String, List<AgreementRating>> _ratingsByAgreement = {};
  final Map<String, List<AgreementCancellation>> _cancellationsByAgreement = {};
  final Map<String, List<PaymentRecord>> _paymentsByAgreement = {};
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

  @override
  Future<List<ProgressUpdate>> getProgressUpdates(String agreementId) async =>
      List<ProgressUpdate>.unmodifiable(
        _updatesByAgreement[agreementId] ?? const [],
      );

  @override
  Future<AgreementMilestone> confirmMilestone({
    required String milestoneId,
    required bool asClient,
  }) async {
    for (final entry in _byId.entries) {
      final idx = entry.value.milestoneItems.indexWhere(
        (m) => m.id == milestoneId,
      );
      if (idx == -1) continue;
      final current = entry.value.milestoneItems[idx];
      final now = DateTime.now();
      final clientAt = asClient ? (current.clientConfirmedAt ?? now) : current.clientConfirmedAt;
      final contractorAt =
          !asClient ? (current.contractorConfirmedAt ?? now) : current.contractorConfirmedAt;
      final updated = current.copyWith(
        clientConfirmedAt: clientAt,
        contractorConfirmedAt: contractorAt,
        isDone: clientAt != null && contractorAt != null,
      );
      final newItems = List<AgreementMilestone>.from(entry.value.milestoneItems)
        ..[idx] = updated;
      final newAgreement = entry.value.copyWith(milestoneItems: newItems);
      _byId[entry.key] = newAgreement;
      _byProposalId[newAgreement.proposalId] = newAgreement;
      return updated;
    }
    throw const AgreementFailure('No encontramos el hito solicitado.');
  }

  @override
  Future<ProgressUpdate> submitProgressUpdate({
    required String agreementId,
    String? milestoneId,
    required int percent,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
    bool asDraft = false,
  }) async {
    final list = _updatesByAgreement.putIfAbsent(agreementId, () => []);
    final update = ProgressUpdate(
      id: 'upd-${list.length + 1}',
      agreementId: agreementId,
      milestoneId: milestoneId,
      authorId: 'contractor-local',
      percent: percent,
      description: description,
      photoPaths: [
        for (var i = 0; i < photos.length; i++)
          '$agreementId/${i}_${photos[i].fileName}',
      ],
      status: asDraft ? 'draft' : 'sent',
      createdAt: DateTime.now(),
    );
    list.insert(0, update);
    return update;
  }

  @override
  Future<List<AgreementRating>> getRatings(String agreementId) async =>
      List<AgreementRating>.unmodifiable(
        _ratingsByAgreement[agreementId] ?? const [],
      );

  @override
  Future<AgreementRating> submitRating({
    required String agreementId,
    required String rateeId,
    required int stars,
    required String review,
  }) async {
    final list = _ratingsByAgreement.putIfAbsent(agreementId, () => []);
    final rating = AgreementRating(
      id: 'rat-${list.length + 1}',
      agreementId: agreementId,
      raterId: 'local-user',
      rateeId: rateeId,
      stars: stars,
      review: review,
      createdAt: DateTime.now(),
    );
    list.insert(0, rating);
    return rating;
  }

  @override
  Future<List<AgreementCancellation>> getCancellations(
    String agreementId,
  ) async =>
      List<AgreementCancellation>.unmodifiable(
        _cancellationsByAgreement[agreementId] ?? const [],
      );

  @override
  Future<AgreementCancellation> requestCancellation({
    required String agreementId,
    required String reason,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
  }) async {
    final list = _cancellationsByAgreement.putIfAbsent(agreementId, () => []);
    final cancellation = AgreementCancellation(
      id: 'can-${list.length + 1}',
      agreementId: agreementId,
      requestedBy: 'local-user',
      reason: reason,
      description: description,
      photoPaths: [
        for (var i = 0; i < photos.length; i++)
          '$agreementId/${i}_${photos[i].fileName}',
      ],
      createdAt: DateTime.now(),
    );
    list.insert(0, cancellation);
    return cancellation;
  }

  @override
  Future<AgreementCancellation> resolveCancellation({
    required String cancellationId,
    required bool approved,
  }) async {
    for (final entry in _cancellationsByAgreement.entries) {
      final idx = entry.value.indexWhere((c) => c.id == cancellationId);
      if (idx == -1) continue;
      final updated = entry.value[idx].copyWith(
        status: approved
            ? CancellationStatus.approved
            : CancellationStatus.rejected,
        resolvedAt: DateTime.now(),
      );
      entry.value[idx] = updated;
      if (approved) {
        final agr = _byId[entry.key];
        if (agr != null) {
          final cancelled = agr.copyWith(status: AgreementStatus.cancelled);
          _byId[entry.key] = cancelled;
          _byProposalId[cancelled.proposalId] = cancelled;
        }
      }
      return updated;
    }
    throw const AgreementFailure('No encontramos la solicitud de cancelación.');
  }

  @override
  Future<List<PaymentRecord>> getPayments(String agreementId) async {
    final existing = _paymentsByAgreement[agreementId];
    if (existing != null) return List<PaymentRecord>.unmodifiable(existing);
    final agr = _byId[agreementId];
    if (agr == null) return const [];
    return [
      PaymentRecord(
        id: 'pay-local-1',
        agreementId: agreementId,
        kind: 'advance',
        amountCop: agr.advanceAmountCop,
        status: agr.paymentStatus,
        cardBrand: agr.cardBrand,
        cardLast4: agr.cardLast4,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<PaymentRecord> releasePayment(String paymentId) async {
    for (final list in _paymentsByAgreement.values) {
      final idx = list.indexWhere((p) => p.id == paymentId);
      if (idx == -1) continue;
      final updated = list[idx].copyWith(
        status: SimulatedPaymentStatus.released,
        releasedAt: DateTime.now(),
      );
      list[idx] = updated;
      return updated;
    }
    return PaymentRecord(
      id: paymentId,
      agreementId: 'local',
      kind: 'advance',
      amountCop: 0,
      status: SimulatedPaymentStatus.released,
      releasedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
}
