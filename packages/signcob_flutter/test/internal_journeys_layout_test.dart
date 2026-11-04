import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_clients_screen.dart';
import 'package:signcob_flutter/screens/admin_dashboard_screen.dart';
import 'package:signcob_flutter/screens/admin_negotiations_screen.dart';
import 'package:signcob_flutter/screens/content_screen.dart';
import 'package:signcob_flutter/theme/signcob_theme.dart';

void main() {
  final now = DateTime.utc(2026, 11, 3);
  final client = LegalClient(
    id: 1,
    name: 'Cliente fictício',
    createdAt: now,
    updatedAt: now,
  );
  final negotiation = Negotiation(
    id: 1,
    legalClientId: 1,
    kind: 'debt',
    title: 'Negociação fictícia',
    amountCents: 12345,
    status: 'draft',
    createdAt: now,
    updatedAt: now,
  );
  Widget clients() => AdminClientsScreen(
    loadClients: (_) async => [client],
    saveClient: (_, _, _, _, _) async => client,
    assignLawyer: (_, _) async {},
    bindOwner: (_, _) async {},
  );
  Widget negotiations() => AdminNegotiationsScreen(
    kind: 'debt',
    loadNegotiations: (_, _) async => [negotiation],
    createNegotiation: (_, _, _, _) async => negotiation,
    changeNegotiation: (_, _, _) async => negotiation,
    loadHistory: (_) async => [],
  );
  Widget content(bool partner) => ContentScreen(
    partners: partner,
    loadArticles: (_) async => [],
    loadPartners: (_) async => [],
    saveArticle: (_, title, summary, body, url, published) async =>
        PublicArticle(
          title: title,
          summary: summary,
          body: body,
          externalUrl: url,
          published: published,
          createdAt: now,
          updatedAt: now,
        ),
    savePartner: (_, name, description, website, active) async => PublicPartner(
      name: name,
      description: description,
      website: website,
      active: active,
      createdAt: now,
      updatedAt: now,
    ),
  );

  testWidgets('aviso ao salvar cliente não cobre a ação de nova negociação', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: SignCobTheme.dark,
        home: AdminDashboardScreen(
          contacts: const SizedBox.shrink(),
          users: const SizedBox.shrink(),
          clients: clients(),
          debts: negotiations(),
          onSignOut: () async {},
        ),
      ),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clientes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Novo cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, client.name);
    await tester.tap(find.text('Salvar cliente'));
    await tester.pumpAndSettle();
    expect(find.text('Cliente salvo.'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Dívidas dos clientes'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cliente salvo.'), findsNothing);
    final create = find.byType(FloatingActionButton);
    expect(
      create.hitTestable(),
      findsOneWidget,
      reason: '${tester.getRect(create)}',
    );
    await tester.tap(create);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  for (final width in [320.0, 390.0, 768.0, 1440.0]) {
    testWidgets('jornadas internas ${width.toInt()} px texto 2', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Future<void> open(Widget page) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: SignCobTheme.dark,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(2)),
              child: child!,
            ),
            home: page,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      Future<void> close() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }

      await open(clients());
      await tester.tap(find.byTooltip('Atribuir advogado'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'atribuição');
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(
        width < 600
            ? find.byTooltip('Novo cliente')
            : find.text('Novo cliente'),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'formulário cliente');
      await close();

      for (final partner in [false, true]) {
        await open(content(partner));
        await tester.tap(find.text('Novo'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'editor conteúdo');
        await close();
      }

      await open(negotiations());
      final createButton = tester.getRect(find.byType(FloatingActionButton));
      expect(
        createButton.left,
        greaterThanOrEqualTo(0),
        reason: 'ação criar cabe na tela',
      );
      expect(createButton.right, lessThanOrEqualTo(width));
      await tester.tap(
        width < 600
            ? find.byTooltip('Nova negociação')
            : find.text('Nova negociação'),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'criar negociação');
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Proposta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Proposta'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'transição');
      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'histórico');
      await close();

      await open(
        AdminDashboardScreen(
          contacts: clients(),
          users: const SizedBox(),
          debts: negotiations(),
          onSignOut: () async {},
        ),
      );
      if (width < 600) {
        await tester.tap(find.byType(DropdownButtonFormField<int>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Dívidas dos clientes').last);
      } else {
        await tester.tap(find.text('Dívidas dos clientes'));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'negociações no painel');
    });
  }
}
