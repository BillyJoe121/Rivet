import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/models.dart';
import '../../../projects/domain/repositories/project_repository.dart';
import '../../../projects/domain/usecases/get_my_projects_usecase.dart';
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
    this._acceptProposalUseCase, [
    this._getMyProjectsUseCase,
  ]) : super(const ProposalsState()) {
    on<LoadReceivedProposals>(_onLoadProposals);
    on<AcceptProposalSubmitted>(_onAcceptProposal);
    on<ProposalsErrorDismissed>(_onErrorDismissed);
  }

  /// Arma el Bloc con los casos de uso sobre [repository].
  factory ProposalsBloc.fromRepository(
    ProposalRepository repository, {
    ProjectRepository? projectRepository,
  }) {
    return ProposalsBloc(
      GetReceivedProposalsUseCase(repository),
      AcceptProposalUseCase(repository, projectRepository),
      projectRepository != null
          ? GetMyProjectsUseCase(projectRepository)
          : null,
    );
  }

  static const _genericError =
      'Algo salió mal con las propuestas. Inténtalo de nuevo.';

  final GetReceivedProposalsUseCase _getReceivedProposalsUseCase;
  final AcceptProposalUseCase _acceptProposalUseCase;
  final GetMyProjectsUseCase? _getMyProjectsUseCase;

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
      var projectTitles = state.projectTitles;
      final getProjects = _getMyProjectsUseCase;
      if (getProjects != null) {
        try {
          final projects = await getProjects();
          projectTitles = {
            for (final project in projects) project.id: project.title,
          };
        } catch (_) {
          // Si falla la carga de proyectos, se mantiene el respaldo por ID.
        }
      }
      emit(
        state.copyWith(
          status: ProposalsStatus.success,
          proposals: list,
          projectTitles: projectTitles,
        ),
      );
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
      final accepted = state.proposals
          .where((p) => p.id == event.proposalId)
          .firstOrNull;
      final projectId = accepted?.projectId;
      emit(state.copyWith(
        status: ProposalsStatus.success,
        isSubmitting: false,
        proposals: [
          for (final p in state.proposals)
            if (p.id == event.proposalId)
              p.copyWith(status: ProposalStatus.accepted)
            else if (projectId != null &&
                p.projectId == projectId &&
                p.status == ProposalStatus.sent)
              p.copyWith(status: ProposalStatus.rejected)
            else
              p,
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
