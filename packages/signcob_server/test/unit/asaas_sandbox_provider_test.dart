import 'dart:convert';

import 'package:signcob_server/src/billing/asaas_sandbox_provider.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

const _key = r'$aact_hmlg_synthetic-payment-key';

Matcher _error(String code) => isA<BillingException>()
    .having((error) => error.code, 'code', code)
    .having((error) => error.message, 'safe message', isNot(contains(_key)));

BillingChargeRecord _charge(BillingMethod method) {
  final now = DateTime.utc(2026, 11, 5);
  return BillingChargeRecord(
    id: 42,
    legalClientId: 7,
    idempotencyKey: 'synthetic-single',
    amountCents: 12345,
    dueDate: '2099-12-31',
    status: BillingStatus.awaitingProvider,
    createdAt: now,
    updatedAt: now,
    environment: 'sandbox',
    accountId: 'synthetic-account',
    kind: 'debt',
    method: method,
    flow: BillingFlow.single,
    providerCustomerId: 'cus_synthetic',
    externalReference: 'signcob_charge_synthetic',
    creationState: 'awaitingProvider',
    createAttempted: true,
  );
}

BillingChargeRecord _installmentCharge(BillingMethod method) =>
    _charge(method).copyWith(
      flow: BillingFlow.installment,
      installmentCount: 3,
      amountCents: 10000,
    );

BillingChargeRecord _recurringCharge(
  BillingMethod method,
  BillingCycle cycle,
) => _charge(method).copyWith(flow: BillingFlow.recurring, cycle: cycle);

Map<String, Object?> _paymentJson(BillingMethod method) => {
  'id': 'pay_synthetic',
  'customer': 'cus_synthetic',
  'externalReference': 'signcob_charge_synthetic',
  'billingType': switch (method) {
    BillingMethod.pix => 'PIX',
    BillingMethod.boleto => 'BOLETO',
    BillingMethod.card => 'CREDIT_CARD',
  },
  'value': 123.45,
  'dueDate': '2099-12-31',
  'status': 'PENDING',
  'invoiceUrl': 'https://sandbox.asaas.com/i/synthetic',
};

