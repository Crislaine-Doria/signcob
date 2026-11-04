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
  withServerpod('Public content', (builder, endpoints) {
    test('public cannot manage content', () async {
      expect(await endpoints.content.articles(builder, 0), isEmpty);
      expect(await endpoints.content.partners(builder, 0), isEmpty);
      await expectLater(
        endpoints.content.adminArticles(builder, 0),
        throwsA(isA<AccessDeniedException>()),
      );
      await expectLater(
        endpoints.content.savePartner(
          builder,
          null,
          'Name',
          'Description',
          'https://example.com',
          true,
        ),
        throwsA(isA<AccessDeniedException>()),
      );
    });
    test(
      'persists edits, filters unpublished, validates and honors revocation',
      () async {
        final identity = await AuthServices.instance.authUsers.create(
          builder.build(),
          scopes: {const Scope('content.write')},
        );
        final admin = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            identity.id.toString(),
            {const Scope('content.write')},
          ),
        );
        final draft = await endpoints.content.saveArticle(
          admin,
          null,
          ' Draft ',
          ' Summary ',
          'Body',
          null,
          false,
        );
        expect(await endpoints.content.articles(builder, 0), isEmpty);
        final published = await endpoints.content.saveArticle(
          admin,
          draft.id,
          'Published',
          'Summary',
          'Body',
          null,
          true,
        );
        expect(published.createdAt, draft.createdAt);
        expect(
          (await endpoints.content.articles(builder, 0)).single.title,
          'Published',
        );
        final partner = await endpoints.content.savePartner(
          admin,
          null,
          'Partner',
          'Description',
          'https://example.com',
          false,
        );
        expect(await endpoints.content.partners(builder, 0), isEmpty);
        await endpoints.content.savePartner(
          admin,
          partner.id,
          'Partner',
          'Description',
          'https://example.com',
          true,
        );
        expect(await endpoints.content.partners(builder, 0), hasLength(1));
        expect(await endpoints.content.adminArticles(admin, 0), hasLength(1));
        await expectLater(
          endpoints.content.savePartner(
            admin,
            null,
            'P',
            'D',
            'javascript:alert(1)',
            true,
          ),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.content.saveArticle(admin, null, 'T', 'S', '', null, true),
          throwsArgumentError,
        );
        await AuthServices.instance.authUsers.update(
          builder.build(),
          authUserId: identity.id,
          scopes: {},
        );
        await expectLater(
          endpoints.content.adminPartners(admin, 0),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
  });
}
