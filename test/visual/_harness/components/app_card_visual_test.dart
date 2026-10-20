// Comparación visual de AppCard contra el nodo 2027:231 ("Pedido") del Figma.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_button.dart';
import 'package:rivet/core/widgets/app_card.dart';

import '../figma_harness.dart';

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('app_card', (tester) async {
    final file = await renderComponentToPng(
      tester,
      SizedBox(
        width: 368,
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('María Gómez', style: AppTypography.labelStrong),
                  Text(
                    'Sin despachar',
                    style: AppTypography.badgeText
                        .copyWith(color: AppColors.warning800),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text('Estuco plástico blanco', style: AppTypography.bodyStrong),
              const SizedBox(height: 5),
              Text(
                'EP-002 · 20 galones · Total \$ 480.000 COP',
                style: AppTypography.caption,
              ),
              const SizedBox(height: 5),
              Text(
                'Retiro en tienda · 17 de mayo de 2024',
                style: AppTypography.caption,
              ),
              const SizedBox(height: 5),
              AppButton(
                text: 'Preparar y despachar',
                onPressed: () {},
                size: AppButtonSize.sm,
                showChevron: true,
              ),
            ],
          ),
        ),
      ),
      name: 'components/app_card',
      canvasSize: const Size(408, 180),
      padding: const EdgeInsets.all(20),
      cropToComponent: true,
    );
    expect(file.existsSync(), isTrue);
  });
}
