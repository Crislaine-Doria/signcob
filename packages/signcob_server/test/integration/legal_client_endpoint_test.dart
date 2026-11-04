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
  withServerpod('Legal clients', (builder, endpoints) {
    test(
      'lawyers cannot read or update others clients and only manager assigns',
      () async {
        final users = AuthServices.instance.authUsers;
        final scopes = {
          const Scope('clients.read'),
          const Scope('clients.write'),
        };
        final first = await users.create(builder.build(), scopes: scopes);
        final second = await users.create(builder.build(), scopes: scopes);
        final manager = await users.create(
          builder.build(),
          scopes: {...scopes, const Scope('users.manage')},
        );
        final a = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            first.id.toString(),
            scopes,
          ),
        );
        final b = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            second.id.toString(),
            scopes,
          ),
        );
        final m = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            manager.id.toString(),
            {...scopes, const Scope('users.manage')},
          ),
        );
        final client = await endpoints.legalClient.create(
          a,
          'Reservado',
          null,
          null,
          null,
        );
        final noReadScopes = {
          const Scope('users.manage'),
          const Scope('clients.write'),
        };
        final noReadManager = await users.create(
          builder.build(),
          scopes: noReadScopes,
        );
        final noRead = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            noReadManager.id.toString(),
            noReadScopes,
          ),
        );
        await expectLater(
          endpoints.legalClient.assign(
            noRead,
            client.id!,
            second.id.toString(),
          ),
          throwsA(isA<AccessDeniedException>()),
        );
        final noWriteScopes = {
          const Scope('users.manage'),
          const Scope('clients.read'),
        };
        final noWriteManager = await users.create(
          builder.build(),
          scopes: noWriteScopes,
        );
        final noWrite = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            noWriteManager.id.toString(),
            noWriteScopes,
          ),
        );
        await expectLater(
          endpoints.legalClient.assign(
            noWrite,
            client.id!,
            second.id.toString(),
          ),
          throwsA(isA<AccessDeniedException>()),
        );
        expect(await endpoints.legalClient.list(b, 0), isEmpty);
        await expectLater(
          endpoints.legalClient.update(
            b,
            client.id!,
            'Invasão',
            null,
            null,
            null,
          ),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.legalClient.assign(b, client.id!, second.id.toString()),
          throwsA(isA<AccessDeniedException>()),
        );
        expect(await endpoints.legalClient.list(m, 0), hasLength(1));
        await endpoints.legalClient.assign(
          m,
          client.id!,
          second.id.toString().toUpperCase(),
        );
        expect(await endpoints.legalClient.list(a, 0), isEmpty);
        expect(await endpoints.legalClient.list(b, 0), hasLength(1));
        await endpoints.legalClient.assign(m, client.id!, null);
        expect(await endpoints.legalClient.list(b, 0), isEmpty);
      },
    );
    test(
      'requires login and both token and current database permission',
      () async {
        await expectLater(
          endpoints.legalClient.list(builder, 0),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        final user = await AuthServices.instance.authUsers.create(
          builder.build(),
          scopes: {const Scope('clients.read')},
        );
        final noTokenScope = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            user.id.toString(),
            {},
          ),
        );
        await expectLater(
          endpoints.legalClient.list(noTokenScope, 0),
          throwsA(isA<AccessDeniedException>()),
        );
        final reader = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            user.id.toString(),
            {const Scope('clients.read')},
          ),
        );
        expect(await endpoints.legalClient.list(reader, 0), isEmpty);
        await expectLater(
          endpoints.legalClient.create(reader, 'Ana', null, null, null),
          throwsA(isA<AccessDeniedException>()),
        );
        await AuthServices.instance.authUsers.update(
          builder.build(),
          authUserId: user.id,
          scopes: {},
        );
        await expectLater(
          endpoints.legalClient.list(reader, 0),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
    test(
      'creates normalized client, updates preserving creation and validates',
      () async {
        final scopes = {
          const Scope('clients.read'),
          const Scope('clients.write'),
        };
        final user = await AuthServices.instance.authUsers.create(
          builder.build(),
          scopes: scopes,
        );
        final authorized = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            user.id.toString(),
            scopes,
          ),
        );
        final created = await endpoints.legalClient.create(
          authorized,
          ' Ana ',
          ' ana@example.com ',
          ' ',
          null,
        );
        expect(created.name, 'Ana');
        expect(created.email, 'ana@example.com');
        expect(created.phone, isNull);
        final updated = await endpoints.legalClient.update(
          authorized,
          created.id!,
          'Ana Silva',
          null,
          '123',
          'documento',
        );
        expect(updated.createdAt, created.createdAt);
        expect(updated.name, 'Ana Silva');
        expect(
          (await endpoints.legalClient.list(authorized, 0)).single.id,
          created.id,
        );
        await expectLater(
          endpoints.legalClient.create(authorized, '', null, null, null),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.legalClient.create(
            authorized,
            'Ana',
            'invalid',
            null,
            null,
          ),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.legalClient.list(authorized, -1),
          throwsArgumentError,
        );
        expect(await LegalClient.db.count(builder.build()), 1);
      },
    );
  });
}
