import 'package:signcob_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
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
  withServerpod('Access administration', (builder, endpoints) {
    test('denies anonymous and unprivileged identities', () async {
      await expectLater(
        endpoints.accessAdmin.list(builder, 0),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      final denied = builder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('none', {}),
      );
      await expectLater(
        endpoints.accessAdmin.list(denied, 0),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });
    test(
      'updates allowlisted scopes, preserves others and revokes stale token',
      () async {
        final session = builder.build();
        final users = AuthServices.instance.authUsers;
        final manager = await users.create(
          session,
          scopes: {const Scope('users.manage')},
        );
        final target = await users.create(
          session,
          scopes: {const Scope('contacts.read'), const Scope('other')},
        );
        final admin = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            manager.id.toString(),
            {const Scope('users.manage')},
          ),
        );
        expect(await endpoints.accessAdmin.list(admin, 0), hasLength(2));
        await endpoints.accessAdmin.setPermissions(
          admin,
          target.id.toString(),
          [],
        );
        final updated = await users.get(session, authUserId: target.id);
        expect(updated.scopes, {const Scope('other')});
        final stale = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            target.id.toString(),
            {const Scope('contacts.read')},
          ),
        );
        await expectLater(
          endpoints.contactAdmin.list(stale, 0),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.accessAdmin.setPermissions(
            admin,
            manager.id.toString().toUpperCase(),
            [],
          ),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.accessAdmin.setPermissions(admin, target.id.toString(), [
            'unknown',
          ]),
          throwsArgumentError,
        );
        await users.update(session, authUserId: manager.id, scopes: {});
        await expectLater(
          endpoints.accessAdmin.list(admin, 0),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
  });
}
