import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/widgets/app_back_button.dart';
import 'package:rivet/core/widgets/rivet_scaffold.dart';
import 'package:rivet/features/auth/forgot_password_screen.dart';
import 'package:rivet/features/auth/login_screen.dart';
import 'package:rivet/features/auth/signup_screen.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';

/// (800×1600 evita desbordes por la fuente de prueba en las pantallas de auth.)
/// El botón volver es el mismo en todas las pantallas: caja táctil de 48×48 y
/// toda ella responde al toque.
void main() {
  const volver = 'Volver';

  Future<void> pushScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => screen),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  final screens = <String, Widget>{
    'RivetScaffold': const RivetScaffold(title: 'Prueba', showHeroImage: false, body: SizedBox()),
    'ProBackHeader': const Scaffold(body: ProBackHeader(title: 'Prueba')),
    'LoginScreen': const LoginScreen(),
    'ForgotPasswordScreen': const ForgotPasswordScreen(),
    'SignupScreen': const SignupScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key}: el botón volver mide al menos 48×48', (tester) async {
      await pushScreen(tester, entry.value);

      final size = tester.getSize(find.bySemanticsLabel(volver));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(find.byType(AppBackButton), findsOneWidget);
    });

    testWidgets('${entry.key}: tocar cerca de cada esquina de la caja de 48 vuelve', (tester) async {
      await pushScreen(tester, entry.value);

      final rect = tester.getRect(find.byType(AppBackButton));
      for (final corner in [rect.topLeft, rect.topRight, rect.bottomLeft, rect.bottomRight]) {
        // 4 px hacia el interior de la esquina (fuera del círculo de 40).
        final point = corner + Offset(corner.dx == rect.left ? 4 : -4, corner.dy == rect.top ? 4 : -4);
        await tester.tapAt(point);
        await tester.pumpAndSettle();
        expect(find.text('Abrir'), findsOneWidget, reason: 'la esquina $point no volvió');

        await tester.tap(find.text('Abrir'));
        await tester.pumpAndSettle();
        expect(find.byType(AppBackButton), findsOneWidget);
      }
    });
  }

  testWidgets('onPressed reemplaza a maybePop', (tester) async {
    var llamadas = 0;
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: AppBackButton(onPressed: () => llamadas++)))),
    );
    await tester.tap(find.byType(AppBackButton));
    await tester.pump();
    expect(llamadas, 1);
  });
}
