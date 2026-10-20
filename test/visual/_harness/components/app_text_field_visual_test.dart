// Comparación visual de AppTextField contra los nodos 11:220 y 11:238
// ("Campo de registro") del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_text_field.dart';

import '../figma_harness.dart';

Future<void> _render(WidgetTester tester, String name, Widget child) async {
  final file = await renderComponentToPng(
    tester,
    SizedBox(width: 372, child: child),
    name: 'components/$name',
    canvasSize: const Size(412, 110),
    padding: const EdgeInsets.all(20),
    background: AppColors.surface0,
    cropToComponent: true,
  );
  expect(file.existsSync(), isTrue);
}

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_text_field', (tester) async {
    await _render(
      tester,
      'app_text_field',
      const AppTextField(
        label: 'Nombre completo',
        hint: 'Juan Pérez',
        prefixIcon: LucideIcons.user,
      ),
    );
  });

  testWidgets('app_text_field_password', (tester) async {
    await _render(
      tester,
      'app_text_field_password',
      const AppTextField(
        label: 'Contraseña',
        hint: '••••••••••••',
        prefixIcon: LucideIcons.lock,
        isPassword: true,
      ),
    );
  });
}
