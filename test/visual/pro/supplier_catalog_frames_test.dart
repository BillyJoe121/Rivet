import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/home/supplier_home_view.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';
import 'package:rivet/features/supplier/add_catalog_product_screen.dart';
import 'package:rivet/features/supplier/catalog_mock.dart';
import 'package:rivet/features/supplier/manage_catalog_screen.dart';
import 'package:rivet/features/supplier/material_detail_screen.dart';
import 'package:rivet/features/supplier/materials_catalog_screen.dart';
import 'package:rivet/features/supplier/supplier_products_screen.dart';
import 'package:rivet/features/supplier/supplier_profile_screen.dart';

import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('22:146094 Inicio del proveedor', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      SupplierHomeView(onSwitchRole: (_) {}),
      name: '22-146094',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:144637 Bodega', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const MaterialsCatalogScreen(),
      name: '22-144637',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:144770 Detalle de material', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      MaterialDetailScreen(material: CatalogMock.paint, info: CatalogMock.products.first.info),
      name: '22-144770',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14377 Agregar material al catálogo', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const AddCatalogProductScreen(),
      name: '66-14377',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:144701 Perfil de proveedor', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const SupplierProfileScreen(),
      name: '22-144701',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('53:137 Productos FerreCasa', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const SupplierProductsScreen(),
      name: '53-137',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('22:146203 Administrar catálogo y precios', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const ManageCatalogScreen(),
      name: '22-146203',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });
}
