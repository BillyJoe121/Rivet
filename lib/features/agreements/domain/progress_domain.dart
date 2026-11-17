import 'dart:typed_data';

import 'agreements_domain.dart';

class ProgressPhotoUpload {
  const ProgressPhotoUpload({
    required this.fileName,
    required this.bytes,
    this.mimeType = 'image/jpeg',
  });

  final String fileName;
  final Uint8List bytes;
  final String mimeType;
}

class ProgressUpdate {
  const ProgressUpdate({
    required this.id,
    required this.agreementId,
    this.milestoneId,
    required this.authorId,
    required this.percent,
    required this.description,
    this.photoPaths = const [],
    this.status = 'sent',
    required this.createdAt,
  });

  final String id;
  final String agreementId;
  final String? milestoneId;
  final String authorId;
  final int percent;
  final String description;
  final List<String> photoPaths;
  final String status;
  final DateTime createdAt;

  bool get isDraft => status == 'draft';
}

class GetProgressUpdatesUseCase {
  const GetProgressUpdatesUseCase(this._repository);
  final AgreementRepository _repository;

  Future<List<ProgressUpdate>> call(String agreementId) =>
      _repository.getProgressUpdates(agreementId);
}

class ConfirmMilestoneUseCase {
  const ConfirmMilestoneUseCase(this._repository);
  final AgreementRepository _repository;

  Future<AgreementMilestone> call({
    required String milestoneId,
    required bool asClient,
  }) =>
      _repository.confirmMilestone(
        milestoneId: milestoneId,
        asClient: asClient,
      );
}

class SubmitProgressUpdateUseCase {
  const SubmitProgressUpdateUseCase(this._repository);
  final AgreementRepository _repository;

  Future<ProgressUpdate> call({
    required String agreementId,
    String? milestoneId,
    required int percent,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
    bool asDraft = false,
  }) {
    if (percent < 0 || percent > 100) {
      throw const AgreementFailure(
        'El porcentaje de avance debe estar entre 0% y 100%.',
      );
    }
    final trimmed = description.trim();
    if (!asDraft && trimmed.isEmpty) {
      throw const AgreementFailure(
        'Describe brevemente el avance realizado antes de enviarlo.',
      );
    }
    return _repository.submitProgressUpdate(
      agreementId: agreementId,
      milestoneId: milestoneId,
      percent: percent,
      description: trimmed,
      photos: photos,
      asDraft: asDraft,
    );
  }
}
