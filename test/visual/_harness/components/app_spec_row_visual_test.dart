// Comparación visual de AppSpecRow contra el nodo 22:144798 ("Opción" de
// Detalle de material) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_spec_row.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_spec_row', (tester) async {
    final file = await renderComponentToPng(
      tester,
      SizedBox(
        width: 362,
        child: AppSpecRow(
          icon: LucideIcons.badge,
          label: 'Marca',
          value: 'Rivet',
          onTap: () {},
        ),
      ),
      name: 'components/app_spec_row',
      canvasSize: const Size(402, 80),
      padding: const EdgeInsets.all(20),
      background: AppColors.surface0,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
