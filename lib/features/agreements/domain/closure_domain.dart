import 'agreements_domain.dart';
import 'progress_domain.dart';

class AgreementRating {
  const AgreementRating({
    required this.id,
    required this.agreementId,
    required this.raterId,
    required this.rateeId,
    required this.stars,
    required this.review,
    required this.createdAt,
  });

  final String id;
  final String agreementId;
  final String raterId;
  final String rateeId;
  final int stars;
  final String review;
  final DateTime createdAt;
}

enum CancellationStatus {
  requested('Solicitada'),
  approved('Aprobada'),
  rejected('Rechazada'),
  refunded('Reembolsada');

  const CancellationStatus(this.label);
  final String label;
}

class AgreementCancellation {
  const AgreementCancellation({
    required this.id,
    required this.agreementId,
    required this.requestedBy,
    required this.reason,
    required this.description,
    this.photoPaths = const [],
    this.status = CancellationStatus.requested,
    this.resolvedAt,
    required this.createdAt,
  });

  final String id;
  final String agreementId;
  final String requestedBy;
  final String reason;
  final String description;
  final List<String> photoPaths;
  final CancellationStatus status;
  final DateTime? resolvedAt;
  final DateTime createdAt;

  AgreementCancellation copyWith({
    CancellationStatus? status,
    DateTime? resolvedAt,
  }) {
    return AgreementCancellation(
      id: id,
      agreementId: agreementId,
      requestedBy: requestedBy,
      reason: reason,
      description: description,
      photoPaths: photoPaths,
      status: status ?? this.status,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt,
    );
  }
}

class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.agreementId,
    required this.kind,
    required this.amountCop,
    required this.status,
    this.cardBrand,
    this.cardLast4,
    this.releasedAt,
    required this.createdAt,
  });

  final String id;
  final String agreementId;
  final String kind;
  final int amountCop;
  final SimulatedPaymentStatus status;
  final String? cardBrand;
  final String? cardLast4;
  final DateTime? releasedAt;
  final DateTime createdAt;

  PaymentRecord copyWith({
    SimulatedPaymentStatus? status,
    DateTime? releasedAt,
  }) {
    return PaymentRecord(
      id: id,
      agreementId: agreementId,
      kind: kind,
      amountCop: amountCop,
      status: status ?? this.status,
      cardBrand: cardBrand,
      cardLast4: cardLast4,
      releasedAt: releasedAt ?? this.releasedAt,
      createdAt: createdAt,
    );
  }
}

class SubmitRatingUseCase {
  const SubmitRatingUseCase(this._repository);
  final AgreementRepository _repository;

  Future<AgreementRating> call({
    required String agreementId,
    required String rateeId,
    required int stars,
    required String review,
  }) {
    if (stars < 1 || stars > 5) {
      throw const AgreementFailure('Selecciona una calificación de 1 a 5 estrellas.');
    }
    final trimmed = review.trim();
    if (trimmed.length > 500) {
      throw const AgreementFailure('La reseña no puede superar los 500 caracteres.');
    }
    return _repository.submitRating(
      agreementId: agreementId,
      rateeId: rateeId,
      stars: stars,
      review: trimmed,
    );
  }
}

class RequestCancellationUseCase {
  const RequestCancellationUseCase(this._repository);
  final AgreementRepository _repository;

  Future<AgreementCancellation> call({
    required String agreementId,
    required String reason,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
  }) {
    final cleanReason = reason.trim();
    if (cleanReason.isEmpty || cleanReason.length > 120) {
      throw const AgreementFailure(
        'Indica un motivo de cancelación (máximo 120 caracteres).',
      );
    }
    return _repository.requestCancellation(
      agreementId: agreementId,
      reason: cleanReason,
      description: description.trim(),
      photos: photos,
    );
  }
}

class ResolveCancellationUseCase {
  const ResolveCancellationUseCase(this._repository);
  final AgreementRepository _repository;

  Future<AgreementCancellation> call({
    required String cancellationId,
    required bool approved,
  }) =>
      _repository.resolveCancellation(
        cancellationId: cancellationId,
        approved: approved,
      );
}
