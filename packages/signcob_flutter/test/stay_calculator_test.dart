import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/calculators/stay_calculator_screen.dart';

void main() {
  test('calcula minutos completos e rejeita datas e valores inválidos', () {
    final start = DateTime.utc(2026, 11, 3, 8);
    final result = calculateStay(
      start,
      start.add(const Duration(minutes: 90)),
      10,
      2,
    );
    expect(result.hours, 1.5);
    expect(result.total, 30);
    expect(parseStayDate('31/02/2026 08:00'), isNull);
    expect(parseStayDate('03/11/2026 24:00'), isNull);
    expect(() => calculateStay(start, start, 10, 2), throwsArgumentError);
    expect(
      () => calculateStay(
        start,
        start.add(const Duration(hours: 1)),
        double.infinity,
        2,
      ),
      throwsArgumentError,
    );
  });
  testWidgets('preenche campos e apresenta resultado', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: StayCalculatorScreen()));
    final fields = find.byType(TextFormField);
    for (final entry in [
      '03/11/2026 08:00',
      '03/11/2026 09:30',
      '10',
      '2',
    ].asMap().entries) {
      await tester.enterText(fields.at(entry.key), entry.value);
    }
    await tester.ensureVisible(find.text('Calcular estadia'));
    await tester.tap(find.text('Calcular estadia'));
    await tester.pump();
    expect(find.textContaining('Valor simulado: R\$ 30,00'), findsOneWidget);
    await tester.enterText(fields.at(2), '20');
    await tester.pump();
    expect(find.textContaining('Valor simulado:'), findsNothing);
  });
}
