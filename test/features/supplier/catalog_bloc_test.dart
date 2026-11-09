import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/supplier/domain/repositories/catalog_repository.dart';
import 'package:rivet/features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';

class FakeCatalogRepository implements CatalogRepository {
  List<MaterialProduct> products = [];

  @override
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    Iterable<MaterialProduct> res = products;
    if (category != null && category != 'Todos') {
      res = res.where((p) => p.category == category);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      res = res.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()));
    }
    return res.toList();
  }

  @override
  Future<MaterialProduct> getProductDetail(String productId) async {
    return products.firstWhere((p) => p.id == productId);
  }
}

void main() {
  late FakeCatalogRepository repo;
  late CatalogBloc bloc;

  final samplePaint = const MaterialProduct(
    id: 'mat-1',
    name: 'Pintura Vinilo Lavable',
    brand: 'Rivet',
    category: 'Pinturas',
    unit: 'galón',
    clientPriceCop: 95000,
    proPriceCop: 88000,
  );

  final sampleStucco = const MaterialProduct(
    id: 'mat-2',
    name: 'Estuco Plástico',
    brand: 'Sika',
    category: 'Estuco',
    unit: '5 galones',
    clientPriceCop: 120000,
    proPriceCop: 110000,
  );

  setUp(() {
    repo = FakeCatalogRepository();
    repo.products = [samplePaint, sampleStucco];
    bloc = CatalogBloc(GetCatalogMaterialsUseCase(repo));
  });

  tearDown(() => bloc.close());

  test('estado inicial de CatalogBloc', () {
    expect(bloc.state.status, CatalogStatus.initial);
    expect(bloc.state.products, isEmpty);
    expect(bloc.state.selectedCategory, 'Todos');
  });

  test('LoadCatalogProducts emite [loading, success] con lista de insumos', () async {
    bloc.add(const LoadCatalogProducts());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CatalogState>().having((s) => s.status, 'status', CatalogStatus.loading),
        isA<CatalogState>()
            .having((s) => s.status, 'status', CatalogStatus.success)
            .having((s) => s.products.length, 'count', 2),
      ]),
    );
  });

  test('filtrado por categoría reduce resultados', () async {
    bloc.add(const CatalogCategoryChanged('Pinturas'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CatalogState>().having((s) => s.status, 'status', CatalogStatus.loading),
        isA<CatalogState>()
            .having((s) => s.status, 'status', CatalogStatus.success)
            .having((s) => s.products.length, 'count', 1)
            .having((s) => s.products.first.name, 'name', 'Pintura Vinilo Lavable'),
      ]),
    );
  });
}

