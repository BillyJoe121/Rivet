import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/models.dart';
import '../../domain/usecases/accept_proposal_usecase.dart';
import '../../domain/usecases/get_received_proposals_usecase.dart';
import 'proposals_event.dart';
import 'proposals_state.dart';

export 'proposals_event.dart';
export 'proposals_state.dart';

/// BLoC que gobierna la consulta y aceptación de cotizaciones.
class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  ProposalsBloc(
    this._getReceivedProposalsUseCase,
    this._acceptProposalUseCase,
  ) : super(const ProposalsState()) {
    on<LoadReceivedProposals>(_onLoadProposals);
    on<AcceptProposalSubmitted>(_onAcceptProposal);
    on<ProposalsErrorDismissed>(_onErrorDismissed);
  }

  final GetReceivedProposalsUseCase _getReceivedProposalsUseCase;
  final AcceptProposalUseCase _acceptProposalUseCase;

  Future<void> _onLoadProposals(
    LoadReceivedProposals event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(status: ProposalsStatus.loading, clearError: true));
    try {
      final list = await _getReceivedProposalsUseCase(projectId: event.projectId);
      emit(state.copyWith(
        status: ProposalsStatus.success,
        proposals: list,
      ));
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ProposalsStatus.failure,
        errorMessage: clean,
      ));
    }
  }

  Future<void> _onAcceptProposal(
    AcceptProposalSubmitted event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(status: ProposalsStatus.loading, clearError: true));
    try {
      await _acceptProposalUseCase(event.proposalId);
      final updated = state.proposals.map((p) {
        if (p.id == event.proposalId) {
          return Proposal(
            id: p.id,
            projectId: p.projectId,
            contractor: p.contractor,
            laborCostCop: p.laborCostCop,
            materialsCostCop: p.materialsCostCop,
            estimatedDays: p.estimatedDays,
            status: 'Aceptada',
            observations: p.observations,
          );
        }
        return p;
      }).toList();

      emit(state.copyWith(
        status: ProposalsStatus.success,
        proposals: updated,
        acceptedProposalId: event.proposalId,
      ));
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: ProposalsStatus.failure,
        errorMessage: clean,
      ));
    }
  }

  void _onErrorDismissed(
    ProposalsErrorDismissed event,
    Emitter<ProposalsState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}

