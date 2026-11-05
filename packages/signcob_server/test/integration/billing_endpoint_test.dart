import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/billing/asaas_sandbox_provider.dart';
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

Future<LegalClient> _insertClient(Session session, {String? owner}) {
  final now = DateTime.now().toUtc();
  return LegalClient.db.insertRow(
    session,
    LegalClient(
      name: 'Cliente sintético',
      ownerAuthUserId: owner,
      createdAt: now,
      updatedAt: now,
    ),
  );
}

TestSessionBuilder _signedIn(
  TestSessionBuilder builder,
  UuidValue userId,
  Set<Scope> scopes,
) => builder.copyWith(
  authentication: AuthenticationOverride.authenticationInfo(
    userId.toString(),
    scopes,
  ),
);

class _ControlledProvider implements BillingProvider {
  _ControlledProvider({this.releaseCreation});

  final Future<void>? releaseCreation;
  int creates = 0;
  int reads = 0;
  bool failCreation = false;
  BillingStatus status = BillingStatus.pending;

  @override
  void ensureCreationAvailable() {}

  @override
  Future<({String id, BillingStatus status})> create(
    BillingCharge charge,
  ) async {
    creates++;
    await releaseCreation;
    if (failCreation) {
      throw StateError('Resultado simulado incerto');
    }
    return (id: 'pay_test_${charge.id}', status: BillingStatus.pending);
  }

  @override
  Future<BillingStatus> fetchStatus(String providerId) async {
    expect(providerId, startsWith('pay_test_'));
    reads++;
    return status;
  }
}

