// Prueba de humo del arnés visual: verifica que Lora, Roboto y los iconos de
// Material y Lucide se rendericen con sus fuentes reales y que se escriba el PNG.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('harness_smoke', (tester) async {
    final file = await renderComponentToPng(
      tester,
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lora 28 Hamburgefonstiv',
            style: TextStyle(fontFamily: 'Lora', fontSize: 28),
          ),
          SizedBox(height: 8),
          Text(
            'ROBOTO 600 12 · Hamburgefonstiv 0123',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 32),
              Icon(Icons.favorite, size: 32, color: Colors.red),
              Icon(Icons.arrow_back, size: 32),
              SizedBox(width: 16),
              // Iconos Lucide (los que usa el diseño de Figma).
              Icon(LucideIcons.house, size: 32),
              Icon(LucideIcons.messageSquare, size: 32),
              Icon(LucideIcons.chevronRight, size: 32),
            ],
          ),
        ],
      ),
      name: 'harness_smoke',
      canvasSize: const Size(412, 200),
      padding: const EdgeInsets.all(16),
    );

    expect(file.existsSync(), isTrue);
    expect(harnessIconsLoaded, isTrue);
    expect(harnessLucideLoaded, isTrue);
  });

  testWidgets('harness_smoke_crop_asset', (tester) async {
    final file = await renderComponentToPng(
      tester,
      Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'Fondos/Escudo de confianza entre hojas verdes.png',
              height: 120,
            ),
            const Text('Recorte', style: TextStyle(fontFamily: 'Lora')),
          ],
        ),
      ),
      name: 'harness_smoke_crop',
      padding: const EdgeInsets.all(24),
      cropToComponent: true,
    );

    expect(file.existsSync(), isTrue);
  });
}
