import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_chat_screen.dart';
import 'package:signcob_flutter/screens/chat_provisioning_panel.dart';

const _client = ChatClientChoice(id: 7, label: 'Cliente permitido');
const _participant = ChatParticipantOption(
  reference: 'referencia-opaca',
  label: 'Participante permitido',
);
const _creation = ChatCreationOptions(clients: [_client], titleMaxLength: 20);
const _empty = ChatParticipantRoster(active: [], eligible: []);

final _clientField = find.byKey(const ValueKey('chat-provision-client'));
final _titleField = find.byKey(const ValueKey('chat-provision-title'));
final _participantField = find.byKey(
  const ValueKey('chat-provision-participant'),
);
final _create = find.widgetWithText(FilledButton, 'Criar conversa');
final _add = find.widgetWithText(FilledButton, 'Incluir participante');

class _Provisioning implements ChatProvisioning {
  Future<ChatCreationOptions> Function() creation = () async => _creation;
  Future<ChatParticipantRoster> Function(int) roster = (_) async => _empty;
  Future<void> Function() onCreate = () async {};
  Future<void> Function() onAdd = () async {};
  Future<void> Function() onRemove = () async {};
  final created = <(int, String)>[];
  final added = <(int, String)>[];
  final removed = <(int, String)>[];

  @override
  Future<ChatCreationOptions> loadCreationOptions() => creation();

  @override
  Future<void> createConversation({
    required int clientId,
    required String title,
  }) {
    created.add((clientId, title));
    return onCreate();
  }

  @override
  Future<ChatParticipantRoster> loadParticipants(int conversationId) =>
      roster(conversationId);

  @override
  Future<void> addParticipant(int conversationId, String reference) {
    added.add((conversationId, reference));
    return onAdd();
  }

  @override
  Future<void> removeParticipant(int conversationId, String reference) {
    removed.add((conversationId, reference));
    return onRemove();
  }
}

Widget _subject(
  ChatProvisioning? provisioning, {
  Object session = 'a',
  LoadChatConversations? conversations,
  double textScale = 1,
}) => MaterialApp(
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    body: AdminChatScreen(
      sessionIdentity: session,
      provisioning: provisioning,
      loadConversations:
          conversations ??
          (_) async => [
            ChatConversationItem(
              id: 1,
              title: 'Conversa autorizada',
              updatedAt: DateTime.utc(2026),
            ),
          ],
      loadMessages: (_, _) async => [],
      sendMessage: (_, _) async => throw StateError('Envio inesperado'),
    ),
  ),
);

