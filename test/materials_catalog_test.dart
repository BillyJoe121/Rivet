import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/core/widgets/widgets.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/supplier/catalog_filters.dart';
import 'package:rivet/features/supplier/catalog_mock.dart';
import 'package:rivet/features/supplier/material_price_tier.dart';
import 'package:rivet/features/supplier/materials_catalog_screen.dart';
import 'package:rivet/features/supplier/widgets/catalog_material_card.dart';

const _note = 'Verifica tu cuenta para acceder a precios de contratista.';

void main() {
  Future<void> pumpCatalog(WidgetTester tester, MaterialPriceTier tier) async {
    // Pantalla alta para que la lista construya todas las tarjetas.
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: MaterialsCatalogScreen(priceTier: tier)));
    await tester.pumpAndSettle();
  }

  Finder inSheet(String text) =>
      find.descendant(of: find.byType(AppBottomSheet), matching: find.text(text));

  Future<void> openFilters(WidgetTester tester) async {
    await tester.tap(find.byType(AppFilterField));
    await tester.pumpAndSettle();
  }

  Future<void> applyFilters(WidgetTester tester) async {
    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();
  }

  group('precio según quien consulta', () {
    testWidgets('el cliente ve solo el precio de cliente', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      expect(find.text('\$ 87.000'), findsOneWidget);
      expect(find.text('\$ 82.000'), findsNothing);
      for (final p in CatalogMock.products) {
        expect(find.text('\$ ${formatCop(p.proPriceCop)}'), findsNothing);
      }
      expect(find.text(_note), findsNothing);
    });

    testWidgets('el contratista verificado ve el precio de contratista', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.verifiedPro);

      expect(find.text('\$ 82.000'), findsOneWidget);
      // El de cliente aparece solo como referencia tachada.
      final reference = tester.widget<Text>(find.text('\$ 87.000'));
      expect(reference.style?.decoration, TextDecoration.lineThrough);
      expect(find.text(_note), findsNothing);
    });

    testWidgets('el contratista sin verificar ve precio de cliente y el aviso', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.unverifiedPro);

      expect(find.text('\$ 87.000'), findsOneWidget);
      expect(find.text('\$ 82.000'), findsNothing);
      expect(find.text(_note), findsOneWidget);
    });

    testWidgets('las tarjetas no son tocables', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      expect(find.byType(CatalogMaterialCard), findsWidgets);
      expect(
        find.descendant(of: find.byType(CatalogMaterialCard), matching: find.byType(InkWell)),
        findsNothing,
      );
    });
  });

  group('búsqueda', () {
    testWidgets('filtra por nombre', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      await tester.enterText(find.byType(TextField), 'porcelanato');
      await tester.pumpAndSettle();

      expect(find.text('Porcelanato gris mate'), findsOneWidget);
      expect(find.text('Porcelanato madera brillante'), findsOneWidget);
      expect(find.text('Pintura vinilo premium'), findsNothing);
    });

    testWidgets('filtra por marca y por categoría', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      await tester.enterText(find.byType(TextField), '3m');
      await tester.pumpAndSettle();
      expect(find.byType(CatalogMaterialCard), findsOneWidget);
      expect(find.text('Cinta de enmascarar 48 mm'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'accesorios');
      await tester.pumpAndSettle();
      expect(find.byType(CatalogMaterialCard), findsNWidgets(2));
    });

    testWidgets('sin coincidencias muestra el estado vacío y Limpiar filtros restaura la lista', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text('Sin resultados'), findsOneWidget);
      expect(find.byType(CatalogMaterialCard), findsNothing);

      await tester.tap(find.text('Limpiar filtros'));
      await tester.pumpAndSettle();
      expect(find.text('Sin resultados'), findsNothing);
      expect(find.byType(CatalogMaterialCard), findsNWidgets(CatalogMock.products.length));
    });
  });

  group('filtros y orden', () {
    testWidgets('la categoría reduce los resultados', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      await openFilters(tester);
      await tester.tap(inSheet('Estuco'));
      await tester.pumpAndSettle();
      await applyFilters(tester);

      expect(find.byType(CatalogMaterialCard), findsNWidgets(2));
      expect(find.text('Estuco plástico blanco'), findsOneWidget);
      expect(find.text('1 filtro activo'), findsOneWidget);
    });

    testWidgets('solo disponibles oculta los agotados', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);
      expect(find.text('Agotado'), findsWidgets);

      await openFilters(tester);
      await tester.tap(inSheet('Solo disponibles'));
      await tester.pumpAndSettle();
      await applyFilters(tester);

      expect(find.text('Agotado'), findsNothing);
      expect(find.text('Estuco acrílico fino'), findsNothing);
      final inStock = CatalogMock.products.where((p) => p.inStock).length;
      expect(find.byType(CatalogMaterialCard), findsNWidgets(inStock));
    });

    testWidgets('ordenar de menor a mayor y de mayor a menor', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      double top(String name) => tester.getTopLeft(find.text(name)).dy;

      await openFilters(tester);
      await tester.tap(inSheet('Menor a mayor'));
      await tester.pumpAndSettle();
      await applyFilters(tester);
      expect(top('Cinta de enmascarar 48 mm'), lessThan(top('Rodillo de lana 9"')));
      expect(top('Rodillo de lana 9"'), lessThan(top('Estuco plástico blanco')));

      await openFilters(tester);
      await tester.tap(inSheet('Mayor a menor'));
      await tester.pumpAndSettle();
      await applyFilters(tester);
      expect(top('Estuco plástico blanco'), lessThan(top('Rodillo de lana 9"')));
      expect(top('Rodillo de lana 9"'), lessThan(top('Cinta de enmascarar 48 mm')));
    });

    testWidgets('Limpiar en la hoja quita los filtros', (tester) async {
      await pumpCatalog(tester, MaterialPriceTier.client);

      await openFilters(tester);
      await tester.tap(inSheet('Solo disponibles'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Limpiar'));
      await tester.pumpAndSettle();
      await applyFilters(tester);

      expect(find.byType(CatalogMaterialCard), findsNWidgets(CatalogMock.products.length));
    });

    test('el rango de precio se evalúa sobre el precio que ve cada nivel', () {
      final over100k = MaterialFilters(priceRange: PriceRange.options.last);
      final client = over100k.apply(CatalogMock.products, MaterialPriceTier.client, '');
      final pro = over100k.apply(CatalogMock.products, MaterialPriceTier.verifiedPro, '');

      // El esmalte cuesta 104.000 para el cliente pero 99.000 para el contratista.
      expect(client.map((p) => p.id), contains('PV-008'));
      expect(pro.map((p) => p.id), isNot(contains('PV-008')));
    });

    test('el orden usa el precio del nivel', () {
      const asc = MaterialFilters(sort: MaterialSort.priceAsc);
      for (final tier in [MaterialPriceTier.client, MaterialPriceTier.verifiedPro]) {
        final prices = asc.apply(CatalogMock.products, tier, '').map(tier.priceOf).toList();
        expect(prices, [...prices]..sort());
      }
    });
  });

  group('sin proveedores', () {
    for (final tier in MaterialPriceTier.values) {
      testWidgets('no aparece FerreCasa ni proveedores ($tier)', (tester) async {
        await pumpCatalog(tester, tier);

        expect(find.textContaining('FerreCasa', findRichText: true), findsNothing);
        expect(find.textContaining('Proveedor', findRichText: true), findsNothing);
      });
    }
  });

  group('RivetUser.isVerified', () {
    test('es falso por defecto y se lee de is_verified', () {
      expect(const RivetUser(id: '1', email: '', fullName: '', role: UserRole.contractor).isVerified, isFalse);
      expect(RivetUser.fromJson({'id': '1'}).isVerified, isFalse);
      expect(RivetUser.fromJson({'id': '1', 'is_verified': true}).isVerified, isTrue);
    });

    test('copyWith lo conserva o lo cambia y toJson no lo envía', () {
      final user = RivetUser.fromJson({'id': '1', 'is_verified': true});
      expect(user.copyWith(fullName: 'Ana').isVerified, isTrue);
      expect(user.copyWith(isVerified: false).isVerified, isFalse);
      expect(user.toJson().containsKey('is_verified'), isFalse);
    });
  });
}
