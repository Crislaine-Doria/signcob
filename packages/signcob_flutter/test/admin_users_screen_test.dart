import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_users_screen.dart';
import 'package:signcob_flutter/screens/admin_dashboard_screen.dart';

void main() {
  testWidgets('perfil sócio seleciona acessos sem salvar automaticamente', (
    tester,
  ) async {
    List<String>? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminUsersScreen(
          loadUsers: (_) async => [
            ManagedUser(userId: 'user-1', permissions: []),
          ],
          savePermissions: (_, permissions) async => saved = permissions,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar perfil de sócio'));
    await tester.pump();
    expect(saved, isNull);
    await tester.ensureVisible(find.text('Salvar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(
      saved,
      containsAll([
        'contacts.read',
        'users.manage',
        'clients.read',
        'clients.write',
        'cases.read',
        'cases.write',
        'content.write',
        'negotiations.read',
        'negotiations.write',
      ]),
    );
  });
  testWidgets('permissão revogada mostra acesso restrito', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminUsersScreen(
          loadUsers: (_) async =>
              throw AccessDeniedException(message: 'revogada'),
          savePermissions: (_, _) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Acesso restrito'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });
  testWidgets('altera capacidade e salva somente escolha atual', (
    tester,
  ) async {
    List<String>? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminUsersScreen(
          loadUsers: (_) async => [
            ManagedUser(
              userId: 'user-1',
              email: 'ana@example.com',
              permissions: ['contacts.read'],
            ),
          ],
          savePermissions: (id, permissions) async {
            expect(id, 'user-1');
            saved = permissions;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gerenciar acessos'));
    await tester.ensureVisible(find.text('Salvar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(saved, containsAll(['contacts.read', 'users.manage']));
    expect(find.textContaining('Permissões salvas'), findsOneWidget);
  });
  testWidgets('erro de permissão não mostra contas e permite nova tentativa', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminUsersScreen(
          loadUsers: (_) async =>
              throw ServerpodClientException('Forbidden', 403),
          savePermissions: (_, _) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Acesso restrito'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });
  testWidgets('dashboard remove conteúdo protegido antes de aguardar saída', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboardScreen(
          contacts: const Text('Dados privados'),
          users: const Text('Contas'),
          onSignOut: () async {},
        ),
      ),
    );
    await tester.tap(find.text('Contatos'));
    await tester.pump();
    expect(find.text('Dados privados'), findsOneWidget);
    await tester.tap(find.text('Sair'));
    await tester.pump();
    expect(find.text('Dados privados'), findsNothing);
  });
}
