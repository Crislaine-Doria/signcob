import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/calculators/revision_calculator_screen.dart';

void main() {
  test('preserva multiplicação simples do legado sem conclusão jurídica', () {
    final result = compareRevision(10000, 2, 1, 12);
    expect(result.contracted, 2400);
    expect(result.comparison, 1200);
    expect(result.difference, 1200);
    expect(compareRevision(10000, 0, 1, 12).difference, -1200);
  });
  test('rejeita não finitos e períodos inválidos', () {
    expect(() => compareRevision(double.nan, 2, 1, 12), throwsArgumentError);
    expect(() => compareRevision(1000, -1, 1, 12), throwsArgumentError);
    expect(() => compareRevision(1000, 2, 1, 0), throwsArgumentError);
  });
}
