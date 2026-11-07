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
      name: 'Pagador recorrente $seed',
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
  BillingCycle cycle = BillingCycle.monthly,
}) => BillingCreateRequest(
  clientId: clientId,
  kind: 'fees',
  method: method,
  flow: BillingFlow.recurring,
  amountCents: 2500,
  dueDate: '2099-06-15',
  idempotencyKey: key,
  cycle: cycle,
);

class _RecurringProvider implements BillingProvider {
  int creates = 0;
  int finds = 0;
  bool loseCreateResponse = false;
  String status = 'ACTIVE';
  String? nextDueDate;
  List<ProviderSubscription> subscriptions = [];
  List<ProviderPayment> payments = [];

  @override
  Future<String> verifyAccount() async => 'synthetic-account';
  @override
  Future<List<ProviderCustomer>> findCustomers(String document) async => [
    ProviderCustomer(id: 'cus_recurring', document: document),
  ];
  @override
  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  }) => throw StateError('Synthetic customer already exists.');
  @override
  void ensureCreationAvailable() {}
  @override
  Future<ProviderPayment> createPayment(BillingChargeRecord charge) =>
      throw UnimplementedError();
  @override
  Future<ProviderPayment> fetchPayment(String providerId) =>
      throw UnimplementedError();
  @override
  Future<List<ProviderPayment>> findPayments(
    String customerId,
    String externalReference,
  ) => throw UnimplementedError();
  @override
  Future<List<ProviderPayment>> listInstallmentPayments(String installmentId) =>
      throw UnimplementedError();

  ProviderSubscription _subscription(
    BillingChargeRecord charge, [
    int suffix = 1,
  ]) => ProviderSubscription(
    id: 'sub_${charge.id}_$suffix',
    customerId: charge.providerCustomerId!,
    externalReference: charge.externalReference,
    method: charge.method!,
    amountCents: charge.amountCents,
    nextDueDate: charge.dueDate,
    cycle: charge.cycle!,
    rawStatus: status,
  );

  @override
  Future<ProviderSubscription> createSubscription(
    BillingChargeRecord charge,
  ) async {
    creates++;
    final subscription = _subscription(charge);
    subscriptions = [subscription];
    if (loseCreateResponse) throw TimeoutException('Synthetic lost response');
    return subscription;
  }

  @override
  Future<List<ProviderSubscription>> findSubscriptions(
    String customerId,
    String externalReference,
  ) async {
    finds++;
    return subscriptions;
  }

  @override
  Future<ProviderSubscription> fetchSubscription(String subscriptionId) async {
    final original = subscriptions.singleWhere(
      (subscription) => subscription.id == subscriptionId,
    );
    return ProviderSubscription(
      id: original.id,
      customerId: original.customerId,
      externalReference: original.externalReference,
      method: original.method,
      amountCents: original.amountCents,
      nextDueDate: nextDueDate ?? original.nextDueDate,
      cycle: original.cycle,
      rawStatus: status,
    );
  }

  @override
  Future<List<ProviderPayment>> listSubscriptionPayments(
    String subscriptionId,
  ) async => payments;

  ProviderPayment generated(
    ProviderSubscription subscription,
    int sequence, {
    String rawStatus = 'PENDING',
    String? subscriptionId,
  }) => ProviderPayment(
    id: 'pay_${subscription.id}_$sequence',
    customerId: subscription.customerId,
    externalReference: subscription.externalReference,
    method: subscription.method,
    amountCents: subscription.amountCents,
    dueDate: '2099-${(sequence + 5).toString().padLeft(2, '0')}-15',
    rawStatus: rawStatus,
    subscriptionId: subscriptionId ?? subscription.id,
    invoiceUrl: 'https://sandbox.asaas.com/i/recurring_$sequence',
  );
}

