// Renderiza pantallas del propietario a 412x868 (2x) con las fuentes reales y
// escribe build/visual/client/<name>.png para compararlas con el export de
// Figma. Dibuja también la barra de estado y el indicador de gestos de los
// frames para que la comparación cubra el frame completo.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/projects/widgets/client_kit/client_kit.dart';

const Size kFigmaFrameSize = Size(412, 868);
const String kVisualOutputDir = 'build/visual/client';
const EdgeInsets kFigmaSystemPadding = EdgeInsets.only(top: 36, bottom: 24);

/// Carpeta con Lora-*.ttf y Roboto-*.ttf: la del proyecto o la compartida.
final String? harnessFontsDir = const ['assets/fonts', '../Rivet-figma-spec/fonts']
    .cast<String?>()
    .firstWhere((d) => File('$d/Roboto-Regular.ttf').existsSync(), orElse: () => null);

/// Motivo para omitir las pruebas visuales cuando faltan las fuentes.
final String? harnessSkipReason =
    harnessFontsDir == null ? 'Sin fuentes Lora/Roboto para el render visual' : null;

Future<void>? _fontsLoading;

Future<void> loadHarnessFonts() => _fontsLoading ??= _loadFonts();

Future<void> _loadFonts() async {
  final dir = harnessFontsDir;
  if (dir == null) return;
  for (final family in const ['Lora', 'Roboto']) {
    final loader = FontLoader(family);
    for (final w in const ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      final file = File('$dir/$family-$w.ttf');
      if (file.existsSync()) {
        loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
      }
    }
    await loader.load();
  }
}

final GlobalKey _canvasKey = GlobalKey(debugLabel: 'client_harness_canvas');

/// Renderiza [screen] como frame completo y devuelve el PNG escrito.
///
/// [statusBar] y [gestureBar] dibujan las barras falsas de Figma encima.
Future<File> renderFrame(
  WidgetTester tester,
  Widget screen, {
  required String name,
  Size size = kFigmaFrameSize,
  EdgeInsets systemPadding = kFigmaSystemPadding,
  bool statusBar = true,
  bool gestureBar = true,
  Color statusInk = RvColors.statusInk,
  double pixelRatio = 2,
}) async {
  await tester.runAsync(loadHarnessFonts);
  tester.view
    ..physicalSize = size * pixelRatio
    ..devicePixelRatio = pixelRatio;
  final physical = FakeViewPadding(
    left: systemPadding.left * pixelRatio,
    top: systemPadding.top * pixelRatio,
    right: systemPadding.right * pixelRatio,
    bottom: systemPadding.bottom * pixelRatio,
  );
  tester.view
    ..padding = physical
    ..viewPadding = physical;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => RepaintBoundary(
        key: _canvasKey,
        child: Stack(
          children: [
            child!,
            if (statusBar) Positioned(top: 0, left: 0, right: 0, child: FigmaStatusBar(ink: statusInk)),
            if (gestureBar) const Positioned(left: 0, right: 0, bottom: 0, child: FigmaGestureIndicator()),
          ],
        ),
      ),
      home: screen,
    ),
  );
  await _precacheImages(tester);
  await _settle(tester);
  if (await _precacheImages(tester)) await _settle(tester);

  final boundary = _canvasKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final file = File('$kVisualOutputDir/$name.png');
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List(), flush: true);
  });
  return file;
}

final Set<ImageProvider> _precached = <ImageProvider>{};

Future<bool> _precacheImages(WidgetTester tester) async {
  final pending = <(ImageProvider, BuildContext)>[];
  void add(ImageProvider? provider, BuildContext context) {
    if (provider != null && _precached.add(provider)) pending.add((provider, context));
  }

  for (final element in find.bySubtype<Widget>().evaluate()) {
    final widget = element.widget;
    if (widget is Image) {
      add(widget.image, element);
    } else if (widget is DecoratedBox && widget.decoration is BoxDecoration) {
      add((widget.decoration as BoxDecoration).image?.image, element);
    } else if (widget is CircleAvatar) {
      add(widget.backgroundImage, element);
    }
  }
  if (pending.isEmpty) return false;
  await tester.runAsync(() async {
    for (final (provider, context) in pending) {
      await precacheImage(provider, context, onError: (e, _) => debugPrint('[client_harness] $provider: $e'));
    }
  });
  await tester.pump();
  return true;
}

Future<void> _settle(WidgetTester tester) async {
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );
  } on FlutterError {
    // Animación infinita: se captura el frame actual.
  }
}

/// Barra de estado Android de los frames (alto 36, padding 25).
class FigmaStatusBar extends StatelessWidget {
  const FigmaStatusBar({super.key, this.ink = RvColors.statusInk});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 25,
            top: 9.5,
            child: Text('9:41', style: rvText(14, weight: FontWeight.w600, lineHeight: 16.8, color: ink)),
          ),
          Positioned(
            left: 201.5,
            top: 12,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: Color(0xFF192421), shape: BoxShape.circle),
            ),
          ),
          Positioned(left: 335.1, top: 12.1, child: RvIcon(RvIcons.statusWifi, color: ink)),
          Positioned(left: 356, top: 11, child: RvIcon(RvIcons.statusSignal, color: ink)),
          Positioned(
            left: 378,
            top: 11,
            child: Container(
              width: 9,
              height: 14,
              decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(1)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Indicador de gestos (108×4 `#25312E`) centrado en la franja inferior de 24.
class FigmaGestureIndicator extends StatelessWidget {
  const FigmaGestureIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Center(
        child: Container(
          width: 108,
          height: 4,
          decoration: BoxDecoration(color: RvColors.gestureBar, borderRadius: BorderRadius.circular(2)),
        ),
      ),
    );
  }
}
