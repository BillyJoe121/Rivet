import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/auth/domain/entities/rivet_user.dart';
import 'package:rivet/features/home/app_shell.dart';
import 'package:rivet/features/onboarding/welcome_screen.dart';
import 'package:rivet/main.dart';

import 'helpers/auth_test_harness.dart';

void main() {
  // La bienvenida anima en bucle: pumpAndSettle no terminaría.
  Future<void> advance(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('Sin sesión guardada abre la bienvenida', (tester) async {
    await tester.pumpWidget(RivetApp(authRepository: InMemoryAuthRepository()));
    await advance(tester);

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Rivet'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Aún no tengo una cuenta'), findsOneWidget);
  });

  testWidgets('Muestra carga mientras verifica la sesión', (tester) async {
    await tester.pumpWidget(RivetApp(authRepository: InMemoryAuthRepository()));

    expect(find.bySemanticsLabel('Cargando tu sesión'), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsNothing);
    await advance(tester);
  });

  testWidgets('Con sesión guardada abre el shell del rol del usuario', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    const user = RivetUser(
      id: 'user-1',
      email: 'ana@correo.com',
      fullName: 'ana gómez',
      role: UserRole.contractor,
    );
    await tester.pumpWidget(
      RivetApp(authRepository: InMemoryAuthRepository(currentUser: user)),
    );
    await advance(tester);

    final shell = tester.widget<AppShell>(find.byType(AppShell));
    expect(shell.initialRole, UserRole.contractor);
    expect(find.byType(WelcomeScreen), findsNothing);
  });
}
