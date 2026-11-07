// ignore_for_file: experimental_member_use

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _partner = Scope('chat.partner');
const _lawyer = Scope('chat.lawyer');
const _support = Scope('chat.support');
const _client = Scope('chat.client');
const _finance = Scope('billing.read');
const _missing = '00000000-0000-4000-8000-000000000001';

final _denied = throwsA(
  isA<AccessDeniedException>().having(
    (error) => error.message,
    'message',
    'Chat indisponível',
  ),
);

typedef _Account = ({UuidValue id, TestSessionBuilder session});

class _Fixtures {
  _Fixtures(this.builder);

  final TestSessionBuilder builder;

  Future<_Account> account(Set<Scope> scopes, {Set<Scope>? token}) async {
    final user = await AuthServices.instance.authUsers.create(
      builder.build(),
      scopes: scopes,
    );
    return (
      id: user.id,
      session: builder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          token ?? scopes,
        ),
      ),
    );
  }

  Future<LegalClient> client({_Account? lawyer, _Account? owner}) =>
      LegalClient.db.insertRow(
        builder.build(),
        LegalClient(
          name: 'Cliente de teste',
          assignedLawyerId: lawyer?.id.toString(),
          ownerAuthUserId: owner?.id.toString(),
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      );
}

int _requestSequence = 0;

String _request() =>
    '00000000-0000-4000-8000-${(++_requestSequence).toString().padLeft(12, '0')}';

