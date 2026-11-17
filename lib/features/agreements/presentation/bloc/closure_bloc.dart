import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/agreements_domain.dart';
import '../../domain/closure_domain.dart';
import '../../domain/progress_domain.dart';

sealed class ClosureEvent {
  const ClosureEvent();
}

final class LoadClosureRequested extends ClosureEvent {
  const LoadClosureRequested(this.agreementId);
  final String agreementId;
}

final class ClosureStarsChanged extends ClosureEvent {
  const ClosureStarsChanged(this.stars);
  final int stars;
}

final class ClosurePhotoAdded extends ClosureEvent {
  const ClosurePhotoAdded(this.photo);
  final ProgressPhotoUpload photo;
}

final class ClosurePhotoRemoved extends ClosureEvent {
  const ClosurePhotoRemoved(this.index);
  final int index;
}

final class CompleteAgreementRequested extends ClosureEvent {
  const CompleteAgreementRequested();
}

final class SubmitRatingRequested extends ClosureEvent {
  const SubmitRatingRequested({
    required this.rateeId,
    required this.stars,
    required this.review,
  });

  final String rateeId;
  final int stars;
  final String review;
}

final class RequestCancellationRequested extends ClosureEvent {
  const RequestCancellationRequested({
    required this.reason,
    required this.description,
    this.photos = const [],
  });

  final String reason;
  final String description;
  final List<ProgressPhotoUpload> photos;
}

final class ResolveCancellationRequested extends ClosureEvent {
  const ResolveCancellationRequested({
    required this.cancellationId,
    required this.approved,
  });

  final String cancellationId;
  final bool approved;
}

final class ReleasePaymentRequested extends ClosureEvent {
  const ReleasePaymentRequested(this.paymentId);
  final String paymentId;
}

enum ClosureStatus { initial, loading, success, failure }

class ClosureState {
  const ClosureState({
    this.status = ClosureStatus.initial,
    this.agreement,
    this.ratings = const [],
    this.cancellations = const [],
    this.payments = const [],
    this.payoutAccount,
    this.selectedStars = 5,
    this.draftPhotos = const [],
    this.errorMessage,
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
    this.isSubmitting = false,
    this.actionMessage,
  });

  final ClosureStatus status;
  final WorkAgreement? agreement;
  final List<AgreementRating> ratings;
  final List<AgreementCancellation> cancellations;
  final List<PaymentRecord> payments;
  final PayoutAccount? payoutAccount;
  final int selectedStars;
  final List<ProgressPhotoUpload> draftPhotos;
  final String? errorMessage;
  final bool isSessionExpired;
  final bool isPermissionDenied;
  final bool isSubmitting;
  final String? actionMessage;

  bool get isLoading => status == ClosureStatus.loading;

  ClosureState copyWith({
    ClosureStatus? status,
    WorkAgreement? agreement,
    List<AgreementRating>? ratings,
    List<AgreementCancellation>? cancellations,
    List<PaymentRecord>? payments,
    PayoutAccount? payoutAccount,
    int? selectedStars,
    List<ProgressPhotoUpload>? draftPhotos,
    String? errorMessage,
    bool clearError = false,
    bool? isSessionExpired,
    bool? isPermissionDenied,
    bool? isSubmitting,
    String? actionMessage,
    bool clearActionMessage = false,
  }) {
    return ClosureState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      ratings: ratings ?? this.ratings,
      cancellations: cancellations ?? this.cancellations,
      payments: payments ?? this.payments,
      payoutAccount: payoutAccount ?? this.payoutAccount,
      selectedStars: selectedStars ?? this.selectedStars,
      draftPhotos: draftPhotos ?? this.draftPhotos,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearError ? false : (isSessionExpired ?? this.isSessionExpired),
      isPermissionDenied:
          clearError ? false : (isPermissionDenied ?? this.isPermissionDenied),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      actionMessage:
          clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }
}

