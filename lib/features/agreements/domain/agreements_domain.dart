import '../../../core/models/models.dart';

enum SimulatedPaymentMethod {
  pse('PSE · Débito bancario (Simulado)'),
  card('Tarjeta débito o crédito (Simulado)'),
  nequi('Nequi / Bancolombia (Simulado)');

  const SimulatedPaymentMethod(this.label);
  final String label;
}

enum SimulatedPaymentStatus { pending, approved, rejected }

class WorkAgreement {
  const WorkAgreement({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.proposalId,
    required this.contractorName,
    required this.laborAmountCop,
    required this.materialsAmountCop,
    required this.estimatedDays,
    required this.milestones,
    this.clientAcceptedTerms = false,
    this.selectedMethod = SimulatedPaymentMethod.pse,
    this.paymentStatus = SimulatedPaymentStatus.pending,
    this.workCompletedConfirmed = false,
    this.receiptCode,
  });

  final String id;
  final String projectId;
  final String projectTitle;
  final String proposalId;
  final String contractorName;
  final int laborAmountCop;
  final int materialsAmountCop;
  final int estimatedDays;
  final List<String> milestones;
  final bool clientAcceptedTerms;
  final SimulatedPaymentMethod selectedMethod;
  final SimulatedPaymentStatus paymentStatus;
  final bool workCompletedConfirmed;
  final String? receiptCode;

  int get totalAmountCop => laborAmountCop + materialsAmountCop;

  WorkAgreement copyWith({
    bool? clientAcceptedTerms,
    SimulatedPaymentMethod? selectedMethod,
    SimulatedPaymentStatus? paymentStatus,
    bool? workCompletedConfirmed,
    String? receiptCode,
  }) {
    return WorkAgreement(
      id: id,
      projectId: projectId,
      projectTitle: projectTitle,
      proposalId: proposalId,
      contractorName: contractorName,
      laborAmountCop: laborAmountCop,
      materialsAmountCop: materialsAmountCop,
      estimatedDays: estimatedDays,
      milestones: milestones,
      clientAcceptedTerms: clientAcceptedTerms ?? this.clientAcceptedTerms,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      workCompletedConfirmed:
          workCompletedConfirmed ?? this.workCompletedConfirmed,
      receiptCode: receiptCode ?? this.receiptCode,
    );
  }
}

class AgreementFailure implements Exception {
  const AgreementFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract interface class AgreementRepository {
  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  });

  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    bool simulateFailure = false,
  });

  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement);
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

class ProcessSimulatedPaymentUseCase {
  const ProcessSimulatedPaymentUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call({
    required WorkAgreement agreement,
    bool simulateFailure = false,
  }) async {
    if (!agreement.clientAcceptedTerms) {
      throw const AgreementFailure(
        'Debes confirmar los términos del acuerdo antes de continuar al pago simulado.',
      );
    }
    return _repository.processSimulatedPayment(
      agreement: agreement,
      simulateFailure: simulateFailure,
    );
  }
}

class ConfirmWorkCompletionUseCase {
  const ConfirmWorkCompletionUseCase(this._repository);
  final AgreementRepository _repository;

  Future<WorkAgreement> call(WorkAgreement agreement) async {
    if (agreement.paymentStatus != SimulatedPaymentStatus.approved) {
      throw const AgreementFailure(
        'El pago simulado debe estar aprobado para confirmar la entrega.',
      );
    }
    return _repository.confirmWorkCompletion(agreement);
  }
}
