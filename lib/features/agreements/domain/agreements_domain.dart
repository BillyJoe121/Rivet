import '../../../core/models/models.dart';
import 'progress_domain.dart';

enum AgreementStatus {
  pending('Pendiente de aceptación'),
  active('Activo'),
  completed('Finalizado'),
  cancelled('Cancelado');

  const AgreementStatus(this.label);
  final String label;
}

class AgreementMilestone {
  const AgreementMilestone({
    required this.id,
    required this.agreementId,
    required this.position,
    required this.title,
    this.isDone = false,
    this.clientConfirmedAt,
    this.contractorConfirmedAt,
  });

  final String id;
  final String agreementId;
  final int position;
  final String title;
  final bool isDone;
  final DateTime? clientConfirmedAt;
  final DateTime? contractorConfirmedAt;

  AgreementMilestone copyWith({
    bool? isDone,
    DateTime? clientConfirmedAt,
    DateTime? contractorConfirmedAt,
  }) {
    return AgreementMilestone(
      id: id,
      agreementId: agreementId,
      position: position,
      title: title,
      isDone: isDone ?? this.isDone,
      clientConfirmedAt: clientConfirmedAt ?? this.clientConfirmedAt,
      contractorConfirmedAt:
          contractorConfirmedAt ?? this.contractorConfirmedAt,
    );
  }
}

enum SimulatedPaymentMethod {
  pse('PSE · Débito bancario (Simulado)'),
  card('Tarjeta débito o crédito (Simulado)'),
  nequi('Nequi / Bancolombia (Simulado)');

  const SimulatedPaymentMethod(this.label);
  final String label;
}

enum SimulatedPaymentStatus {
  pending,
  approved,
  rejected,
  held,
  released,
  refunded,
}

class PayoutAccount {
  const PayoutAccount({
    required this.id,
    required this.contractorId,
    required this.bankName,
    required this.accountType,
    required this.accountNumberLast4,
    required this.holderName,
    required this.documentNumberLast4,
    this.verificationStatus = 'pending',
    this.createdAt,
  });

  final String id;
  final String contractorId;
  final String bankName;
  final String accountType;
  final String accountNumberLast4;
  final String holderName;
  final String documentNumberLast4;
  final String verificationStatus;
  final DateTime? createdAt;

  bool get isVerified => verificationStatus == 'verified';
  String get maskedAccountNumber => '•••• $accountNumberLast4';
  String get maskedDocumentNumber => '•••• $documentNumberLast4';
}

class WorkAgreement {
  const WorkAgreement({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.proposalId,
    this.clientId = '',
    this.contractorId = '',
    required this.contractorName,
    this.clientName = '',
    required this.laborAmountCop,
    required this.materialsAmountCop,
    required this.estimatedDays,
    required this.milestones,
    this.milestoneItems = const [],
    this.status = AgreementStatus.pending,
    this.clientAcceptedAt,
    this.contractorAcceptedAt,
    this.clientAcceptedTerms = false,
    this.contractorAcceptedTerms = false,
    this.selectedMethod = SimulatedPaymentMethod.pse,
    this.paymentStatus = SimulatedPaymentStatus.pending,
    this.cardBrand,
    this.cardLast4,
    this.workCompletedConfirmed = false,
    this.receiptCode,
  });

  final String id;
  final String projectId;
  final String projectTitle;
  final String proposalId;
  final String clientId;
  final String contractorId;
  final String contractorName;
  final String clientName;
  final int laborAmountCop;
  final int materialsAmountCop;
  final int estimatedDays;
  final List<String> milestones;
  final List<AgreementMilestone> milestoneItems;
  final AgreementStatus status;
  final DateTime? clientAcceptedAt;
  final DateTime? contractorAcceptedAt;
  final bool clientAcceptedTerms;
  final bool contractorAcceptedTerms;
  final SimulatedPaymentMethod selectedMethod;
  final SimulatedPaymentStatus paymentStatus;
  final String? cardBrand;
  final String? cardLast4;
  final bool workCompletedConfirmed;
  final String? receiptCode;

