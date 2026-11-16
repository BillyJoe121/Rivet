import '../repositories/proposal_repository.dart';

/// Retira una propuesta enviada por el contratista actual.
class WithdrawProposalUseCase {
  const WithdrawProposalUseCase(this._repository);
  final ProposalRepository _repository;

  Future<void> call(String proposalId) =>
      _repository.withdrawProposal(proposalId);
}
