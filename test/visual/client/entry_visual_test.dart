import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/auth/login_screen.dart';
import 'package:rivet/features/auth/signup_screen.dart';
import 'package:rivet/features/onboarding/welcome_screen.dart';

import 'client_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('49:3 pantalla inicial', skip: harnessSkipReason != null, (tester) async {
    await renderFrame(tester, const WelcomeScreen(), name: '49-3', statusBar: false, gestureBar: false);
  });

  testWidgets('93:56 login', skip: harnessSkipReason != null, (tester) async {
    await renderFrame(tester, const LoginScreen(), name: '93-56');
  });

  testWidgets('11:196 signup', skip: harnessSkipReason != null, (tester) async {
    await renderFrame(tester, const SignupScreen(), name: '11-196');
  });
}
