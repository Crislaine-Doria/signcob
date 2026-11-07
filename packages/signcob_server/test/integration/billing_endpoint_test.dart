import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/billing/billing_endpoint.dart';
import 'package:signcob_server/src/billing/billing_provider.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _read = Scope('billing.read');
const _write = Scope('billing.write');
const _dueDate = '2099-12-31';

Matcher _error(String code) =>
    isA<BillingException>().having((error) => error.code, 'code', code);

String _document(int seed) {
  final values = seed
      .toString()
      .padLeft(9, '0')
      .split('')
      .map(int.parse)
      .toList();
  for (var length = 9; length < 11; length++) {
    var sum = 0;
    for (var index = 0; index < length; index++) {
      sum += values[index] * (length + 1 - index);
    }
    final rest = sum % 11;
    values.add(rest < 2 ? 0 : 11 - rest);
  }
  return values.join();
}

Future<LegalClient> _client(Session session, int seed) {
  final now = DateTime.now().toUtc();
  return LegalClient.db.insertRow(
    session,
    LegalClient(
      name: 'Pagador sintético $seed',
      document: _document(seed),
      createdAt: now,
      updatedAt: now,
    ),
  );
}

Future<TestSessionBuilder> _finance(TestSessionBuilder builder) async {
  final user = await AuthServices.instance.authUsers.create(
    builder.build(),
    scopes: {_read, _write},
  );
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      user.id.toString(),
      {_read, _write},
    ),
  );
}

BillingCreateRequest _request(
  int clientId,
  String key, {
  BillingMethod method = BillingMethod.pix,
  BillingFlow flow = BillingFlow.single,
  int amount = 12345,
  int? installmentCount,
}) => BillingCreateRequest(
  clientId: clientId,
  kind: 'debt',
  method: method,
  flow: flow,
  amountCents: amount,
  dueDate: _dueDate,
  idempotencyKey: key,
  installmentCount: installmentCount,
);

class _PaymentProvider implements BillingProvider {
  String account = 'synthetic-account';
  int verifies = 0;
  int creates = 0;
  int finds = 0;
  bool failAfterRemoteCreate = false;
  Completer<void>? releaseCreate;
  final createStarted = Completer<void>();
  List<ProviderPayment> matches = [];

  @override
  Future<String> verifyAccount() async {
    verifies++;
    return account;
  }

  @override
  Future<List<ProviderCustomer>> findCustomers(String document) async => [
    ProviderCustomer(id: 'cus_synthetic', document: document),
  ];

  @override
  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  }) => throw StateError('Existing synthetic customer should be reused.');

  @override
  void ensureCreationAvailable() {}

  ProviderPayment _payment(BillingChargeRecord charge) => ProviderPayment(
    id: 'pay_${charge.id}',
    customerId: charge.providerCustomerId!,
    externalReference: charge.externalReference,
    method: charge.method!,
    amountCents: charge.amountCents,
    dueDate: charge.dueDate,
    rawStatus: 'PENDING',
    invoiceUrl: 'https://sandbox.asaas.com/i/pay_${charge.id}',
  );

  @override
  Future<ProviderPayment> createPayment(BillingChargeRecord charge) async {
    creates++;
    if (!createStarted.isCompleted) createStarted.complete();
    await releaseCreate?.future;
    final payment = _payment(charge);
    if (failAfterRemoteCreate) {
      matches = [payment];
      throw TimeoutException('Synthetic lost response');
    }
    matches = [payment];
    return payment;
  }

  @override
  Future<ProviderPayment> fetchPayment(String providerId) async =>
      matches.singleWhere((payment) => payment.id == providerId);

  @override
  Future<List<ProviderPayment>> findPayments(
    String customerId,
    String externalReference,
  ) async {
    finds++;
    return matches
        .where(
          (payment) =>
              payment.customerId == customerId &&
              payment.externalReference == externalReference,
        )
        .toList();
  }

  @override
  Future<List<ProviderPayment>> listInstallmentPayments(String installmentId) =>
      Future.value(
        matches
            .where((payment) => payment.installmentId == installmentId)
            .toList(),
      );

  @override
  Future<ProviderSubscription> createSubscription(BillingChargeRecord charge) =>
      throw UnimplementedError();
  @override
  Future<List<ProviderSubscription>> findSubscriptions(
    String customerId,
    String externalReference,
  ) => throw UnimplementedError();
  @override
  Future<ProviderSubscription> fetchSubscription(String subscriptionId) =>
      throw UnimplementedError();
  @override
  Future<List<ProviderPayment>> listSubscriptionPayments(
    String subscriptionId,
  ) => throw UnimplementedError();
}

