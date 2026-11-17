import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/agreements_domain.dart';
import '../../domain/progress_domain.dart';

sealed class ProgressEvent {
  const ProgressEvent();
}

final class LoadProgressRequested extends ProgressEvent {
  const LoadProgressRequested(this.agreementId);
  final String agreementId;
}

final class ProgressPercentChanged extends ProgressEvent {
  const ProgressPercentChanged(this.percent);
  final int percent;
}

final class ProgressMilestoneSelected extends ProgressEvent {
  const ProgressMilestoneSelected(this.milestoneId);
  final String? milestoneId;
}

final class ProgressPhotoAdded extends ProgressEvent {
  const ProgressPhotoAdded(this.photo);
  final ProgressPhotoUpload photo;
}

final class ProgressPhotoRemoved extends ProgressEvent {
  const ProgressPhotoRemoved(this.index);
  final int index;
}

final class ConfirmMilestoneRequested extends ProgressEvent {
  const ConfirmMilestoneRequested({
    required this.milestoneId,
    required this.asClient,
  });

  final String milestoneId;
  final bool asClient;
}

final class SubmitProgressUpdateRequested extends ProgressEvent {
  const SubmitProgressUpdateRequested({
    required this.agreementId,
    this.milestoneId,
    required this.percent,
    required this.description,
    this.photos = const [],
    this.asDraft = false,
  });

  final String agreementId;
  final String? milestoneId;
  final int percent;
  final String description;
  final List<ProgressPhotoUpload> photos;
  final bool asDraft;
}

enum ProgressStatus { initial, loading, success, failure }

class ProgressState {
  const ProgressState({
    this.status = ProgressStatus.initial,
    this.agreement,
    this.updates = const [],
    this.draftPercent = 35,
    this.selectedMilestoneId,
    this.draftPhotos = const [],
    this.errorMessage,
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
    this.isSubmitting = false,
    this.submittedSuccessfully = false,
  });

  final ProgressStatus status;
  final WorkAgreement? agreement;
  final List<ProgressUpdate> updates;
  final int draftPercent;
  final String? selectedMilestoneId;
  final List<ProgressPhotoUpload> draftPhotos;
  final String? errorMessage;
  final bool isSessionExpired;
  final bool isPermissionDenied;
  final bool isSubmitting;
  final bool submittedSuccessfully;

  bool get isLoading => status == ProgressStatus.loading;

  int get latestPercent => updates.isNotEmpty ? updates.first.percent : 0;

  ProgressState copyWith({
    ProgressStatus? status,
    WorkAgreement? agreement,
    List<ProgressUpdate>? updates,
    int? draftPercent,
    String? selectedMilestoneId,
    List<ProgressPhotoUpload>? draftPhotos,
    String? errorMessage,
    bool clearError = false,
    bool? isSessionExpired,
    bool? isPermissionDenied,
    bool? isSubmitting,
    bool? submittedSuccessfully,
  }) {
    return ProgressState(
      status: status ?? this.status,
      agreement: agreement ?? this.agreement,
      updates: updates ?? this.updates,
      draftPercent: draftPercent ?? this.draftPercent,
      selectedMilestoneId: selectedMilestoneId ?? this.selectedMilestoneId,
      draftPhotos: draftPhotos ?? this.draftPhotos,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearError ? false : (isSessionExpired ?? this.isSessionExpired),
      isPermissionDenied:
          clearError ? false : (isPermissionDenied ?? this.isPermissionDenied),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submittedSuccessfully:
          submittedSuccessfully ?? this.submittedSuccessfully,
    );
  }
}

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc(
    this._repository,
    this._getUpdatesUseCase,
    this._confirmMilestoneUseCase,
    this._submitProgressUseCase,
  ) : super(const ProgressState()) {
    on<LoadProgressRequested>(_onLoad);
    on<ProgressPercentChanged>(
      (e, emit) => emit(state.copyWith(draftPercent: e.percent)),
    );
    on<ProgressMilestoneSelected>(
      (e, emit) => emit(state.copyWith(selectedMilestoneId: e.milestoneId)),
    );
    on<ProgressPhotoAdded>(
      (e, emit) =>
          emit(state.copyWith(draftPhotos: [...state.draftPhotos, e.photo])),
    );
    on<ProgressPhotoRemoved>((e, emit) {
      final next = List<ProgressPhotoUpload>.from(state.draftPhotos)
        ..removeAt(e.index);
      emit(state.copyWith(draftPhotos: next));
    });
    on<ConfirmMilestoneRequested>(_onConfirmMilestone);
    on<SubmitProgressUpdateRequested>(_onSubmit);
  }

  factory ProgressBloc.fromRepository(AgreementRepository repository) {
    return ProgressBloc(
      repository,
      GetProgressUpdatesUseCase(repository),
      ConfirmMilestoneUseCase(repository),
      SubmitProgressUpdateUseCase(repository),
    );
  }

  final AgreementRepository _repository;
  final GetProgressUpdatesUseCase _getUpdatesUseCase;
  final ConfirmMilestoneUseCase _confirmMilestoneUseCase;
  final SubmitProgressUpdateUseCase _submitProgressUseCase;

  ProgressState _failureState(Object error, {bool isSubmitting = false}) {
    if (error is AgreementFailure) {
      return state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: error.message,
        isSessionExpired: error.isSessionExpired,
        isPermissionDenied: error.isPermissionDenied,
        isSubmitting: isSubmitting,
        submittedSuccessfully: false,
      );
    }
    return state.copyWith(
      status: ProgressStatus.failure,
      errorMessage: error.toString().replaceFirst('Exception: ', ''),
      isSubmitting: isSubmitting,
      submittedSuccessfully: false,
    );
  }

  Future<void> _onLoad(
    LoadProgressRequested event,
    Emitter<ProgressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProgressStatus.loading,
        clearError: true,
        submittedSuccessfully: false,
      ),
    );
    try {
      final agreement = await _repository.getAgreementById(event.agreementId);
      final updates = await _getUpdatesUseCase(event.agreementId);
      emit(
        state.copyWith(
          status: ProgressStatus.success,
          agreement: agreement,
          updates: updates,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
    }
  }

  Future<void> _onConfirmMilestone(
    ConfirmMilestoneRequested event,
    Emitter<ProgressState> emit,
  ) async {
    final current = state.agreement;
    if (current == null) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final updated = await _confirmMilestoneUseCase(
        milestoneId: event.milestoneId,
        asClient: event.asClient,
      );
      final items = [
        for (final m in current.milestoneItems)
          m.id == updated.id ? updated : m,
      ];
      emit(
        state.copyWith(
          status: ProgressStatus.success,
          agreement: current.copyWith(milestoneItems: items),
          isSubmitting: false,
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }

  Future<void> _onSubmit(
    SubmitProgressUpdateRequested event,
    Emitter<ProgressState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        submittedSuccessfully: false,
      ),
    );
    try {
      final created = await _submitProgressUseCase(
        agreementId: event.agreementId,
        milestoneId: event.milestoneId,
        percent: event.percent,
        description: event.description,
        photos: event.photos,
        asDraft: event.asDraft,
      );
      emit(
        state.copyWith(
          status: ProgressStatus.success,
          updates: [created, ...state.updates],
          isSubmitting: false,
          submittedSuccessfully: true,
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSubmitting: false));
    }
  }
}
