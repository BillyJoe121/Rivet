// Utilidades de pruebas visuales: renderizan widgets con las fuentes reales
// del proyecto y escriben un PNG en build/visual/ para compararlo contra el
// export de Figma (pantallas de 412x868 px lógicos).
//
// Uso típico:
//
//   setUpAll(loadHarnessFonts);
//   testWidgets('welcome', (tester) async {
//     await renderToPng(tester, const WelcomeScreen(), name: 'welcome');
//   });
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/theme/theme.dart';

/// Tamaño lógico de los frames de Figma.
const Size kFigmaFrameSize = Size(412, 868);

/// Carpeta (relativa a la raíz del proyecto) donde se escriben los PNG.
const String kVisualOutputDir = 'build/visual';

const Map<String, List<String>> _projectFonts = {
  'Lora': [
    'assets/fonts/Lora-Regular.ttf',
    'assets/fonts/Lora-Medium.ttf',
    'assets/fonts/Lora-SemiBold.ttf',
    'assets/fonts/Lora-Bold.ttf',
  ],
  'Roboto': [
    'assets/fonts/Roboto-Regular.ttf',
    'assets/fonts/Roboto-Medium.ttf',
    'assets/fonts/Roboto-SemiBold.ttf',
    'assets/fonts/Roboto-Bold.ttf',
  ],
};

Future<void>? _fontsLoading;

/// Familias de iconos Lucide (paquete lucide_icons_flutter) y su archivo
/// dentro del paquete. Se registran como `packages/lucide_icons_flutter/<f>`,
/// que es como las referencia `IconData(fontPackage: ...)`.
const String _lucidePackage = 'lucide_icons_flutter';
const Map<String, String> _lucideFonts = {
  'Lucide': 'assets/lucide.ttf',
  'Lucide100': 'assets/build_font/LucideVariable-w100.ttf',
  'Lucide200': 'assets/build_font/LucideVariable-w200.ttf',
  'Lucide300': 'assets/build_font/LucideVariable-w300.ttf',
  'Lucide400': 'assets/build_font/LucideVariable-w400.ttf',
  'Lucide500': 'assets/build_font/LucideVariable-w500.ttf',
  'Lucide600': 'assets/build_font/LucideVariable-w600.ttf',
};

/// Indica si se pudo registrar la fuente de iconos de Material.
bool harnessIconsLoaded = false;

/// Indica si se pudo registrar la fuente principal de Lucide.
bool harnessLucideLoaded = false;

/// Carga Lora, Roboto, MaterialIcons y Lucide una sola vez por ejecución.
///
/// Llamarla en `setUpAll(loadHarnessFonts)` es lo más fiable; [renderToPng]
/// también la invoca (dentro de `runAsync`) por si se olvidó.
Future<void> loadHarnessFonts() => _fontsLoading ??= _loadFonts();

