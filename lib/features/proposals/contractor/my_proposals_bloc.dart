import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../projects/domain/repositories/project_repository.dart';
import '../../projects/domain/usecases/get_open_projects_usecase.dart';
import '../domain/errors/proposal_failure.dart';
import '../domain/repositories/proposal_repository.dart';
import '../domain/usecases/get_my_proposals_usecase.dart';
import '../domain/usecases/withdraw_proposal_usecase.dart';

sealed class MyProposalsEvent {
  const MyProposalsEvent();
}

final class LoadMyProposalsAndJobs extends MyProposalsEvent {
  const LoadMyProposalsAndJobs();
}

final class MyProposalsTabChanged extends MyProposalsEvent {
  const MyProposalsTabChanged(this.tabIndex);
  final int tabIndex;
}

final class WithdrawProposalRequested extends MyProposalsEvent {
  const WithdrawProposalRequested(this.proposalId);
  final String proposalId;
}

enum MyProposalsStatus { initial, loading, success, failure }

class MyProposalsState {
  const MyProposalsState({
    this.status = MyProposalsStatus.initial,
    this.tabIndex = 0,
    this.proposals = const [],
    this.openProjects = const [],
    this.errorMessage,
  });

  final MyProposalsStatus status;
  final int tabIndex;
  final List<Proposal> proposals;
  final List<Project> openProjects;
  final String? errorMessage;

  bool get isLoading => status == MyProposalsStatus.loading;
  bool get isFailure => status == MyProposalsStatus.failure;

  int get draftCount =>
      proposals.where((p) => p.status == ProposalStatus.draft).length;
  int get sentCount =>
      proposals.where((p) => p.status == ProposalStatus.sent).length;
  int get acceptedCount =>
      proposals.where((p) => p.status == ProposalStatus.accepted).length;

  List<Proposal> get activeJobs =>
      proposals.where((p) => p.status == ProposalStatus.accepted).toList();

  Project? projectFor(String projectId) {
    for (final p in openProjects) {
      if (p.id == projectId) return p;
    }
    return null;
  }

  MyProposalsState copyWith({
    MyProposalsStatus? status,
    int? tabIndex,
    List<Proposal>? proposals,
    List<Project>? openProjects,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyProposalsState(
      status: status ?? this.status,
      tabIndex: tabIndex ?? this.tabIndex,
      proposals: proposals ?? this.proposals,
      openProjects: openProjects ?? this.openProjects,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MyProposalsBloc extends Bloc<MyProposalsEvent, MyProposalsState> {
  MyProposalsBloc(
    this._getMyProposalsUseCase,
    this._getOpenProjectsUseCase,
    this._withdrawProposalUseCase, {
    int initialTab = 0,
  }) : super(MyProposalsState(tabIndex: initialTab)) {
    on<LoadMyProposalsAndJobs>(_onLoad);
    on<MyProposalsTabChanged>(_onTabChanged);
    on<WithdrawProposalRequested>(_onWithdraw);
  }

  factory MyProposalsBloc.fromRepositories(
    ProposalRepository proposalRepository,
    ProjectRepository projectRepository, {
    int initialTab = 0,
  }) {
    return MyProposalsBloc(
      GetMyProposalsUseCase(proposalRepository),
      GetOpenProjectsUseCase(projectRepository),
      WithdrawProposalUseCase(proposalRepository),
      initialTab: initialTab,
    );
  }

  final GetMyProposalsUseCase _getMyProposalsUseCase;
  final GetOpenProjectsUseCase _getOpenProjectsUseCase;
  final WithdrawProposalUseCase _withdrawProposalUseCase;

  Future<void> _onLoad(
    LoadMyProposalsAndJobs event,
    Emitter<MyProposalsState> emit,
  ) async {
    emit(state.copyWith(status: MyProposalsStatus.loading, clearError: true));
    try {
      final results = await Future.wait([
        _getMyProposalsUseCase(),
        _getOpenProjectsUseCase(),
      ]);
      emit(
        state.copyWith(
          status: MyProposalsStatus.success,
          proposals: results[0] as List<Proposal>,
          openProjects: results[1] as List<Project>,
        ),
      );
    } catch (e) {
      final message = e is ProposalFailure
          ? e.message
          : 'No pudimos cargar tus propuestas y trabajos. Inténtalo de nuevo.';
      emit(
        state.copyWith(
          status: MyProposalsStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }

  void _onTabChanged(
    MyProposalsTabChanged event,
    Emitter<MyProposalsState> emit,
  ) {
    emit(state.copyWith(tabIndex: event.tabIndex));
  }

  Future<void> _onWithdraw(
    WithdrawProposalRequested event,
    Emitter<MyProposalsState> emit,
  ) async {
    try {
      await _withdrawProposalUseCase(event.proposalId);
      add(const LoadMyProposalsAndJobs());
    } catch (e) {
      final message = e is ProposalFailure
          ? e.message
          : 'No pudimos retirar la propuesta. Inténtalo de nuevo.';
      emit(
        state.copyWith(
          status: MyProposalsStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}
