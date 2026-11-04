import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'test-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-secret-key-long-enough-for-integration-tests'),
          ),
        ),
      ],
    ),
  );
  withServerpod('Negotiations', (builder, endpoints) {
    test(
      'separates flows, protects assignments and audits atomic transitions',
      () async {
        final scopes = {
          const Scope('negotiations.read'),
          const Scope('negotiations.write'),
        };
        final users = AuthServices.instance.authUsers;
        final lawyer = await users.create(builder.build(), scopes: scopes);
        final outsider = await users.create(builder.build(), scopes: scopes);
        final owner = await users.create(builder.build(), scopes: scopes);
        final a = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            lawyer.id.toString(),
            scopes,
          ),
        );
        final b = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            outsider.id.toString(),
            scopes,
          ),
        );
        final c = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            owner.id.toString(),
            scopes,
          ),
        );
        final now = DateTime.now().toUtc();
        final client = await LegalClient.db.insertRow(
          builder.build(),
          LegalClient(
            name: 'Teste',
            assignedLawyerId: lawyer.id.toString(),
            ownerAuthUserId: owner.id.toString(),
            createdAt: now,
            updatedAt: now,
          ),
        );
        final debt = await endpoints.negotiation.create(
          a,
          client.id!,
          'debt',
          ' Dívida ',
          10000,
        );
        await endpoints.negotiation.create(
          a,
          client.id!,
          'fees',
          'Honorários',
          20000,
        );
        expect(
          (await endpoints.negotiation.list(a, 0, 'debt')).single.title,
          'Dívida',
        );
        expect(
          (await endpoints.negotiation.list(a, 0, 'fees')).single.amountCents,
          20000,
        );
        expect(await endpoints.negotiation.list(b, 0, 'debt'), isEmpty);
        expect(await endpoints.negotiation.list(c, 0, 'debt'), isEmpty);
        await expectLater(
          endpoints.negotiation.history(b, debt.id!),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.negotiation.create(c, client.id!, 'debt', 'Inválida', 1),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.negotiation.transition(a, debt.id!, 'accepted', null),
          throwsArgumentError,
        );
        expect(await endpoints.negotiation.history(a, debt.id!), hasLength(1));
        await endpoints.negotiation.transition(
          a,
          debt.id!,
          'proposed',
          'Proposta',
        );
        await endpoints.negotiation.transition(a, debt.id!, 'accepted', null);
        await expectLater(
          endpoints.negotiation.transition(a, debt.id!, 'cancelled', null),
          throwsArgumentError,
        );
        final history = await endpoints.negotiation.history(a, debt.id!);
        expect(history.map((e) => e.toStatus), [
          'draft',
          'proposed',
          'accepted',
        ]);
        expect(
          history.every((e) => e.actorAuthUserId == lawyer.id.toString()),
          isTrue,
        );
      },
    );
    test(
      'requires login, scopes, valid kind and positive integer amount',
      () async {
        await expectLater(
          endpoints.negotiation.list(builder, 0, 'debt'),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        final scopes = {
          const Scope('negotiations.read'),
          const Scope('negotiations.write'),
        };
        final u = await AuthServices.instance.authUsers.create(
          builder.build(),
          scopes: scopes,
        );
        final a = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            u.id.toString(),
            scopes,
          ),
        );
        await expectLater(
          endpoints.negotiation.create(a, 1, 'other', 'Title', 1),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.negotiation.create(a, 1, 'debt', 'Title', 0),
          throwsArgumentError,
        );
        await AuthServices.instance.authUsers.update(
          builder.build(),
          authUserId: u.id,
          scopes: {},
        );
        await expectLater(
          endpoints.negotiation.list(a, 0, 'debt'),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
  });
}
