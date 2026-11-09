/// Eventos del bloque de propuestas.
sealed class ProposalsEvent {
  const ProposalsEvent();
}

/// Carga las propuestas recibidas, opcionalmente filtradas por proyecto.
final class LoadReceivedProposals extends ProposalsEvent {
  const LoadReceivedProposals({this.projectId});

  final String? projectId;
}

/// Acepta formalmente una propuesta para iniciar la formalización de la obra.
final class AcceptProposalSubmitted extends ProposalsEvent {
  const AcceptProposalSubmitted(this.proposalId);

  final String proposalId;
}

/// Descarta cualquier mensaje de error.
final class ProposalsErrorDismissed extends ProposalsEvent {
  const ProposalsErrorDismissed();
}

