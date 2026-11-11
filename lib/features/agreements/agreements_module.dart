import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';

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

abstract class AgreementRepository {
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

sealed class AgreementsEvent {
  const AgreementsEvent();
}

final class PrepareAgreementRequested extends AgreementsEvent {
  const PrepareAgreementRequested({
    required this.projectId,
    required this.projectTitle,
    required this.proposal,
  });

  final String projectId;
  final String projectTitle;
  final Proposal proposal;
}

final class ToggleAgreementTermsAccepted extends AgreementsEvent {
  const ToggleAgreementTermsAccepted(this.accepted);
  final bool accepted;
}

final class SelectSimulatedPaymentMethod extends AgreementsEvent {
  const SelectSimulatedPaymentMethod(this.method);
  final SimulatedPaymentMethod method;
}

final class SubmitSimulatedPayment extends AgreementsEvent {
  const SubmitSimulatedPayment({this.simulateFailure = false});
  final bool simulateFailure;
}

final class ConfirmWorkCompletedRequested extends AgreementsEvent {
  const ConfirmWorkCompletedRequested();
}

enum AgreementsStatus {
  initial,
  loading,
  ready,
  processingPayment,
  paymentSuccess,
  paymentFailed,
  workCompleted,
}

class AgreementsState {
  const AgreementsState({
    this.status = AgreementsStatus.initial,
    this.agreement,
    this.errorMessage,
  });

  final AgreementsStatus status;
  final WorkAgreement? agreement;
  final String? errorMessage;

  bool get isLoading => status == AgreementsStatus.loading;
  bool get isProcessingPayment => status == AgreementsStatus.processingPayment;

  AgreementsState copyWith({
    AgreementsStatus? status,
    WorkAgreement? agreement,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AgreementsState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AgreementsBloc extends Bloc<AgreementsEvent, AgreementsState> {
  AgreementsBloc(
    this._prepareAgreementUseCase,
    this._processSimulatedPaymentUseCase,
    this._confirmWorkCompletionUseCase,
  ) : super(const AgreementsState()) {
    on<PrepareAgreementRequested>(_onPrepare);
    on<ToggleAgreementTermsAccepted>(_onToggleTerms);
    on<SelectSimulatedPaymentMethod>(_onSelectMethod);
    on<SubmitSimulatedPayment>(_onSubmitPayment);
    on<ConfirmWorkCompletedRequested>(_onConfirmWorkCompleted);
  }

  final PrepareAgreementUseCase _prepareAgreementUseCase;
  final ProcessSimulatedPaymentUseCase _processSimulatedPaymentUseCase;
  final ConfirmWorkCompletionUseCase _confirmWorkCompletionUseCase;

  Future<void> _onPrepare(
    PrepareAgreementRequested event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(state.copyWith(status: AgreementsStatus.loading, clearError: true));
    try {
      final agreement = await _prepareAgreementUseCase(
        projectId: event.projectId,
        projectTitle: event.projectTitle,
        proposal: event.proposal,
      );
      emit(
        state.copyWith(
          status: AgreementsStatus.ready,
          agreement: agreement,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: AgreementsStatus.paymentFailed,
          errorMessage: clean,
        ),
      );
    }
  }

  void _onToggleTerms(
    ToggleAgreementTermsAccepted event,
    Emitter<AgreementsState> emit,
  ) {
    final current = state.agreement;
    if (current == null) return;
    emit(
      state.copyWith(
        status: AgreementsStatus.ready,
        agreement: current.copyWith(clientAcceptedTerms: event.accepted),
        clearError: true,
      ),
    );
  }

  void _onSelectMethod(
    SelectSimulatedPaymentMethod event,
    Emitter<AgreementsState> emit,
  ) {
    final current = state.agreement;
    if (current == null) return;
    emit(
      state.copyWith(
        status: AgreementsStatus.ready,
        agreement: current.copyWith(selectedMethod: event.method),
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitPayment(
    SubmitSimulatedPayment event,
    Emitter<AgreementsState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(
      state.copyWith(
        status: AgreementsStatus.processingPayment,
        clearError: true,
      ),
    );
    try {
      final updated = await _processSimulatedPaymentUseCase(
        agreement: current,
        simulateFailure: event.simulateFailure,
      );
      emit(
        state.copyWith(
          status: AgreementsStatus.paymentSuccess,
          agreement: updated,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: AgreementsStatus.paymentFailed,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onConfirmWorkCompleted(
    ConfirmWorkCompletedRequested event,
    Emitter<AgreementsState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    try {
      final updated = await _confirmWorkCompletionUseCase(current);
      emit(
        state.copyWith(
          status: AgreementsStatus.workCompleted,
          agreement: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: AgreementsStatus.paymentFailed,
          errorMessage: clean,
        ),
      );
    }
  }
}
