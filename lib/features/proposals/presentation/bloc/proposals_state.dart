import '../../../../core/models/models.dart';

enum ProposalsStatus { initial, loading, success, failure }

/// Estado del bloque de propuestas.
class ProposalsState {
  const ProposalsState({
    this.status = ProposalsStatus.initial,
    this.proposals = const [],
    this.acceptedProposalId,
    this.errorMessage,
  });

  final ProposalsStatus status;
  final List<Proposal> proposals;
  final String? acceptedProposalId;
  final String? errorMessage;

  bool get isLoading => status == ProposalsStatus.loading;
  bool get isSuccess => status == ProposalsStatus.success;
  bool get isFailure => status == ProposalsStatus.failure;

  ProposalsState copyWith({
    ProposalsStatus? status,
    List<Proposal>? proposals,
    String? acceptedProposalId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProposalsState(
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
      acceptedProposalId: acceptedProposalId ?? this.acceptedProposalId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

