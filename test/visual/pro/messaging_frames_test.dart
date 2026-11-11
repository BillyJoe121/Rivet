import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/design_system/design_system.dart';
import 'package:rivet/features/messaging/notifications_screen.dart';

import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('22:146347 Mensajes y notificaciones', skip: !fontsAvailable, (
    tester,
  ) async {
    await renderFrame(
      tester,
      const NotificationsScreen(),
      name: '22-146347',
      nav: ProNavDestination.messages,
    );
    expect(tester.takeException(), isNull);
  });
}
