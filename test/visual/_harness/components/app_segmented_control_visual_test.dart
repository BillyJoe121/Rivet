// Comparación visual de AppSegmentedControl contra el nodo 22:145919
// ("Pestañas" de Mis propuestas) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_segmented_control.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_segmented_control', (tester) async {
    final file = await renderComponentToPng(
      tester,
      SizedBox(
        width: 368,
        child: AppSegmentedControl<int>(
          items: const {0: 'Propuestas', 1: 'Trabajos'},
          selected: 0,
          onChanged: (_) {},
        ),
      ),
      name: 'components/app_segmented_control',
      canvasSize: const Size(408, 80),
      padding: const EdgeInsets.all(20),
      background: AppColors.paper100,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
