import 'package:flutter/material.dart';
import '../../widgets/legal_form_scaffold.dart';

({double contracted, double comparison, double difference}) compareRevision(
  double principal,
  double contractedRate,
  double comparisonRate,
  int periods,
) {
  if (!principal.isFinite ||
      principal <= 0 ||
      !contractedRate.isFinite ||
      contractedRate < 0 ||
      !comparisonRate.isFinite ||
      comparisonRate < 0 ||
      periods <= 0) {
    throw ArgumentError('Valores inválidos');
  }
  final contracted = principal * contractedRate / 100 * periods;
  final comparison = principal * comparisonRate / 100 * periods;
  final difference = contracted - comparison;
  if (!contracted.isFinite || !comparison.isFinite || !difference.isFinite) {
    throw ArgumentError('Valores fora do intervalo');
  }
  return (
    contracted: contracted,
    comparison: comparison,
    difference: difference,
  );
}

class RevisionCalculatorScreen extends StatefulWidget {
  const RevisionCalculatorScreen({super.key});
  @override
  State<RevisionCalculatorScreen> createState() =>
      _RevisionCalculatorScreenState();
}

class _RevisionCalculatorScreenState extends State<RevisionCalculatorScreen> {
  final _form = GlobalKey<FormState>();
  final _fields = List.generate(4, (_) => TextEditingController());
  String? _result;
  double? _number(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));
  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    if (!_form.currentState!.validate()) return;
    try {
      final result = compareRevision(
        _number(_fields[0].text)!,
        _number(_fields[1].text)!,
        _number(_fields[2].text)!,
        int.parse(_fields[3].text.trim()),
      );
      String money(double value) =>
          'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
      setState(
        () => _result =
            'Juros pela taxa contratada: ${money(result.contracted)}\n'
            'Juros pela taxa de comparação: ${money(result.comparison)}\n'
            'Diferença aritmética: ${money(result.difference)}',
      );
    } on ArgumentError {
      setState(() => _result = 'Valores fora do intervalo de cálculo.');
    }
  }

  @override
  Widget build(BuildContext context) => LegalFormScaffold(
    title: 'Comparação de juros',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Simulação simples sobre o valor original, com as duas taxas informadas por você. Use taxas e quantidade na mesma unidade de período. Não considera amortização, tarifas ou composição de juros.',
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _fields[i],
                decoration: InputDecoration(
                  labelText: const [
                    'Valor original (R\$)',
                    'Taxa contratada por período (%)',
                    'Taxa de comparação por período (%)',
                    'Quantidade de períodos pagos',
                  ][i],
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) {
                  if (_result != null) setState(() => _result = null);
                },
                validator: (value) {
                  if (i == 3) {
                    final count = int.tryParse(value?.trim() ?? '');
                    return count == null || count <= 0
                        ? 'Informe um inteiro positivo.'
                        : null;
                  }
                  final number = _number(value ?? '');
                  return number == null ||
                          !number.isFinite ||
                          (i == 0 ? number <= 0 : number < 0)
                      ? 'Informe um valor válido.'
                      : null;
                },
              ),
            ),
          FilledButton(
            onPressed: _calculate,
            child: const Text('Comparar'),
          ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SelectableText(_result!),
            ),
          const SizedBox(height: 16),
          const Text(
            'O resultado compara valores matemáticos. Não determina abusividade, saldo devedor ou direito a restituição.',
          ),
        ],
      ),
    ),
  );
}