  int get totalAmountCop => laborAmountCop + materialsAmountCop;
  int get advanceAmountCop => (totalAmountCop * 0.5).round();
  bool get isMutuallyAccepted =>
      clientAcceptedAt != null && contractorAcceptedAt != null;
  bool get isPaymentApproved =>
      paymentStatus == SimulatedPaymentStatus.approved ||
      paymentStatus == SimulatedPaymentStatus.held ||
      paymentStatus == SimulatedPaymentStatus.released;

  WorkAgreement copyWith({
    String? projectTitle,
    String? clientId,
    String? contractorId,
    String? contractorName,
    String? clientName,
    List<String>? milestones,
    List<AgreementMilestone>? milestoneItems,
    AgreementStatus? status,
    DateTime? clientAcceptedAt,
    DateTime? contractorAcceptedAt,
    bool? clientAcceptedTerms,
    bool? contractorAcceptedTerms,
    SimulatedPaymentMethod? selectedMethod,
    SimulatedPaymentStatus? paymentStatus,
    String? cardBrand,
    String? cardLast4,
    bool? workCompletedConfirmed,
    String? receiptCode,
  }) {
    return WorkAgreement(
      id: id,
      projectId: projectId,
      projectTitle: projectTitle ?? this.projectTitle,
      proposalId: proposalId,
      clientId: clientId ?? this.clientId,
      contractorId: contractorId ?? this.contractorId,
      contractorName: contractorName ?? this.contractorName,
      clientName: clientName ?? this.clientName,
      laborAmountCop: laborAmountCop,
      materialsAmountCop: materialsAmountCop,
      estimatedDays: estimatedDays,
      milestones: milestones ?? this.milestones,
      milestoneItems: milestoneItems ?? this.milestoneItems,
      status: status ?? this.status,
      clientAcceptedAt: clientAcceptedAt ?? this.clientAcceptedAt,
      contractorAcceptedAt: contractorAcceptedAt ?? this.contractorAcceptedAt,
      clientAcceptedTerms: clientAcceptedTerms ?? this.clientAcceptedTerms,
      contractorAcceptedTerms:
          contractorAcceptedTerms ?? this.contractorAcceptedTerms,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cardBrand: cardBrand ?? this.cardBrand,
      cardLast4: cardLast4 ?? this.cardLast4,
      workCompletedConfirmed:
          workCompletedConfirmed ?? this.workCompletedConfirmed,
      receiptCode: receiptCode ?? this.receiptCode,
    );
  }
}

class AgreementFailure implements Exception {
  const AgreementFailure(
    this.message, {
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
  });

  final String message;
  final bool isSessionExpired;
  final bool isPermissionDenied;

  @override
  String toString() => message;
}

abstract interface class AgreementRepository {
  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  });

  Future<WorkAgreement> getAgreementById(String agreementId);

  Future<WorkAgreement?> getAgreementForProject(String projectId);

  Future<List<WorkAgreement>> getMyAgreements();

  Future<WorkAgreement> acceptAgreement({
    required String agreementId,
    required bool asClient,
  });

  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    String? cardBrand,
    String? cardLast4,
    bool simulateFailure = false,
  });

  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement);

  Future<PayoutAccount?> getPayoutAccount();

  Future<PayoutAccount> savePayoutAccount({
    required String bankName,
    required String accountType,
    required String accountNumberLast4,
    required String holderName,
    required String documentNumberLast4,
  });

  Future<List<ProgressUpdate>> getProgressUpdates(String agreementId);

  Future<AgreementMilestone> confirmMilestone({
    required String milestoneId,
    required bool asClient,
  });

  Future<ProgressUpdate> submitProgressUpdate({
    required String agreementId,
    String? milestoneId,
    required int percent,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
    bool asDraft = false,
  });
}

