import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/calculators/financing_calculator_screen.dart';

void main() {
  test('preserva fórmula do legado para um período', () {
    final result = calculateFinancing(1000, 100, 10, 1);
    expect(result.installment, closeTo(990, 0.000001));
    expect(result.total, closeTo(1090, 0.000001));
  });
  test('rejeita entradas e taxas fora do domínio suportado', () {
    expect(() => calculateFinancing(1000, 1000, 10, 1), throwsArgumentError);
    expect(() => calculateFinancing(1000, 0, 0, 1), throwsArgumentError);
    expect(() => calculateFinancing(double.nan, 0, 10, 1), throwsArgumentError);
  });
}
