import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/agreements_domain.dart';

sealed class PayoutAccountEvent {
  const PayoutAccountEvent();
}

final class LoadPayoutAccountRequested extends PayoutAccountEvent {
  const LoadPayoutAccountRequested();
}

final class SavePayoutAccountRequested extends PayoutAccountEvent {
  const SavePayoutAccountRequested({
    required this.bankName,
    required this.accountType,
    required this.accountNumber,
    required this.holderName,
    required this.documentNumber,
  });

  final String bankName;
  final String accountType;
  final String accountNumber;
  final String holderName;
  final String documentNumber;
}

enum PayoutAccountStatus { initial, loading, success, failure }

class PayoutAccountState {
  const PayoutAccountState({
    this.status = PayoutAccountStatus.initial,
    this.account,
    this.errorMessage,
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
    this.isSaving = false,
    this.savedSuccessfully = false,
  });

  final PayoutAccountStatus status;
  final PayoutAccount? account;
  final String? errorMessage;
  final bool isSessionExpired;
  final bool isPermissionDenied;
  final bool isSaving;
  final bool savedSuccessfully;

  bool get isLoading => status == PayoutAccountStatus.loading;

  PayoutAccountState copyWith({
    PayoutAccountStatus? status,
    PayoutAccount? account,
    String? errorMessage,
    bool clearError = false,
    bool? isSessionExpired,
    bool? isPermissionDenied,
    bool? isSaving,
    bool? savedSuccessfully,
  }) {
    return PayoutAccountState(
      status: status ?? this.status,
      account: account ?? this.account,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearError ? false : (isSessionExpired ?? this.isSessionExpired),
      isPermissionDenied:
          clearError ? false : (isPermissionDenied ?? this.isPermissionDenied),
      isSaving: isSaving ?? this.isSaving,
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

class PayoutAccountBloc extends Bloc<PayoutAccountEvent, PayoutAccountState> {
  PayoutAccountBloc(
    this._getPayoutAccountUseCase,
    this._savePayoutAccountUseCase,
  ) : super(const PayoutAccountState()) {
    on<LoadPayoutAccountRequested>(_onLoad);
    on<SavePayoutAccountRequested>(_onSave);
  }

  factory PayoutAccountBloc.fromRepository(AgreementRepository repository) {
    return PayoutAccountBloc(
      GetPayoutAccountUseCase(repository),
      SavePayoutAccountUseCase(repository),
    );
  }

  final GetPayoutAccountUseCase _getPayoutAccountUseCase;
  final SavePayoutAccountUseCase _savePayoutAccountUseCase;

  PayoutAccountState _failureState(Object error, {bool isSaving = false}) {
    if (error is AgreementFailure) {
      return state.copyWith(
        status: PayoutAccountStatus.failure,
        errorMessage: error.message,
        isSessionExpired: error.isSessionExpired,
        isPermissionDenied: error.isPermissionDenied,
        isSaving: isSaving,
        savedSuccessfully: false,
      );
    }
    return state.copyWith(
      status: PayoutAccountStatus.failure,
      errorMessage: error.toString().replaceFirst('Exception: ', ''),
      isSaving: isSaving,
      savedSuccessfully: false,
    );
  }

  Future<void> _onLoad(
    LoadPayoutAccountRequested event,
    Emitter<PayoutAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PayoutAccountStatus.loading,
        clearError: true,
        savedSuccessfully: false,
      ),
    );
    try {
      final account = await _getPayoutAccountUseCase();
      emit(
        state.copyWith(
          status: PayoutAccountStatus.success,
          account: account,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
    }
  }

  Future<void> _onSave(
    SavePayoutAccountRequested event,
    Emitter<PayoutAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        isSaving: true,
        clearError: true,
        savedSuccessfully: false,
      ),
    );
    try {
      final saved = await _savePayoutAccountUseCase(
        bankName: event.bankName,
        accountType: event.accountType,
        accountNumber: event.accountNumber,
        holderName: event.holderName,
        documentNumber: event.documentNumber,
      );
      emit(
        state.copyWith(
          status: PayoutAccountStatus.success,
          account: saved,
          isSaving: false,
          savedSuccessfully: true,
        ),
      );
    } catch (e) {
      emit(_failureState(e, isSaving: false));
    }
  }
}
