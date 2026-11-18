import '../domain/contractors_domain.dart';
import 'local_contractor_repository.dart';

/// Arma el repositorio de contratistas que la raíz de la app inyecta.
ContractorRepository createContractorRepository() => LocalContractorRepository();
