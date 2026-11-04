import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/legal_form_scaffold.dart';

({double installment, double total}) calculateFinancing(
  double value,
  double entry,
  double ratePercent,
  int periods,
) {
  if (!value.isFinite ||
      !entry.isFinite ||
      !ratePercent.isFinite ||
      value <= 0 ||
      entry < 0 ||
      entry >= value ||
      ratePercent <= 0 ||
      periods <= 0) {
    throw ArgumentError('Valores inválidos');
  }
  final rate = ratePercent / 100;
  final factor = pow(1 + rate, periods);
  final installment = (value - entry) * rate * factor / (factor - 1);
  final total = installment * periods + entry;
  if (!installment.isFinite || !total.isFinite) {
    throw ArgumentError('Valores fora do intervalo');
  }
  return (installment: installment, total: total);
}

class FinancingCalculatorScreen extends StatefulWidget {
  const FinancingCalculatorScreen({super.key});
  @override
  State<FinancingCalculatorScreen> createState() =>
      _FinancingCalculatorScreenState();
}

class _FinancingCalculatorScreenState extends State<FinancingCalculatorScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _form = GlobalKey<FormState>();
  String? _result;
  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _number(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));
  void _calculate() {
    if (!_form.currentState!.validate()) return;
    try {
      final result = calculateFinancing(
        _number(_controllers[0].text)!,
        _number(_controllers[1].text)!,
        _number(_controllers[2].text)!,
        int.parse(_controllers[3].text),
      );
      setState(
        () => _result =
            'Parcela: R\$ ${result.installment.toStringAsFixed(2).replaceAll('.', ',')}\nTotal com entrada: R\$ ${result.total.toStringAsFixed(2).replaceAll('.', ',')}',
      );
    } on ArgumentError {
      setState(
        () => _result =
            'Confira os valores: a entrada deve ser menor que o valor financiado e a taxa deve ser positiva.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Valor do bem (R\$)',
      'Entrada (R\$)',
      'Taxa por período (%)',
      'Número de períodos',
    ];
    return LegalFormScaffold(
      title: 'Simulação de financiamento',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Use a taxa e o prazo na mesma unidade de período. Digite valores sem separador de milhar.',
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  onChanged: (_) => setState(() => _result = null),
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    labelText: labels[i],
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final number = _number(value ?? '');
                    if (number == null ||
                        !number.isFinite ||
                        number < 0 ||
                        (i != 1 && number == 0) ||
                        (i == 3 && int.tryParse(value ?? '') == null)) {
                      return 'Informe um valor válido.';
                    }
                    return null;
                  },
                ),
              ),
            FilledButton(
              onPressed: _calculate,
              child: const Text('Calcular'),
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _result!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Simulação matemática. Não inclui tarifas, seguros ou outros custos do contrato. Os dados desta simulação não são enviados nem salvos.',
            ),
          ],
        ),
      ),
    );
  }
}