void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'synthetic-payment-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('synthetic-payment-key-long-enough-for-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Single Asaas payments', (builder, endpoints) {
    test(
      'creates Pix, boleto and card as separate persisted pending payments',
      () async {
        final session = builder.build();
        final client = await _client(session, 710000001);
        final finance = (await _finance(builder)).build();
        final provider = _PaymentProvider();
        final endpoint = BillingEndpoint(provider: provider);

        for (final method in BillingMethod.values) {
          final key = 'single-${method.name}';
          final charge = await endpoint.create(
            finance,
            _request(client.id!, key, method: method),
          );
          expect(charge.method, method);
          expect(charge.flow, BillingFlow.single);
          expect(charge.creationState, 'active');
          expect(charge.status, BillingStatus.pending);
          expect(charge.payments, hasLength(1));
          expect(charge.payments!.single.status, BillingStatus.pending);
          expect(
            charge.payments!.single.invoiceUrl,
            startsWith('https://sandbox.asaas.com/i/'),
          );
          final row = await BillingChargeRecord.db.findById(session, charge.id);
          expect(row!.createAttempted, isTrue);
          expect(row.providerId, charge.payments!.single.providerPaymentId);
          expect(
            (await endpoint.create(
              finance,
              _request(client.id!, key, method: method),
            )).id,
            charge.id,
          );
          await expectLater(
            endpoint.create(
              finance,
              _request(client.id!, key, method: method, amount: 12346),
            ),
            throwsA(_error('idempotency_conflict')),
          );
        }
        expect(provider.creates, 3);

        await expectLater(
          endpoint.create(
            finance,
            _request(
              client.id!,
              'invalid-recurring',
              flow: BillingFlow.recurring,
            ),
          ),
          throwsA(_error('invalid_input')),
        );
        expect(provider.creates, 3);
        expect(
          await BillingChargeRecord.db.count(
            session,
            where: (row) => row.idempotencyKey.equals('invalid-recurring'),
          ),
          0,
        );
        await expectLater(
          endpoints.billing.create(builder, _request(client.id!, 'anonymous')),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'keeps a lost response uncertain and reconciles it without a second POST',
      () async {
        final session = builder.build();
        final client = await _client(session, 710000002);
        final finance = (await _finance(builder)).build();
        final provider = _PaymentProvider()..failAfterRemoteCreate = true;
        final endpoint = BillingEndpoint(provider: provider);
        final request = _request(client.id!, 'lost-response');

        await expectLater(
          endpoint.create(finance, request),
          throwsA(_error('creation_uncertain')),
        );
        final reserved = await endpoint.findIntent(
          finance,
          client.id!,
          request.idempotencyKey,
        );
        expect(reserved, isNotNull);
        expect(reserved!.creationState, 'awaitingProvider');
        expect((await endpoint.create(finance, request)).id, reserved.id);
        expect(provider.creates, 1);

        final reconciled = await endpoint.refresh(finance, reserved.id);
        expect(reconciled.creationState, 'active');
        expect(reconciled.status, BillingStatus.pending);
        expect(reconciled.payments, hasLength(1));
        expect(provider.finds, 1);
        expect(provider.creates, 1);
        expect(
          (await BillingChargeRecord.db.findById(
            session,
            reserved.id,
          ))!.createAttempted,
          isTrue,
        );
      },
    );
  });

  withServerpod('Concurrent single Asaas payment', (builder, _) {
    test('same key has one durable reservation and only one POST', () async {
      final session = builder.build();
      final client = await _client(session, 710000003);
      final finance = await _finance(builder);
      final provider = _PaymentProvider()..releaseCreate = Completer<void>();
      final endpoint = BillingEndpoint(provider: provider);
      final request = _request(client.id!, 'concurrent-single');

      final first = endpoint.create(finance.build(), request);
      await provider.createStarted.future.timeout(const Duration(seconds: 5));
      final replay = await endpoint.create(finance.build(), request);
      expect(replay.creationState, 'awaitingProvider');
      expect(provider.creates, 1);
      provider.releaseCreate!.complete();
      final completed = await first;
      expect(completed.creationState, 'active');
      expect(provider.creates, 1);
      expect(
        await BillingChargeRecord.db.count(
          session,
          where: (row) => row.legalClientId.equals(client.id!),
        ),
        1,
      );

      await BillingPaymentRecord.db.deleteWhere(
        session,
        where: (row) => row.chargeId.equals(completed.id),
      );
      await BillingChargeRecord.db.deleteWhere(
        session,
        where: (row) => row.legalClientId.equals(client.id!),
      );
      await BillingCustomerRecord.db.deleteWhere(
        session,
        where: (row) => row.legalClientId.equals(client.id!),
      );
      await LegalClient.db.deleteRow(session, client);
      await AuthServices.instance.authUsers.delete(
        session,
        authUserId: UuidValue.withValidation(
          finance.build().authenticated!.userIdentifier,
        ),
      );
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
