import 'package:serverpod/serverpod.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';
import 'package:serverpod_auth_idp_server/core.dart';
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
  withServerpod('Contact administration', (builder, endpoints) {
    test('denies anonymous and users without scope', () async {
      await expectLater(
        endpoints.contactAdmin.list(builder, 0),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      final user = builder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'operator',
          {},
        ),
      );
      await expectLater(
        endpoints.contactAdmin.list(user, 0),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });
    test('authorized operator receives ordered pages', () async {
      final identity = await AuthServices.instance.authUsers.create(
        builder.build(),
        scopes: {const Scope('contacts.read')},
      );
      final admin = builder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          identity.id.toString(),
          {
            const Scope('contacts.read'),
          },
        ),
      );
      final session = builder.build();
      for (var i = 0; i < 26; i++) {
        await ContactMessage.db.insertRow(
          session,
          ContactMessage(
            name: 'Contact $i',
            email: 'contact@example.com',
            message: 'Hello',
            createdAt: DateTime.utc(2026, 1, 1).add(Duration(minutes: i)),
          ),
        );
      }
      final first = await endpoints.contactAdmin.list(admin, 0);
      final second = await endpoints.contactAdmin.list(admin, 25);
      expect(first, hasLength(25));
      expect(first.first.name, 'Contact 25');
      expect(second.single.name, 'Contact 0');
      await expectLater(
        endpoints.contactAdmin.list(admin, -1),
        throwsArgumentError,
      );
    });
  });
}
