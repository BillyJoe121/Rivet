import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';

/// Solicitud de visita técnica a un contratista (P-021, P-022).
class VisitRequest {
  const VisitRequest({
    required this.id,
    required this.contractorId,
    required this.contractorName,
    required this.projectId,
    required this.address,
    required this.preferredDate,
    required this.timeSlot,
    required this.notes,
    required this.feeCop,
    required this.createdAt,
    this.simulatedPaid = true,
  });

  final String id;
  final String contractorId;
  final String contractorName;
  final String projectId;
  final String address;
  final String preferredDate;
  final String timeSlot;
  final String notes;
  final int feeCop;
  final DateTime createdAt;
  final bool simulatedPaid;
}

class ContractorFailure implements Exception {
  const ContractorFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class ContractorRepository {
  Future<List<Contractor>> getContractors();

  Future<VisitRequest> requestVisit({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  });
}

class GetContractorsUseCase {
  const GetContractorsUseCase(this._repository);
  final ContractorRepository _repository;

  Future<List<Contractor>> call() => _repository.getContractors();
}

class RequestContractorVisitUseCase {
  const RequestContractorVisitUseCase(this._repository);
  final ContractorRepository _repository;

  Future<VisitRequest> call({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  }) async {
    if (address.trim().isEmpty) {
      throw const ContractorFailure(
        'Ingresa la dirección donde se realizará la visita técnica.',
      );
    }
    if (preferredDate.trim().isEmpty) {
      throw const ContractorFailure(
        'Selecciona una fecha preferida para la visita.',
      );
    }
    if (timeSlot.trim().isEmpty) {
      throw const ContractorFailure('Elige una franja horaria.');
    }
    return _repository.requestVisit(
      contractorId: contractorId,
      contractorName: contractorName,
      projectId: projectId,
      address: address.trim(),
      preferredDate: preferredDate.trim(),
      timeSlot: timeSlot.trim(),
      notes: notes.trim(),
      feeCop: feeCop,
    );
  }
}

class LocalContractorRepository implements ContractorRepository {
  final List<VisitRequest> _visits = [];

  static const List<Contractor> _seedContractors = [
    Contractor(
      id: 'con-001',
      name: 'Andrés Felipe Montoya',
      trade: 'Pintura arquitectónica y estuco',
      zone: 'Cali · Sur (Ciudad Jardín, Pance)',
      rating: 4.9,
      reviewCount: 54,
      completedJobs: 68,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_living_room.jpg',
        'assets/hero/hero_greenery.jpg',
      ],
      bio:
          'Maestro pintor con 12 años en acabados residenciales, estuco plástico, veneciano y recuperación de muros con humedad.',
    ),
    Contractor(
      id: 'con-002',
      name: 'Carolina Rivas & Equipo',
      trade: 'Acabados interiores y drywall',
      zone: 'Cali · Oeste (El Peñón, Cristales)',
      rating: 4.8,
      reviewCount: 41,
      completedJobs: 52,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_lounge.jpg',
        'assets/hero/hero_planning.jpg',
      ],
      bio:
          'Cuadrilla especializada en remodelación limpia de apartamentos ocupados, encintado láser y entrega con aseo.',
    ),
    Contractor(
      id: 'con-003',
      name: 'Julián Darío Sinisterra',
      trade: 'Impermeabilización y fachadas',
      zone: 'Cali · Norte (Granada, La Flora)',
      rating: 4.7,
      reviewCount: 33,
      completedJobs: 44,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_paint_roller.jpg',
      ],
      bio:
          'Técnico en tratamiento de filtraciones, koraza elastomérica, sellado de fisuras y pintura de fachadas.',
    ),
    Contractor(
      id: 'con-004',
      name: 'Héctor Fabio Mosquera',
      trade: 'Estuco liso y pintura epóxica',
      zone: 'Cali · Sur (Valle del Lili, Bochalema)',
      rating: 4.9,
      reviewCount: 62,
      completedJobs: 81,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_home.jpg',
      ],
      bio:
          'Especialista en nivelación de muros nuevos en obra gris, aplicación de vinilo tipo 1 y esmaltes lavables.',
    ),
    Contractor(
      id: 'con-005',
      name: 'Natalia Gómez Restrepo',
      trade: 'Pintura decorativa y microcemento',
      zone: 'Cali · Oeste (San Antonio, Normandía)',
      rating: 4.8,
      reviewCount: 29,
      completedJobs: 37,
      isVerified: true,
      portfolioImages: [
        'assets/hero/hero_living_room.jpg',
      ],
      bio:
          'Restauración de muros patrimoniales, paletas cálidas, tierras minerales y acabados satinados.',
    ),
    Contractor(
      id: 'con-006',
      name: 'Mauricio Caicedo',
      trade: 'Pintura general y resanes',
      zone: 'Cali · Centro y Oriente',
      rating: 4.5,
      reviewCount: 19,
      completedJobs: 26,
      isVerified: false,
      portfolioImages: [
        'assets/hero/hero_paint_shelf.jpg',
      ],
      bio:
          'Pintura rápida para entregas de arrendamiento, resane de perforaciones y mantenimiento de puertas.',
    ),
  ];

  @override
  Future<List<Contractor>> getContractors() async => _seedContractors;

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
  }) async {
    final visit = VisitRequest(
      id: 'vis-${DateTime.now().millisecondsSinceEpoch}',
      contractorId: contractorId,
      contractorName: contractorName,
      projectId: projectId,
      address: address,
      preferredDate: preferredDate,
      timeSlot: timeSlot,
      notes: notes,
      feeCop: feeCop,
      createdAt: DateTime.now(),
    );
    _visits.insert(0, visit);
    return visit;
  }
}

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

enum ContractorsStatus { initial, loading, success, submittingVisit, failure }

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

  bool get isLoading => status == ContractorsStatus.loading;
  bool get isSubmittingVisit => status == ContractorsStatus.submittingVisit;

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
        status: ContractorsStatus.submittingVisit,
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
          lastVisitRequest: visit,
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
}

class ContractorsService {
  ContractorsService._();
  static final ContractorsService instance = ContractorsService._();

  ContractorRepository _repository = LocalContractorRepository();

  void setRepositoryForTesting(ContractorRepository repository) {
    _repository = repository;
  }

  GetContractorsUseCase get getContractorsUseCase =>
      GetContractorsUseCase(_repository);

  RequestContractorVisitUseCase get requestContractorVisitUseCase =>
      RequestContractorVisitUseCase(_repository);
}
