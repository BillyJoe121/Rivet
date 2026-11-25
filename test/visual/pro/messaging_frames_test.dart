import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/messaging/messaging_screens.dart';

import '../../helpers/repositories_test_harness.dart';
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
      withRepositories(ConversationsListScreen.withBloc()),
      name: '22-146347',
      navIndex: 3,
    );
    expect(tester.takeException(), isNull);
  });
}
