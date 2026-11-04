import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/access/partner_profile.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

// All identities and records below exist only in signcob_test, inside the
// harness transaction rolled back after each test. No email account is created.
void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'local-journey-test-pepper',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('local-journey-test-key-with-at-least-thirty-two-bytes'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Local cross-module journeys', (builder, endpoints) {
    final scopes = partnerScopes({});
    test(
      'public contact persists and authorized inbox reads normalized data',
      () async {
        expect(await ContactMessage.db.count(builder.build()), 0);
        await endpoints.contact.submit(
          builder,
          ' Pessoa fictícia QA ',
          ' qa@example.invalid ',
          ' Mensagem fictícia de validação local. ',
        );
        final identity = await AuthServices.instance.authUsers.create(
          builder.build(),
          scopes: {const Scope('contacts.read')},
        );
        final operator = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            identity.id.toString(),
            {const Scope('contacts.read')},
          ),
        );
        final message = (await endpoints.contactAdmin.list(operator, 0)).single;
        expect(message.name, 'Pessoa fictícia QA');
        expect(message.email, 'qa@example.invalid');
        expect(message.message, 'Mensagem fictícia de validação local.');
        expect(message.createdAt.isUtc, isTrue);
        await expectLater(
          endpoints.contact.submit(builder, 'Pessoa', 'sem-email', 'Mensagem'),
          throwsArgumentError,
        );
        expect(await ContactMessage.db.count(builder.build()), 1);
        await expectLater(
          endpoints.contactAdmin.list(builder, 0),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'client ownership, case access, both negotiations and public content persist',
      () async {
        final session = builder.build();
        final users = AuthServices.instance.authUsers;
        final manager = await users.create(session, scopes: scopes);
        final admin = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            manager.id.toString(),
            scopes,
          ),
        );
        final owner = await users.create(
          session,
          scopes: {const Scope('cases.read')},
        );
        final owned = builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            owner.id.toString(),
            {const Scope('cases.read')},
          ),
        );
        final client = await endpoints.legalClient.create(
          admin,
          ' Cliente fictício QA ',
          'qa@example.invalid',
          null,
          null,
        );
        await endpoints.legalClient.update(
          admin,
          client.id!,
          'Cliente fictício atualizado',
          null,
          '123',
          null,
        );
        await endpoints.legalClient.bindOwner(
          admin,
          client.id!,
          owner.id.toString(),
        );
        // DataJud is deliberately not called. This fixture validates SQL access
        // and ownership, not remote tribunal availability or remote import.
        final record = await LegalCase.db.insertRow(
          session,
          LegalCase(
            legalClientId: client.id!,
            number: '00000012020248160001',
            tribunal: 'tjpr',
            movementsJson: '[]',
          ),
        );
        expect(
          (await endpoints.caseRecord.list(owned, 0)).single.id,
          record.id,
        );
        await expectLater(
          endpoints.caseRecord.sync(owned, record.id!),
          throwsA(isA<AccessDeniedException>()),
        );
        for (final kind in ['debt', 'fees']) {
          final negotiation = await endpoints.negotiation.create(
            admin,
            client.id!,
            kind,
            'Proposta fictícia $kind',
            12345,
          );
          await endpoints.negotiation.transition(
            admin,
            negotiation.id!,
            'proposed',
            'Nota fictícia',
          );
          await endpoints.negotiation.transition(
            admin,
            negotiation.id!,
            'accepted',
            null,
          );
          expect(
            (await endpoints.negotiation.list(admin, 0, kind)).single.status,
            'accepted',
          );
          expect(
            (await endpoints.negotiation.history(
              admin,
              negotiation.id!,
            )).map((e) => e.toStatus),
            ['draft', 'proposed', 'accepted'],
          );
        }
        final article = await endpoints.content.saveArticle(
          admin,
          null,
          'Artigo fictício',
          'Resumo',
          'Conteúdo',
          null,
          false,
        );
        expect(await endpoints.content.articles(builder, 0), isEmpty);
        await endpoints.content.saveArticle(
          admin,
          article.id,
          article.title,
          article.summary,
          article.body,
          null,
          true,
        );
        expect(
          (await endpoints.content.articles(builder, 0)).single.id,
          article.id,
        );
        await endpoints.content.saveArticle(
          admin,
          article.id,
          article.title,
          article.summary,
          article.body,
          null,
          false,
        );
        expect(await endpoints.content.articles(builder, 0), isEmpty);
        final partner = await endpoints.content.savePartner(
          admin,
          null,
          'Parceiro fictício',
          'Descrição',
          'https://example.invalid',
          true,
        );
        expect(
          (await endpoints.content.partners(builder, 0)).single.id,
          partner.id,
        );
        await endpoints.content.savePartner(
          admin,
          partner.id,
          partner.name,
          partner.description,
          partner.website,
          false,
        );
        expect(await endpoints.content.partners(builder, 0), isEmpty);
        await endpoints.legalClient.bindOwner(admin, client.id!, null);
        expect(await endpoints.caseRecord.list(owned, 0), isEmpty);
        expect(
          (await endpoints.legalClient.list(admin, 0)).single.name,
          'Cliente fictício atualizado',
        );
        expect(await endpoints.accessAdmin.list(admin, 0), hasLength(2));
      },
    );

    for (final mode in ['blocked', 'revoked', 'missing-token-scopes']) {
      test(
        '$mode denies reads and writes across all internal modules',
        () async {
          final session = builder.build();
          final users = AuthServices.instance.authUsers;
          final identity = await users.create(session, scopes: scopes);
          final operator = builder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              identity.id.toString(),
              mode == 'missing-token-scopes' ? {} : scopes,
            ),
          );
          if (mode == 'blocked') {
            await users.update(session, authUserId: identity.id, blocked: true);
          } else if (mode == 'revoked') {
            await users.update(session, authUserId: identity.id, scopes: {});
          }
          final calls = <Future<dynamic> Function()>[
            () => endpoints.contactAdmin.list(operator, 0),
            () => endpoints.accessAdmin.list(operator, 0),
            () => endpoints.accessAdmin.setPermissions(
              operator,
              identity.id.toString(),
              ['users.manage'],
            ),
            () => endpoints.legalClient.list(operator, 0),
            () => endpoints.legalClient.create(
              operator,
              'Não persistir',
              null,
              null,
              null,
            ),
            () => endpoints.legalClient.update(
              operator,
              1,
              'Não persistir',
              null,
              null,
              null,
            ),
            () => endpoints.legalClient.assign(operator, 1, null),
            () => endpoints.legalClient.bindOwner(operator, 1, null),
            () => endpoints.caseRecord.list(operator, 0),
            () => endpoints.caseRecord.importFromDataJud(
              operator,
              1,
              'tjpr',
              '00000012020248160001',
            ),
            () => endpoints.caseRecord.sync(operator, 1),
            () => endpoints.negotiation.list(operator, 0, 'debt'),
            () => endpoints.negotiation.create(
              operator,
              1,
              'fees',
              'Não persistir',
              100,
            ),
            () =>
                endpoints.negotiation.transition(operator, 1, 'proposed', null),
            () => endpoints.negotiation.history(operator, 1),
            () => endpoints.content.adminArticles(operator, 0),
            () => endpoints.content.adminPartners(operator, 0),
            () => endpoints.content.saveArticle(
              operator,
              null,
              'Não persistir',
              'Resumo',
              'Conteúdo',
              null,
              true,
            ),
            () => endpoints.content.savePartner(
              operator,
              null,
              'Não persistir',
              'Descrição',
              'https://example.invalid',
              true,
            ),
          ];
          for (var i = 0; i < calls.length; i++) {
            await expectLater(
              calls[i](),
              throwsA(
                anyOf(
                  isA<AccessDeniedException>(),
                  isA<ServerpodInsufficientAccessException>(),
                ),
              ),
              reason: '$mode: operação $i',
            );
          }
          expect(await LegalClient.db.count(session), 0);
          expect(await LegalCase.db.count(session), 0);
          expect(await Negotiation.db.count(session), 0);
          expect(await NegotiationEvent.db.count(session), 0);
          expect(await PublicArticle.db.count(session), 0);
          expect(await PublicPartner.db.count(session), 0);
        },
      );
    }
  });
}
