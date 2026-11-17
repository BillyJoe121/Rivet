import '../../../core/config/supabase_config.dart';
import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';
import '../domain/closure_domain.dart';
import '../domain/progress_domain.dart';
import 'supabase_agreement_data_source.dart';
import 'supabase_closure_data_source.dart';
import 'supabase_progress_data_source.dart';

class AgreementRepositoryImpl implements AgreementRepository {
  const AgreementRepositoryImpl(
    this._dataSource,
    this._progressDataSource,
    this._closureDataSource,
  );

  final SupabaseAgreementDataSource _dataSource;
  final SupabaseProgressDataSource _progressDataSource;
  final SupabaseClosureDataSource _closureDataSource;

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

  @override
  Future<List<AgreementRating>> getRatings(String agreementId) =>
      _closureDataSource.getRatings(agreementId);

  @override
  Future<AgreementRating> submitRating({
    required String agreementId,
    required String rateeId,
    required int stars,
    required String review,
  }) =>
      _closureDataSource.submitRating(
        agreementId: agreementId,
        rateeId: rateeId,
        stars: stars,
        review: review,
      );

  @override
  Future<List<AgreementCancellation>> getCancellations(String agreementId) =>
      _closureDataSource.getCancellations(agreementId);

  @override
  Future<AgreementCancellation> requestCancellation({
    required String agreementId,
    required String reason,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
  }) =>
      _closureDataSource.requestCancellation(
        agreementId: agreementId,
        reason: reason,
        description: description,
        photos: photos,
      );

  @override
  Future<AgreementCancellation> resolveCancellation({
    required String cancellationId,
    required bool approved,
  }) =>
      _closureDataSource.resolveCancellation(
        cancellationId: cancellationId,
        approved: approved,
      );

  @override
  Future<List<PaymentRecord>> getPayments(String agreementId) =>
      _closureDataSource.getPayments(agreementId);

  @override
  Future<PaymentRecord> releasePayment(String paymentId) =>
      _closureDataSource.releasePayment(paymentId);
}

AgreementRepository createAgreementRepository() {
  try {
    final client = SupabaseConfig.client;
    return AgreementRepositoryImpl(
      SupabaseAgreementDataSource(client),
      SupabaseProgressDataSource(client),
      SupabaseClosureDataSource(client),
    );
  } catch (_) {
    return AgreementRepositoryImpl(
      SupabaseAgreementDataSource(null),
      SupabaseProgressDataSource(null),
      SupabaseClosureDataSource(null),
    );
  }
}
