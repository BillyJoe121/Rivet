import '../../../core/config/supabase_config.dart';
import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';
import '../domain/progress_domain.dart';
import 'supabase_agreement_data_source.dart';
import 'supabase_progress_data_source.dart';

class AgreementRepositoryImpl implements AgreementRepository {
  const AgreementRepositoryImpl(this._dataSource, this._progressDataSource);

  final SupabaseAgreementDataSource _dataSource;
  final SupabaseProgressDataSource _progressDataSource;

  @override
  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  }) =>
      _dataSource.prepareAgreement(
        projectId: projectId,
        projectTitle: projectTitle,
        proposal: proposal,
      );

  @override
  Future<WorkAgreement> getAgreementById(String agreementId) =>
      _dataSource.getAgreementById(agreementId);

  @override
  Future<WorkAgreement?> getAgreementForProject(String projectId) =>
      _dataSource.getAgreementForProject(projectId);

  @override
  Future<List<WorkAgreement>> getMyAgreements() => _dataSource.getMyAgreements();

  @override
  Future<WorkAgreement> acceptAgreement({
    required String agreementId,
    required bool asClient,
  }) =>
      _dataSource.acceptAgreement(agreementId: agreementId, asClient: asClient);

  @override
  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    String? cardBrand,
    String? cardLast4,
    bool simulateFailure = false,
  }) =>
      _dataSource.processSimulatedPayment(
        agreement: agreement,
        cardBrand: cardBrand,
        cardLast4: cardLast4,
        simulateFailure: simulateFailure,
      );

  @override
  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement) =>
      _dataSource.confirmWorkCompletion(agreement);

  @override
  Future<PayoutAccount?> getPayoutAccount() => _dataSource.getPayoutAccount();

  @override
  Future<PayoutAccount> savePayoutAccount({
    required String bankName,
    required String accountType,
    required String accountNumberLast4,
    required String holderName,
    required String documentNumberLast4,
  }) =>
      _dataSource.savePayoutAccount(
        bankName: bankName,
        accountType: accountType,
        accountNumberLast4: accountNumberLast4,
        holderName: holderName,
        documentNumberLast4: documentNumberLast4,
      );

  @override
  Future<List<ProgressUpdate>> getProgressUpdates(String agreementId) =>
      _progressDataSource.getProgressUpdates(agreementId);

  @override
  Future<AgreementMilestone> confirmMilestone({
    required String milestoneId,
    required bool asClient,
  }) =>
      _progressDataSource.confirmMilestone(
        milestoneId: milestoneId,
        asClient: asClient,
      );

  @override
  Future<ProgressUpdate> submitProgressUpdate({
    required String agreementId,
    String? milestoneId,
    required int percent,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
    bool asDraft = false,
  }) =>
      _progressDataSource.submitProgressUpdate(
        agreementId: agreementId,
        milestoneId: milestoneId,
        percent: percent,
        description: description,
        photos: photos,
        asDraft: asDraft,
      );
}

AgreementRepository createAgreementRepository() {
  try {
    final client = SupabaseConfig.client;
    return AgreementRepositoryImpl(
      SupabaseAgreementDataSource(client),
      SupabaseProgressDataSource(client),
    );
  } catch (_) {
    return AgreementRepositoryImpl(
      SupabaseAgreementDataSource(null),
      SupabaseProgressDataSource(null),
    );
  }
}
