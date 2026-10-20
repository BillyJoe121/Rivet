import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/data/mock_data.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';
import 'package:rivet/features/supplier/choose_supplier_screen.dart';
import 'package:rivet/features/supplier/link_supplier_screen.dart';
import 'package:rivet/features/supplier/materials_delivery_screen.dart';
import 'package:rivet/features/supplier/materials_order_screen.dart';
import 'package:rivet/features/supplier/prepare_dispatch_screen.dart';
import 'package:rivet/features/supplier/pro_rate_authorization_screen.dart';
import 'package:rivet/features/supplier/supplier_orders_screen.dart';

import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('2027:119 Pedidos sin despachos', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const SupplierOrdersScreen(),
      name: '2027-119',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('2027:210 Pedidos con despacho', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const SupplierOrdersScreen(dispatched: true),
      name: '2027-210',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14749 Preparar y despachar pedido', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const PrepareDispatchScreen(),
      name: '66-14749',
      nav: ProNavDestination.projects,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14806 Seguimiento del pedido de materiales', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const MaterialsDeliveryScreen(),
      name: '66-14806',
      nav: ProNavDestination.projects,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14548 Solicitudes de vinculación', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      ProRateAuthorizationScreen(contractor: MockData.contractors.first),
      name: '66-14548',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14148 Vincular proveedor', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const LinkSupplierScreen(),
      name: '66-14148',
      nav: ProNavDestination.more,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('66:14210 Elegir proveedor para cotizar', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const ChooseSupplierScreen(),
      name: '66-14210',
      nav: ProNavDestination.proposals,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('45:222 Confirmación de pago del trabajo', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const MaterialsOrderScreen(),
      name: '45-222',
      nav: ProNavDestination.projects,
    );
    expect(tester.takeException(), isNull);
  });
}
