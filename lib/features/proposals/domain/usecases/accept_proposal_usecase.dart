import '../repositories/proposal_repository.dart';

/// Caso de uso: Aceptación formal de una cotización para iniciar el acuerdo.
class AcceptProposalUseCase {
  const AcceptProposalUseCase(this._repository);

  final ProposalRepository _repository;

  Future<void> call(String proposalId) {
    return _repository.acceptProposal(proposalId);
  }
}

