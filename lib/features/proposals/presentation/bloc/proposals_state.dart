import '../../../../core/models/models.dart';

enum ProposalsStatus { initial, loading, success, failure }

/// Estado del bloque de propuestas.
class ProposalsState {
  const ProposalsState({
    this.status = ProposalsStatus.initial,
    this.proposals = const [],
    this.projectTitles = const {},
    this.acceptedProposalId,
    this.errorMessage,
    this.isSubmitting = false,
  });

  final ProposalsStatus status;
  final List<Proposal> proposals;
  final Map<String, String> projectTitles;
  final String? acceptedProposalId;
  final String? errorMessage;

  /// Hay una aceptación en curso; la información ya cargada sigue visible.
  final bool isSubmitting;

  /// Todavía no hay datos que mostrar: aún no se pidió o se están cargando.
  bool get isWaiting =>
      status == ProposalsStatus.initial || status == ProposalsStatus.loading;

  bool get isLoading => status == ProposalsStatus.loading;
  bool get isSuccess => status == ProposalsStatus.success;
  bool get isFailure => status == ProposalsStatus.failure;

  ProposalsState copyWith({
    ProposalsStatus? status,
    List<Proposal>? proposals,
    Map<String, String>? projectTitles,
    String? acceptedProposalId,
    String? errorMessage,
    bool? isSubmitting,
    bool clearError = false,
  }) {
    return ProposalsState(
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
      projectTitles: projectTitles ?? this.projectTitles,
      acceptedProposalId: acceptedProposalId ?? this.acceptedProposalId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

