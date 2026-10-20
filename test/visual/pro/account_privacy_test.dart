import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/account/privacy_preferences_screen.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';

import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('22:146416 Cuenta, privacidad y preferencias', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      const PrivacyPreferencesScreen(currentRole: UserRole.client),
      name: '22-146416',
      nav: ProNavDestination.more,
    );
    expect(tester.takeException(), isNull);
  });
}
