import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/content_screen.dart';
import 'package:signcob_flutter/screens/admin_dashboard_screen.dart';

void main() {
  final now = DateTime.utc(2026);
  testWidgets('troca entre blog e parceiros recria dados da seção', (
    tester,
  ) async {
    final article = PublicArticle(
      title: 'Artigo da seção',
      summary: 'Resumo',
      body: 'Texto',
      published: true,
      createdAt: now,
      updatedAt: now,
    );
    final partner = PublicPartner(
      name: 'Parceiro da seção',
      description: 'Descrição',
      website: 'https://example.com',
      active: true,
      createdAt: now,
      updatedAt: now,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboardScreen(
          contacts: const SizedBox(),
          users: const SizedBox(),
          onSignOut: () async {},
          articles: ContentScreen(
            key: const ValueKey('admin-blog'),
            partners: false,
            loadArticles: (_) async => [article],
            loadPartners: (_) async => [],
          ),
          partners: ContentScreen(
            key: const ValueKey('admin-partners'),
            partners: true,
            loadArticles: (_) async => [],
            loadPartners: (_) async => [partner],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Blog'));
    await tester.pumpAndSettle();
    expect(find.text('Artigo da seção'), findsOneWidget);
    await tester.tap(find.text('Parceiros').first);
    await tester.pumpAndSettle();
    expect(find.text('Parceiro da seção'), findsOneWidget);
    expect(find.text('Artigo da seção'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('conteúdo público abre texto e link sem interpretar HTML', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ContentScreen(
          partners: false,
          loadArticles: (_) async => [
            PublicArticle(
              title: 'Artigo',
              summary: 'Resumo',
              body: '<b>Texto simples</b>',
              published: true,
              createdAt: now,
              updatedAt: now,
            ),
          ],
          loadPartners: (_) async => [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Artigo'));
    await tester.pumpAndSettle();
    expect(find.text('<b>Texto simples</b>'), findsOneWidget);
  });
  testWidgets(
    'cadastro de parceiro valida e persiste após formulário completo',
    (tester) async {
      var saved = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ContentScreen(
            partners: true,
            loadArticles: (_) async => [],
            loadPartners: (_) async => [],
            savePartner: (id, name, description, url, active) async {
              saved = true;
              return PublicPartner(
                name: name,
                description: description,
                website: url,
                active: active,
                createdAt: now,
                updatedAt: now,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Novo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(saved, isFalse);
      expect(find.text('Preencha este campo.'), findsWidgets);
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Parceiro');
      await tester.enterText(fields.at(1), 'Descrição');
      await tester.enterText(fields.at(2), 'https://example.com');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(saved, isTrue);
    },
  );
  testWidgets('falha de carregamento permite nova tentativa', (tester) async {
    var attempt = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ContentScreen(
          partners: false,
          loadArticles: (_) async {
            if (++attempt == 1) throw Exception();
            return [];
          },
          loadPartners: (_) async => [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum conteúdo disponível.'), findsOneWidget);
  });
}
