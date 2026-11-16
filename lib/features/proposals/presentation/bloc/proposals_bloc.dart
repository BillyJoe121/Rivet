import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/models.dart';
import '../../domain/errors/proposal_failure.dart';
import '../../domain/repositories/proposal_repository.dart';
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

  /// Arma el Bloc con los casos de uso sobre [repository].
  factory ProposalsBloc.fromRepository(ProposalRepository repository) {
    return ProposalsBloc(
      GetReceivedProposalsUseCase(repository),
      AcceptProposalUseCase(repository),
    );
  }

  static const _genericError =
      'Algo salió mal con las propuestas. Inténtalo de nuevo.';

  final GetReceivedProposalsUseCase _getReceivedProposalsUseCase;
  final AcceptProposalUseCase _acceptProposalUseCase;

  String _messageOf(Object error) =>
      error is ProposalFailure ? error.message : _genericError;

  Future<void> _onLoadProposals(
    LoadReceivedProposals event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(status: ProposalsStatus.loading, clearError: true));
    try {
      final list = await _getReceivedProposalsUseCase(
        projectId: event.projectId,
      );
      emit(state.copyWith(status: ProposalsStatus.success, proposals: list));
    } catch (e) {
      emit(state.copyWith(
        status: ProposalsStatus.failure,
        errorMessage: _messageOf(e),
      ));
    }
  }

  Future<void> _onAcceptProposal(
    AcceptProposalSubmitted event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _acceptProposalUseCase(event.proposalId);
      emit(state.copyWith(
        status: ProposalsStatus.success,
        isSubmitting: false,
        proposals: [
          for (final p in state.proposals)
            p.id == event.proposalId
                ? p.copyWith(status: ProposalStatus.accepted)
                : p,
        ],
        acceptedProposalId: event.proposalId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProposalsStatus.failure,
        isSubmitting: false,
        errorMessage: _messageOf(e),
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
