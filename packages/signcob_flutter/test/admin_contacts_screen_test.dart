import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_contacts_screen.dart';

ContactMessage contact(int id) => ContactMessage(
  id: id,
  name: 'Pessoa $id',
  email: 'pessoa$id@example.com',
  message: 'Mensagem $id',
  createdAt: DateTime.utc(2026, 11, 3),
);

void main() {
  testWidgets('permissão revogada não mostra contatos', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminContactsScreen(
          loadContacts: (_) async =>
              throw AccessDeniedException(message: 'revogada'),
          onSignOut: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Acesso restrito'), findsOneWidget);
    expect(find.textContaining('Pessoa 0'), findsNothing);
  });
  testWidgets(
    'loading, lista e paginação usam offsets e removem dados antigos',
    (tester) async {
      final first = Completer<List<ContactMessage>>();
      final offsets = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          home: AdminContactsScreen(
            loadContacts: (offset) {
              offsets.add(offset);
              return offset == 0 ? first.future : Future.value([]);
            },
            onSignOut: () async {},
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      first.complete(List.generate(25, contact));
      await tester.pumpAndSettle();
      expect(find.text('Pessoa 0'), findsOneWidget);
      await tester.tap(find.text('Próxima'));
      await tester.pumpAndSettle();
      expect(offsets, [0, 25]);
      expect(find.text('Pessoa 0'), findsNothing);
      expect(find.text('Nenhum contato nesta página.'), findsOneWidget);
      await tester.tap(find.text('Anterior'));
      await tester.pumpAndSettle();
      expect(offsets, [0, 25, 0]);
    },
  );

  testWidgets('acesso negado não expõe dados e permite nova tentativa', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminContactsScreen(
          loadContacts: (_) async {
            attempts++;
            if (attempts == 1) {
              throw const ServerpodClientException('Forbidden', 403);
            }
            return [];
          },
          onSignOut: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Sua conta precisa de autorização'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum contato nesta página.'), findsOneWidget);
  });

  testWidgets('sair limpa contatos antes de completar callback', (
    tester,
  ) async {
    final signOut = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: AdminContactsScreen(
          loadContacts: (_) async => [contact(1)],
          onSignOut: () => signOut.future,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pessoa 1'), findsOneWidget);
    await tester.tap(find.text('Sair'));
    await tester.pump();
    expect(find.text('Pessoa 1'), findsNothing);
    signOut.complete();
    await tester.pump();
  });
}
