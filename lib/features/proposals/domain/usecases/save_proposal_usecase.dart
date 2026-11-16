import '../../../../core/models/models.dart';
import '../errors/proposal_failure.dart';
import '../repositories/proposal_repository.dart';

/// Guarda un borrador o envía una propuesta de obra.
class SaveProposalUseCase {
  const SaveProposalUseCase(this._repository);
  final ProposalRepository _repository;

  Future<Proposal> call({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  }) async {
    if (status == ProposalStatus.sent) {
      if (laborCostCop <= 0) {
        throw const ProposalFailure(
          'Ingresa el valor de la mano de obra para enviar la propuesta.',
        );
      }
      if (estimatedDays <= 0) {
        throw const ProposalFailure(
          'Ingresa la duración estimada en días hábiles.',
        );
      }
    }
    return _repository.saveProposal(
      proposalId: proposalId,
      projectId: projectId,
      laborCostCop: laborCostCop,
      materialsCostCop: materialsCostCop,
      estimatedDays: estimatedDays <= 0 ? 1 : estimatedDays,
      observations: observations.trim(),
      status: status,
    );
  }
}
