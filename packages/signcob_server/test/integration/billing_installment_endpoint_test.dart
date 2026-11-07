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
      name: 'Pagador parcelado $seed',
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
}) => BillingCreateRequest(
  clientId: clientId,
  kind: 'fees',
  method: method,
  flow: BillingFlow.installment,
  amountCents: 10000,
  dueDate: '2099-01-31',
  idempotencyKey: key,
  installmentCount: 3,
);

enum _InvalidInstallment { none, count, total, group }

class _InstallmentProvider implements BillingProvider {
  int creates = 0;
  int groupReads = 0;
  bool loseCreateResponse = false;
  bool sameFirstTwoDueDate = false;
  Completer<void>? releaseCreate;
  final createStarted = Completer<void>();
  _InvalidInstallment invalid = _InvalidInstallment.none;
  List<ProviderPayment> payments = [];

  @override
  Future<String> verifyAccount() async => 'synthetic-account';

  @override
  Future<List<ProviderCustomer>> findCustomers(String document) async => [
    ProviderCustomer(id: 'cus_installment', document: document),
  ];

  @override
  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  }) => throw StateError('Synthetic customer should already exist.');

  @override
  void ensureCreationAvailable() {}

  List<ProviderPayment> _build(BillingChargeRecord charge) {
    final group = 'group_${charge.id}';
    final values = invalid == _InvalidInstallment.total
        ? [3333, 3333, 3333]
        : [3333, 3333, 3334];
    final count = invalid == _InvalidInstallment.count ? 2 : 3;
    return List.generate(count, (index) {
      final number = index + 1;
      return ProviderPayment(
        id: 'pay_${charge.id}_$number',
        customerId: charge.providerCustomerId!,
        externalReference: charge.externalReference,
        method: charge.method!,
        amountCents: values[index],
        dueDate: number == 1 || (sameFirstTwoDueDate && number == 2)
            ? charge.dueDate
            : '2099-0${number + 1}-28',
        rawStatus: 'PENDING',
        installmentId: invalid == _InvalidInstallment.group && number == 2
            ? '${group}_other'
            : group,
        installmentNumber: number,
        invoiceUrl: 'https://sandbox.asaas.com/i/pay_${charge.id}_$number',
      );
    });
  }

  @override
  Future<ProviderPayment> createPayment(BillingChargeRecord charge) async {
    creates++;
    if (!createStarted.isCompleted) createStarted.complete();
    await releaseCreate?.future;
    payments = _build(charge);
    if (loseCreateResponse) throw TimeoutException('Synthetic lost response');
    return payments.first;
  }

  @override
  Future<ProviderPayment> fetchPayment(String providerId) =>
      throw UnimplementedError();

  @override
  Future<List<ProviderPayment>> findPayments(
    String customerId,
    String externalReference,
  ) async => payments;

  @override
  Future<List<ProviderPayment>> listInstallmentPayments(
    String installmentId,
  ) async {
    groupReads++;
    return payments;
  }

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
          refreshTokenHashPepper: 'synthetic-installment-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('synthetic-installment-key-long-enough-for-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Asaas installments', (builder, _) {
    test(
      'persists every Pix, boleto and card installment including final rounding',
      () async {
        final session = builder.build();
        final client = await _client(session, 720000001);
        final finance = (await _finance(builder)).build();
        for (final method in BillingMethod.values) {
          final provider = _InstallmentProvider();
          final charge = await BillingEndpoint(provider: provider).create(
            finance,
            _request(client.id!, 'installment-${method.name}', method: method),
          );
          expect(charge.creationState, 'active');
          expect(charge.providerGroupId, isNotNull);
          expect(charge.status, BillingStatus.awaitingProvider);
          final payments = charge.payments!;
          expect(payments.map((payment) => payment.installmentNumber), [
            1,
            2,
            3,
          ]);
          expect(payments.map((payment) => payment.amountCents), [
            3333,
            3333,
            3334,
          ]);
          expect(
            payments.fold<int>(0, (sum, payment) => sum + payment.amountCents),
            10000,
          );
          expect(provider.creates, 1);
          expect(provider.groupReads, 1);
        }
      },
    );

    test(
      'reconciles a lost response without another POST and keeps parcel states independent',
      () async {
        final session = builder.build();
        final client = await _client(session, 720000002);
        final finance = (await _finance(builder)).build();
        final provider = _InstallmentProvider()..loseCreateResponse = true;
        final endpoint = BillingEndpoint(provider: provider);
        final request = _request(client.id!, 'installment-lost');
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
        provider.loseCreateResponse = false;
        final reconciled = await endpoint.refresh(finance, reserved.id);
        expect(reconciled.creationState, 'active');
        expect(provider.creates, 1);

        provider.payments = [
          provider.payments[0].copyWithRawStatus('RECEIVED'),
          provider.payments[1].copyWithRawStatus('CONFIRMED'),
          provider.payments[2].copyWithRawStatus('OVERDUE'),
        ];
        final refreshed = await endpoint.refresh(finance, reserved.id);
        expect(refreshed.payments!.map((payment) => payment.status), [
          BillingStatus.received,
          BillingStatus.confirmed,
          BillingStatus.overdue,
        ]);
      },
    );

    test(
      'rejects swapped installment numbers and rolls the refresh back',
      () async {
        final session = builder.build();
        final client = await _client(session, 720000005);
        final finance = (await _finance(builder)).build();
        final provider = _InstallmentProvider()..sameFirstTwoDueDate = true;
        final endpoint = BillingEndpoint(provider: provider);
        final charge = await endpoint.create(
          finance,
          _request(client.id!, 'installment-swapped-numbers'),
        );
        final before = await BillingPaymentRecord.db.find(
          session,
          where: (row) => row.chargeId.equals(charge.id),
          orderBy: (row) => row.providerId,
        );

        provider.payments = [
          provider.payments[0].copyWithInstallmentNumber(2),
          provider.payments[1].copyWithInstallmentNumber(1),
          provider.payments[2],
        ];
        await expectLater(
          endpoint.refresh(finance, charge.id),
          throwsA(_error('provider_response')),
        );

        final after = await BillingPaymentRecord.db.find(
          session,
          where: (row) => row.chargeId.equals(charge.id),
          orderBy: (row) => row.providerId,
        );
        expect(
          after
              .map((row) => (row.providerId, row.installmentNumber, row.status))
              .toList(),
          before
              .map((row) => (row.providerId, row.installmentNumber, row.status))
              .toList(),
        );
      },
    );

    test(
      'keeps payment observations monotonic and upserts by provider id',
      () async {
        final session = builder.build();
        final client = await _client(session, 720000006);
        final finance = (await _finance(builder)).build();
        final provider = _InstallmentProvider();
        final endpoint = BillingEndpoint(provider: provider);
        final charge = await endpoint.create(
          finance,
          _request(client.id!, 'installment-monotonic'),
        );

        provider.payments = [
          provider.payments[0].copyWithRawStatus('RECEIVED'),
          provider.payments[1].copyWithRawStatus('CONFIRMED'),
          provider.payments[2],
        ];
        var refreshed = await endpoint.refresh(finance, charge.id);
        final directReceived = refreshed.payments!.firstWhere(
          (payment) => payment.installmentNumber == 1,
        );
        final confirmed = refreshed.payments!.firstWhere(
          (payment) => payment.installmentNumber == 2,
        );
        expect(directReceived.status, BillingStatus.received);
        expect(directReceived.receivedAt, isNotNull);
        expect(directReceived.confirmedAt, isNull);
        expect(confirmed.status, BillingStatus.confirmed);
        expect(confirmed.confirmedAt, isNotNull);
        expect(confirmed.receivedAt, isNull);

        provider.payments = [
          provider.payments[0].copyWithRawStatus('PENDING'),
          provider.payments[1].copyWithRawStatus('RECEIVED'),
          provider.payments[2].copyWithRawStatus('OVERDUE'),
        ];
        refreshed = await endpoint.refresh(finance, charge.id);
        final receivedAfterConfirmation = refreshed.payments!.firstWhere(
          (payment) => payment.installmentNumber == 2,
        );
        expect(receivedAfterConfirmation.status, BillingStatus.received);
        expect(receivedAfterConfirmation.confirmedAt, confirmed.confirmedAt);
        expect(receivedAfterConfirmation.receivedAt, isNotNull);

        provider.payments = [
          provider.payments[0].copyWithRawStatus('PENDING'),
          provider.payments[1].copyWithRawStatus('CONFIRMED'),
          provider.payments[2].copyWithRawStatus('PENDING'),
        ];
        refreshed = await endpoint.refresh(finance, charge.id);
        expect(
          refreshed.payments!.map((payment) => payment.status),
          [
            BillingStatus.received,
            BillingStatus.received,
            BillingStatus.overdue,
          ],
        );
        expect(
          await BillingPaymentRecord.db.count(
            session,
            where: (row) => row.chargeId.equals(charge.id),
          ),
          3,
        );
      },
    );

    test(
      'refuses conflicting count, sum or group during creation and reconciliation',
      () async {
        final session = builder.build();
        final client = await _client(session, 720000003);
        final finance = (await _finance(builder)).build();
        for (final invalid in [
          _InvalidInstallment.count,
          _InvalidInstallment.total,
          _InvalidInstallment.group,
        ]) {
          final provider = _InstallmentProvider()..invalid = invalid;
          final endpoint = BillingEndpoint(provider: provider);
          final request = _request(client.id!, 'invalid-${invalid.name}');
          await expectLater(
            endpoint.create(finance, request),
            throwsA(_error('creation_uncertain')),
          );
          final reserved = (await endpoint.findIntent(
            finance,
            client.id!,
            request.idempotencyKey,
          ))!;
          await expectLater(
            endpoint.refresh(finance, reserved.id),
            throwsA(
              _error(
                invalid == _InvalidInstallment.group
                    ? 'reconciliation_conflict'
                    : 'provider_response',
              ),
            ),
          );
          expect(provider.creates, 1);
        }
      },
    );
  });

  withServerpod('Concurrent Asaas installment', (builder, _) {
    test('same key reserves and posts one installment only', () async {
      final session = builder.build();
      final client = await _client(session, 720000004);
      final finance = await _finance(builder);
      final provider = _InstallmentProvider()
        ..releaseCreate = Completer<void>();
      final endpoint = BillingEndpoint(provider: provider);
      final request = _request(client.id!, 'installment-concurrent');
      final first = endpoint.create(finance.build(), request);
      await provider.createStarted.future.timeout(const Duration(seconds: 5));
      final replay = await endpoint.create(finance.build(), request);
      expect(replay.creationState, 'awaitingProvider');
      expect(provider.creates, 1);
      provider.releaseCreate!.complete();
      final completed = await first;
      expect(completed.creationState, 'active');
      expect(provider.creates, 1);

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

extension on ProviderPayment {
  ProviderPayment copyWithRawStatus(String status) => ProviderPayment(
    id: id,
    customerId: customerId,
    externalReference: externalReference,
    method: method,
    amountCents: amountCents,
    dueDate: dueDate,
    rawStatus: status,
    installmentId: installmentId,
    subscriptionId: subscriptionId,
    installmentNumber: installmentNumber,
    invoiceUrl: invoiceUrl,
  );

  ProviderPayment copyWithInstallmentNumber(int number) => ProviderPayment(
    id: id,
    customerId: customerId,
    externalReference: externalReference,
    method: method,
    amountCents: amountCents,
    dueDate: dueDate,
    rawStatus: rawStatus,
    installmentId: installmentId,
    subscriptionId: subscriptionId,
    installmentNumber: number,
    invoiceUrl: invoiceUrl,
  );
}
