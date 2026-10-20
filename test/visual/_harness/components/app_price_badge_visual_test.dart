// Comparación visual de AppPriceBadge contra el nodo 22:144789 ("Tarjeta"
// de precio en Detalle de material) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_price_badge.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_price_badge', (tester) async {
    final file = await renderComponentToPng(
      tester,
      const SizedBox(width: 368, child: AppPriceBadge(priceCop: '\$ 87.000')),
      name: 'components/app_price_badge',
      canvasSize: const Size(408, 120),
      padding: const EdgeInsets.all(20),
      background: AppColors.paper100,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
