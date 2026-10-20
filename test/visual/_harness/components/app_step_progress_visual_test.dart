// Comparación visual de AppStepProgress contra el nodo 22:143813
// ("Indicador de pasos" de Crear proyecto) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_step_progress.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_step_progress', (tester) async {
    final file = await renderComponentToPng(
      tester,
      const SizedBox(
        width: 368,
        child: AppStepProgress(
          steps: ['Detalles', 'Superficies', 'Revisión'],
          currentStep: 0,
        ),
      ),
      name: 'components/app_step_progress',
      canvasSize: const Size(408, 100),
      padding: const EdgeInsets.all(20),
      background: AppColors.paper100,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
