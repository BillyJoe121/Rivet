import '../../../../core/models/models.dart';

/// Contrato del repositorio de propuestas y cotizaciones.
abstract interface class ProposalRepository {
  /// Obtiene todas las propuestas recibidas por el cliente, agrupadas o filtradas.
  Future<List<Proposal>> getReceivedProposals({String? projectId});

  /// Obtiene el detalle de una propuesta por su identificador.
  Future<Proposal> getProposalDetail(String proposalId);

  /// Acepta formalmente una propuesta y formaliza el acuerdo con el contratista.
  Future<void> acceptProposal(String proposalId);
}

