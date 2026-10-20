import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';

/// Renders professional and supplier screens at the Figma frame size
/// (412x868 at 2x) with the real Lora and Roboto fonts and writes PNGs to
/// `build/visual/pro/` for side-by-side comparison with the Figma export.
const Size kFrameSize = Size(ProLayout.frameWidth, ProLayout.frameHeight);
const String kOutputDir = 'build/visual/pro';

/// Fonts come from `assets/fonts` when bundled, or from the shared spec folder.
final List<String> _fontDirs = [
  if (Platform.environment['RIVET_FONTS_DIR'] != null) Platform.environment['RIVET_FONTS_DIR']!,
  'assets/fonts',
  '../Rivet-figma-spec/fonts',
];

bool fontsLoaded = false;

/// True when the TTF files exist, so visual tests can be skipped otherwise.
bool get fontsAvailable => _fontDirs.any((d) => File('$d/Roboto-Regular.ttf').existsSync());

Future<void> loadProFonts() async {
  if (fontsLoaded) return;
  final dir = _fontDirs.firstWhere((d) => File('$d/Roboto-Regular.ttf').existsSync());
  for (final family in [ProFonts.sans, ProFonts.serif]) {
    final loader = FontLoader(family);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      final file = File('$dir/$family-$weight.ttf');
      if (file.existsSync()) {
        loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
      }
    }
    await loader.load();
  }
  fontsLoaded = true;
}

/// Pumps [screen] inside the frame chrome (status bar, gesture bar) and
/// writes `build/visual/pro/<name>.png`. When [nav] is given, the bottom
/// navigation is appended as the app shell would show it.
Future<File> renderFrame(
  WidgetTester tester,
  Widget screen, {
  required String name,
  ProNavDestination? nav,
  bool navCentered = false,
  Color background = ProColors.paper100,
}) async {
  tester.view.physicalSize = kFrameSize * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  final key = GlobalKey();
  Widget body = screen;
  if (nav != null) {
    body = Builder(
      builder: (context) => Column(
        children: [
          Expanded(child: MediaQuery.removePadding(context: context, removeBottom: true, child: screen)),
          ProBottomNav(active: nav, centered: navCentered, onSelect: (_) {}),
        ],
      ),
    );
  }

  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: ProFonts.sans, scaffoldBackgroundColor: background),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(top: 36, bottom: 24),
            viewPadding: const EdgeInsets.only(top: 36, bottom: 24),
          ),
          child: Stack(
            children: [
              child!,
              const Positioned(top: 0, left: 0, right: 0, height: 36, child: _StatusBar()),
              const Positioned(left: 0, right: 0, bottom: 0, height: 24, child: _GestureBar()),
            ],
          ),
        ),
        home: Builder(builder: (_) => body),
      ),
    ),
  );
  await _precache(tester);
  await tester.pump(const Duration(milliseconds: 300));
  await _precache(tester);
  await tester.pump();

  final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  });
  final file = File('$kOutputDir/$name.png');
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes!);
  return file;
}

Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate().toList()) {
      final widget = element.widget as Image;
      await precacheImage(widget.image, element, onError: (_, _) {});
    }
  });
  await tester.pump();
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Text('9:41', style: ProText.r(14, weight: FontWeight.w600, color: ProColors.statusInk, lineHeight: 16.40625)),
          const Spacer(),
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(color: Color(0xFF192421), shape: BoxShape.circle),
          ),
          const Spacer(),
          const SizedBox(width: 51, height: 14, child: CustomPaint(painter: _ConnectionPainter())),
        ],
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  const _ConnectionPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()..color = ProColors.statusInk;
    final wifi = Paint()
      ..color = ProColors.statusInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    for (final r in [3.0, 6.5, 10.0]) {
      canvas.drawArc(Rect.fromCircle(center: const Offset(7, 13), radius: r), -2.3, 1.6, false, wifi);
    }
    canvas.drawPath(
      Path()
        ..moveTo(20, 14)
        ..lineTo(36, 14)
        ..lineTo(36, 0)
        ..close(),
      ink,
    );
    canvas.drawRRect(RRect.fromLTRBR(42, 0, 51, 14, const Radius.circular(1)), ink);
  }

  @override
  bool shouldRepaint(_ConnectionPainter oldDelegate) => false;
}

class _GestureBar extends StatelessWidget {
  const _GestureBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProColors.surface0,
      alignment: Alignment.center,
      child: Container(
        width: 108,
        height: 4,
        decoration: BoxDecoration(color: ProColors.gestureBar, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}
