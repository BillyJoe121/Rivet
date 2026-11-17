import '../../../../core/models/models.dart';

/// Contrato del repositorio de propuestas y cotizaciones.
abstract interface class ProposalRepository {
  /// Obtiene todas las propuestas recibidas por el cliente, agrupadas o filtradas.
  Future<List<Proposal>> getReceivedProposals({String? projectId});

  /// Obtiene el detalle de una propuesta por su identificador.
  Future<Proposal> getProposalDetail(String proposalId);

  /// Acepta formalmente una propuesta y formaliza el acuerdo con el contratista.
  Future<void> acceptProposal(String proposalId);

  /// Actualiza el estado de una propuesta (rechazo o reversión a enviada).
  Future<void> updateProposalStatus(String proposalId, ProposalStatus status);

  /// Obtiene las propuestas enviadas o en borrador del contratista actual.
  Future<List<Proposal>> getMyProposals();

  /// Guarda un borrador o envía una propuesta para un proyecto.
  Future<Proposal> saveProposal({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  });

  /// Retira una propuesta enviada por el contratista actual.
  Future<void> withdrawProposal(String proposalId);
}

