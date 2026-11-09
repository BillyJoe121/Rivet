import '../../core/config/supabase_config.dart';
import 'data/repositories/proposal_repository_impl.dart';
import 'data/sources/supabase_proposal_data_source.dart';
import 'domain/repositories/proposal_repository.dart';
import 'domain/usecases/accept_proposal_usecase.dart';
import 'domain/usecases/get_received_proposals_usecase.dart';

/// Contenedor de servicios y casos de uso para propuestas.
class ProposalsService {
  ProposalsService._();

  static final ProposalsService instance = ProposalsService._();

  ProposalRepository? _repository;

  void setRepositoryForTesting(ProposalRepository repository) {
    _repository = repository;
  }

  ProposalRepository get repository {
    if (_repository != null) return _repository!;
    try {
      return _repository = ProposalRepositoryImpl(
        SupabaseProposalDataSource(SupabaseConfig.client),
      );
    } catch (_) {
      return _repository = ProposalRepositoryImpl(
        SupabaseProposalDataSource(null),
      );
    }
  }

  GetReceivedProposalsUseCase get getReceivedProposalsUseCase =>
      GetReceivedProposalsUseCase(repository);

  AcceptProposalUseCase get acceptProposalUseCase =>
      AcceptProposalUseCase(repository);
}

