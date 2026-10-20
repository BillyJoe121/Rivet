// Pruebas visuales de los modales contra los exports de Figma
// (2004:37, 2004:167 y 2006:5). El export incluye el margen de la sombra:
// 24 px a los lados y 14 px arriba, por eso el lienzo es de 368 de ancho.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/widgets/widgets.dart';

import '../figma_harness.dart';

const EdgeInsets _shadowMargin = EdgeInsets.only(left: 24, top: 14);

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('modal_confirmacion', (tester) async {
    final file = await renderComponentToPng(
      tester,
      AppConfirmDialog(
        title: 'Finalizar proyecto',
        message:
            'Se le notificará al cliente y comenzará el proceso de gestión '
            'de tu pago.',
        onConfirm: () {},
        onCancel: () {},
      ),
      name: 'components/modal_confirmacion',
      canvasSize: const Size(368, 200),
      padding: _shadowMargin,
      background: Colors.transparent,
    );
    expect(file.existsSync(), isTrue);
  });

  testWidgets('modal_precio', (tester) async {
    final file = await renderComponentToPng(
      tester,
      const AppPriceSelectDialog(
        productTitle: 'Pintura vinilo premium',
        productSubtitle: 'Interior lavable, 1 galón',
        message:
            'Ajusta el valor medio según el margen que quieras ofrecer al '
            'cliente.',
        initialIndex: 1,
        options: [
          AppPriceOption(label: 'Costo contratista', value: r'$ 87.000'),
          AppPriceOption(label: 'Valor medio', value: r'$ 103.500'),
          AppPriceOption(label: 'Precio al cliente', value: r'$ 120.000'),
        ],
      ),
      name: 'components/modal_precio',
      canvasSize: const Size(368, 440),
      padding: _shadowMargin,
      background: Colors.transparent,
    );
    expect(file.existsSync(), isTrue);
  });

  testWidgets('modal_fecha', (tester) async {
    // Octubre de 2025 con fines de semana y los días 8 y 16 no disponibles,
    // como en el diseño.
    final file = await renderComponentToPng(
      tester,
      AppDatePickerDialog(
        initialDate: DateTime(2025, 10, 17),
        selectableDayPredicate: (day) =>
            day.weekday < DateTime.saturday && day.day != 8 && day.day != 16,
      ),
      name: 'components/modal_fecha',
      canvasSize: const Size(368, 444),
      padding: _shadowMargin,
      background: Colors.transparent,
    );
    expect(file.existsSync(), isTrue);
  });

  testWidgets('modal_fecha_interaccion', (tester) async {
    DateTime? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showAppDatePickerDialog(
                context,
                initialDate: DateTime(2025, 10, 17),
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Octubre 2025'), findsOneWidget);
    await tester.tap(find.byTooltip('Mes siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Noviembre 2025'), findsOneWidget);
    await tester.tap(find.text('20'));
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, DateTime(2025, 11, 20));
  });

  testWidgets('confirmacion_devuelve_bool', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showAppConfirmDialog(
                context,
                title: 'Finalizar proyecto',
                message: 'Mensaje',
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}