Future<void> _loadFonts() async {
  for (final entry in _projectFonts.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      final file = File(path);
      if (!file.existsSync()) {
        throw StateError(
          'No se encontró $path. Ejecuta `flutter test` desde la raíz del '
          'proyecto (cwd actual: ${Directory.current.path}).',
        );
      }
      final bytes = file.readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  final icons = await _materialIconsBytes();
  if (icons != null) {
    final loader = FontLoader('MaterialIcons')..addFont(Future.value(icons));
    await loader.load();
    harnessIconsLoaded = true;
  } else {
    // Sin la fuente los iconos se ven como cajas, pero la prueba sigue.
    debugPrint('[figma_harness] MaterialIcons no encontrada; iconos omitidos.');
  }

  final lucideRoot = _packageRoot(_lucidePackage);
  for (final entry in _lucideFonts.entries) {
    final bytes = await _packageFontBytes(lucideRoot, entry.value);
    if (bytes == null) {
      debugPrint('[figma_harness] ${entry.key} no encontrada; se omite.');
      continue;
    }
    final loader = FontLoader('packages/$_lucidePackage/${entry.key}')
      ..addFont(Future.value(bytes));
    await loader.load();
    if (entry.key == 'Lucide') harnessLucideLoaded = true;
  }
}

/// Bytes de una fuente de paquete: primero desde el bundle de pruebas y, si
/// no está, desde la carpeta del paquete en la caché de pub.
Future<ByteData?> _packageFontBytes(Directory? root, String relative) async {
  try {
    return await rootBundle.load('packages/$_lucidePackage/$relative');
  } catch (_) {
    // Continúa con la caché de pub.
  }
  if (root == null) return null;
  final file = File('${root.path}/$relative');
  if (!file.existsSync()) return null;
  return ByteData.sublistView(file.readAsBytesSync());
}

/// Carpeta raíz de [package] según `.dart_tool/package_config.json`.
Directory? _packageRoot(String package) {
  final config = File('.dart_tool/package_config.json');
  if (!config.existsSync()) return null;
  try {
    final json = jsonDecode(config.readAsStringSync()) as Map<String, dynamic>;
    for (final entry in json['packages'] as List<dynamic>) {
      final map = entry as Map<String, dynamic>;
      if (map['name'] != package) continue;
      // rootUri puede ser relativo a .dart_tool/ (dependencias por path).
      final uri = config.absolute.uri.resolve(map['rootUri'] as String);
      return Directory.fromUri(uri);
    }
  } catch (_) {
    return null;
  }
  return null;
}

Future<ByteData?> _materialIconsBytes() async {
  // 1) Bundle de pruebas (uses-material-design: true lo incluye).
  try {
    return await rootBundle.load('fonts/MaterialIcons-Regular.otf');
  } catch (_) {
    // Continúa con el SDK.
  }
  // 2) Caché de artefactos del SDK de Flutter.
  for (final root in _flutterRootCandidates()) {
    final dir = Directory('$root/bin/cache/artifacts/material_fonts');
    for (final name in const [
      'MaterialIcons-Regular.otf',
      'materialicons-regular.otf',
    ]) {
      final file = File('${dir.path}/$name');
      if (file.existsSync()) {
        return ByteData.sublistView(file.readAsBytesSync());
      }
    }
  }
  return null;
}

Iterable<String> _flutterRootCandidates() sync* {
  final env = Platform.environment['FLUTTER_ROOT'];
  if (env != null && env.isNotEmpty) yield env;
  // flutter_tester vive en <root>/bin/cache/artifacts/engine/<plataforma>/.
  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 8; i++) {
    if (Directory('${dir.path}/bin/cache/artifacts').existsSync()) {
      yield dir.path;
      return;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) return;
    dir = parent;
  }
}

/// Renderiza [child] como pantalla completa (por defecto 412x868 a 2x) y
/// escribe `build/visual/<name>.png`. Devuelve el archivo escrito.
///
/// [child] suele ser un `Scaffold`; se envuelve en `MaterialApp` con
/// `AppTheme.lightTheme`. [background] pinta detrás del widget (por defecto
/// el `scaffoldBackgroundColor` del tema). [settle] intenta `pumpAndSettle`
/// y, si hay animaciones infinitas, se queda con el último frame.
/// [systemPadding] simula barras del sistema (MediaQuery.padding y
/// viewPadding, en px lógicos), p. ej. `EdgeInsets.only(top: 36, bottom: 24)`
/// para las barras de estado y de navegación que dibujan los frames de Figma.
Future<File> renderToPng(
  WidgetTester tester,
  Widget child, {
  required String name,
  Size size = kFigmaFrameSize,
  double pixelRatio = 2,
  Color? background,
  bool settle = true,
  EdgeInsets systemPadding = EdgeInsets.zero,
}) {
  return _render(
    tester,
    child,
    name: name,
    size: size,
    pixelRatio: pixelRatio,
    background: background,
    settle: settle,
    systemPadding: systemPadding,
  );
}

