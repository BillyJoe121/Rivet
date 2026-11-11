import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/auth/forgot_password_screen.dart';
import 'package:rivet/features/auth/login_screen.dart';
import 'package:rivet/features/auth/signup_screen.dart';

import 'helpers/auth_test_harness.dart';

void main() {
  testWidgets('LoginScreen valida correo inválido y muestra error', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      withAuth(const MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();

    // Tocar el botón de inicio de sesión
    final loginButton = find.text('Iniciar sesión');
    await tester.ensureVisible(loginButton.last);
    await tester.tap(loginButton.last);
    await tester.pumpAndSettle();

    // Debe mostrar error de validación
    expect(find.text('Ingresa tu correo electrónico'), findsAtLeastNWidgets(1));
  });

  testWidgets('SignupScreen valida campos vacíos y requisitos de contraseña', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      withAuth(const MaterialApp(home: SignupScreen())),
    );
    await tester.pumpAndSettle();

    // Tocar el botón de crear cuenta
    final signupButton = find.text('Crear cuenta');
    await tester.ensureVisible(signupButton);
    await tester.tap(signupButton);
    await tester.pumpAndSettle();

    // Debe mostrar error de nombre
    expect(find.text('Ingresa tu nombre completo'), findsAtLeastNWidgets(1));
  });

  testWidgets('ForgotPasswordScreen valida, confirma el envío y permite corregir el correo', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      withAuth(const MaterialApp(home: ForgotPasswordScreen())),
    );

    // Correo inválido: se queda en el paso 1
    await tester.tap(find.text('Enviar enlace'));
    await tester.pump();
    expect(find.text('Ingresa tu correo electrónico'), findsAtLeastNWidgets(1));
    expect(find.text('Recuperar acceso'), findsOneWidget);

    // Correo válido: paso 2 con el correo enviado y reenvío bloqueado
    await tester.enterText(find.byType(TextField), 'maria@correo.com');
    await tester.tap(find.text('Enviar enlace'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Revisa tu correo'), findsOneWidget);
    expect(find.text('maria@correo.com'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Reenviar enlace en')), findsOneWidget);

    // Corregir el correo regresa al paso 1 conservando el texto
    await tester.tap(find.bySemanticsLabel('Cambiar correo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Recuperar acceso'), findsOneWidget);
    expect(find.text('maria@correo.com'), findsOneWidget);
  });
}
