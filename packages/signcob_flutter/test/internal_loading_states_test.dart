import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_cases_screen.dart';
import 'package:signcob_flutter/screens/admin_clients_screen.dart';
import 'package:signcob_flutter/screens/admin_contacts_screen.dart';
import 'package:signcob_flutter/screens/admin_negotiations_screen.dart';
import 'package:signcob_flutter/screens/admin_users_screen.dart';
import 'package:signcob_flutter/screens/content_screen.dart';
import 'package:signcob_flutter/theme/signcob_theme.dart';

void main() {
  final pages = <String, Widget Function(Future<void> Function())>{
    'contatos': (load) => AdminContactsScreen(
      loadContacts: (_) async {
        await load();
        return [];
      },
      onSignOut: () async {},
    ),
    'clientes': (load) => AdminClientsScreen(
      loadClients: (_) async {
        await load();
        return [];
      },
      saveClient: (_, _, _, _, _) async => throw StateError('Não deve gravar'),
    ),
    'processos': (load) => AdminCasesScreen(
      loadCases: (_) async {
        await load();
        return [];
      },
      importCase: (_, _, _) async => throw StateError('Não deve importar'),
      syncCase: (_) async => throw StateError('Não deve consultar'),
    ),
    'usuários': (load) => AdminUsersScreen(
      loadUsers: (_) async {
        await load();
        return [];
      },
      savePermissions: (_, _) async =>
          throw StateError('Não deve alterar permissão'),
    ),
    for (final kind in ['debt', 'fees'])
      kind: (load) => AdminNegotiationsScreen(
        kind: kind,
        loadNegotiations: (_, _) async {
          await load();
          return [];
        },
        createNegotiation: (_, _, _, _) async =>
            throw StateError('Não deve gravar'),
        changeNegotiation: (_, _, _) async =>
            throw StateError('Não deve mudar'),
        loadHistory: (_) async => [],
      ),
    for (final partner in [false, true])
      partner ? 'parceiros' : 'blog': (load) => ContentScreen(
        partners: partner,
        loadArticles: (_) async {
          await load();
          return [];
        },
        loadPartners: (_) async {
          await load();
          return [];
        },
      ),
  };
  for (final page in pages.entries) {
    for (final denied in [false, true]) {
      testWidgets(
        '${page.key}: carregando, ${denied ? 'negado' : 'erro'}, nova tentativa e vazio',
        (tester) async {
          final pending = <Completer<void>>[];
          await tester.pumpWidget(
            MaterialApp(
              theme: SignCobTheme.dark,
              home: page.value(() {
                final request = Completer<void>();
                pending.add(request);
                return request.future;
              }),
            ),
          );
          await tester.pump();
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(pending, hasLength(1));
          pending.first.completeError(
            denied
                ? AccessDeniedException(message: 'Negação fictícia')
                : StateError('Rede fictícia indisponível'),
          );
          await tester.pumpAndSettle();
          expect(find.byType(CircularProgressIndicator), findsNothing);
          if (denied) {
            expect(find.textContaining('Acesso restrito'), findsOneWidget);
          }
          expect(find.text('Tentar novamente'), findsOneWidget);
          await tester.ensureVisible(find.text('Tentar novamente'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Tentar novamente'));
          await tester.pump();
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(pending, hasLength(2));
          pending.last.complete();
          await tester.pumpAndSettle();
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.textContaining('Nenhum'), findsOneWidget);
          expect(find.text('Tentar novamente'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
