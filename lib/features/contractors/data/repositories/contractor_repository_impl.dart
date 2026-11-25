import '../../../../core/models/models.dart';
import '../../domain/contractors_domain.dart';
import '../sources/supabase_contractor_data_source.dart';

/// Implementación de [ContractorRepository] respaldada por Supabase.
class ContractorRepositoryImpl implements ContractorRepository {
  const ContractorRepositoryImpl(this._dataSource);

  final SupabaseContractorDataSource _dataSource;

  @override
  Future<List<Contractor>> getContractors() => _dataSource.getContractors();

  @override
  Future<VisitRequest> requestVisit({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  }) => _dataSource.requestVisit(
    contractorId: contractorId,
    contractorName: contractorName,
    projectId: projectId,
    address: address,
    preferredDate: preferredDate,
    timeSlot: timeSlot,
    notes: notes,
    feeCop: feeCop,
  );
}
