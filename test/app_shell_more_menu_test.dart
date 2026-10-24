import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/home/app_shell.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester, UserRole role) async {
    await tester.pumpWidget(MaterialApp(home: AppShell(initialRole: role)));
    await tester.pumpAndSettle();
  }

  testWidgets('Más abre el panel sin cambiar la pantalla y lo cierra al tocar fuera', (tester) async {
    await pumpShell(tester, UserRole.client);

    expect(find.text('Tus proyectos'), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsNothing);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsOneWidget);
    expect(find.text('Tus proyectos'), findsOneWidget);

    await tester.tapAt(const Offset(20, 200));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsNothing);
  });

  testWidgets('Un destino del panel se abre dentro del shell', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Propuestas'));
    await tester.pumpAndSettle();

    expect(find.text('Propuestas recibidas'), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsNothing);
  });

  testWidgets('Ver todos lleva a la pestaña Proyectos', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.text('Ver todos'));
    await tester.pumpAndSettle();

    expect(find.text('Mis Proyectos'), findsOneWidget);
  });

  testWidgets('El contratista tiene Bodega y Mi perfil en Más', (tester) async {
    await pumpShell(tester, UserRole.contractor);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();

    expect(find.text('Bodega').hitTestable(), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsOneWidget);
  });
}
