import '../../../../core/models/models.dart';
import '../repositories/proposal_repository.dart';

/// Caso de uso: Consultar las cotizaciones recibidas para proyectos del cliente.
class GetReceivedProposalsUseCase {
  const GetReceivedProposalsUseCase(this._repository);

  final ProposalRepository _repository;

  Future<List<Proposal>> call({String? projectId}) {
    return _repository.getReceivedProposals(projectId: projectId);
  }
}