/// Renderiza un componente con su tamaño intrínseco dentro de un lienzo de
/// [canvasSize], alineado según [alignment] (arriba a la izquierda por
/// defecto) y con [padding] alrededor.
///
/// Con [cropToComponent] el PNG contiene solo el componente (útil para
/// compararlo con el export de un nodo de Figma del mismo tamaño).
Future<File> renderComponentToPng(
  WidgetTester tester,
  Widget child, {
  required String name,
  Size canvasSize = kFigmaFrameSize,
  Alignment alignment = Alignment.topLeft,
  EdgeInsets padding = EdgeInsets.zero,
  double pixelRatio = 2,
  Color? background,
  bool cropToComponent = false,
  bool settle = true,
}) {
  return _render(
    tester,
    Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: RepaintBoundary(key: _componentKey, child: child),
      ),
    ),
    name: name,
    size: canvasSize,
    pixelRatio: pixelRatio,
    background: background,
    settle: settle,
    componentOnly: cropToComponent,
  );
}

final GlobalKey _canvasKey = GlobalKey(debugLabel: 'figma_harness_canvas');
final GlobalKey _componentKey = GlobalKey(
  debugLabel: 'figma_harness_component',
);

Future<File> _render(
  WidgetTester tester,
  Widget content, {
  required String name,
  required Size size,
  required double pixelRatio,
  required Color? background,
  required bool settle,
  bool componentOnly = false,
  EdgeInsets systemPadding = EdgeInsets.zero,
}) async {
  await tester.runAsync(loadHarnessFonts);
  _precached.clear();

  tester.view
    ..physicalSize = size * pixelRatio
    ..devicePixelRatio = pixelRatio;
  if (systemPadding != EdgeInsets.zero) {
    final physical = FakeViewPadding(
      left: systemPadding.left * pixelRatio,
      top: systemPadding.top * pixelRatio,
      right: systemPadding.right * pixelRatio,
      bottom: systemPadding.bottom * pixelRatio,
    );
    tester.view
      ..padding = physical
      ..viewPadding = physical;
  }
  addTearDown(tester.view.reset);

  final theme = AppTheme.lightTheme;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: RepaintBoundary(
        key: _canvasKey,
        child: Material(
          color: background ?? theme.scaffoldBackgroundColor,
          child: content,
        ),
      ),
    ),
  );

  // Dos pasadas: la segunda cubre imágenes que aparecen tras animaciones.
  await _precacheImages(tester);
  await _settle(tester, settle);
  if (await _precacheImages(tester)) await _settle(tester, settle);

  final key = componentOnly ? _componentKey : _canvasKey;
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

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

/// Precarga las imágenes de `Image`, `DecorationImage` (Container,
/// DecoratedBox, Ink) y `CircleAvatar` del árbol para que aparezcan en la
/// captura: la decodificación necesita tiempo real (`runAsync`), así que
/// `Image.asset` sin precarga sale en blanco. Devuelve si precargó algo.
Future<bool> _precacheImages(WidgetTester tester) async {
  final pending = <(ImageProvider, BuildContext)>[];
  void add(ImageProvider? provider, BuildContext context) {
    if (provider != null && _precached.add(provider)) {
      pending.add((provider, context));
    }
  }

  ImageProvider? fromDecoration(Decoration? decoration) =>
      decoration is BoxDecoration ? decoration.image?.image : null;

  for (final element in find.bySubtype<Widget>().evaluate()) {
    final widget = element.widget;
    if (widget is Image) {
      add(widget.image, element);
    } else if (widget is DecoratedBox) {
      add(fromDecoration(widget.decoration), element);
    } else if (widget is Ink) {
      add(fromDecoration(widget.decoration), element);
    } else if (widget is CircleAvatar) {
      add(widget.backgroundImage, element);
      add(widget.foregroundImage, element);
    }
  }
  if (pending.isEmpty) return false;
  await tester.runAsync(() async {
    for (final (provider, context) in pending) {
      await precacheImage(
        provider,
        context,
        onError: (error, _) =>
            debugPrint('[figma_harness] imagen no cargada ($provider): $error'),
      );
    }
  });
  await tester.pump();
  return true;
}

Future<void> _settle(WidgetTester tester, bool settle) async {
  if (!settle) {
    await tester.pump(const Duration(milliseconds: 16));
    return;
  }
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );
  } on FlutterError {
    // Animación infinita (p. ej. un indicador de progreso): se usa el frame
    // actual tal cual.
  }
}
