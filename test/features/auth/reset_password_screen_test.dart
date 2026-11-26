import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_button.dart';
import 'package:rivet/features/auth/reset_password_screen.dart';
import 'package:rivet/injection_container.dart';

import '../../helpers/auth_test_harness.dart';
import 'reset_password_bloc_test.dart';

void main() {
  late FakeUpdatePasswordAuthRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeUpdatePasswordAuthRepository();
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget buildScreen() {
    return withAuth(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ResetPasswordScreen(),
      ),
      repository: fakeRepo,
    );
  }

  testWidgets('ResetPasswordScreen renderiza campos y botón de guardar',
      (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 868 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Nueva contraseña'), findsWidgets);
    expect(find.text('Confirma la contraseña'), findsOneWidget);
    expect(find.text('Guardar contraseña'), findsOneWidget);
  });

  testWidgets('muestra error si la contraseña es menor a 8 caracteres',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    // Ingresar texto corto en ambos campos
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    await tester.enterText(textFields.at(0), 'Short1!');
    await tester.enterText(textFields.at(1), 'Short1!');
    await tester.pump();

    final button = find.byType(AppButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(
      find.text('La contraseña debe tener al menos 8 caracteres'),
      findsAtLeastNWidgets(1),
    );
  });
}
