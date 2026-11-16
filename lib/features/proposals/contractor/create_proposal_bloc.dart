import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../domain/errors/proposal_failure.dart';
import '../domain/repositories/proposal_repository.dart';
import '../domain/usecases/save_proposal_usecase.dart';

sealed class CreateProposalEvent {
  const CreateProposalEvent();
}

final class CreateProposalStepChanged extends CreateProposalEvent {
  const CreateProposalStepChanged(this.step);
  final int step;
}

final class CreateProposalLaborChanged extends CreateProposalEvent {
  const CreateProposalLaborChanged(this.amountCop);
  final int amountCop;
}

final class CreateProposalDaysChanged extends CreateProposalEvent {
  const CreateProposalDaysChanged(this.days);
  final int days;
}

final class CreateProposalMaterialsChanged extends CreateProposalEvent {
  const CreateProposalMaterialsChanged(this.amountCop);
  final int amountCop;
}

final class CreateProposalObservationsChanged extends CreateProposalEvent {
  const CreateProposalObservationsChanged(this.observations);
  final String observations;
}

final class SaveProposalSubmitted extends CreateProposalEvent {
  const SaveProposalSubmitted(this.status);
  final ProposalStatus status;
}

enum CreateProposalStatus { initial, loading, success, failure }

class CreateProposalState {
  const CreateProposalState({
    this.status = CreateProposalStatus.initial,
    this.step = 0,
    this.proposalId,
    required this.projectId,
    this.laborCostCop = 0,
    this.materialsCostCop = 0,
    this.estimatedDays = 3,
    this.observations = '',
    this.savedProposal,
    this.errorMessage,
  });

  final CreateProposalStatus status;
  final int step;
  final String? proposalId;
  final String projectId;
  final int laborCostCop;
  final int materialsCostCop;
  final int estimatedDays;
  final String observations;
  final Proposal? savedProposal;
  final String? errorMessage;

  bool get isLoading => status == CreateProposalStatus.loading;
  bool get isSuccess => status == CreateProposalStatus.success;
  bool get isFailure => status == CreateProposalStatus.failure;
  int get totalCostCop => laborCostCop + materialsCostCop;

  CreateProposalState copyWith({
    CreateProposalStatus? status,
    int? step,
    String? proposalId,
    int? laborCostCop,
    int? materialsCostCop,
    int? estimatedDays,
    String? observations,
    Proposal? savedProposal,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateProposalState(
      status: status ?? this.status,
      step: step ?? this.step,
      proposalId: proposalId ?? this.proposalId,
      projectId: projectId,
      laborCostCop: laborCostCop ?? this.laborCostCop,
      materialsCostCop: materialsCostCop ?? this.materialsCostCop,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      observations: observations ?? this.observations,
      savedProposal: savedProposal ?? this.savedProposal,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CreateProposalBloc
    extends Bloc<CreateProposalEvent, CreateProposalState> {
  CreateProposalBloc(
    this._saveProposalUseCase, {
    required String projectId,
    Proposal? initialProposal,
  }) : super(
         CreateProposalState(
           projectId: projectId,
           proposalId: initialProposal?.id,
           laborCostCop: initialProposal?.laborCostCop ?? 0,
           materialsCostCop: initialProposal?.materialsCostCop ?? 0,
           estimatedDays: initialProposal?.estimatedDays ?? 3,
           observations: initialProposal?.observations ?? '',
         ),
       ) {
    on<CreateProposalStepChanged>(_onStepChanged);
    on<CreateProposalLaborChanged>(_onLaborChanged);
    on<CreateProposalDaysChanged>(_onDaysChanged);
    on<CreateProposalMaterialsChanged>(_onMaterialsChanged);
    on<CreateProposalObservationsChanged>(_onObservationsChanged);
    on<SaveProposalSubmitted>(_onSaveSubmitted);
  }

  factory CreateProposalBloc.fromRepository(
    ProposalRepository repository, {
    required String projectId,
    Proposal? initialProposal,
  }) {
    return CreateProposalBloc(
      SaveProposalUseCase(repository),
      projectId: projectId,
      initialProposal: initialProposal,
    );
  }

  final SaveProposalUseCase _saveProposalUseCase;

  void _onStepChanged(
    CreateProposalStepChanged event,
    Emitter<CreateProposalState> emit,
  ) {
    emit(state.copyWith(step: event.step.clamp(0, 2), clearError: true));
  }

  void _onLaborChanged(
    CreateProposalLaborChanged event,
    Emitter<CreateProposalState> emit,
  ) {
    emit(state.copyWith(laborCostCop: event.amountCop, clearError: true));
  }

  void _onDaysChanged(
    CreateProposalDaysChanged event,
    Emitter<CreateProposalState> emit,
  ) {
    emit(state.copyWith(estimatedDays: event.days, clearError: true));
  }

  void _onMaterialsChanged(
    CreateProposalMaterialsChanged event,
    Emitter<CreateProposalState> emit,
  ) {
    emit(state.copyWith(materialsCostCop: event.amountCop, clearError: true));
  }

  void _onObservationsChanged(
    CreateProposalObservationsChanged event,
    Emitter<CreateProposalState> emit,
  ) {
    emit(state.copyWith(observations: event.observations, clearError: true));
  }

  Future<void> _onSaveSubmitted(
    SaveProposalSubmitted event,
    Emitter<CreateProposalState> emit,
  ) async {
    emit(
      state.copyWith(status: CreateProposalStatus.loading, clearError: true),
    );
    try {
      final saved = await _saveProposalUseCase(
        proposalId: state.proposalId,
        projectId: state.projectId,
        laborCostCop: state.laborCostCop,
        materialsCostCop: state.materialsCostCop,
        estimatedDays: state.estimatedDays,
        observations: state.observations,
        status: event.status,
      );
      emit(
        state.copyWith(
          status: CreateProposalStatus.success,
          proposalId: saved.id,
          savedProposal: saved,
        ),
      );
    } catch (e) {
      final message = e is ProposalFailure
          ? e.message
          : 'No pudimos guardar tu propuesta. Inténtalo de nuevo.';
      emit(
        state.copyWith(
          status: CreateProposalStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}
