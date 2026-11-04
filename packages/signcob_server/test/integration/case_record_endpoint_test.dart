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
          refreshTokenHashPepper: 'test-pepper-long-enough',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-secret-key-long-enough-for-integration-tests'),
          ),
        ),
      ],
    ),
  );
  withServerpod('Process ownership', (builder, endpoints) {
    test(
      'only assigned lawyer or bound owner reads; owner cannot sync without write',
      () async {
        final session = builder.build();
        final users = AuthServices.instance.authUsers;
        final scopes = {const Scope('cases.read'), const Scope('cases.write')};
        final a = await users.create(session, scopes: scopes);
        final b = await users.create(session, scopes: scopes);
        final owner = await users.create(
          session,
          scopes: {const Scope('cases.read')},
        );
        final now = DateTime.now().toUtc();
        final client = await LegalClient.db.insertRow(
          session,
          LegalClient(
            name: 'Private',
            assignedLawyerId: a.id.toString(),
            ownerAuthUserId: owner.id.toString(),
            createdAt: now,
            updatedAt: now,
          ),
        );
        final record = await LegalCase.db.insertRow(
          session,
          LegalCase(
            legalClientId: client.id!,
            number: '00000012020248160001',
            tribunal: 'tjpr',
            movementsJson: '[]',
          ),
        );
        final first = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            a.id.toString(),
            scopes,
          ),
        );
        final other = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            b.id.toString(),
            scopes,
          ),
        );
        final owned = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            owner.id.toString(),
            {const Scope('cases.read')},
          ),
        );
        expect(await endpoints.caseRecord.list(first, 0), hasLength(1));
        expect(await endpoints.caseRecord.list(owned, 0), hasLength(1));
        expect(await endpoints.caseRecord.list(other, 0), isEmpty);
        await expectLater(
          endpoints.caseRecord.sync(other, record.id!),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.caseRecord.sync(owned, record.id!),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.caseRecord.list(builder, 0),
          throwsA(anything),
        );
        final managerScopes = {
          const Scope('users.manage'),
          const Scope('clients.read'),
          const Scope('clients.write'),
        };
        final manager = await users.create(session, scopes: managerScopes);
        final management = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            manager.id.toString(),
            managerScopes,
          ),
        );
        await expectLater(
          endpoints.legalClient.bindOwner(first, client.id!, b.id.toString()),
          throwsA(isA<AccessDeniedException>()),
        );
        final rebound = await endpoints.legalClient.bindOwner(
          management,
          client.id!,
          b.id.toString().toUpperCase(),
        );
        expect(rebound.ownerAuthUserId, b.id.toString().toLowerCase());
        expect(await endpoints.caseRecord.list(owned, 0), isEmpty);
        expect(await endpoints.caseRecord.list(other, 0), hasLength(1));
      },
    );
  });
}