void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'synthetic-recurring-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('synthetic-recurring-key-long-enough-for-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Asaas recurring subscriptions', (builder, _) {
    test(
      'creates three methods without confirming payment and imports generated cycles incrementally',
      () async {
        final session = builder.build();
        final client = await _client(session, 730000001);
        final finance = (await _finance(builder)).build();
        for (final method in BillingMethod.values) {
          final provider = _RecurringProvider();
          final endpoint = BillingEndpoint(provider: provider);
          final charge = await endpoint.create(
            finance,
            _request(client.id!, 'recurring-${method.name}', method: method),
          );
          expect(charge.creationState, 'active');
          expect(charge.subscriptionStatus, 'ACTIVE');
          expect(charge.status, BillingStatus.awaitingProvider);
          expect(charge.payments, isEmpty);
          final subscription = provider.subscriptions.single;
          provider.payments = [provider.generated(subscription, 1)];
          final first = await endpoint.refresh(finance, charge.id);
          expect(first.payments, hasLength(1));
          provider.payments = [
            provider.generated(subscription, 1),
            provider.generated(subscription, 2),
          ];
          final second = await endpoint.refresh(finance, charge.id);
          expect(second.payments, hasLength(2));
          expect(
            (await endpoint.refresh(finance, charge.id)).payments,
            hasLength(2),
          );
          expect(provider.creates, 1);
        }
      },
    );

    test(
      'accepts advanced nextDueDate for a linked subscription without changing the intent',
      () async {
        final session = builder.build();
        final client = await _client(session, 730000004);
        final finance = (await _finance(builder)).build();
        final provider = _RecurringProvider();
        final endpoint = BillingEndpoint(provider: provider);
        final charge = await endpoint.create(
          finance,
          _request(client.id!, 'recurring-advanced-date'),
        );
        final subscription = provider.subscriptions.single;
        provider.nextDueDate = '2099-07-15';
        provider.payments = [provider.generated(subscription, 2)];

        final refreshed = await endpoint.refresh(finance, charge.id);
        expect(refreshed.dueDate, '2099-06-15');
        expect(refreshed.providerGroupId, subscription.id);
        expect(refreshed.payments, hasLength(1));
        expect(provider.creates, 1);
        final persisted = await BillingChargeRecord.db.findById(
          session,
          charge.id,
        );
        expect(persisted!.dueDate, '2099-06-15');
      },
    );

    test(
      'reconciles a lost response once and distinguishes zero from multiple matches',
      () async {
        final session = builder.build();
        final client = await _client(session, 730000002);
        final finance = (await _finance(builder)).build();
        final provider = _RecurringProvider()..loseCreateResponse = true;
        final endpoint = BillingEndpoint(provider: provider);
        final request = _request(client.id!, 'recurring-lost');
        await expectLater(
          endpoint.create(finance, request),
          throwsA(_error('creation_uncertain')),
        );
        final reserved = (await endpoint.findIntent(
          finance,
          client.id!,
          request.idempotencyKey,
        ))!;
        expect((await endpoint.create(finance, request)).id, reserved.id);
        expect(provider.creates, 1);
        final original = provider.subscriptions.single;
        provider.subscriptions = [];
        await expectLater(
          endpoint.refresh(finance, reserved.id),
          throwsA(_error('creation_uncertain')),
        );
        provider.subscriptions = [original, original];
        await expectLater(
          endpoint.refresh(finance, reserved.id),
          throwsA(_error('reconciliation_conflict')),
        );
        provider.subscriptions = [original];
        final reconciled = await endpoint.refresh(finance, reserved.id);
        expect(reconciled.providerGroupId, original.id);
        expect(provider.creates, 1);
      },
    );

    test(
      'keeps subscription lifecycle separate and rejects payment reassociation',
      () async {
        final session = builder.build();
        final client = await _client(session, 730000003);
        final finance = (await _finance(builder)).build();
        final provider = _RecurringProvider();
        final endpoint = BillingEndpoint(provider: provider);
        final charge = await endpoint.create(
          finance,
          _request(client.id!, 'recurring-states', method: BillingMethod.card),
        );
        final subscription = provider.subscriptions.single;
        provider.status = 'INACTIVE';
        provider.payments = [
          provider.generated(subscription, 1, rawStatus: 'RECEIVED'),
        ];
        final inactive = await endpoint.refresh(finance, charge.id);
        expect(inactive.subscriptionStatus, 'INACTIVE');
        expect(inactive.status, BillingStatus.awaitingProvider);
        expect(inactive.payments!.single.status, BillingStatus.received);

        provider.payments = [
          provider.generated(
            subscription,
            1,
            rawStatus: 'RECEIVED',
            subscriptionId: 'sub_other',
          ),
        ];
        await expectLater(
          endpoint.refresh(finance, charge.id),
          throwsA(_error('provider_response')),
        );
        final unchanged = await endpoint.get(finance, charge.id);
        expect(unchanged.subscriptionStatus, 'INACTIVE');
        expect(unchanged.payments!.single.status, BillingStatus.received);

        provider.status = 'EXPIRED';
        provider.payments = [
          provider.generated(subscription, 1, rawStatus: 'RECEIVED'),
        ];
        expect(
          (await endpoint.refresh(finance, charge.id)).subscriptionStatus,
          'EXPIRED',
        );
      },
    );
  });
}
