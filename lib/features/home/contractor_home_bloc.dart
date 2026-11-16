import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';
import '../projects/domain/errors/project_failure.dart';
import '../projects/domain/repositories/project_repository.dart';
import '../projects/domain/usecases/get_open_projects_usecase.dart';
import '../proposals/domain/errors/proposal_failure.dart';
import '../proposals/domain/repositories/proposal_repository.dart';
import '../proposals/domain/usecases/get_my_proposals_usecase.dart';

sealed class ContractorHomeEvent {
  const ContractorHomeEvent();
}

final class LoadContractorHome extends ContractorHomeEvent {
  const LoadContractorHome();
}

enum ContractorHomeStatus { initial, loading, success, failure }

class ContractorHomeState {
  const ContractorHomeState({
    this.status = ContractorHomeStatus.initial,
    this.openProjects = const [],
    this.myProposals = const [],
    this.errorMessage,
  });

  final ContractorHomeStatus status;
  final List<Project> openProjects;
  final List<Proposal> myProposals;
  final String? errorMessage;

  bool get isLoading => status == ContractorHomeStatus.loading;
  bool get isFailure => status == ContractorHomeStatus.failure;

  Project? get featuredProject =>
      openProjects.isNotEmpty ? openProjects.first : null;

  Proposal? get activeProposal {
    for (final p in myProposals) {
      if (p.status == ProposalStatus.accepted) return p;
    }
    return null;
  }

  int get pendingProposalsCount =>
      myProposals.where((p) => p.status == ProposalStatus.sent).length;

  ContractorHomeState copyWith({
    ContractorHomeStatus? status,
    List<Project>? openProjects,
    List<Proposal>? myProposals,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ContractorHomeState(
      status: status ?? this.status,
      openProjects: openProjects ?? this.openProjects,
      myProposals: myProposals ?? this.myProposals,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ContractorHomeBloc
    extends Bloc<ContractorHomeEvent, ContractorHomeState> {
  ContractorHomeBloc(
    this._getOpenProjectsUseCase,
    this._getMyProposalsUseCase,
  ) : super(const ContractorHomeState()) {
    on<LoadContractorHome>(_onLoad);
  }

  factory ContractorHomeBloc.fromRepositories(
    ProjectRepository projectRepository,
    ProposalRepository proposalRepository,
  ) {
    return ContractorHomeBloc(
      GetOpenProjectsUseCase(projectRepository),
      GetMyProposalsUseCase(proposalRepository),
    );
  }

  final GetOpenProjectsUseCase _getOpenProjectsUseCase;
  final GetMyProposalsUseCase _getMyProposalsUseCase;

  Future<void> _onLoad(
    LoadContractorHome event,
    Emitter<ContractorHomeState> emit,
  ) async {
    emit(state.copyWith(status: ContractorHomeStatus.loading, clearError: true));
    try {
      final results = await Future.wait([
        _getOpenProjectsUseCase(),
        _getMyProposalsUseCase(),
      ]);
      emit(
        state.copyWith(
          status: ContractorHomeStatus.success,
          openProjects: results[0] as List<Project>,
          myProposals: results[1] as List<Proposal>,
        ),
      );
    } catch (e) {
      final message = switch (e) {
        ProjectFailure(:final message) => message,
        ProposalFailure(:final message) => message,
        _ => 'No pudimos cargar tu inicio. Inténtalo de nuevo.',
      };
      emit(
        state.copyWith(
          status: ContractorHomeStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}
