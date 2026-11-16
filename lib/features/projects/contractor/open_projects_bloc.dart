import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../domain/errors/project_failure.dart';
import '../domain/repositories/project_repository.dart';
import '../domain/usecases/get_open_projects_usecase.dart';

sealed class OpenProjectsEvent {
  const OpenProjectsEvent();
}

final class LoadOpenProjects extends OpenProjectsEvent {
  const LoadOpenProjects();
}

final class OpenProjectsSearchChanged extends OpenProjectsEvent {
  const OpenProjectsSearchChanged(this.query);
  final String query;
}

final class OpenProjectsCityChanged extends OpenProjectsEvent {
  const OpenProjectsCityChanged(this.city);
  final String? city;
}

enum OpenProjectsStatus { initial, loading, success, failure }

class OpenProjectsState {
  const OpenProjectsState({
    this.status = OpenProjectsStatus.initial,
    this.projects = const [],
    this.searchQuery = '',
    this.selectedCity,
    this.errorMessage,
  });

  final OpenProjectsStatus status;
  final List<Project> projects;
  final String searchQuery;
  final String? selectedCity;
  final String? errorMessage;

  bool get isLoading => status == OpenProjectsStatus.loading;
  bool get isFailure => status == OpenProjectsStatus.failure;

  List<String> get availableCities {
    final set = <String>{};
    for (final p in projects) {
      if (p.city.trim().isNotEmpty) set.add(p.city.trim());
    }
    return set.toList()..sort();
  }

  List<Project> get filteredProjects {
    final q = searchQuery.trim().toLowerCase();
    return projects.where((p) {
      if (selectedCity != null &&
          selectedCity!.isNotEmpty &&
          p.city.toLowerCase() != selectedCity!.toLowerCase()) {
        return false;
      }
      if (q.isEmpty) return true;
      return p.title.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q) ||
          p.neighborhood.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  OpenProjectsState copyWith({
    OpenProjectsStatus? status,
    List<Project>? projects,
    String? searchQuery,
    String? selectedCity,
    bool clearCity = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OpenProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class OpenProjectsBloc extends Bloc<OpenProjectsEvent, OpenProjectsState> {
  OpenProjectsBloc(this._getOpenProjectsUseCase)
    : super(const OpenProjectsState()) {
    on<LoadOpenProjects>(_onLoad);
    on<OpenProjectsSearchChanged>(_onSearch);
    on<OpenProjectsCityChanged>(_onCity);
  }

  factory OpenProjectsBloc.fromRepository(ProjectRepository repository) {
    return OpenProjectsBloc(GetOpenProjectsUseCase(repository));
  }

  final GetOpenProjectsUseCase _getOpenProjectsUseCase;

  Future<void> _onLoad(
    LoadOpenProjects event,
    Emitter<OpenProjectsState> emit,
  ) async {
    emit(state.copyWith(status: OpenProjectsStatus.loading, clearError: true));
    try {
      final list = await _getOpenProjectsUseCase();
      emit(
        state.copyWith(
          status: OpenProjectsStatus.success,
          projects: list,
        ),
      );
    } catch (e) {
      final message = e is ProjectFailure
          ? e.message
          : 'No pudimos cargar los proyectos disponibles. Inténtalo de nuevo.';
      emit(
        state.copyWith(
          status: OpenProjectsStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }

  void _onSearch(
    OpenProjectsSearchChanged event,
    Emitter<OpenProjectsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, clearError: true));
  }

  void _onCity(
    OpenProjectsCityChanged event,
    Emitter<OpenProjectsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCity: event.city,
        clearCity: event.city == null,
        clearError: true,
      ),
    );
  }
}