void main() {
  test(
    'creates single Pix, boleto and card invoices with the minimal payload',
    () async {
      for (final method in BillingMethod.values) {
        var calls = 0;
        final provider = AsaasSandboxProvider(
          environment: 'sandbox',
          apiKey: _key,
          accountId: 'synthetic-account',
          requestTransport: (verb, uri, headers, body) async {
            calls++;
            expect(verb, 'POST');
            expect(uri.toString(), 'https://api-sandbox.asaas.com/v3/payments');
            expect(headers['access_token'], _key);
            expect(jsonDecode(body!), {
              'customer': 'cus_synthetic',
              'billingType': switch (method) {
                BillingMethod.pix => 'PIX',
                BillingMethod.boleto => 'BOLETO',
                BillingMethod.card => 'CREDIT_CARD',
              },
              'value': 123.45,
              'dueDate': '2099-12-31',
              'externalReference': 'signcob_charge_synthetic',
              'description': 'SignCob - dívida',
            });

            return (statusCode: 200, body: jsonEncode(_paymentJson(method)));
          },
        );
        final payment = await provider.createPayment(_charge(method));
        expect(payment.id, 'pay_synthetic');
        expect(payment.method, method);
        expect(payment.amountCents, 12345);
        expect(payment.invoiceUrl, 'https://sandbox.asaas.com/i/synthetic');
        expect(calls, 1);
      }
    },
  );

  test(
    'creates installments with count and totalValue and lists every payment',
    () async {
      for (final method in BillingMethod.values) {
        final calls = <String>[];
        final provider = AsaasSandboxProvider(
          environment: 'sandbox',
          apiKey: _key,
          accountId: 'synthetic-account',
          requestTransport: (verb, uri, headers, body) async {
            calls.add('$verb ${uri.path}');
            if (verb == 'POST') {
              final payload = jsonDecode(body!) as Map<String, dynamic>;
              expect(payload['installmentCount'], 3);
              expect(payload['totalValue'], 100.0);
              expect(payload, isNot(contains('value')));
              expect(payload, isNot(contains('installmentValue')));
              expect(payload, isNot(contains('interest')));
              expect(payload, isNot(contains('fine')));
              expect(payload, isNot(contains('discount')));
              return (
                statusCode: 200,
                body: jsonEncode({
                  ..._paymentJson(method),
                  'value': 33.33,
                  'installment': 'group_synthetic',
                  'installmentNumber': 1,
                }),
              );
            }
            expect(uri.path, '/v3/installments/group_synthetic/payments');
            return (
              statusCode: 200,
              body: jsonEncode({
                'hasMore': false,
                'data': [
                  {
                    ..._paymentJson(method),
                    'value': 33.33,
                    'installment': 'group_synthetic',
                    'installmentNumber': 1,
                  },
                ],
              }),
            );
          },
        );
        final first = await provider.createPayment(_installmentCharge(method));
        expect(first.installmentId, 'group_synthetic');
        expect(first.installmentNumber, 1);
        expect(
          await provider.listInstallmentPayments(first.installmentId!),
          hasLength(1),
        );
        expect(calls, [
          'POST /v3/payments',
          'GET /v3/installments/group_synthetic/payments',
        ]);
      }
    },
  );

  test(
    'finds every matching payment page for explicit reconciliation',
    () async {
      var calls = 0;
      final provider = AsaasSandboxProvider(
        environment: 'sandbox',
        apiKey: _key,
        accountId: 'synthetic-account',
        requestTransport: (verb, uri, headers, body) async {
          expect(verb, 'GET');
          expect(body, isNull);
          expect(uri.queryParameters['customer'], 'cus_synthetic');
          expect(
            uri.queryParameters['externalReference'],
            'signcob_charge_synthetic',
          );
          expect(uri.queryParameters['offset'], '$calls');
          calls++;
          return (
            statusCode: 200,
            body: jsonEncode({
              'hasMore': calls == 1,
              'data': [_paymentJson(BillingMethod.pix)],
            }),
          );
        },
      );
      final matches = await provider.findPayments(
        'cus_synthetic',
        'signcob_charge_synthetic',
      );
      expect(matches, hasLength(2));
      expect(calls, 2);
    },
  );

  test('creates minimal subscriptions for every method and cycle', () async {
    for (final method in BillingMethod.values) {
      for (final cycle in BillingCycle.values) {
        final provider = AsaasSandboxProvider(
          environment: 'sandbox',
          apiKey: _key,
          accountId: 'synthetic-account',
          requestTransport: (verb, uri, headers, body) async {
            expect(verb, 'POST');
            expect(uri.path, '/v3/subscriptions');
            final payload = jsonDecode(body!) as Map<String, dynamic>;
            expect(payload['customer'], 'cus_synthetic');
            expect(payload['value'], 123.45);
            expect(payload['nextDueDate'], '2099-12-31');
            expect(payload['externalReference'], 'signcob_charge_synthetic');
            expect(payload, isNot(contains('creditCard')));
            expect(payload, isNot(contains('creditCardToken')));
            expect(payload, isNot(contains('interest')));
            expect(payload, isNot(contains('fine')));
            expect(payload, isNot(contains('discount')));
            expect(payload, isNot(contains('endDate')));
            expect(payload, isNot(contains('maxPayments')));
            return (
              statusCode: 200,
              body: jsonEncode({
                'id': 'sub_synthetic',
                'customer': 'cus_synthetic',
                'externalReference': 'signcob_charge_synthetic',
                'billingType': payload['billingType'],
                'value': 123.45,
                'nextDueDate': '2099-12-31',
                'cycle': payload['cycle'],
                'status': 'ACTIVE',
              }),
            );
          },
        );
        final subscription = await provider.createSubscription(
          _recurringCharge(method, cycle),
        );
        expect(subscription.method, method);
        expect(subscription.cycle, cycle);
        expect(subscription.rawStatus, 'ACTIVE');
      }
    }
  });

  test(
    'rejects unsafe configuration and malformed payment data before it escapes',
    () async {
      for (final (environment, key, account) in [
        (null, _key, 'synthetic-account'),
        ('production', _key, 'synthetic-account'),
        ('sandbox', null, 'synthetic-account'),
        ('sandbox', r'$aact_prod_key', 'synthetic-account'),
        ('sandbox', _key, null),
      ]) {
        var called = false;
        final provider = AsaasSandboxProvider(
          environment: environment,
          apiKey: key,
          accountId: account,
          requestTransport: (_, _, _, _) async {
            called = true;
            return (statusCode: 200, body: '{}');
          },
        );
        await expectLater(
          provider.createPayment(_charge(BillingMethod.pix)),
          throwsA(_error('provider_configuration')),
        );
        expect(called, isFalse);
      }

      for (final invoice in [
        'http://sandbox.asaas.com/i/insecure',
        'https://www.asaas.com/i/production',
        'https://sandbox.asaas.com/other/path',
      ]) {
        final provider = AsaasSandboxProvider(
          environment: 'sandbox',
          apiKey: _key,
          accountId: 'synthetic-account',
          requestTransport: (_, _, _, _) async => (
            statusCode: 200,
            body: jsonEncode({
              ..._paymentJson(BillingMethod.pix),
              'invoiceUrl': invoice,
            }),
          ),
        );
        await expectLater(
          provider.createPayment(_charge(BillingMethod.pix)),
          throwsA(_error('provider_response')),
        );
      }
    },
  );
}
