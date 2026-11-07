import '../generated/protocol.dart';

BillingException billingError(String code, String message) =>
    BillingException(code: code, message: message);

String? billingDocument(String? input) {
  if (input == null || !RegExp(r'^[0-9./\-\s]+$').hasMatch(input)) return null;
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if ((digits.length != 11 && digits.length != 14) ||
      digits.split('').toSet().length == 1) {
    return null;
  }
  final values = digits.split('').map(int.parse).toList();
  final base = digits.length - 2;
  for (var position = base; position < digits.length; position++) {
    var sum = 0;
    for (var index = 0; index < position; index++) {
      final weight = base == 9
          ? position + 1 - index
          : (position - index - 1) % 8 + 2;
      sum += values[index] * weight;
    }
    final remainder = sum % 11;
    final check = remainder < 2 ? 0 : 11 - remainder;
    if (values[position] != check) return null;
  }
  return digits;
}

bool billingDate(String value) {
  if (!RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(value) ||
      value.startsWith('0000')) {
    return false;
  }
  return DateTime.tryParse(
        '${value}T00:00:00Z',
      )?.toIso8601String().split('T').first ==
      value;
}

void validateBillingRequest(BillingCreateRequest request) {
  if (request.clientId <= 0 ||
      !{'debt', 'fees'}.contains(request.kind) ||
      request.amountCents <= 0 ||
      request.amountCents > 9000000000000 ||
      !billingDate(request.dueDate) ||
      !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(request.idempotencyKey)) {
    throw billingError('invalid_input', 'Dados da cobrança inválidos.');
  }
  final count = request.installmentCount;
  final valid = switch (request.flow) {
    BillingFlow.single => count == null && request.cycle == null,
    BillingFlow.installment =>
      count != null &&
          count >= 2 &&
          count <= (request.method == BillingMethod.card ? 12 : 60) &&
          request.amountCents >= count &&
          request.cycle == null,
    BillingFlow.recurring => count == null && request.cycle != null,
  };
  if (!valid) {
    throw billingError(
      'invalid_input',
      'Meio, fluxo, parcelas ou periodicidade incompatíveis.',
    );
  }
}
