import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_catalog_materials_usecase.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

export 'catalog_event.dart';
export 'catalog_state.dart';

/// BLoC que gobierna la consulta, filtrado y búsqueda de insumos en la Bodega Rivet.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this._getCatalogMaterialsUseCase) : super(const CatalogState()) {
    on<LoadCatalogProducts>(_onLoadProducts);
    on<CatalogCategoryChanged>(_onCategoryChanged);
    on<CatalogSearchQueryChanged>(_onSearchQueryChanged);
    on<CatalogErrorDismissed>(_onErrorDismissed);
  }

  final GetCatalogMaterialsUseCase _getCatalogMaterialsUseCase;

  Future<void> _onLoadProducts(
    LoadCatalogProducts event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: CatalogStatus.loading, clearError: true));
    try {
      final list = await _getCatalogMaterialsUseCase(
        category: event.category ?? state.selectedCategory,
        searchQuery: event.searchQuery ?? state.searchQuery,
      );
      emit(state.copyWith(
        status: CatalogStatus.success,
        products: list,
        selectedCategory: event.category ?? state.selectedCategory,
        searchQuery: event.searchQuery ?? state.searchQuery,
      ));
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: CatalogStatus.failure,
        errorMessage: clean,
      ));
    }
  }

  Future<void> _onCategoryChanged(
    CatalogCategoryChanged event,
    Emitter<CatalogState> emit,
  ) async {
    add(LoadCatalogProducts(
      category: event.category,
      searchQuery: state.searchQuery,
    ));
  }

  Future<void> _onSearchQueryChanged(
    CatalogSearchQueryChanged event,
    Emitter<CatalogState> emit,
  ) async {
    add(LoadCatalogProducts(
      category: state.selectedCategory,
      searchQuery: event.query,
    ));
  }

  void _onErrorDismissed(
    CatalogErrorDismissed event,
    Emitter<CatalogState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}

