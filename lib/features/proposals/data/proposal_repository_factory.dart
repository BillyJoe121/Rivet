import '../../../core/config/supabase_config.dart';
import '../domain/repositories/proposal_repository.dart';
import 'repositories/proposal_repository_impl.dart';
import 'sources/supabase_proposal_data_source.dart';

/// Arma el repositorio de propuestas que la raíz de la app inyecta.
///
/// Si Supabase no quedó inicializado (sin `.env`), la fuente de datos trabaja
/// con su memoria local para que la app siga abriendo.
ProposalRepository createProposalRepository() {
  try {
    return ProposalRepositoryImpl(
      SupabaseProposalDataSource(SupabaseConfig.client),
    );
  } catch (_) {
    return ProposalRepositoryImpl(SupabaseProposalDataSource(null));
  }
}
