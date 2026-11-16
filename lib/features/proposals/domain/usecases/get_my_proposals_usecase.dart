import '../../../../core/models/models.dart';
import '../repositories/proposal_repository.dart';

/// Obtiene las propuestas del contratista actual.
class GetMyProposalsUseCase {
  const GetMyProposalsUseCase(this._repository);
  final ProposalRepository _repository;

  Future<List<Proposal>> call() => _repository.getMyProposals();
}
