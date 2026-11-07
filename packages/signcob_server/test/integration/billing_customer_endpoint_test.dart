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
      name: 'Pagador sintético $seed',
      document: _document(seed),
      createdAt: now,
      updatedAt: now,
    ),
  );
}

Future<TestSessionBuilder> _finance(
  TestSessionBuilder builder, {
  bool write = true,
}) async {
  final scopes = {_read, if (write) _write};
  final user = await AuthServices.instance.authUsers.create(
    builder.build(),
    scopes: scopes,
  );
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      user.id.toString(),
      scopes,
    ),
  );
}

class _CustomerProvider implements BillingProvider {
  String account = 'synthetic-account-a';
  int creates = 0;
  int reads = 0;
  bool failCreate = false;
  bool failRead = false;
  final started = Completer<void>();
  Completer<void>? release;
  Completer<void>? firstReadRelease;
  final firstReadStarted = Completer<void>();
  Completer<void>? secondReadRelease;
  final secondReadStarted = Completer<void>();
  List<ProviderCustomer> customers = [];

  @override
  Future<String> verifyAccount() async => account;

  @override
  Future<List<ProviderCustomer>> findCustomers(String document) async {
    reads++;
    if (failRead) throw StateError('Synthetic read failure');
    final snapshot = customers
        .where((row) => row.document == document)
        .toList();
    if (reads == 1 && firstReadRelease != null) {
      firstReadStarted.complete();
      await firstReadRelease!.future;
    } else if (reads == 2 && secondReadRelease != null) {
      secondReadStarted.complete();
      await secondReadRelease!.future;
    }
    return snapshot;
  }

