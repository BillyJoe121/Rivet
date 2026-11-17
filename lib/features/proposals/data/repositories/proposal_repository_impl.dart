import '../../../../core/models/models.dart';
import '../../domain/errors/proposal_failure.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../sources/supabase_proposal_data_source.dart';

/// Implementación del repositorio de propuestas.
///
/// La fuente de datos ya entrega [ProposalFailure]; cualquier otro error se
/// envuelve con un mensaje genérico para no mostrar detalles técnicos.
class ProposalRepositoryImpl implements ProposalRepository {
  const ProposalRepositoryImpl(this._dataSource);

  final SupabaseProposalDataSource _dataSource;

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) => _guard(
    SupabaseProposalDataSource.loadListMessage,
    () => _dataSource.getReceivedProposals(projectId: projectId),
  );

  @override
  Future<Proposal> getProposalDetail(String proposalId) => _guard(
    SupabaseProposalDataSource.loadDetailMessage,
    () => _dataSource.getProposalDetail(proposalId),
  );

  @override
  Future<void> acceptProposal(String proposalId) => _guard(
    SupabaseProposalDataSource.acceptMessage,
    () => _dataSource.acceptProposal(proposalId),
  );

  @override
  Future<void> updateProposalStatus(String proposalId, ProposalStatus status) =>
      _guard(
        SupabaseProposalDataSource.acceptMessage,
        () => _dataSource.updateProposalStatus(proposalId, status),
      );

  @override
  Future<List<Proposal>> getMyProposals() => _guard(
    SupabaseProposalDataSource.loadListMessage,
    _dataSource.getMyProposals,
  );

  @override
  Future<Proposal> saveProposal({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  }) => _guard(
    SupabaseProposalDataSource.saveMessage,
    () => _dataSource.saveProposal(
      proposalId: proposalId,
      projectId: projectId,
      laborCostCop: laborCostCop,
      materialsCostCop: materialsCostCop,
      estimatedDays: estimatedDays,
      observations: observations,
      status: status,
    ),
  );

  @override
  Future<void> withdrawProposal(String proposalId) => _guard(
    SupabaseProposalDataSource.withdrawMessage,
    () => _dataSource.withdrawProposal(proposalId),
  );

  Future<T> _guard<T>(String message, Future<T> Function() run) async {
    try {
      return await run();
    } on ProposalFailure {
      rethrow;
    } catch (_) {
      throw ProposalFailure(message);
    }
  }
}
