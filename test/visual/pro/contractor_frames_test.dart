import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/home/contractor_home_view.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';

import 'pro_harness.dart';

void main() {
  setUpAll(() async {
    if (fontsAvailable) await loadProFonts();
  });

  testWidgets('22:145582 Hola, Carlos', skip: !fontsAvailable, (tester) async {
    await renderFrame(
      tester,
      ContractorHomeView(onSwitchRole: (_) {}),
      name: '22-145582',
      nav: ProNavDestination.home,
    );
    expect(tester.takeException(), isNull);
  });
}
