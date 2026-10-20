import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/admin/admin_dashboard_screen.dart';
import 'package:rivet/features/admin/admin_dispute_resolution_screen.dart';
import 'package:rivet/features/finance/financial_transactions_screen.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';

import 'pro_harness.dart';

/// Finanzas y administración sin frame de Figma: solo comprueban que las
/// pantallas renderizan con el kit y guardan PNG para revisión visual.
void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('Movimientos y finanzas (P-038)', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const FinancialTransactionsScreen(currentRole: UserRole.client),
      name: 'finance-transactions',
      nav: ProNavDestination.more,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Movimientos y Finanzas'), findsOneWidget);
    expect(find.text('Registro de Operaciones (P-038)'), findsOneWidget);
  });

  testWidgets('Panel administrativo (P-045)', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const AdminDashboardScreen(),
      name: 'admin-dashboard',
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Panel Administrativo'), findsOneWidget);
    expect(find.text('Resumen de Operación (P-045)'), findsOneWidget);
  });

  testWidgets('Resolución de casos y tarifas (P-046 / P-047)', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const AdminDisputeResolutionScreen(),
      name: 'admin-dispute-resolution',
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Políticas y Casos'), findsOneWidget);
    expect(find.text('Resolución Fundada de Casos (P-046)'), findsOneWidget);
  });
}
