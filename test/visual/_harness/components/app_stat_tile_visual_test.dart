// Comparación visual de AppStatTile contra el nodo 22:146135 (fila de
// "Resumen" en Inicio del proveedor) del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_stat_tile.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_stat_tile', (tester) async {
    const tiles = [
      ('28', 'productos'),
      ('6', 'solicitudes nuevas'),
      ('4', 'pedidos en curso'),
      ('3', 'con bajo stock'),
    ];
    final file = await renderComponentToPng(
      tester,
      SizedBox(
        width: 368,
        child: Row(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0) const SizedBox(width: 7),
              Expanded(
                child: AppStatTile(value: tiles[i].$1, label: tiles[i].$2),
              ),
            ],
          ],
        ),
      ),
      name: 'components/app_stat_tile',
      canvasSize: const Size(408, 112),
      padding: const EdgeInsets.all(20),
      background: AppColors.paper100,
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
