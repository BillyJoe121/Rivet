import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';
import '../projects/domain/errors/project_failure.dart';
import '../projects/domain/repositories/project_repository.dart';
import '../projects/domain/usecases/get_my_projects_usecase.dart';
import '../proposals/domain/repositories/proposal_repository.dart';
import '../proposals/domain/usecases/get_received_proposals_usecase.dart';

/// Eventos de la pantalla de inicio del cliente.
sealed class ClientHomeEvent {
  const ClientHomeEvent();
}

/// Solicita cargar los proyectos propios y el conteo de propuestas recibidas.
final class LoadClientHome extends ClientHomeEvent {
  const LoadClientHome();
}

enum ClientHomeStatus { initial, loading, success, failure }

/// Estado del inicio del cliente con proyectos reales y conteo de cotizaciones.
class ClientHomeState {
  const ClientHomeState({
    this.status = ClientHomeStatus.initial,
    this.projects = const [],
    this.proposals = const [],
    this.errorMessage,
  });

  final ClientHomeStatus status;
  final List<Project> projects;
  final List<Proposal> proposals;
  final String? errorMessage;

  bool get isLoading => status == ClientHomeStatus.loading;
  bool get isFailure => status == ClientHomeStatus.failure;

  /// Máximo dos proyectos destacados para la vista de resumen.
  List<Project> get featuredProjects => projects.take(2).toList();

  /// Cantidad de propuestas recibidas asociadas a [projectId].
  int proposalCountFor(String projectId) =>
      proposals.where((p) => p.projectId == projectId).length;

  ClientHomeState copyWith({
    ClientHomeStatus? status,
    List<Project>? projects,
    List<Proposal>? proposals,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ClientHomeState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      proposals: proposals ?? this.proposals,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// BLoC que gobierna el inicio del propietario con datos reales de proyectos.
class ClientHomeBloc extends Bloc<ClientHomeEvent, ClientHomeState> {
  ClientHomeBloc(
    this._getMyProjectsUseCase,
    this._getReceivedProposalsUseCase,
  ) : super(const ClientHomeState()) {
    on<LoadClientHome>(_onLoad);
  }

  /// Arma el Bloc directamente desde los repositorios inyectados.
  factory ClientHomeBloc.fromRepositories(
    ProjectRepository projectRepository,
    ProposalRepository proposalRepository,
  ) {
    return ClientHomeBloc(
      GetMyProjectsUseCase(projectRepository),
      GetReceivedProposalsUseCase(proposalRepository),
    );
  }

  final GetMyProjectsUseCase _getMyProjectsUseCase;
  final GetReceivedProposalsUseCase _getReceivedProposalsUseCase;

  Future<void> _onLoad(
    LoadClientHome event,
    Emitter<ClientHomeState> emit,
  ) async {
    emit(state.copyWith(status: ClientHomeStatus.loading, clearError: true));
    try {
      final projects = await _getMyProjectsUseCase();
      var proposals = const <Proposal>[];
      try {
        proposals = await _getReceivedProposalsUseCase();
      } catch (_) {
        // Las propuestas son secundarias para mostrar la lista de proyectos.
      }
      emit(
        state.copyWith(
          status: ClientHomeStatus.success,
          projects: projects,
          proposals: proposals,
        ),
      );
    } catch (e) {
      final message = e is ProjectFailure
          ? e.message
          : 'No pudimos cargar tus proyectos. Inténtalo de nuevo.';
      emit(
        state.copyWith(
          status: ClientHomeStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}
