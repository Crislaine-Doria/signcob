import 'package:signcob_server/src/billing/asaas_sandbox_provider.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

const _key = r'$aact_hmlg_synthetic-test-key';

Matcher _error(String code) => isA<BillingException>()
    .having((error) => error.code, 'code', code)
    .having((error) => error.message, 'safe message', isNot(contains(_key)));

void main() {
  test(
    'requests status over HTTPS with the required sandbox headers',
    () async {
      var calls = 0;
      final provider = AsaasSandboxProvider(
        environment: 'sandbox',
        apiKey: _key,
        transport: (uri, headers) async {
          expect(
            uri.toString(),
            'https://api-sandbox.asaas.com/v3/payments/pay_example/status',
          );
          expect(headers['access_token'], _key);
          expect(headers['User-Agent'], 'SignCob/1.0');
          expect(headers['Accept'], 'application/json');
          calls++;
          return (
            statusCode: 200,
            body: calls == 1 ? '{"status":"PENDING"}' : '{"status":"OVERDUE"}',
          );
        },
      );
      expect(await provider.fetchStatus('pay_example'), BillingStatus.pending);
      expect(await provider.fetchStatus('pay_example'), BillingStatus.overdue);
      await expectLater(
        provider.fetchStatus('pay_example/redirect'),
        throwsA(_error('provider_response')),
      );
      expect(
        provider.ensureCreationAvailable,
        throwsA(_error('creation_disabled')),
      );
      expect(calls, 2);
    },
  );

  test(
    'rejects missing, malformed or production configuration before IO',
    () async {
      for (final (environment, key) in [
        (null, _key),
        ('production', _key),
        ('sandbox', null),
        ('sandbox', ''),
        ('sandbox', r'$aact_prod_synthetic-test-key'),
        ('sandbox', r'$aact_hmlg_with space'),
      ]) {
        var called = false;
        final provider = AsaasSandboxProvider(
          environment: environment,
          apiKey: key,
          transport: (_, _) async {
            called = true;
            return (statusCode: 200, body: '{}');
          },
        );
        await expectLater(
          provider.fetchStatus('pay_example'),
          throwsA(_error('provider_configuration')),
        );
        expect(
          provider.ensureCreationAvailable,
          throwsA(_error('provider_configuration')),
        );
        expect(called, isFalse);
      }
    },
  );

  test('sanitizes upstream failures and refuses unresolved statuses', () async {
    for (final (statusCode, body, code) in [
      (401, _key, 'provider_authentication'),
      (403, _key, 'provider_authentication'),
      (302, _key, 'provider_unavailable'),
      (500, _key, 'provider_unavailable'),
      (200, _key, 'provider_response'),
      (200, '[]', 'provider_response'),
      (200, '{"status":false}', 'provider_response'),
      (200, '{"status":"CONFIRMED"}', 'unsupported_status'),
      (200, '{"status":"RECEIVED"}', 'unsupported_status'),
    ]) {
      final provider = AsaasSandboxProvider(
        environment: 'sandbox',
        apiKey: _key,
        transport: (_, _) async => (statusCode: statusCode, body: body),
      );
      await expectLater(
        provider.fetchStatus('pay_example'),
        throwsA(_error(code)),
      );
    }

    final provider = AsaasSandboxProvider(
      environment: 'sandbox',
      apiKey: _key,
      transport: (_, _) async => throw StateError(_key),
    );
    await expectLater(
      provider.fetchStatus('pay_example'),
      throwsA(_error('provider_unavailable')),
    );
  });
}
