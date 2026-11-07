import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_chat_screen.dart';

final _now = DateTime.utc(2026, 11, 7, 12);

ChatConversationItem conversation(int id, {String? title}) =>
    ChatConversationItem(
      id: id,
      title: title ?? 'Conversa $id',
      updatedAt: _now,
      preview: 'Última mensagem',
    );

ChatMessageItem message(int id, {String content = 'Olá'}) => ChatMessageItem(
  id: id,
  authorLabel: 'Pessoa',
  content: content,
  createdAt: _now,
  isCurrentUser: false,
);

Widget subject({
  Object? sessionIdentity = 'session-a',
  LoadChatConversations? loadConversations,
  LoadChatMessages? loadMessages,
  SendChatMessage? sendMessage,
}) => MaterialApp(
  home: Scaffold(
    body: AdminChatScreen(
      sessionIdentity: sessionIdentity,
      loadConversations: loadConversations ?? (_) async => [conversation(1)],
      loadMessages: loadMessages ?? (_, _) async => [message(1)],
      sendMessage:
          sendMessage ?? (_, content) async => message(2, content: content),
    ),
  ),
);

Future<void> openConversation(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('Conversa 1'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mostra carregamento, vazio e falha recuperável', (tester) async {
    final first = Completer<List<ChatConversationItem>>();
    var attempts = 0;
    await tester.pumpWidget(
      subject(
        loadConversations: (_) {
          attempts++;
          if (attempts == 1) return first.future;
          if (attempts == 2) throw StateError('indisponível');
          return Future.value(const []);
        },
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    first.completeError(StateError('indisponível'));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível carregar o chat. Tente novamente.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível carregar o chat. Tente novamente.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma conversa disponível.'), findsOneWidget);
  });

  testWidgets('acesso negado não exibe conversas', (tester) async {
    await tester.pumpWidget(
      subject(
        loadConversations: (_) async =>
            throw AccessDeniedException(message: 'segredo'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Acesso restrito para esta conta.'), findsOneWidget);
    expect(find.byKey(const ValueKey('chat-conversation-list')), findsNothing);
    expect(find.textContaining('segredo'), findsNothing);
  });

  testWidgets('abre conversa e pagina mensagens', (tester) async {
    final offsets = <int>[];
    await tester.pumpWidget(
      subject(
        loadMessages: (_, offset) async {
          offsets.add(offset);
          return List.generate(
            chatPageSize,
            (index) => message(index + offset),
          );
        },
      ),
    );
    await openConversation(tester);
    expect(find.byKey(const ValueKey('chat-message-list')), findsOneWidget);
    await tester.tap(find.text('Mensagens anteriores'));
    await tester.pumpAndSettle();
    expect(offsets, [0, chatPageSize]);
    expect(find.text('Mensagens mais recentes'), findsOneWidget);
  });

  testWidgets('bloqueia vazio e evita envio duplicado', (tester) async {
    final pending = Completer<ChatMessageItem>();
    var calls = 0;
    String? sent;
    await tester.pumpWidget(
      subject(
        sendMessage: (_, content) {
          calls++;
          sent = content;
          return pending.future;
        },
      ),
    );
    await openConversation(tester);
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pump();
    expect(find.text('Digite uma mensagem.'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('chat-composer')),
      '  mensagem segura  ',
    );
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pump();
    expect(calls, 1);
    expect(sent, 'mensagem segura');
    expect(find.byTooltip('Enviando…'), findsOneWidget);
    final sendingButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip('Enviando…'),
        matching: find.byType(IconButton),
      ),
    );
    expect(sendingButton.onPressed, isNull);
    pending.complete(message(2, content: sent!));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('mensagem segura'), findsNothing);
  });

  testWidgets('troca de sessão remove seleção e mensagens anteriores', (
    tester,
  ) async {
    var session = 'session-a';
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: AdminChatScreen(
                sessionIdentity: session,
                loadConversations: (_) async => [
                  conversation(
                    session == 'session-a' ? 1 : 2,
                    title: session == 'session-a'
                        ? 'Conversa antiga'
                        : 'Conversa nova',
                  ),
                ],
                loadMessages: (_, _) async => [
                  message(1, content: 'Mensagem da sessão antiga'),
                ],
                sendMessage: (_, content) async => message(2, content: content),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conversa antiga'));
    await tester.pumpAndSettle();
    expect(find.text('Mensagem da sessão antiga'), findsOneWidget);
    update(() => session = 'session-b');
    await tester.pumpAndSettle();
    expect(find.text('Mensagem da sessão antiga'), findsNothing);
    expect(find.text('Conversa antiga'), findsNothing);
    expect(find.text('Conversa nova'), findsOneWidget);
  });

  testWidgets('ignora lista de conversas concluída pela sessão anterior', (
    tester,
  ) async {
    var session = 'session-a';
    final oldResponse = Completer<List<ChatConversationItem>>();
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: AdminChatScreen(
                sessionIdentity: session,
                loadConversations: (_) => session == 'session-a'
                    ? oldResponse.future
                    : Future.value([
                        conversation(2, title: 'Conversa da sessão nova'),
                      ]),
                loadMessages: (_, _) async => const [],
                sendMessage: (_, content) async => message(1, content: content),
              ),
            );
          },
        ),
      ),
    );
    await tester.pump();
    update(() => session = 'session-b');
    await tester.pumpAndSettle();
    expect(find.text('Conversa da sessão nova'), findsOneWidget);

    oldResponse.complete([conversation(1, title: 'Conversa antiga tardia')]);
    await tester.pumpAndSettle();
    expect(find.text('Conversa antiga tardia'), findsNothing);
    expect(find.text('Conversa da sessão nova'), findsOneWidget);
  });

  testWidgets('ignora mensagens tardias com mesmo id após trocar sessão', (
    tester,
  ) async {
    var session = 'session-a';
    final oldMessages = Completer<List<ChatMessageItem>>();
    var messageLoads = 0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: AdminChatScreen(
                sessionIdentity: session,
                loadConversations: (_) async => [
                  conversation(
                    1,
                    title: session == 'session-a'
                        ? 'Conversa antiga'
                        : 'Conversa nova com mesmo id',
                  ),
                ],
                loadMessages: (_, _) {
                  messageLoads++;
                  return messageLoads == 1
                      ? oldMessages.future
                      : Future.value([
                          message(2, content: 'Mensagem da sessão nova'),
                        ]);
                },
                sendMessage: (_, content) async => message(3, content: content),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conversa antiga'));
    await tester.pump();

    update(() => session = 'session-b');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conversa nova com mesmo id'));
    await tester.pumpAndSettle();
    expect(find.text('Mensagem da sessão nova'), findsOneWidget);

    oldMessages.complete([message(1, content: 'Mensagem antiga tardia')]);
    await tester.pumpAndSettle();
    expect(find.text('Mensagem antiga tardia'), findsNothing);
    expect(find.text('Mensagem da sessão nova'), findsOneWidget);
  });

  testWidgets('funciona em 390 px e desktop com texto ampliado', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: subject(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Conversa 1'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Voltar às conversas'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Voltar às conversas'), findsNothing);
    expect(
      find.byKey(const ValueKey('chat-conversation-list')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('chat-message-list')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