class PrepareAgreementUseCase {
  const PrepareAgreementUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  }) {
    return _repository.prepareAgreement(
      projectId: projectId,
      projectTitle: projectTitle,
      proposal: proposal,
    );
  }
}

class GetMyAgreementsUseCase {
  const GetMyAgreementsUseCase(this._repository);
  final AgreementRepository _repository;

  Future<List<WorkAgreement>> call() => _repository.getMyAgreements();
}

class AcceptAgreementUseCase {
  const AcceptAgreementUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call({
    required String agreementId,
    required bool asClient,
  }) {
    return _repository.acceptAgreement(
      agreementId: agreementId,
      asClient: asClient,
    );
  }
}

class ProcessSimulatedPaymentUseCase {
  const ProcessSimulatedPaymentUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call({
    required WorkAgreement agreement,
    String? cardBrand,
    String? cardLast4,
    bool simulateFailure = false,
  }) async {
    if (!agreement.clientAcceptedTerms && agreement.clientAcceptedAt == null) {
      throw const AgreementFailure(
        'Debes confirmar los términos del acuerdo antes de continuar al pago simulado.',
      );
    }
    if (agreement.selectedMethod == SimulatedPaymentMethod.card &&
        !simulateFailure &&
        (cardLast4 == null || !RegExp(r'^[0-9]{4}$').hasMatch(cardLast4))) {
      throw const AgreementFailure(
        'Ingresa un número de tarjeta de prueba válido para continuar.',
      );
    }
    return _repository.processSimulatedPayment(
      agreement: agreement,
      cardBrand: cardBrand,
      cardLast4: cardLast4,
      simulateFailure: simulateFailure,
    );
  }
}

class ConfirmWorkCompletionUseCase {
  const ConfirmWorkCompletionUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call(WorkAgreement agreement) async {
    if (!agreement.isPaymentApproved) {
      throw const AgreementFailure(
        'El pago simulado debe estar aprobado para confirmar la entrega.',
      );
    }
    return _repository.confirmWorkCompletion(agreement);
  }
}

class GetPayoutAccountUseCase {
  const GetPayoutAccountUseCase(this._repository);
  final AgreementRepository _repository;

  Future<PayoutAccount?> call() => _repository.getPayoutAccount();
}

class SavePayoutAccountUseCase {
  const SavePayoutAccountUseCase(this._repository);
  final AgreementRepository _repository;

  Future<PayoutAccount> call({
    required String bankName,
    required String accountType,
    required String accountNumber,
    required String holderName,
    required String documentNumber,
  }) async {
    final trimmedBank = bankName.trim();
    final trimmedHolder = holderName.trim();
    final accountDigits = accountNumber.replaceAll(RegExp(r'\D'), '');
    final docDigits = documentNumber.replaceAll(RegExp(r'\D'), '');

    if (trimmedBank.isEmpty) {
      throw const AgreementFailure('Selecciona o escribe el nombre del banco.');
    }
    if (accountType != 'ahorros' && accountType != 'corriente') {
      throw const AgreementFailure(
        'El tipo de cuenta debe ser ahorros o corriente.',
      );
    }
    if (trimmedHolder.length < 3) {
      throw const AgreementFailure(
        'Ingresa el nombre completo del titular de la cuenta.',
      );
    }
    if (accountDigits.length < 6) {
      throw const AgreementFailure(
        'El número de cuenta debe tener al menos 6 dígitos.',
      );
    }
    if (docDigits.length < 6) {
      throw const AgreementFailure(
        'El número de documento debe tener al menos 6 dígitos.',
      );
    }

    final accountLast4 = accountDigits.substring(accountDigits.length - 4);
    final docLast4 = docDigits.substring(docDigits.length - 4);

    return _repository.savePayoutAccount(
      bankName: trimmedBank,
      accountType: accountType,
      accountNumberLast4: accountLast4,
      holderName: trimmedHolder,
      documentNumberLast4: docLast4,
    );
  }
}
