// ignore_for_file: experimental_member_use

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
          refreshTokenHashPepper: 'test-pepper-chat',
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-secret-key-long-enough-for-chat-tests'),
          ),
        ),
      ],
    ),
  );

  withServerpod('Chat authorization and persistence', (builder, endpoints) {
    Future<({UuidValue id, TestSessionBuilder session})> user(
      Set<Scope> scopes,
    ) async {
      final account = await AuthServices.instance.authUsers.create(
        builder.build(),
        scopes: scopes,
      );
      return (
        id: account.id,
        session: builder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            account.id.toString(),
            scopes,
          ),
        ),
      );
    }

    Future<LegalClient> client({
      required UuidValue owner,
      required UuidValue lawyer,
      required String name,
    }) => LegalClient.db.insertRow(
      builder.build(),
      LegalClient(
        name: name,
        ownerAuthUserId: owner.toString().toLowerCase(),
        assignedLawyerId: lawyer.toString().toLowerCase(),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    Future<ChatConversation> conversation(
      LegalClient legalClient,
      String title,
      DateTime createdAt,
    ) => ChatConversation.db.insertRow(
      builder.build(),
      ChatConversation(
        title: title,
        legalClientId: legalClient.id,
        createdAt: createdAt,
      ),
    );

    Future<void> participate(ChatConversation chat, UuidValue account) async {
      await ChatParticipant.db.insertRow(
        builder.build(),
        ChatParticipant(
          conversationId: chat.id!,
          authUserId: account.toString().toLowerCase(),
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      );
    }

    test(
      'anonymous and finance are denied without leaking conversations',
      () async {
        await expectLater(
          endpoints.chat.listConversations(builder, 0, 25),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
        final finance = await user({const Scope('billing.read')});
        await expectLater(
          endpoints.chat.listConversations(finance.session, 0, 25),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );

    test(
      'partner, lawyer, support and client receive only authorized rows',
      () async {
        final partner = await user({
          const Scope('chat.partner'),
          const Scope('chat.lawyer'),
        });
        final lawyerA = await user({const Scope('chat.lawyer')});
        final lawyerB = await user({const Scope('chat.lawyer')});
        final clientA = await user({const Scope('chat.client')});
        final clientB = await user({const Scope('chat.client')});
        final support = await user({const Scope('chat.support')});
        final a = await client(
          owner: clientA.id,
          lawyer: lawyerA.id,
          name: 'A',
        );
        final b = await client(
          owner: clientB.id,
          lawyer: lawyerB.id,
          name: 'B',
        );
        final chatA = await conversation(a, 'A', DateTime.utc(2026, 1, 1));
        final chatB = await conversation(b, 'B', DateTime.utc(2026, 1, 2));
        await participate(chatA, clientA.id);
        await participate(chatB, clientB.id);
        await participate(chatA, support.id);

        expect(
          (await endpoints.chat.listConversations(
            partner.session,
            0,
            25,
          )).map((row) => row.id),
          [chatB.id, chatA.id],
        );
        expect(
          (await endpoints.chat.listConversations(
            lawyerA.session,
            0,
            25,
          )).single.id,
          chatA.id,
        );
        expect(
          (await endpoints.chat.listConversations(
            lawyerB.session,
            0,
            25,
          )).single.id,
          chatB.id,
        );
        expect(
          (await endpoints.chat.listConversations(
            support.session,
            0,
            25,
          )).single.id,
          chatA.id,
        );
        expect(
          (await endpoints.chat.listConversations(
            clientA.session,
            0,
            25,
          )).single.id,
          chatA.id,
        );
        expect(
          (await endpoints.chat.listConversations(
            clientB.session,
            0,
            25,
          )).single.id,
          chatB.id,
        );
        await expectLater(
          endpoints.chat.listMessages(clientA.session, chatB.id!, 0, 25),
          throwsA(isA<AccessDeniedException>()),
        );
        await expectLater(
          endpoints.chat.sendMessage(clientA.session, chatB.id!, 'invasão'),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );

    test(
      'multiple current capabilities are combined instead of prioritized',
      () async {
        final lawyer = await user({
          const Scope('chat.lawyer'),
          const Scope('chat.support'),
        });
        final otherLawyer = await user({const Scope('chat.lawyer')});
        final ownerA = await user({const Scope('chat.client')});
        final ownerB = await user({const Scope('chat.client')});
        final a = await client(owner: ownerA.id, lawyer: lawyer.id, name: 'A');
        final b = await client(
          owner: ownerB.id,
          lawyer: otherLawyer.id,
          name: 'B',
        );
        final own = await conversation(a, 'lawyer', DateTime.utc(2026, 2, 1));
        final assignedSupport = await conversation(
          b,
          'support',
          DateTime.utc(2026, 2, 2),
        );
        await participate(assignedSupport, lawyer.id);
        expect(
          (await endpoints.chat.listConversations(
            lawyer.session,
            0,
            25,
          )).map((row) => row.id).toSet(),
          {own.id, assignedSupport.id},
        );
      },
    );

    test(
      'send uses normalized content, authenticated author and UTC server time',
      () async {
        final owner = await user({const Scope('chat.client')});
        final lawyer = await user({const Scope('chat.lawyer')});
        final legalClient = await client(
          owner: owner.id,
          lawyer: lawyer.id,
          name: 'A',
        );
        final chat = await conversation(
          legalClient,
          'A',
          DateTime.utc(2026, 3, 1),
        );
        await participate(chat, owner.id);
        final before = DateTime.now().toUtc();
        final sent = await endpoints.chat.sendMessage(
          owner.session,
          chat.id!,
          '  Olá  ',
        );
        final after = DateTime.now().toUtc();
        expect(sent.content, 'Olá');
        expect(sent.authorAuthUserId, owner.id.toString().toLowerCase());
        expect(sent.createdAt.isUtc, isTrue);
        expect(sent.createdAt.isBefore(before), isFalse);
        expect(sent.createdAt.isAfter(after), isFalse);
        expect((await ChatMessage.db.find(builder.build())).single.id, sent.id);
        await expectLater(
          endpoints.chat.sendMessage(owner.session, chat.id!, '   '),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.chat.sendMessage(owner.session, chat.id!, 'x' * 4001),
          throwsArgumentError,
        );
      },
    );

    test(
      'message order and pagination are deterministic and bounded',
      () async {
        final partner = await user({const Scope('chat.partner')});
        final owner = await user({const Scope('chat.client')});
        final lawyer = await user({const Scope('chat.lawyer')});
        final legalClient = await client(
          owner: owner.id,
          lawyer: lawyer.id,
          name: 'A',
        );
        final chat = await conversation(
          legalClient,
          'A',
          DateTime.utc(2026, 4, 1),
        );
        final time = DateTime.utc(2026, 4, 2);
        final first = await ChatMessage.db.insertRow(
          builder.build(),
          ChatMessage(
            conversationId: chat.id!,
            authorAuthUserId: partner.id.toString(),
            content: 'first',
            createdAt: time,
          ),
        );
        final second = await ChatMessage.db.insertRow(
          builder.build(),
          ChatMessage(
            conversationId: chat.id!,
            authorAuthUserId: partner.id.toString(),
            content: 'second',
            createdAt: time,
          ),
        );
        expect(
          (await endpoints.chat.listMessages(
            partner.session,
            chat.id!,
            0,
            1,
          )).single.id,
          second.id,
        );
        expect(
          (await endpoints.chat.listMessages(
            partner.session,
            chat.id!,
            1,
            1,
          )).single.id,
          first.id,
        );
        await expectLater(
          endpoints.chat.listMessages(partner.session, chat.id!, 0, 51),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.chat.listConversations(partner.session, -1, 25),
          throwsArgumentError,
        );
      },
    );

    test(
      'participant removal and current scope revocation apply immediately',
      () async {
        final support = await user({const Scope('chat.support')});
        final owner = await user({const Scope('chat.client')});
        final lawyer = await user({const Scope('chat.lawyer')});
        final legalClient = await client(
          owner: owner.id,
          lawyer: lawyer.id,
          name: 'A',
        );
        final chat = await conversation(
          legalClient,
          'A',
          DateTime.utc(2026, 5, 1),
        );
        await participate(chat, support.id);
        final participant = (await ChatParticipant.db.find(
          builder.build(),
        )).single;
        expect(
          await endpoints.chat.listConversations(support.session, 0, 25),
          hasLength(1),
        );
        await ChatParticipant.db.updateRow(
          builder.build(),
          participant.copyWith(removedAt: DateTime.now().toUtc()),
        );
        expect(
          await endpoints.chat.listConversations(support.session, 0, 25),
          isEmpty,
        );
        await expectLater(
          endpoints.chat.listMessages(support.session, chat.id!, 0, 25),
          throwsA(isA<AccessDeniedException>()),
        );

        await AuthServices.instance.authUsers.update(
          builder.build(),
          authUserId: support.id,
          scopes: {},
        );
        await expectLater(
          endpoints.chat.listConversations(support.session, 0, 25),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
  });
}
