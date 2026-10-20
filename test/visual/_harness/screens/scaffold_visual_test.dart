import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/app_bottom_nav.dart';
import 'package:rivet/core/widgets/rivet_scaffold.dart';

import '../figma_harness.dart';

/// Estructura de pantalla contra el frame 2027:210 "Pedidos · Con despacho":
/// imagen de cabecera, cabecera con volver + título y navegación inferior.
void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('RivetScaffold + AppBottomNav como Pedidos', (tester) async {
    await renderToPng(
      tester,
      Scaffold(
        backgroundColor: AppColors.paper100,
        body: const RivetScaffold(
          title: 'Pedidos',
          backgroundImagePath: AppHeroImages.paintShelf,
          body: SizedBox.shrink(),
        ),
        bottomNavigationBar: AppBottomNav(
          destinations: AppNavDestinations.professional,
          currentIndex: 0,
          onSelected: (_) {},
        ),
      ),
      name: 'screens/scaffold_pedidos',
      systemPadding: const EdgeInsets.only(top: 36, bottom: 24),
    );
  });
}