void main() {
  setUpAll(
    () => AuthServices.set(
      tokenManagerBuilders: [
        JwtConfig(
          refreshTokenHashPepper: 'test-pepper-chat-provisioning',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-secret-key-long-enough-for-chat-provisioning'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Chat provisioning', (builder, endpoints) {
    final fixture = _Fixtures(builder);
    final chat = endpoints.chat;

    test('creation options use current assignment and stable client IDs', () async {
      final partner = await fixture.account({_partner});
      final lawyer = await fixture.account({_lawyer});
      final otherLawyer = await fixture.account({_lawyer});
      final own = await fixture.client(lawyer: lawyer);
      final foreign = await fixture.client(lawyer: otherLawyer);
      final otherOwn = await fixture.client(lawyer: lawyer);
      expect((await chat.listCreationClients(partner.session, 0, 50)).map((row) => row.legalClientId), [own.id, foreign.id, otherOwn.id]);
      final first = (await chat.listCreationClients(lawyer.session, 0, 1)).single;
      final second = (await chat.listCreationClients(lawyer.session, 1, 1)).single;
      expect(first.name, second.name);
      expect([first.legalClientId, second.legalClientId], [own.id, otherOwn.id]);
      expect(await chat.listCreationClients(lawyer.session, 2, 1), isEmpty);
      await expectLater(chat.listCreationClients(lawyer.session, 0, 51), throwsArgumentError);
      for (final scope in [_support, _client, _finance]) {
        final user = await fixture.account({scope});
        await expectLater(chat.listCreationClients(user.session, 0, 50), _denied);
      }
      await expectLater(chat.listCreationClients(builder, 0, 50), throwsA(isA<ServerpodUnauthenticatedException>()));
      await LegalClient.db.updateRow(builder.build(), own.copyWith(assignedLawyerId: otherLawyer.id.toString()));
      expect((await chat.listCreationClients(lawyer.session, 0, 1)).single.legalClientId, otherOwn.id);
      await AuthServices.instance.authUsers.update(builder.build(), authUserId: lawyer.id, scopes: {});
      await expectLater(chat.listCreationClients(lawyer.session, 0, 50), _denied);
    });

    test('roster is scoped to current managers and active membership rows', () async {
      final partner = await fixture.account({_partner});
      final lawyer = await fixture.account({_lawyer});
      final otherLawyer = await fixture.account({_lawyer});
      final owner = await fixture.account({_client});
      final support = await fixture.account({_support});
      final client = await fixture.client(lawyer: lawyer, owner: owner);
      final room = await chat.createConversation(partner.session, client.id!, 'A', _request());
      final id = room.id!;
      expect(await chat.listParticipants(lawyer.session, id, 0, 50), isEmpty);
      final first = await chat.addParticipant(lawyer.session, id, support.id.toString());
      final second = await chat.addParticipant(support.session, id, owner.id.toString());
      await ChatParticipant.db.updateRow(builder.build(), second.copyWith(createdAt: first.createdAt));
      expect((await chat.listParticipants(support.session, id, 0, 1)).single.authUserId, owner.id.toString());
      expect((await chat.listParticipants(support.session, id, 1, 1)).single.authUserId, support.id.toString());
      for (final inaccessible in [id, 2147483647]) {
        await expectLater(chat.listParticipants(otherLawyer.session, inaccessible, 0, 50), _denied);
      }
      expect((await chat.listParticipants(owner.session, id, 0, 50)).map((row) => row.authUserId), [owner.id.toString(), support.id.toString()]);
      await expectLater(chat.listParticipants(lawyer.session, id, -1, 50), throwsArgumentError);
      await expectLater(chat.listParticipants(builder, id, 0, 50), throwsA(isA<ServerpodUnauthenticatedException>()));
      await chat.removeParticipant(partner.session, id, support.id.toString());
      await expectLater(chat.listParticipants(support.session, id, 0, 50), _denied);
      expect((await chat.listParticipants(lawyer.session, id, 0, 50)).single.id, second.id);
      await AuthServices.instance.authUsers.update(builder.build(), authUserId: lawyer.id, blocked: true);
      await expectLater(chat.listParticipants(lawyer.session, id, 0, 50), _denied);
    });

    test(
      'creates a linked conversation with server identity and UTC time',
      () async {
        final partner = await fixture.account({_partner});
        final otherPartner = await fixture.account({_partner});
        final client = await fixture.client();
        final key = _request();
        final before = DateTime.now().toUtc();
        final created = await chat.createConversation(
          partner.session,
          client.id!,
          '  Dúvidas  ',
          key,
        );
        expect(created.legalClientId, client.id);
        expect(created.title, 'Dúvidas');
        expect(created.createdAt.isUtc, isTrue);
        expect(created.createdAt.isBefore(before), isFalse);
        expect(created.createdAt.isAfter(DateTime.now().toUtc()), isFalse);
        final stored = await ChatConversation.db.findById(
          builder.build(),
          created.id!,
        );
        expect(stored?.createdByAuthUserId, partner.id.toString());
        expect(stored?.creationRequestId, key);

        final retry = await chat.createConversation(
          partner.session,
          client.id!,
          'Dúvidas',
          key.toUpperCase(),
        );
        expect(retry.id, created.id);
        expect(retry.createdAt, created.createdAt);
        await expectLater(
          chat.createConversation(
            partner.session,
            client.id!,
            'Outro título',
            key,
          ),
          throwsArgumentError,
        );
        final other = await chat.createConversation(
          otherPartner.session,
          client.id!,
          'Dúvidas',
          key,
        );
        expect(other.id, isNot(created.id));
      },
    );

    test('rejects invalid titles, request keys and client IDs', () async {
      final partner = await fixture.account({_partner});
      final client = await fixture.client();
      for (final title in [' ', 'x' * 121, 'a\u0000b', 'a\nb']) {
        await expectLater(
          chat.createConversation(
            partner.session,
            client.id!,
            title,
            _request(),
          ),
          throwsArgumentError,
        );
      }
      await expectLater(
        chat.createConversation(
          partner.session,
          client.id!,
          'Válido',
          'inválido',
        ),
        throwsArgumentError,
      );
      for (final id in [-1, 0, 2147483647]) {
        await expectLater(
          chat.createConversation(partner.session, id, 'Válido', _request()),
          _denied,
        );
      }
      final legacy = await ChatConversation.db.insertRow(
        builder.build(),
        ChatConversation(title: 'Legado', createdAt: DateTime.utc(2026)),
      );
      await expectLater(
        chat.addParticipant(partner.session, legacy.id!, partner.id.toString()),
        _denied,
      );
      expect(
        await chat.listMessages(partner.session, legacy.id!, 0, 1),
        isEmpty,
      );
      expect(
        (await chat.createConversation(
          partner.session,
          client.id!,
          'x' * 120,
          _request(),
        )).title.length,
        120,
      );
    });

    test(
      'enforces current lawyer assignment and hides other conversations',
      () async {
        final lawyer = await fixture.account({_lawyer});
        final otherLawyer = await fixture.account({_lawyer});
        final owner = await fixture.account({_client});
        final otherOwner = await fixture.account({_client});
        final a = await fixture.client(lawyer: lawyer, owner: owner);
        final b = await fixture.client(lawyer: otherLawyer, owner: otherOwner);
        final key = _request();
        final own = await chat.createConversation(
          lawyer.session,
          a.id!,
          'A',
          key,
        );
        final other = await chat.createConversation(
          otherLawyer.session,
          b.id!,
          'B',
          _request(),
        );
        await expectLater(
          chat.createConversation(lawyer.session, b.id!, 'Invasão', _request()),
          _denied,
        );
        for (final id in [other.id!, 2147483647]) {
          await expectLater(
            chat.addParticipant(lawyer.session, id, owner.id.toString()),
            _denied,
          );
          await expectLater(
            chat.removeParticipant(lawyer.session, id, owner.id.toString()),
            _denied,
          );
        }
        await expectLater(
          chat.addParticipant(
            lawyer.session,
            own.id!,
            otherOwner.id.toString(),
          ),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            lawyer.session,
            own.id!,
            otherLawyer.id.toString(),
          ),
          _denied,
        );
        await chat.addParticipant(lawyer.session, own.id!, owner.id.toString());
        await LegalClient.db.updateRow(
          builder.build(),
          a.copyWith(
            assignedLawyerId: otherLawyer.id.toString(),
            ownerAuthUserId: otherOwner.id.toString(),
          ),
        );

        await expectLater(
          chat.createConversation(lawyer.session, a.id!, 'A', key),
          _denied,
        );
        await expectLater(
          chat.removeParticipant(lawyer.session, own.id!, owner.id.toString()),
          _denied,
        );
        expect(await chat.listConversations(lawyer.session, 0, 50), isEmpty);
        expect(await chat.listConversations(owner.session, 0, 50), isEmpty);
        await expectLater(
          chat.sendMessage(owner.session, own.id!, 'Ainda aqui?'),
          _denied,
        );
        expect(
          await chat.listMessages(otherLawyer.session, own.id!, 0, 50),
          isEmpty,
        );
      },
    );

    test(
      'support manages the current owner only in its active conversation',
      () async {
        final partner = await fixture.account({_partner});
        final support = await fixture.account({_support});
        final peer = await fixture.account({_support});
        final owner = await fixture.account({_client});
        final otherOwner = await fixture.account({_client});
        final a = await fixture.client(owner: owner);
        final b = await fixture.client(owner: otherOwner);
        final allowed = await chat.createConversation(
          partner.session,
          a.id!,
          'A',
          _request(),
        );
        final sameClient = await chat.createConversation(
          partner.session,
          a.id!,
          'Outro A',
          _request(),
        );
        final foreign = await chat.createConversation(
          partner.session,
          b.id!,
          'B',
          _request(),
        );
        await expectLater(
          chat.addParticipant(
            support.session,
            allowed.id!,
            owner.id.toString(),
          ),
          _denied,
        );
        await chat.addParticipant(
          partner.session,
          allowed.id!,
          support.id.toString(),
        );
        await chat.addParticipant(
          partner.session,
          allowed.id!,
          peer.id.toString(),
        );
        await expectLater(
          chat.createConversation(support.session, a.id!, 'A', _request()),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            support.session,
            sameClient.id!,
            owner.id.toString(),
          ),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            support.session,
            foreign.id!,
            otherOwner.id.toString(),
          ),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            support.session,
            allowed.id!,
            otherOwner.id.toString(),
          ),
          _denied,
        );
        await expectLater(
          chat.addParticipant(support.session, allowed.id!, peer.id.toString()),
          _denied,
        );
        await expectLater(
          chat.removeParticipant(
            support.session,
            allowed.id!,
            peer.id.toString(),
          ),
          _denied,
        );
        final participant = await chat.addParticipant(
          support.session,
          allowed.id!,
          owner.id.toString(),
        );
        expect(participant.authUserId, owner.id.toString());
        expect(participant.createdAt.isUtc, isTrue);
        expect(
          (await chat.listConversations(owner.session, 0, 50)).single.id,
          allowed.id,
        );

        await chat.removeParticipant(
          support.session,
          allowed.id!,
          owner.id.toString(),
        );
        expect(await chat.listConversations(owner.session, 0, 50), isEmpty);
        await expectLater(
          chat.listMessages(owner.session, allowed.id!, 0, 50),
          _denied,
        );
        await expectLater(
          chat.sendMessage(owner.session, allowed.id!, 'Bloqueado'),
          _denied,
        );
        await chat.removeParticipant(
          partner.session,
          allowed.id!,
          support.id.toString(),
        );
        await expectLater(
          chat.removeParticipant(
            support.session,
            allowed.id!,
            owner.id.toString(),
          ),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            support.session,
            allowed.id!,
            owner.id.toString(),
          ),
          _denied,
        );
      },
    );

    test(
      'denies anonymous, client, finance, blocked and unbound targets',
      () async {
        final partner = await fixture.account({_partner});
        final lawyer = await fixture.account({_lawyer});
        final owner = await fixture.account({_client});
        final finance = await fixture.account({_finance});
        final blocked = await fixture.account({_support});
        final client = await fixture.client(lawyer: lawyer, owner: owner);
        final conversation = await chat.createConversation(
          partner.session,
          client.id!,
          'A',
          _request(),
        );
        final id = conversation.id!;
        await chat.addParticipant(partner.session, id, owner.id.toString());
        await AuthServices.instance.authUsers.update(
          builder.build(),
          authUserId: blocked.id,
          blocked: true,
        );
        final anonymous = throwsA(isA<ServerpodUnauthenticatedException>());
        await expectLater(
          chat.createConversation(builder, client.id!, 'A', _request()),
          anonymous,
        );
        await expectLater(
          chat.addParticipant(builder, id, owner.id.toString()),
          anonymous,
        );
        await expectLater(
          chat.removeParticipant(builder, id, owner.id.toString()),
          anonymous,
        );
        for (final account in [owner, finance]) {
          await expectLater(
            chat.createConversation(
              account.session,
              client.id!,
              'A',
              _request(),
            ),
            _denied,
          );
          await expectLater(
            chat.addParticipant(account.session, id, owner.id.toString()),
            _denied,
          );
          await expectLater(
            chat.removeParticipant(account.session, id, owner.id.toString()),
            _denied,
          );
        }
        for (final target in [
          _missing,
          'não é UUID',
          finance.id.toString(),
          blocked.id.toString(),
        ]) {
          await expectLater(
            chat.addParticipant(partner.session, id, target),
            _denied,
          );
        }
        await chat.addParticipant(partner.session, id, partner.id.toString());
        await expectLater(
          chat.removeParticipant(lawyer.session, id, partner.id.toString()),
          _denied,
        );
      },
    );

    test('applies current account changes to the same session', () async {
      final partner = await fixture.account({_partner});
      final blocked = await fixture.account({_partner});
      final noToken = await fixture.account({_partner}, token: {});
      final owner = await fixture.account({_client});
      final client = await fixture.client(owner: owner);
      final key = _request();
      final created = await chat.createConversation(
        partner.session,
        client.id!,
        'A',
        key,
      );
      final id = created.id!;
      await chat.addParticipant(partner.session, id, owner.id.toString());
      await AuthServices.instance.authUsers.update(
        builder.build(),
        authUserId: partner.id,
        scopes: {},
      );
      await AuthServices.instance.authUsers.update(
        builder.build(),
        authUserId: blocked.id,
        blocked: true,
      );
      for (final account in [partner, blocked, noToken]) {
        await expectLater(
          chat.createConversation(account.session, client.id!, 'A', key),
          _denied,
        );
        await expectLater(
          chat.addParticipant(account.session, id, owner.id.toString()),
          _denied,
        );
        await expectLater(
          chat.removeParticipant(account.session, id, owner.id.toString()),
          _denied,
        );
        await expectLater(
          chat.listConversations(account.session, 0, 50),
          _denied,
        );
        await expectLater(
          chat.listMessages(account.session, id, 0, 50),
          _denied,
        );
        await expectLater(
          chat.sendMessage(account.session, id, 'Bloqueado'),
          _denied,
        );
      }
    });

    test(
      'filters before pagination and removal also overrides assignment',
      () async {
        final partner = await fixture.account({_partner});
        final lawyer = await fixture.account({_lawyer});
        final own = await fixture.client(lawyer: lawyer);
        final other = await fixture.client();
        final time = DateTime.utc(2026);
        Future<ChatConversation> seed(int clientId) =>
            ChatConversation.db.insertRow(
              builder.build(),
              ChatConversation(
                title: 'Mesmo horário',
                legalClientId: clientId,
                createdAt: time,
              ),
            );
        final first = await seed(own.id!);
        final second = await seed(own.id!);
        await seed(other.id!);
        expect(
          (await chat.listConversations(lawyer.session, 0, 1)).single.id,
          second.id,
        );
        expect(
          (await chat.listConversations(lawyer.session, 1, 1)).single.id,
          first.id,
        );
        await expectLater(
          chat.listConversations(lawyer.session, 0, 51),
          throwsArgumentError,
        );
        await expectLater(
          chat.listConversations(lawyer.session, 0, 0),
          throwsArgumentError,
        );

        final membership = await chat.addParticipant(
          partner.session,
          second.id!,
          lawyer.id.toString(),
        );
        await chat.removeParticipant(
          partner.session,
          second.id!,
          lawyer.id.toString(),
        );
        final removed = await ChatParticipant.db.findById(
          builder.build(),
          membership.id!,
        );
        expect(removed?.removedAt?.isUtc, isTrue);
        expect(removed?.createdAt, membership.createdAt);
        expect(
          (await chat.listConversations(lawyer.session, 0, 1)).single.id,
          first.id,
        );
        await expectLater(
          chat.listMessages(lawyer.session, second.id!, 0, 1),
          _denied,
        );
        await expectLater(
          chat.sendMessage(lawyer.session, second.id!, 'Bloqueado'),
          _denied,
        );
        await expectLater(
          chat.addParticipant(
            partner.session,
            second.id!,
            lawyer.id.toString(),
          ),
          _denied,
        );
        await chat.removeParticipant(
          partner.session,
          second.id!,
          lawyer.id.toString(),
        );
        expect(
          (await ChatParticipant.db.findById(
            builder.build(),
            membership.id!,
          ))?.removedAt,
          removed?.removedAt,
        );
      },
    );
  });

  withServerpod('Concurrent chat provisioning', (builder, endpoints) {
    final fixture = _Fixtures(builder);
    final chat = endpoints.chat;
    test(
      'concurrent retries share one conversation and one membership',
      () async {
        final partner = await fixture.account({_partner});
        final support = await fixture.account({_support});
        final client = await fixture.client();
        final key = _request();
        try {
          final conversations = await Future.wait(
            List.generate(
              4,
              (_) => chat.createConversation(
                partner.session,
                client.id!,
                'Paralela',
                key,
              ),
            ),
          );
          final id = conversations.first.id!;
          expect(conversations.map((row) => row.id).toSet(), {id});
          final target = support.id.toString();
          final memberships = await Future.wait(
            List.generate(
              4,
              (_) => chat.addParticipant(partner.session, id, target),
            ),
          );
          expect(memberships.map((row) => row.id).toSet(), {
            memberships.first.id,
          });
          await Future.wait(
            List.generate(
              4,
              (_) => chat.removeParticipant(partner.session, id, target),
            ),
          );
          final rows = await ChatParticipant.db.find(
            builder.build(),
            where: (table) => table.conversationId.equals(id),
          );
          expect(rows.single.id, memberships.first.id);
          expect(rows.single.removedAt, isNotNull);
          await expectLater(
            chat.addParticipant(partner.session, id, target),
            _denied,
          );
          await expectLater(
            chat.sendMessage(support.session, id, 'Bloqueado'),
            _denied,
          );
        } finally {
          final session = builder.build();
          await session.db.transaction((transaction) async {
            final conversations = await ChatConversation.db.find(
              session,
              where: (table) => table.legalClientId.equals(client.id),
              transaction: transaction,
            );
            for (final row in conversations) {
              await ChatMessage.db.deleteWhere(
                session,
                where: (table) => table.conversationId.equals(row.id),
                transaction: transaction,
              );
              await ChatParticipant.db.deleteWhere(
                session,
                where: (table) => table.conversationId.equals(row.id),
                transaction: transaction,
              );
            }
            await ChatConversation.db.deleteWhere(
              session,
              where: (table) => table.legalClientId.equals(client.id),
              transaction: transaction,
            );
            await LegalClient.db.deleteRow(
              session,
              client,
              transaction: transaction,
            );
            for (final account in [partner, support]) {
              await AuthServices.instance.authUsers.delete(
                session,
                authUserId: account.id,
                transaction: transaction,
              );
            }
          });
        }
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