Future<void> _tapText(WidgetTester tester, String label) async {
  final target = find.text(label);
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _choose(WidgetTester tester, Finder field, String label) async {
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _openRoster(WidgetTester tester) async {
  await _tapText(tester, 'Conversa autorizada');
  await _tapText(tester, 'Gerenciar participantes');
}

Future<void> _fillCreation(WidgetTester tester, String title) async {
  await _tapText(tester, 'Nova conversa');
  await _choose(tester, _clientField, _client.label);
  await tester.enterText(_titleField, title);
}

void main() {
  testWidgets('sem adaptador, o chat existente não oferece provisionamento', (
    tester,
  ) async {
    await tester.pumpWidget(_subject(null));
    await tester.pumpAndSettle();
    expect(find.text('Nova conversa'), findsNothing);
    await _tapText(tester, 'Conversa autorizada');
    expect(find.text('Gerenciar participantes'), findsNothing);
  });

  testWidgets(
    'carrega, omite detalhe da falha e permite tentar ler novamente',
    (
      tester,
    ) async {
      final pending = Completer<ChatCreationOptions>();
      var loads = 0;
      final api = _Provisioning()
        ..creation = () => ++loads == 1
            ? pending.future
            : Future.value(
                const ChatCreationOptions(clients: [], titleMaxLength: 20),
              );
      await tester.pumpWidget(_subject(api, conversations: (_) async => []));
      await tester.pumpAndSettle();
      expect(find.text('Nenhuma conversa disponível.'), findsOneWidget);
      await tester.tap(find.text('Nova conversa'));
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      pending.completeError(StateError('detalhe privado'));
      await tester.pumpAndSettle();
      expect(find.textContaining('detalhe privado'), findsNothing);
      expect(
        find.text('Não foi possível carregar os dados. Tente novamente.'),
        findsOneWidget,
      );
      await _tapText(tester, 'Tentar novamente');
      expect(loads, 2);
      expect(
        find.text('Nenhum cliente disponível para criar uma conversa.'),
        findsOneWidget,
      );
      expect(_create, findsNothing);
    },
  );

  testWidgets('valida título e cliente, cria uma vez e relê a lista do chat', (
    tester,
  ) async {
    final pending = Completer<void>();
    final api = _Provisioning()..onCreate = () => pending.future;
    final offsets = <int>[];
    await tester.pumpWidget(
      _subject(
        api,
        conversations: (offset) async {
          offsets.add(offset);
          return api.created.isEmpty
              ? []
              : [
                  ChatConversationItem(
                    id: 1,
                    title: 'Novo caso',
                    updatedAt: DateTime.utc(2026),
                  ),
                ];
        },
      ),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Nova conversa');
    await _tapText(tester, 'Criar conversa');
    expect(find.text('Selecione um cliente.'), findsOneWidget);
    expect(find.text('Digite um título.'), findsOneWidget);
    await _choose(tester, _clientField, _client.label);
    await tester.enterText(_titleField, '123456789012345678901');
    await _tapText(tester, 'Criar conversa');
    expect(find.text('Use até 20 caracteres.'), findsOneWidget);
    expect(api.created, isEmpty);

    await tester.enterText(_titleField, '  Novo caso  ');
    await tester.tap(_create);
    await tester.tap(_create);
    await tester.pump();
    expect(api.created, [(7, 'Novo caso')]);
    expect(tester.widget<FilledButton>(_create).onPressed, isNull);
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('Conversa criada.'), findsOneWidget);
    expect(_create, findsNothing);
    await _tapText(tester, 'Voltar ao chat');
    expect(find.text('Novo caso'), findsOneWidget);
    expect(offsets, [0, 0]);
  });

  testWidgets('não repete criação com resultado incerto', (tester) async {
    final api = _Provisioning()
      ..onCreate = () async => throw StateError('resposta perdida');
    await tester.pumpWidget(_subject(api));
    await tester.pumpAndSettle();
    await _fillCreation(tester, 'Novo caso');
    await _tapText(tester, 'Criar conversa');
    expect(
      find.textContaining('Não foi possível confirmar a criação'),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(_create).onPressed, isNull);
    expect(api.created, [(7, 'Novo caso')]);
    await _tapText(tester, 'Voltar ao chat');
    expect(find.text('Conversa autorizada'), findsOneWidget);
  });

  testWidgets(
    'inclui e remove alvos da lista autorizada, relendo após cada ação',
    (
      tester,
    ) async {
      final pending = Completer<void>();
      final requests = <int>[];
      var active = false;
      final api = _Provisioning()
        ..roster = (id) async {
          requests.add(id);
          return ChatParticipantRoster(
            active: active ? [_participant] : [],
            eligible: [_participant],
          );
        }
        ..onAdd = () async {
          await pending.future;
          active = true;
        }
        ..onRemove = () async => active = false;
      await tester.pumpWidget(_subject(api));
      await tester.pumpAndSettle();
      await _openRoster(tester);
      expect(find.text('Nenhum participante ativo.'), findsOneWidget);
      expect(tester.widget<FilledButton>(_add).onPressed, isNull);
      await _choose(tester, _participantField, _participant.label);
      await tester.tap(_add);
      await tester.tap(_add);
      await tester.pump();
      expect(tester.widget<FilledButton>(_add).onPressed, isNull);
      expect(api.added, [(1, _participant.reference)]);
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Participante incluído.'), findsOneWidget);
      expect(_add, findsNothing);
      final remove = find.byTooltip('Remover ${_participant.label}');
      await tester.tap(remove);
      await tester.tap(remove);
      await tester.pumpAndSettle();
      expect(api.removed, [(1, _participant.reference)]);
      expect(requests, [1, 1, 1]);
      expect(find.text('Participante removido.'), findsOneWidget);
      expect(find.text('Nenhum participante ativo.'), findsOneWidget);
    },
  );

  testWidgets('nega criação sem mostrar detalhes do servidor', (tester) async {
    final api = _Provisioning()
      ..onCreate = () async =>
          throw AccessDeniedException(message: 'detalhe privado');
    await tester.pumpWidget(_subject(api));
    await tester.pumpAndSettle();
    await _fillCreation(tester, 'Rascunho');
    await _tapText(tester, 'Criar conversa');
    expect(find.text('Acesso restrito para esta conta.'), findsOneWidget);
    expect(find.textContaining('detalhe privado'), findsNothing);
    expect(find.text('Rascunho'), findsNothing);
    expect(_create, findsNothing);
  });

  testWidgets('falha de inclusão reconsulta os dados sem repetir a escrita', (
    tester,
  ) async {
    var reads = 0;
    final api = _Provisioning()
      ..roster = (_) async {
        switch (++reads) {
          case 1:
            return const ChatParticipantRoster(
              active: [],
              eligible: [_participant],
            );
          case 2:
            throw StateError('leitura indisponível');
          default:
            return const ChatParticipantRoster(
              active: [_participant],
              eligible: [],
            );
        }
      }
      ..onAdd = () async => throw StateError('resposta perdida');
    await tester.pumpWidget(_subject(api));
    await tester.pumpAndSettle();
    await _openRoster(tester);
    await _choose(tester, _participantField, _participant.label);
    await tester.tap(_add);
    await tester.tap(_add);
    await tester.pumpAndSettle();
    expect(_add, findsNothing);
    expect(find.text(_participant.label), findsNothing);
    await _tapText(tester, 'Tentar novamente');
    expect(reads, 3);
    expect(api.added, [(1, _participant.reference)]);
    expect(find.byTooltip('Remover ${_participant.label}'), findsOneWidget);
  });

  testWidgets(
    'revogação durante remoção limpa a lista e bloqueia novas ações',
    (
      tester,
    ) async {
      final api = _Provisioning()
        ..roster = (_) async {
          return const ChatParticipantRoster(
            active: [_participant],
            eligible: [],
          );
        }
        ..onRemove = () async =>
            throw AccessDeniedException(message: 'detalhe privado');
      await tester.pumpWidget(_subject(api));
      await tester.pumpAndSettle();
      await _openRoster(tester);
      await tester.tap(find.byTooltip('Remover ${_participant.label}'));
      await tester.pumpAndSettle();
      expect(find.text('Acesso restrito para esta conta.'), findsOneWidget);
      expect(find.text(_participant.label), findsNothing);
      expect(find.textContaining('detalhe privado'), findsNothing);
      expect(find.byIcon(Icons.person_remove_outlined), findsNothing);
    },
  );

  testWidgets('troca de sessão limpa rascunho e ignora criação tardia', (
    tester,
  ) async {
    final pending = Completer<void>();
    final api = _Provisioning()..onCreate = () => pending.future;
    await tester.pumpWidget(_subject(api));
    await tester.pumpAndSettle();
    await _fillCreation(tester, 'Rascunho privado');
    await tester.tap(_create);
    await tester.pump();
    await tester.pumpWidget(_subject(api, session: 'b'));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Nova conversa');
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('Conversa criada.'), findsNothing);
    expect(find.text('Rascunho privado'), findsNothing);
    expect(find.text(_client.label), findsNothing);
    expect(tester.widget<FilledButton>(_create).onPressed, isNotNull);
  });

  testWidgets('ignora participantes tardios da sessão anterior no mesmo chat', (
    tester,
  ) async {
    final pending = Completer<ChatParticipantRoster>();
    var requests = 0;
    final api = _Provisioning()
      ..roster = (_) => ++requests == 1 ? pending.future : Future.value(_empty);
    await tester.pumpWidget(_subject(api));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Conversa autorizada');
    await tester.tap(find.text('Gerenciar participantes'));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pumpWidget(_subject(api, session: 'b'));
    await tester.pumpAndSettle();
    await _openRoster(tester);
    pending.complete(
      const ChatParticipantRoster(active: [_participant], eligible: []),
    );
    await tester.pumpAndSettle();
    expect(find.text(_participant.label), findsNothing);
    expect(find.text('Nenhum participante ativo.'), findsOneWidget);
  });

  for (final width in [390.0, 1200.0]) {
    testWidgets(
      'formulários funcionam a ${width.toInt()} px com texto em 200%',
      (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final api = _Provisioning()
          ..roster = (_) async =>
              const ChatParticipantRoster(active: [], eligible: [_participant]);
        await tester.pumpWidget(_subject(api, textScale: 2));
        await tester.pumpAndSettle();
        await _fillCreation(tester, 'Caso novo');
        await _tapText(tester, 'Criar conversa');
        expect(find.text('Conversa criada.'), findsOneWidget);
        await _tapText(tester, 'Voltar ao chat');
        await _openRoster(tester);
        await _choose(tester, _participantField, _participant.label);
        await _tapText(tester, 'Incluir participante');
        expect(find.text('Participante incluído.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
