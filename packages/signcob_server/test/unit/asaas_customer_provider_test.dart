import 'dart:convert';

import 'package:signcob_server/src/billing/asaas_sandbox_provider.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

const _key = r'$aact_hmlg_synthetic-customer-key';
const _document = '52998224725';

Matcher _error(String code) =>
    isA<BillingException>().having((e) => e.code, 'code', code);

void main() {
  test(
    'verifies actual account and sends only synthetic minimal customer payload',
    () async {
      final calls = <String>[];
      final provider = AsaasSandboxProvider(
        environment: 'sandbox',
        apiKey: _key,
        accountId: 'synthetic-account',
        requestTransport: (method, uri, headers, body) async {
          expect(uri.scheme, 'https');
          expect(uri.host, 'api-sandbox.asaas.com');
          expect(headers['access_token'], _key);
          calls.add('$method ${uri.path}');
          if (uri.path == '/v3/myAccount/status') {
            expect(body, isNull);
            return (statusCode: 200, body: '{"id":"synthetic-account"}');
          }
          expect(method, 'POST');
          final payload = jsonDecode(body!) as Map<String, dynamic>;
          expect(payload, {
            'name': 'Pagador sintético',
            'cpfCnpj': _document,
            'externalReference': 'synthetic-reference',
            'notificationDisabled': true,
          });
          return (
            statusCode: 200,
            body: jsonEncode({
              'id': 'cus_synthetic',
              'cpfCnpj': _document,
              'externalReference': 'synthetic-reference',
            }),
          );
        },
      );
      expect(await provider.verifyAccount(), 'synthetic-account');
      final customer = await provider.createCustomer(
        name: 'Pagador sintético',
        document: _document,
        externalReference: 'synthetic-reference',
      );
      expect(customer.id, 'cus_synthetic');
      expect(calls, ['GET /v3/myAccount/status', 'POST /v3/customers']);
    },
  );

  test(
    'customer query reads every page and retains duplicates for conflict detection',
    () async {
      var calls = 0;
      final provider = AsaasSandboxProvider(
        environment: 'sandbox',
        apiKey: _key,
        accountId: 'synthetic-account',
        requestTransport: (method, uri, headers, body) async {
          expect(method, 'GET');
          expect(body, isNull);
          expect(uri.queryParameters['cpfCnpj'], _document);
          expect(uri.queryParameters['limit'], '100');
          expect(uri.queryParameters['offset'], '$calls');
          calls++;
          return (
            statusCode: 200,
            body: jsonEncode({
              'hasMore': calls == 1,
              'data': [
                {'id': 'cus_synthetic_$calls', 'cpfCnpj': _document},
              ],
            }),
          );
        },
      );
      expect((await provider.findCustomers(_document)).length, 2);
      expect(calls, 2);
    },
  );

  test(
    'refuses account mismatch, malformed pages and wrong document without leaking upstream',
    () async {
      for (final (body, action, code) in [
        ('{"id":"other-account"}', 'account', 'account_mismatch'),
        ('{"data":[],"hasMore":true}', 'customers', 'provider_response'),
        ('{"data":[],"hasMore":"false"}', 'customers', 'provider_response'),
        (
          '{"data":[{"id":"cus_wrong","cpfCnpj":"11144477735"}],"hasMore":false}',
          'customers',
          'provider_response',
        ),
        (_key, 'account', 'provider_response'),
      ]) {
        final provider = AsaasSandboxProvider(
          environment: 'sandbox',
          apiKey: _key,
          accountId: 'synthetic-account',
          requestTransport: (_, _, _, _) async => (statusCode: 200, body: body),
        );
        await expectLater(
          action == 'account'
              ? provider.verifyAccount()
              : provider.findCustomers(_document),
          throwsA(_error(code)),
        );
      }
    },
  );
}
