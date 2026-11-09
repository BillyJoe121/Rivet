import '../../../../core/models/models.dart';
import '../../domain/errors/proposal_failure.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../sources/supabase_proposal_data_source.dart';

/// Implementación del repositorio de propuestas.
class ProposalRepositoryImpl implements ProposalRepository {
  const ProposalRepositoryImpl(this._dataSource);

  final SupabaseProposalDataSource _dataSource;

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async {
    try {
      return await _dataSource.getReceivedProposals(projectId: projectId);
    } catch (e) {
      throw ProposalFailure('No se pudieron consultar las propuestas: ${e.toString()}');
    }
  }

  @override
  Future<Proposal> getProposalDetail(String proposalId) async {
    try {
      return await _dataSource.getProposalDetail(proposalId);
    } catch (e) {
      throw ProposalFailure('No se pudo cargar la cotización: ${e.toString()}');
    }
  }

  @override
  Future<void> acceptProposal(String proposalId) async {
    try {
      await _dataSource.acceptProposal(proposalId);
    } catch (e) {
      throw ProposalFailure('No fue posible aceptar la propuesta: ${e.toString()}');
    }
  }
}

