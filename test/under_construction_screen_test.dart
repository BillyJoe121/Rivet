import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/under_construction/under_construction_screen.dart';

void main() {
  // La animación corre en bucle: se avanza con duraciones fijas.
  Future<void> advance(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('Muestra título, mensaje y sección sin botón volver como raíz', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UnderConstructionScreen(section: 'Bodega')));
    await advance(tester);

    expect(find.text('Pantalla en construcción'), findsOneWidget);
    expect(find.text('Esta sección aún no está disponible.'), findsOneWidget);
    expect(find.text('Bodega'), findsOneWidget);
    expect(find.bySemanticsLabel('Volver'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Con push muestra volver y regresa a la pantalla anterior', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const UnderConstructionScreen(section: 'Proyectos')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await advance(tester);
    expect(find.text('Pantalla en construcción'), findsOneWidget);
    expect(find.bySemanticsLabel('Volver'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Volver'));
    await advance(tester);
    expect(find.text('Abrir'), findsOneWidget);
    expect(find.text('Pantalla en construcción'), findsNothing);
  });

  testWidgets('La animación recorre un ciclo completo sin errores', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: UnderConstructionScreen()));
    for (var i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Con animaciones desactivadas queda estática y se estabiliza', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(const MaterialApp(home: UnderConstructionScreen(section: 'Bodega')));
    await tester.pumpAndSettle();

    expect(find.text('Pantalla en construcción'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cabe en una pantalla pequeña sin desbordar', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: UnderConstructionScreen(section: 'Bodega')));
    await advance(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Esta sección aún no está disponible.'), findsOneWidget);
  });
}