void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'synthetic-test-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('synthetic-key-long-enough-for-integration-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Billing', (builder, endpoints) {
    test(
      'checks links, refreshes valid statuses and protects other clients',
      () async {
        final session = builder.build();
        final users = AuthServices.instance.authUsers;
        final negotiationScopes = {
          const Scope('negotiations.read'),
          const Scope('negotiations.write'),
        };
        final finance = await users.create(session, scopes: {_read, _write});
        final reader = await users.create(session, scopes: {_read});
        final customer = await users.create(
          session,
          scopes: {const Scope('cases.read')},
        );
        final lawyer = await users.create(session, scopes: negotiationScopes);
        final financeBuilder = _signedIn(builder, finance.id, {_read, _write});
        final financeSession = financeBuilder.build();
        final customerBuilder = _signedIn(builder, customer.id, {
          const Scope('cases.read'),
        });
        final lawyerBuilder = _signedIn(builder, lawyer.id, negotiationScopes);
        final client = await _insertClient(session);
        final other = await _insertClient(
          session,
          owner: customer.id.toString(),
        );
        await LegalClient.db.updateRow(
          session,
          client.copyWith(assignedLawyerId: lawyer.id.toString()),
        );

        final negotiation = await endpoints.negotiation.create(
          lawyerBuilder,
          client.id!,
          'fees',
          'Proposta sintética',
          12500,
        );
        await endpoints.negotiation.transition(
          lawyerBuilder,
          negotiation.id!,
          'proposed',
          null,
        );
        await endpoints.negotiation.transition(
          lawyerBuilder,
          negotiation.id!,
          'accepted',
          null,
        );
        expect(
          await BillingChargeRecord.db.count(
            session,
            where: (row) => row.legalClientId.equals(client.id!),
          ),
          0,
        );

        final provider = _ControlledProvider();
        final endpoint = BillingEndpoint(provider: provider);
        Future<BillingCharge> create({
          int amount = 12500,
          String dueDate = _dueDate,
        }) => endpoint.create(
          financeSession,
          client.id!,
          negotiation.id,
          amount,
          dueDate,
          'example',
        );

        await expectLater(
          endpoint.create(
            financeSession,
            other.id!,
            negotiation.id,
            12500,
            _dueDate,
            'example',
          ),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          create(dueDate: '2099-02-29'),
          throwsA(_error('invalid_input')),
        );
        expect(provider.creates, 0);

        final charge = await create();
        expect(charge.legalClientId, client.id);
        expect(charge.negotiationId, negotiation.id);
        expect(charge.amountCents, 12500);
        expect(charge.status, BillingStatus.pending);
        expect(charge.toJson().keys, isNot(contains('providerId')));
        expect(charge.toJson().keys, isNot(contains('idempotencyKey')));
        final readerBuilder = _signedIn(builder, reader.id, {_read});
        expect(
          (await endpoints.billing.get(readerBuilder, charge.id)).id,
          charge.id,
        );
        await expectLater(
          endpoints.billing.get(builder, charge.id),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        await expectLater(
          endpoint.get(customerBuilder.build(), charge.id),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoint.refresh(readerBuilder.build(), charge.id),
          throwsA(isA<AccessDeniedException>()),
        );
        expect(provider.reads, 0);

        expect(
          (await endpoint.refresh(financeSession, charge.id)).updatedAt,
          charge.updatedAt,
        );
        provider.status = BillingStatus.overdue;
        final overdue = await endpoint.refresh(financeSession, charge.id);
        expect(overdue.status, BillingStatus.overdue);
        provider.status = BillingStatus.pending;
        await expectLater(
          endpoint.refresh(financeSession, charge.id),
          throwsA(_error('invalid_transition')),
        );
        expect(
          (await endpoint.get(financeSession, charge.id)).status,
          BillingStatus.overdue,
        );
        expect((await create()).id, charge.id);
        expect(provider.creates, 1);
        await expectLater(
          create(amount: 12501),
          throwsA(_error('idempotency_conflict')),
        );
        await users.update(session, authUserId: finance.id, scopes: {});
        await expectLater(
          endpoints.billing.get(financeBuilder, charge.id),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );

    test('leaves no reservation when sandbox creation is disabled', () async {
      final session = builder.build();
      final client = await _insertClient(session);
      final user = await AuthServices.instance.authUsers.create(
        session,
        scopes: {_read, _write},
      );
      final finance = _signedIn(builder, user.id, {_read, _write}).build();

      for (final (key, code) in [
        (null, 'provider_configuration'),
        (r'$aact_hmlg_synthetic-test-key', 'creation_disabled'),
      ]) {
        final endpoint = BillingEndpoint(
          provider: AsaasSandboxProvider(
            environment: 'sandbox',
            apiKey: key,
            transport: (_, _) async => throw StateError('Unexpected transport'),
          ),
        );
        await expectLater(
          endpoint.create(finance, client.id!, null, 100, _dueDate, 'disabled'),
          throwsA(_error(code)),
        );
      }
      expect(
        await BillingChargeRecord.db.count(
          session,
          where: (row) => row.legalClientId.equals(client.id!),
        ),
        0,
      );
    });

    test(
      'preserves an uncertain reservation across repeated operations',
      () async {
        final session = builder.build();
        final client = await _insertClient(session);
        final user = await AuthServices.instance.authUsers.create(
          session,
          scopes: {_read, _write},
        );
        final finance = _signedIn(builder, user.id, {_read, _write}).build();
        final provider = _ControlledProvider()..failCreation = true;
        final endpoint = BillingEndpoint(provider: provider);

        Future<BillingCharge> create() => endpoint.create(
          finance,
          client.id!,
          null,
          100,
          _dueDate,
          'uncertain',
        );
        await expectLater(create(), throwsA(_error('creation_uncertain')));
        final charge = await create();
        expect(charge.status, BillingStatus.awaitingProvider);
        expect((await create()).id, charge.id);
        expect(provider.creates, 1);
        await expectLater(
          endpoint.refresh(finance, charge.id),
          throwsA(_error('creation_uncertain')),
        );
        expect(provider.reads, 0);
      },
    );
  });

  // Use independent committed transactions for the idempotency race, so the
  // second request cannot accidentally see an uncommitted test transaction.
  withServerpod('Concurrent billing', (builder, _) {
    test('only one request dispatches the same reservation', () async {
      final session = builder.build();
      final client = await _insertClient(session);
      final clientId = client.id!;
      addTearDown(() async {
        await BillingChargeRecord.db.deleteWhere(
          session,
          where: (row) => row.legalClientId.equals(clientId),
        );
        await LegalClient.db.deleteRow(session, client);
      });

      final users = AuthServices.instance.authUsers;
      final user = await users.create(session, scopes: {_read, _write});
      addTearDown(() => users.delete(session, authUserId: user.id));
      final finance = _signedIn(builder, user.id, {_read, _write});
      final releaseCreation = Completer<void>();
      final provider = _ControlledProvider(
        releaseCreation: releaseCreation.future,
      );
      final endpoint = BillingEndpoint(provider: provider);

      Future<BillingCharge> create() => endpoint.create(
        finance.build(),
        clientId,
        null,
        100,
        _dueDate,
        'concurrent',
      );
      final requests = [create(), create()];
      late final BillingCharge replay;
      late final List<BillingCharge> results;
      try {
        replay = await Future.any(requests).timeout(const Duration(seconds: 5));
      } finally {
        releaseCreation.complete();
        results = await Future.wait(requests);
      }
      final completed = results.singleWhere(
        (charge) => charge.status == BillingStatus.pending,
      );
      expect(replay.id, completed.id);
      expect(replay.status, BillingStatus.awaitingProvider);
      expect((await create()).id, completed.id);
      expect(provider.creates, 1);
      expect(
        await BillingChargeRecord.db.count(
          session,
          where: (row) => row.legalClientId.equals(clientId),
        ),
        1,
      );
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
