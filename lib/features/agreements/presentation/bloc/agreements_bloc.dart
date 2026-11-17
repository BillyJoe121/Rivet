import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/models.dart';
import '../../domain/agreements_domain.dart';

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

final class LoadAgreementById extends AgreementsEvent {
  const LoadAgreementById(this.agreementId);
  final String agreementId;
}

final class ToggleAgreementTermsAccepted extends AgreementsEvent {
  const ToggleAgreementTermsAccepted(this.accepted);
  final bool accepted;
}

final class AcceptAgreementRequested extends AgreementsEvent {
  const AcceptAgreementRequested({required this.asClient});
  final bool asClient;
}

final class SelectSimulatedPaymentMethod extends AgreementsEvent {
  const SelectSimulatedPaymentMethod(this.method);
  final SimulatedPaymentMethod method;
}

final class SubmitSimulatedPayment extends AgreementsEvent {
  const SubmitSimulatedPayment({
    this.cardBrand,
    this.cardLast4,
    this.simulateFailure = false,
  });

  final String? cardBrand;
  final String? cardLast4;
  final bool simulateFailure;
}

final class ConfirmWorkCompletedRequested extends AgreementsEvent {
  const ConfirmWorkCompletedRequested();
}

enum AgreementsStatus { initial, loading, success, failure }

class AgreementsState {
  const AgreementsState({
    this.status = AgreementsStatus.initial,
    this.agreement,
    this.errorMessage,
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
    this.isAccepting = false,
    this.isProcessingPayment = false,
    this.hasPaymentResult = false,
  });

  final AgreementsStatus status;
  final WorkAgreement? agreement;
  final String? errorMessage;
  final bool isSessionExpired;
  final bool isPermissionDenied;
  final bool isAccepting;
  final bool isProcessingPayment;
  final bool hasPaymentResult;

  bool get isLoading => status == AgreementsStatus.loading;

  AgreementsState copyWith({
    AgreementsStatus? status,
    WorkAgreement? agreement,
    String? errorMessage,
    bool clearError = false,
    bool? isSessionExpired,
    bool? isPermissionDenied,
    bool? isAccepting,
    bool? isProcessingPayment,
    bool? hasPaymentResult,
  }) {
    return AgreementsState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearError ? false : (isSessionExpired ?? this.isSessionExpired),
      isPermissionDenied:
          clearError ? false : (isPermissionDenied ?? this.isPermissionDenied),
      isAccepting: isAccepting ?? this.isAccepting,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      hasPaymentResult: hasPaymentResult ?? this.hasPaymentResult,
    );
  }
}

class AgreementsBloc extends Bloc<AgreementsEvent, AgreementsState> {
  AgreementsBloc(
    this._prepareAgreementUseCase,
    this._acceptAgreementUseCase,
    this._processSimulatedPaymentUseCase,
    this._confirmWorkCompletionUseCase,
    this._repository,
  ) : super(const AgreementsState()) {
    on<PrepareAgreementRequested>(_onPrepare);
    on<LoadAgreementById>(_onLoadById);
    on<ToggleAgreementTermsAccepted>(_onToggleTerms);
    on<AcceptAgreementRequested>(_onAccept);
    on<SelectSimulatedPaymentMethod>(_onSelectMethod);
    on<SubmitSimulatedPayment>(_onSubmitPayment);
    on<ConfirmWorkCompletedRequested>(_onConfirmWorkCompleted);
  }

  factory AgreementsBloc.fromRepository(AgreementRepository repository) {
    return AgreementsBloc(
      PrepareAgreementUseCase(repository),
      AcceptAgreementUseCase(repository),
      ProcessSimulatedPaymentUseCase(repository),
      ConfirmWorkCompletionUseCase(repository),
      repository,
    );
  }

  final PrepareAgreementUseCase _prepareAgreementUseCase;
  final AcceptAgreementUseCase _acceptAgreementUseCase;
  final ProcessSimulatedPaymentUseCase _processSimulatedPaymentUseCase;
  final ConfirmWorkCompletionUseCase _confirmWorkCompletionUseCase;
  final AgreementRepository _repository;

  AgreementsState _failureState(Object error, {bool isAccepting = false, bool isProcessingPayment = false, bool hasPaymentResult = false}) {
    if (error is AgreementFailure) {
      return state.copyWith(
        status: AgreementsStatus.failure,
        errorMessage: error.message,
        isSessionExpired: error.isSessionExpired,
        isPermissionDenied: error.isPermissionDenied,
        isAccepting: isAccepting,
        isProcessingPayment: isProcessingPayment,
        hasPaymentResult: hasPaymentResult,
      );
    }
    return state.copyWith(
      status: AgreementsStatus.failure,
      errorMessage: error.toString().replaceFirst('Exception: ', ''),
      isAccepting: isAccepting,
      isProcessingPayment: isProcessingPayment,
      hasPaymentResult: hasPaymentResult,
    );
  }

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
          status: AgreementsStatus.success,
          agreement: agreement,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
    }
  }

  Future<void> _onLoadById(
    LoadAgreementById event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(state.copyWith(status: AgreementsStatus.loading, clearError: true));
    try {
      final agreement = await _repository.getAgreementById(event.agreementId);
      emit(
        state.copyWith(
          status: AgreementsStatus.success,
          agreement: agreement,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
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
        status: AgreementsStatus.success,
        agreement: current.copyWith(clientAcceptedTerms: event.accepted),
        clearError: true,
        hasPaymentResult: false,
      ),
    );
  }

  Future<void> _onAccept(
    AcceptAgreementRequested event,
    Emitter<AgreementsState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(state.copyWith(isAccepting: true, clearError: true));
    try {
      final updated = await _acceptAgreementUseCase(
        agreementId: current.id,
        asClient: event.asClient,
      );
      emit(
        state.copyWith(
          status: AgreementsStatus.success,
          agreement: updated,
          isAccepting: false,
        ),
      );
    } catch (e) {
      emit(_failureState(e, isAccepting: false));
    }
  }

  void _onSelectMethod(
    SelectSimulatedPaymentMethod event,
    Emitter<AgreementsState> emit,
  ) {
    final current = state.agreement;
    if (current == null) return;
    emit(
      state.copyWith(
        status: AgreementsStatus.success,
        agreement: current.copyWith(selectedMethod: event.method),
        clearError: true,
        hasPaymentResult: false,
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
        isProcessingPayment: true,
        hasPaymentResult: false,
        clearError: true,
      ),
    );
    try {
      final updated = await _processSimulatedPaymentUseCase(
        agreement: current,
        cardBrand: event.cardBrand,
        cardLast4: event.cardLast4,
        simulateFailure: event.simulateFailure,
      );
      emit(
        state.copyWith(
          status: AgreementsStatus.success,
          agreement: updated,
          isProcessingPayment: false,
          hasPaymentResult: true,
        ),
      );
    } catch (e) {
      emit(
        _failureState(
          e,
          isProcessingPayment: false,
          hasPaymentResult: true,
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
    emit(state.copyWith(status: AgreementsStatus.loading, clearError: true));
    try {
      final updated = await _confirmWorkCompletionUseCase(current);
      emit(
        state.copyWith(
          status: AgreementsStatus.success,
          agreement: updated,
          hasPaymentResult: false,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
    }
  }
}
