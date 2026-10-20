// Comparación visual de AppBadge contra los nodos 66:14765 (estándar),
// 2027:259 (compacto) y 2027:228 (conteo) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_badge.dart';

import '../figma_harness.dart';

Future<void> _render(WidgetTester tester, String name, Widget child) async {
  final file = await renderComponentToPng(
    tester,
    child,
    name: 'components/$name',
    canvasSize: const Size(240, 80),
    padding: const EdgeInsets.all(20),
    background: AppColors.surface0,
    cropToComponent: true,
  );
  expect(file.existsSync(), isTrue);
}

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_badge', (tester) async {
    await _render(
      tester,
      'app_badge',
      const AppBadge(
        text: 'Pedido confirmado',
        variant: AppBadgeVariant.success,
      ),
    );
  });

  testWidgets('app_badge_compact', (tester) async {
    await _render(
      tester,
      'app_badge_compact',
      const AppBadge(
        text: 'Listo para retiro',
        variant: AppBadgeVariant.success,
        compact: true,
      ),
    );
  });

  testWidgets('app_badge_count', (tester) async {
    await _render(tester, 'app_badge_count', const AppBadge.count(text: '2'));
  });
}
