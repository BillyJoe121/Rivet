import '../../../core/config/supabase_config.dart';
import '../domain/contractors_domain.dart';
import 'repositories/contractor_repository_impl.dart';
import 'sources/supabase_contractor_data_source.dart';

/// Arma el repositorio de contratistas conectado a Supabase que GetIt inyecta.
ContractorRepository createContractorRepository() {
  try {
    return ContractorRepositoryImpl(
      SupabaseContractorDataSource(SupabaseConfig.client),
    );
  } catch (_) {
    return ContractorRepositoryImpl(SupabaseContractorDataSource(null));
  }
}
