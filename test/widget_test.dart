import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/main.dart';

void main() {
  testWidgets('RivetApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RivetApp());
    expect(find.text('Rivet'), findsOneWidget);
    expect(find.text('Cotizaciones para tu obra'), findsOneWidget);
  });
}