class ClosureBloc extends Bloc<ClosureEvent, ClosureState> {
  ClosureBloc(
    this._repository,
    this._submitRatingUseCase,
    this._requestCancellationUseCase,
    this._resolveCancellationUseCase,
  ) : super(const ClosureState()) {
    on<LoadClosureRequested>(_onLoad);
    on<ClosureStarsChanged>(
      (e, emit) => emit(state.copyWith(selectedStars: e.stars)),
    );
    on<ClosurePhotoAdded>(
      (e, emit) =>
          emit(state.copyWith(draftPhotos: [...state.draftPhotos, e.photo])),
    );
    on<ClosurePhotoRemoved>((e, emit) {
      final next = List<ProgressPhotoUpload>.from(state.draftPhotos)
        ..removeAt(e.index);
      emit(state.copyWith(draftPhotos: next));
    });
    on<CompleteAgreementRequested>(_onComplete);
    on<SubmitRatingRequested>(_onSubmitRating);
    on<RequestCancellationRequested>(_onRequestCancellation);
    on<ResolveCancellationRequested>(_onResolveCancellation);
    on<ReleasePaymentRequested>(_onReleasePayment);
  }

  factory ClosureBloc.fromRepository(AgreementRepository repository) {
    return ClosureBloc(
      repository,
      SubmitRatingUseCase(repository),
      RequestCancellationUseCase(repository),
      ResolveCancellationUseCase(repository),
    );
  }

  final AgreementRepository _repository;
  final SubmitRatingUseCase _submitRatingUseCase;
  final RequestCancellationUseCase _requestCancellationUseCase;
  final ResolveCancellationUseCase _resolveCancellationUseCase;

  ClosureState _failureState(Object error, {bool isSubmitting = false}) {
    if (error is AgreementFailure) {
      return state.copyWith(
        status: ClosureStatus.failure,
        errorMessage: error.message,
        isSessionExpired: error.isSessionExpired,
        isPermissionDenied: error.isPermissionDenied,
        isSubmitting: isSubmitting,
      );
    }
    return state.copyWith(
      status: ClosureStatus.failure,
      errorMessage: error.toString().replaceFirst('Exception: ', ''),
      isSubmitting: isSubmitting,
    );
  }

  Future<void> _onLoad(
    LoadClosureRequested event,
    Emitter<ClosureState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ClosureStatus.loading,
        clearError: true,
        clearActionMessage: true,
      ),
    );
    try {
      final agreement = await _repository.getAgreementById(event.agreementId);
      final ratings = await _repository.getRatings(event.agreementId);
      final cancellations = await _repository.getCancellations(event.agreementId);
      final payments = await _repository.getPayments(event.agreementId);
      final payout = await _repository.getPayoutAccount();
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          agreement: agreement,
          ratings: ratings,
          cancellations: cancellations,
          payments: payments,
          payoutAccount: payout,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
    }
  }

  Future<void> _onComplete(
    CompleteAgreementRequested event,
    Emitter<ClosureState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final completed = await _repository.confirmWorkCompletion(current);
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          agreement: completed,
          isSubmitting: false,
          actionMessage: 'Obra finalizada correctamente.',
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }

  Future<void> _onSubmitRating(
    SubmitRatingRequested event,
    Emitter<ClosureState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final rating = await _submitRatingUseCase(
        agreementId: current.id,
        rateeId: event.rateeId,
        stars: event.stars,
        review: event.review,
      );
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          ratings: [rating, ...state.ratings],
          isSubmitting: false,
          actionMessage: 'Calificación registrada.',
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }

  Future<void> _onRequestCancellation(
    RequestCancellationRequested event,
    Emitter<ClosureState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final created = await _requestCancellationUseCase(
        agreementId: current.id,
        reason: event.reason,
        description: event.description,
        photos: event.photos,
      );
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          cancellations: [created, ...state.cancellations],
          isSubmitting: false,
          actionMessage: 'Solicitud de cancelación enviada.',
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }

  Future<void> _onResolveCancellation(
    ResolveCancellationRequested event,
    Emitter<ClosureState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final resolved = await _resolveCancellationUseCase(
        cancellationId: event.cancellationId,
        approved: event.approved,
      );
      final updatedAgreement = event.approved
          ? state.agreement?.copyWith(status: AgreementStatus.cancelled)
          : state.agreement;
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          agreement: updatedAgreement,
          cancellations: [
            for (final c in state.cancellations)
              c.id == resolved.id ? resolved : c,
          ],
          isSubmitting: false,
          actionMessage: event.approved
              ? 'Cancelación aprobada.'
              : 'Cancelación rechazada.',
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }

  Future<void> _onReleasePayment(
    ReleasePaymentRequested event,
    Emitter<ClosureState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final released = await _repository.releasePayment(event.paymentId);
      emit(
        state.copyWith(
          status: ClosureStatus.success,
          payments: [
            for (final p in state.payments) p.id == released.id ? released : p,
          ],
          isSubmitting: false,
          actionMessage: 'Pago simulado marcado como liberado.',
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }
}
