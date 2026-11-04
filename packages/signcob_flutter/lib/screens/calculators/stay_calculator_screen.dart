import 'package:flutter/material.dart';
import '../../widgets/legal_form_scaffold.dart';

DateTime? parseStayDate(String value) {
  final match = RegExp(
    r'^(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2})$',
  ).firstMatch(value.trim());
  if (match == null) return null;
  final parts = List.generate(5, (i) => int.parse(match.group(i + 1)!));
  final date = DateTime.utc(parts[2], parts[1], parts[0], parts[3], parts[4]);
  return date.year == parts[2] &&
          date.month == parts[1] &&
          date.day == parts[0] &&
          date.hour == parts[3] &&
          date.minute == parts[4]
      ? date
      : null;
}

({double hours, double total}) calculateStay(
  DateTime arrival,
  DateTime departure,
  double tons,
  double hourlyRate,
) {
  if (!departure.isAfter(arrival) ||
      !tons.isFinite ||
      tons <= 0 ||
      !hourlyRate.isFinite ||
      hourlyRate <= 0) {
    throw ArgumentError('Valores inválidos');
  }
  final hours = departure.difference(arrival).inMinutes / 60;
  final total = hours * tons * hourlyRate;
  if (hours <= 0 || !total.isFinite) throw ArgumentError('Valores inválidos');
  return (hours: hours, total: total);
}

class StayCalculatorScreen extends StatefulWidget {
  const StayCalculatorScreen({super.key});
  @override
  State<StayCalculatorScreen> createState() => _StayCalculatorScreenState();
}

class _StayCalculatorScreenState extends State<StayCalculatorScreen> {
  final _form = GlobalKey<FormState>();
  final _fields = List.generate(4, (_) => TextEditingController());
  String? _result;
  double? _number(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));
  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    setState(() => _result = null);
    if (!_form.currentState!.validate()) return;
    try {
      final result = calculateStay(
        parseStayDate(_fields[0].text)!,
        parseStayDate(_fields[1].text)!,
        _number(_fields[2].text)!,
        _number(_fields[3].text)!,
      );
      setState(
        () => _result =
            'Tempo: ${result.hours.toStringAsFixed(2).replaceAll('.', ',')} horas\n'
            'Valor simulado: R\$ ${result.total.toStringAsFixed(2).replaceAll('.', ',')}',
      );
    } on ArgumentError {
      setState(
        () => _result =
            'A saída deve ser posterior à chegada. Confira os valores.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => LegalFormScaffold(
    title: 'Simulação de estadia',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informe o valor por hora e tonelada para uma simulação aritmética. O resultado não determina direito a pagamento.',
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _fields[i],
                onChanged: (_) {
                  if (_result != null) setState(() => _result = null);
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: const [
                    'Chegada (dd/mm/aaaa hh:mm)',
                    'Saída (dd/mm/aaaa hh:mm)',
                    'Carga (toneladas)',
                    'Valor por hora e tonelada (R\$)',
                  ][i],
                ),
                keyboardType: i < 2
                    ? TextInputType.datetime
                    : const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                validator: (value) {
                  if (i < 2) {
                    return parseStayDate(value ?? '') == null
                        ? 'Informe uma data e hora válidas.'
                        : null;
                  }
                  final number = _number(value ?? '');
                  return number == null || !number.isFinite || number <= 0
                      ? 'Informe um valor positivo.'
                      : null;
                },
              ),
            ),
          FilledButton(
            onPressed: _calculate,
            child: const Text('Calcular estadia'),
          ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(_result!, semanticsLabel: _result),
            ),
        ],
      ),
    ),
  );
}
