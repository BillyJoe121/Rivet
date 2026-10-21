import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/onboarding/role_selection_screen.dart';

void main() {
  testWidgets('RoleSelectionScreen solo muestra Cliente y Contratista (sin Proveedor)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RoleSelectionScreen(),
      ),
    );

    // Debe mostrar la cabecera clara
    expect(find.text('¿Cómo usarás Rivet?'), findsOneWidget);

    // Debe mostrar exactamente las opciones de Cliente y Contratista
    expect(find.text('Cliente'), findsOneWidget);
    expect(find.text('Contratista'), findsOneWidget);

    // NO debe existir la opción de Proveedor
    expect(find.text('Proveedor'), findsNothing);
  });
}
