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

enum AgreementsStatus { initial, loading, success, failure }

class AgreementsState {
  const AgreementsState({
    this.status = AgreementsStatus.initial,
    this.agreement,
    this.errorMessage,
    this.isProcessingPayment = false,
    this.hasPaymentResult = false,
  });

  final AgreementsStatus status;
  final WorkAgreement? agreement;
  final String? errorMessage;
  final bool isProcessingPayment;
  final bool hasPaymentResult;

  bool get isLoading => status == AgreementsStatus.loading;

  AgreementsState copyWith({
    AgreementsStatus? status,
    WorkAgreement? agreement,
    String? errorMessage,
    bool clearError = false,
    bool? isProcessingPayment,
    bool? hasPaymentResult,
  }) {
    return AgreementsState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      hasPaymentResult: hasPaymentResult ?? this.hasPaymentResult,
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

  factory AgreementsBloc.fromRepository(AgreementRepository repository) {
    return AgreementsBloc(
      PrepareAgreementUseCase(repository),
      ProcessSimulatedPaymentUseCase(repository),
      ConfirmWorkCompletionUseCase(repository),
    );
  }

  final PrepareAgreementUseCase _prepareAgreementUseCase;
  final ProcessSimulatedPaymentUseCase _processSimulatedPaymentUseCase;
  final ConfirmWorkCompletionUseCase _confirmWorkCompletionUseCase;

  String _cleanError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

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
      emit(
        state.copyWith(
          status: AgreementsStatus.failure,
          errorMessage: _cleanError(e),
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
        status: AgreementsStatus.success,
        agreement: current.copyWith(clientAcceptedTerms: event.accepted),
        clearError: true,
        hasPaymentResult: false,
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
        state.copyWith(
          status: AgreementsStatus.failure,
          errorMessage: _cleanError(e),
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
    try {
      final updated = await _confirmWorkCompletionUseCase(current);
      emit(
        state.copyWith(
          status: AgreementsStatus.success,
          agreement: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AgreementsStatus.failure,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }
}