  @override
  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  }) async {
    creates++;
    if (!started.isCompleted) started.complete();
    await release?.future;
    final result = ProviderCustomer(
      id: 'cus_synthetic_$creates',
      document: document,
      externalReference: externalReference,
    );
    customers = [result];
    if (failCreate) throw TimeoutException('Synthetic uncertain result');
    return result;
  }

  @override
  void ensureCreationAvailable() => throw UnimplementedError();

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
          refreshTokenHashPepper: 'synthetic-customer-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('synthetic-customer-key-long-enough-for-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Asaas customer links', (builder, endpoints) {
    test(
      'creates one customer, reuses persisted link, exposes minimal options and enforces write',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000001);
        final finance = await _finance(builder);
        final reader = await _finance(builder, write: false);
        final provider = _CustomerProvider();
        final endpoint = BillingEndpoint(provider: provider);
        expect(
          (await endpoint.resolveCustomer(finance.build(), client.id!)).state,
          'linked',
        );
        expect(
          (await endpoint.resolveCustomer(finance.build(), client.id!)).state,
          'linked',
        );
        expect(provider.creates, 1);
        expect(provider.reads, 1);
        final options = await endpoint.listClients(
          reader.build(),
          'sintético',
          0,
        );
        expect(options.single.id, client.id);
        expect(options.single.readyForBilling, isTrue);
        expect(options.single.toJson().keys, isNot(contains('document')));
        expect(options.single.toJson().keys, isNot(contains('email')));
        await expectLater(
          endpoint.resolveCustomer(reader.build(), client.id!),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.billing.listClients(builder, '', 0),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        final info = reader.build().authenticated!;
        await AuthServices.instance.authUsers.update(
          session,
          authUserId: UuidValue.withValidation(info.userIdentifier),
          scopes: {},
        );
        await expectLater(
          endpoint.listClients(reader.build(), '', 0),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );

    test(
      'reuses exactly one existing document; duplicate identities remain unresolved',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000002);
        final finance = (await _finance(builder)).build();
        final provider = _CustomerProvider()
          ..customers = [
            ProviderCustomer(id: 'cus_existing', document: client.document!),
          ];
        final endpoint = BillingEndpoint(provider: provider);
        expect(
          (await endpoint.resolveCustomer(finance, client.id!)).state,
          'linked',
        );
        expect(provider.creates, 0);
        final other = await _client(session, 700000003);
        provider.customers = [
          ProviderCustomer(id: 'cus_duplicate_a', document: other.document!),
          ProviderCustomer(id: 'cus_duplicate_b', document: other.document!),
        ];
        await expectLater(
          endpoint.resolveCustomer(finance, other.id!),
          throwsA(_error('customer_conflict')),
        );
        await expectLater(
          endpoint.resolveCustomer(finance, other.id!),
          throwsA(_error('customer_uncertain')),
        );
        expect(provider.creates, 0);
      },
    );

    test(
      'lost create response is reconciled, never resent; unrelated reference is refused',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000004);
        final finance = (await _finance(builder)).build();
        final provider = _CustomerProvider()..failCreate = true;
        final endpoint = BillingEndpoint(provider: provider);
        await expectLater(
          endpoint.resolveCustomer(finance, client.id!),
          throwsA(_error('customer_uncertain')),
        );
        await expectLater(
          endpoint.resolveCustomer(finance, client.id!),
          throwsA(_error('customer_uncertain')),
        );
        final original = provider.customers.single;
        provider.customers = [
          ProviderCustomer(
            id: original.id,
            document: original.document,
            externalReference: 'unrelated',
          ),
        ];
        await expectLater(
          endpoint.reconcileCustomer(finance, client.id!),
          throwsA(_error('customer_uncertain')),
        );
        provider.customers = [];
        await expectLater(
          endpoint.reconcileCustomer(finance, client.id!),
          throwsA(_error('customer_uncertain')),
        );
        provider.customers = [original];
        expect(
          (await endpoint.reconcileCustomer(finance, client.id!)).state,
          'linked',
        );
        expect(provider.creates, 1);
      },
    );

    test(
      'pre-create GET failure can reconcile old customer and document changes are rejected',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000005);
        final finance = (await _finance(builder)).build();
        final provider = _CustomerProvider()..failRead = true;
        final endpoint = BillingEndpoint(provider: provider);
        await expectLater(
          endpoint.resolveCustomer(finance, client.id!),
          throwsA(_error('customer_uncertain')),
        );
        provider.failRead = false;
        provider.customers = [
          ProviderCustomer(id: 'cus_existing', document: client.document!),
        ];
        expect(
          (await endpoint.reconcileCustomer(finance, client.id!)).state,
          'linked',
        );
        expect(provider.creates, 0);
        await LegalClient.db.updateRow(
          session,
          client.copyWith(document: _document(700000006)),
        );
        await expectLater(
          endpoint.resolveCustomer(finance, client.id!),
          throwsA(_error('customer_conflict')),
        );
        await expectLater(
          endpoint.reconcileCustomer(finance, client.id!),
          throwsA(_error('customer_conflict')),
        );
      },
    );

    test(
      'links are isolated by verified account; invalid client produces no call',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000007);
        final finance = (await _finance(builder)).build();
        final provider = _CustomerProvider();
        final endpoint = BillingEndpoint(provider: provider);
        await endpoint.resolveCustomer(finance, client.id!);
        provider.account = 'synthetic-account-b';
        provider.customers = [];
        await endpoint.resolveCustomer(finance, client.id!);
        expect(await BillingCustomerRecord.db.count(session), 2);
        expect(provider.creates, 2);
        await LegalClient.db.updateRow(
          session,
          client.copyWith(document: '00000000000'),
        );
        await expectLater(
          endpoint.resolveCustomer(finance, client.id!),
          throwsA(_error('invalid_customer')),
        );
        expect(provider.creates, 2);
      },
    );
  });

  withServerpod('Concurrent Asaas customer links', (builder, _) {
    test(
      'reconciliation started before POST cannot adopt an unrelated customer after POST starts',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000010);
        final finance = await _finance(builder);
        final provider = _CustomerProvider()
          ..firstReadRelease = Completer<void>()
          ..secondReadRelease = Completer<void>()
          ..release = Completer<void>();
        final endpoint = BillingEndpoint(provider: provider);
        final first = endpoint.resolveCustomer(finance.build(), client.id!);
        await provider.firstReadStarted.future.timeout(
          const Duration(seconds: 5),
        );
        provider.customers = [
          ProviderCustomer(id: 'cus_unrelated', document: client.document!),
        ];
        final reconciliation = endpoint.reconcileCustomer(
          finance.build(),
          client.id!,
        );
        await provider.secondReadStarted.future.timeout(
          const Duration(seconds: 5),
        );
        try {
          provider.firstReadRelease!.complete();
          await provider.started.future.timeout(const Duration(seconds: 5));
          final expectation = expectLater(
            reconciliation,
            throwsA(_error('customer_uncertain')),
          );
          provider.secondReadRelease!.complete();
          await expectation;
        } finally {
          provider.release!.complete();
          await first;
        }
        expect(provider.creates, 1);
        final record = await BillingCustomerRecord.db.findFirstRow(
          session,
          where: (row) => row.legalClientId.equals(client.id!),
        );
        expect(record!.providerCustomerId, 'cus_synthetic_1');
        expect(record.createAttempted, isTrue);
        await BillingCustomerRecord.db.deleteRow(session, record);
        await LegalClient.db.deleteRow(session, client);
        await AuthServices.instance.authUsers.delete(
          session,
          authUserId: UuidValue.withValidation(
            finance.build().authenticated!.userIdentifier,
          ),
        );
      },
    );

    test(
      'reconciliation winning before POST prevents a stale create',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000009);
        final finance = await _finance(builder);
        final provider = _CustomerProvider()
          ..firstReadRelease = Completer<void>();
        final endpoint = BillingEndpoint(provider: provider);
        final first = endpoint.resolveCustomer(finance.build(), client.id!);
        await provider.firstReadStarted.future.timeout(
          const Duration(seconds: 5),
        );
        try {
          provider.customers = [
            ProviderCustomer(id: 'cus_existing', document: client.document!),
          ];
          expect(
            (await endpoint.reconcileCustomer(
              finance.build(),
              client.id!,
            )).state,
            'linked',
          );
        } finally {
          provider.firstReadRelease!.complete();
          await first;
        }
        expect(provider.creates, 0);
        final record = await BillingCustomerRecord.db.findFirstRow(
          session,
          where: (row) => row.legalClientId.equals(client.id!),
        );
        expect(record!.providerCustomerId, 'cus_existing');
        expect(record.createAttempted, isFalse);
        await BillingCustomerRecord.db.deleteRow(session, record);
        await LegalClient.db.deleteRow(session, client);
        await AuthServices.instance.authUsers.delete(
          session,
          authUserId: UuidValue.withValidation(
            finance.build().authenticated!.userIdentifier,
          ),
        );
      },
    );

    test(
      'one POST for same client and same document across different clients',
      () async {
        final session = builder.build();
        final client = await _client(session, 700000008);
        final other = await _client(session, 700000008);
        final finance = await _finance(builder);
        final provider = _CustomerProvider()..release = Completer<void>();
        final endpoint = BillingEndpoint(provider: provider);
        final first = endpoint.resolveCustomer(finance.build(), client.id!);
        await provider.started.future.timeout(const Duration(seconds: 5));
        try {
          await expectLater(
            endpoint.resolveCustomer(finance.build(), client.id!),
            throwsA(_error('customer_uncertain')),
          );
          await expectLater(
            endpoint.resolveCustomer(finance.build(), other.id!),
            throwsA(_error('customer_conflict')),
          );
        } finally {
          provider.release!.complete();
          await first;
        }
        expect(provider.creates, 1);
        await BillingCustomerRecord.db.deleteWhere(
          session,
          where: (row) => row.legalClientId.equals(client.id!),
        );
        await LegalClient.db.deleteRow(session, client);
        await LegalClient.db.deleteRow(session, other);
        await AuthServices.instance.authUsers.delete(
          session,
          authUserId: UuidValue.withValidation(
            finance.build().authenticated!.userIdentifier,
          ),
        );
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
