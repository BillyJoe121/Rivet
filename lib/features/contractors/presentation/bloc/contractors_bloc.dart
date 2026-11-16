import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/models.dart';
import '../../domain/contractors_domain.dart';

sealed class ContractorsEvent {
  const ContractorsEvent();
}

final class LoadContractors extends ContractorsEvent {
  const LoadContractors();
}

final class UpdateContractorSearch extends ContractorsEvent {
  const UpdateContractorSearch(this.query);
  final String query;
}

final class UpdateContractorTradeFilter extends ContractorsEvent {
  const UpdateContractorTradeFilter(this.trade);
  final String? trade;
}

final class UpdateContractorZoneFilter extends ContractorsEvent {
  const UpdateContractorZoneFilter(this.zone);
  final String? zone;
}

final class UpdateContractorRatingFilter extends ContractorsEvent {
  const UpdateContractorRatingFilter(this.minRating);
  final double minRating;
}

final class ToggleContractorVerifiedOnly extends ContractorsEvent {
  const ToggleContractorVerifiedOnly(this.onlyVerified);
  final bool onlyVerified;
}

final class SubmitVisitRequest extends ContractorsEvent {
  const SubmitVisitRequest({
    required this.contractorId,
    required this.contractorName,
    required this.projectId,
    required this.address,
    required this.preferredDate,
    required this.timeSlot,
    required this.notes,
    required this.feeCop,
  });

  final String contractorId;
  final String contractorName;
  final String projectId;
  final String address;
  final String preferredDate;
  final String timeSlot;
  final String notes;
  final int feeCop;
}

enum ContractorsStatus { initial, loading, success, failure }

class ContractorsState {
  const ContractorsState({
    this.status = ContractorsStatus.initial,
    this.contractors = const [],
    this.searchQuery = '',
    this.selectedTrade,
    this.selectedZone,
    this.minRating = 0,
    this.onlyVerified = false,
    this.lastVisitRequest,
    this.errorMessage,
    this.isSubmittingVisit = false,
  });

  final ContractorsStatus status;
  final List<Contractor> contractors;
  final String searchQuery;
  final String? selectedTrade;
  final String? selectedZone;
  final double minRating;
  final bool onlyVerified;
  final VisitRequest? lastVisitRequest;
  final String? errorMessage;
  final bool isSubmittingVisit;

  bool get isLoading => status == ContractorsStatus.loading;

  List<Contractor> get filteredContractors {
    final q = searchQuery.trim().toLowerCase();
    return contractors.where((c) {
      if (onlyVerified && !c.isVerified) return false;
      if (c.rating < minRating) return false;
      if (selectedTrade != null && selectedTrade!.isNotEmpty) {
        final t = selectedTrade!.toLowerCase();
        if (!c.trade.toLowerCase().contains(t) &&
            !c.bio.toLowerCase().contains(t)) {
          return false;
        }
      }
      if (selectedZone != null && selectedZone!.isNotEmpty) {
        if (!c.zone.toLowerCase().contains(selectedZone!.toLowerCase())) {
          return false;
        }
      }
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.trade.toLowerCase().contains(q) ||
          c.zone.toLowerCase().contains(q) ||
          c.bio.toLowerCase().contains(q);
    }).toList();
  }

  ContractorsState copyWith({
    ContractorsStatus? status,
    List<Contractor>? contractors,
    String? searchQuery,
    String? selectedTrade,
    bool clearTrade = false,
    String? selectedZone,
    bool clearZone = false,
    double? minRating,
    bool? onlyVerified,
    VisitRequest? lastVisitRequest,
    String? errorMessage,
    bool clearError = false,
    bool? isSubmittingVisit,
  }) {
    return ContractorsState(
      status: status ?? this.status,
      contractors: contractors ?? this.contractors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTrade: clearTrade ? null : (selectedTrade ?? this.selectedTrade),
      selectedZone: clearZone ? null : (selectedZone ?? this.selectedZone),
      minRating: minRating ?? this.minRating,
      onlyVerified: onlyVerified ?? this.onlyVerified,
      lastVisitRequest: lastVisitRequest ?? this.lastVisitRequest,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmittingVisit: isSubmittingVisit ?? this.isSubmittingVisit,
    );
  }
}

class ContractorsBloc extends Bloc<ContractorsEvent, ContractorsState> {
  ContractorsBloc(
    this._getContractorsUseCase,
    this._requestVisitUseCase,
  ) : super(const ContractorsState()) {
    on<LoadContractors>(_onLoad);
    on<UpdateContractorSearch>(_onSearch);
    on<UpdateContractorTradeFilter>(_onTrade);
    on<UpdateContractorZoneFilter>(_onZone);
    on<UpdateContractorRatingFilter>(_onRating);
    on<ToggleContractorVerifiedOnly>(_onVerified);
    on<SubmitVisitRequest>(_onSubmitVisit);
  }

  factory ContractorsBloc.fromRepository(ContractorRepository repository) {
    return ContractorsBloc(
      GetContractorsUseCase(repository),
      RequestContractorVisitUseCase(repository),
    );
  }

  final GetContractorsUseCase _getContractorsUseCase;
  final RequestContractorVisitUseCase _requestVisitUseCase;

  Future<void> _onLoad(
    LoadContractors event,
    Emitter<ContractorsState> emit,
  ) async {
    emit(state.copyWith(status: ContractorsStatus.loading, clearError: true));
    try {
      final list = await _getContractorsUseCase();
      emit(
        state.copyWith(
          status: ContractorsStatus.success,
          contractors: list,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: ContractorsStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  void _onSearch(
    UpdateContractorSearch event,
    Emitter<ContractorsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, clearError: true));
  }

  void _onTrade(
    UpdateContractorTradeFilter event,
    Emitter<ContractorsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedTrade: event.trade,
        clearTrade: event.trade == null,
        clearError: true,
      ),
    );
  }

  void _onZone(
    UpdateContractorZoneFilter event,
    Emitter<ContractorsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedZone: event.zone,
        clearZone: event.zone == null,
        clearError: true,
      ),
    );
  }

  void _onRating(
    UpdateContractorRatingFilter event,
    Emitter<ContractorsState> emit,
  ) {
    emit(state.copyWith(minRating: event.minRating, clearError: true));
  }

  void _onVerified(
    ToggleContractorVerifiedOnly event,
    Emitter<ContractorsState> emit,
  ) {
    emit(state.copyWith(onlyVerified: event.onlyVerified, clearError: true));
  }

  Future<void> _onSubmitVisit(
    SubmitVisitRequest event,
    Emitter<ContractorsState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmittingVisit: true,
        clearError: true,
      ),
    );
    try {
      final visit = await _requestVisitUseCase(
        contractorId: event.contractorId,
        contractorName: event.contractorName,
        projectId: event.projectId,
        address: event.address,
        preferredDate: event.preferredDate,
        timeSlot: event.timeSlot,
        notes: event.notes,
        feeCop: event.feeCop,
      );
      emit(
        state.copyWith(
          status: ContractorsStatus.success,
          isSubmittingVisit: false,
          lastVisitRequest: visit,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: ContractorsStatus.failure,
          isSubmittingVisit: false,
          errorMessage: clean,
        ),
      );
    }
  }
}
