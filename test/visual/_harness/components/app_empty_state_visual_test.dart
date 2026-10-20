// Comparación visual de AppEmptyState contra el nodo 2027:181 ("Sin pedidos
// despachados") del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_empty_state.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_empty_state', (tester) async {
    final file = await renderComponentToPng(
      tester,
      const SizedBox(
        width: 368,
        child: AppEmptyState(
          icon: LucideIcons.truck,
          title: 'Aún no hay pedidos despachados',
          message: 'Cuando confirmes un despacho, aparecerá aquí para hacer '
              'seguimiento.',
        ),
      ),
      name: 'components/app_empty_state',
      canvasSize: const Size(408, 110),
      padding: const EdgeInsets.all(20),
      background: AppColors.paper100,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
