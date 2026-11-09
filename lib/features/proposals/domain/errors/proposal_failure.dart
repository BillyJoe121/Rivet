/// Error del dominio de propuestas.
class ProposalFailure implements Exception {
  final String message;

  const ProposalFailure(this.message);

  @override
  String toString() => message;
}

