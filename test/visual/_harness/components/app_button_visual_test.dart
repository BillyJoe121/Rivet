// Comparación visual de AppButton contra los nodos 2027:238 (sm),
// 66:14877 / 66:14611 (md) y 14:44 (lg) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_button.dart';

import '../figma_harness.dart';

Future<void> _render(
  WidgetTester tester,
  String name,
  double width,
  Widget child,
) async {
  final file = await renderComponentToPng(
    tester,
    SizedBox(width: width, child: child),
    name: 'components/$name',
    canvasSize: Size(width + 40, 120),
    padding: const EdgeInsets.all(20),
    background: AppColors.surface0,
    cropToComponent: true,
  );
  expect(file.existsSync(), isTrue);
}

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_button_sm', (tester) async {
    await _render(
      tester,
      'app_button_sm',
      348,
      AppButton(
        text: 'Preparar y despachar',
        onPressed: () {},
        size: AppButtonSize.sm,
        showChevron: true,
      ),
    );
  });

  testWidgets('app_button_md', (tester) async {
    await _render(
      tester,
      'app_button_md',
      368,
      AppButton(
        text: 'Reportar un problema con el pedido',
        onPressed: () {},
        showChevron: true,
      ),
    );
  });

  testWidgets('app_button_md_outline', (tester) async {
    await _render(
      tester,
      'app_button_md_outline',
      368,
      AppButton(
        text: 'Volver al inicio del proveedor',
        onPressed: () {},
        variant: AppButtonVariant.outline,
        showChevron: true,
      ),
    );
  });

  testWidgets('app_button_lg', (tester) async {
    await _render(
      tester,
      'app_button_lg',
      372,
      AppButton(
        text: 'Continuar',
        onPressed: () {},
        size: AppButtonSize.lg,
        showChevron: true,
      ),
    );
  });
}
