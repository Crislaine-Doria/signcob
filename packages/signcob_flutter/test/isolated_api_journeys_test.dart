import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/main.dart' as app;

import 'support/isolated_e2e_fixture.dart';

// Only the disposable runner may supply this manifest. No development account,
// development database, mail provider or external DataJud transport is used.
const _enabled = bool.fromEnvironment('SIGNCOB_ISOLATED_E2E');
const _contact = 'Contato sintético da jornada Flutter';
const _clientName = 'Cliente sintético da jornada Flutter';
const _updatedName = 'Cliente sintético editado pela jornada Flutter';
const _caseNumber = '10000000000000000001';

class _MemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? value;
  @override
  Future<AuthSuccess?> get() async => value;
  @override
  Future<void> set(AuthSuccess? value) async => this.value = value;
}

Future<void> _until(
  WidgetTester tester,
  bool Function() ready,
  String state,
) async {
  for (var i = 0; i < 150; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (ready()) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
  }
  fail('A jornada isolada não atingiu: $state.');
}

Future<T> _http<T>(WidgetTester tester, Future<T> Function() request) async {
  // Reused sockets can have callbacks waiting on the widget test's clock.
  // Pump it while waiting, as we do for requests initiated by the widgets.
  late T result;
  Object? error;
  StackTrace? stackTrace;
  var completed = false;
  unawaited(
    request().then<void>(
      (value) {
        result = value;
        completed = true;
      },
      onError: (Object failure, StackTrace trace) {
        error = failure;
        stackTrace = trace;
        completed = true;
      },
    ),
  );
  await _until(tester, () => completed, 'resposta HTTP');
  if (error != null) Error.throwWithStackTrace(error!, stackTrace!);
  return result;
}

Future<Object?> _requestError(Future<void> request) async {
  try {
    await request;
    return null;
  } catch (error) {
    return error;
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pump();
  final target = finder.hitTestable();
  expect(target, findsOneWidget);
  await tester.tap(target);
  await tester.pump();
}

Finder _cardContent(String title, Finder matching) => find.descendant(
  of: find.ancestor(of: find.text(title), matching: find.byType(Card)),
  matching: matching,
);

Future<void> _section(WidgetTester tester, String label) async {
  await _tap(tester, find.widgetWithText(OutlinedButton, label).first);
  await _until(
    tester,
    () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
    'área $label',
  );
  await tester.pumpAndSettle();
  expect(find.textContaining('Acesso restrito'), findsNothing);
  expect(find.textContaining('Não foi possível'), findsNothing);
  expect(tester.takeException(), isNull);
}

Future<void> _saveDialog(WidgetTester tester, String expected) async {
  await _tap(tester, find.widgetWithText(FilledButton, 'Salvar').last);
  await _until(
    tester,
    () =>
        find.byType(AlertDialog).evaluate().isEmpty &&
        find.text(expected).evaluate().isNotEmpty,
    'salvar $expected',
  );
}

void main() {
  testWidgets('UI → HTTP → SQL isolado: escritas, sessão e logout', (
    tester,
  ) async {
    final fixture = loadIsolatedE2eFixture();
    final users = fixture['users'] as Map<String, dynamic>;
    final manager = users['manager'] as Map<String, dynamic>;
    final previousOverrides = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = previousOverrides);
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final storage = _MemoryAuthStorage();
    final apiUrl = fixture['apiUrl'] as String;
    app.client = Client(apiUrl)
      ..authSessionManager = FlutterAuthSessionManager(storage: storage);
    try {
      await app.client.auth.initialize();
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      // Public contact validates first, then really persists through HTTP.
      await _tap(tester, find.text('Contato').first);
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(find.text('Informe seu nome.'), findsOneWidget);
      var fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), _contact);
      await tester.enterText(fields.at(1), 'flutter-e2e@example.invalid');
      await tester.enterText(
        fields.at(2),
        'Mensagem sintética sem dados de pessoas reais.',
      );
      await _tap(tester, find.text('Enviar mensagem'));
      await _until(
        tester,
        () => find.text('Mensagem enviada com sucesso!').evaluate().isNotEmpty,
        'contato enviado',
      );
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Login, JWT/session storage and protected administrative read are real.
      await _tap(tester, find.text('Área administrativa').first);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('auth-email')),
        manager['email'] as String,
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password')),
        manager['password'] as String,
      );
      await _tap(tester, find.widgetWithText(FilledButton, 'Entrar'));
      await _until(
        tester,
        () => find.text('Área interna').evaluate().isNotEmpty,
        'login com identidade descartável',
      );
      expect(app.client.auth.isAuthenticated, isTrue);
      expect(storage.value, isNotNull);
      await _section(tester, 'Contatos');
      expect(find.text(_contact), findsOneWidget);
      await _http(tester, () async {
        final rows = await app.client.contactAdmin.list(0);
        expectSync(rows.where((row) => row.name == _contact).length, 1);
      });

      // Create, edit, lawyer assignment and owner binding use the real screens.
      await _section(tester, 'Clientes');
      await _tap(tester, find.text('Novo cliente'));
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Salvar cliente'));
      await tester.pumpAndSettle();
      expect(find.text('Informe o nome.'), findsOneWidget);
      fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), _clientName);
      await tester.enterText(fields.at(1), 'client-flutter@example.invalid');
      await tester.enterText(fields.at(2), '0000000000');
      await tester.enterText(fields.at(3), 'SINTETICO-UI');
      await _tap(tester, find.text('Salvar cliente'));
      final editClient = _cardContent(
        _clientName,
        find.byTooltip('Editar cliente'),
      );
      await _until(
        tester,
        () => editClient.evaluate().isNotEmpty,
        'cliente cadastrado',
      );
      await _tap(tester, editClient);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), _updatedName);
      await _tap(tester, find.text('Salvar cliente'));
      await _until(
        tester,
        () => _cardContent(
          _updatedName,
          find.byTooltip('Editar cliente'),
        ).evaluate().isNotEmpty,
        'cliente editado',
      );
      var clientId = 0;
      await _http(tester, () async {
        final saved = (await app.client.legalClient.list(
          0,
        )).singleWhere((row) => row.name == _updatedName);
        clientId = saved.id!;
        expectSync(saved.email, 'client-flutter@example.invalid');
        expectSync(saved.document, 'SINTETICO-UI');
      });
      for (final binding in [
        ('Atribuir advogado', 'lawyerA'),
        ('Vincular conta do cliente', 'owner'),
      ]) {
        final action = _cardContent(
          _updatedName,
          find.byWidgetPredicate(
            (widget) =>
                widget is IconButton &&
                widget.tooltip == binding.$1 &&
                widget.onPressed != null,
            description: 'ação habilitada: ${binding.$1}',
          ),
        );
        await _tap(tester, action);
        await tester.pumpAndSettle();
        final dialog = find.widgetWithText(AlertDialog, binding.$1);
        expect(dialog, findsOneWidget);
        await tester.enterText(
          find.descendant(of: dialog, matching: find.byType(TextField)),
          (users[binding.$2] as Map)['userId'] as String,
        );
        await _tap(tester, find.text('Confirmar'));
        await _until(
          tester,
          () =>
              find.byType(AlertDialog).evaluate().isEmpty &&
              action.evaluate().isNotEmpty,
          binding.$1,
        );
      }
      await _http(tester, () async {
        final saved = (await app.client.legalClient.list(
          0,
        )).singleWhere((row) => row.id == clientId);
        expectSync(saved.assignedLawyerId, (users['lawyerA'] as Map)['userId']);
        expectSync(saved.ownerAuthUserId, (users['owner'] as Map)['userId']);
      });

      // Separate debt/fees, exact cents and auditable state transitions.
      for (final flow in [
        ('Dívidas dos clientes', 'debt'),
        ('Honorários e serviços', 'fees'),
      ]) {
        final title = 'Negociação sintética UI ${flow.$2}';
        await _section(tester, flow.$1);
        await _tap(tester, find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await _tap(tester, find.widgetWithText(FilledButton, 'Salvar'));
        await tester.pumpAndSettle();
        expect(find.text('Informe um ID válido.'), findsOneWidget);
        expect(find.text('Informe um valor válido.'), findsOneWidget);
        fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '$clientId');
        await tester.enterText(fields.at(1), title);
        await tester.enterText(fields.at(2), '1234,56');
        await _saveDialog(tester, title);
        for (final status in ['Proposta', 'Aceita']) {
          await _tap(
            tester,
            _cardContent(title, find.widgetWithText(TextButton, status)),
          );
          await tester.pumpAndSettle();
          await tester.enterText(
            find.byType(TextField).last,
            'Registro sintético: $status',
          );
          await _tap(tester, find.widgetWithText(FilledButton, 'Confirmar'));
          await _until(
            tester,
            () =>
                find.byType(AlertDialog).evaluate().isEmpty &&
                _cardContent(
                  title,
                  find.textContaining('• $status'),
                ).evaluate().isNotEmpty,
            'negociação $status',
          );
        }
        await _tap(
          tester,
          _cardContent(title, find.widgetWithText(TextButton, 'Histórico')),
        );
        await _until(
          tester,
          () => find
              .textContaining('Registro sintético: Aceita')
              .evaluate()
              .isNotEmpty,
          'histórico persistido',
        );
        for (final status in ['Rascunho', 'Proposta', 'Aceita']) {
          expect(
            find.descendant(
              of: find.byType(AlertDialog),
              matching: find.text(status),
            ),
            findsOneWidget,
          );
        }
        await _tap(tester, find.text('Fechar'));
        await tester.pumpAndSettle();
        await _http(tester, () async {
          final row = (await app.client.negotiation.list(
            0,
            flow.$2,
          )).singleWhere((row) => row.title == title);
          expectSync(row.amountCents, 123456);
          expectSync(row.status, 'accepted');
          expectSync(row.kind, flow.$2);
          expectSync(
            (await app.client.negotiation.history(
              row.id!,
            )).map((event) => event.toStatus),
            ['draft', 'proposed', 'accepted'],
          );
          final other = flow.$2 == 'debt' ? 'fees' : 'debt';
          expectSync(
            (await app.client.negotiation.list(
              0,
              other,
            )).where((item) => item.id == row.id),
            isEmpty,
          );
        });
      }

      // Draft/hidden → published/active → hidden, with anonymous HTTP reads.
      final publicClient = Client(apiUrl);
      try {
        for (final partner in [false, true]) {
          final title = partner
              ? 'Parceiro sintético UI'
              : 'Artigo sintético UI';
          await _section(tester, partner ? 'Parceiros' : 'Blog');
          await _tap(tester, find.text('Novo'));
          await tester.pumpAndSettle();
          await _tap(tester, find.widgetWithText(FilledButton, 'Salvar'));
          await tester.pumpAndSettle();
          expect(find.text('Preencha este campo.'), findsWidgets);
          fields = find.byType(TextFormField);
          await tester.enterText(fields.at(0), title);
          await tester.enterText(fields.at(1), 'Descrição sintética de teste.');
          await tester.enterText(
            fields.at(2),
            partner
                ? 'https://example.invalid'
                : 'Corpo sintético sem HTML nem dados reais.',
          );
          await _saveDialog(tester, title);
          Future<void> checkPublic(bool visible) => _http(tester, () async {
            if (partner) {
              expectSync(
                (await publicClient.content.partners(
                  0,
                )).any((row) => row.name == title),
                visible,
              );
            } else {
              expectSync(
                (await publicClient.content.articles(
                  0,
                )).any((row) => row.title == title),
                visible,
              );
            }
          });
          await checkPublic(false);
          for (final visible in [true, false]) {
            await _tap(tester, find.text(title));
            await tester.pumpAndSettle();
            await _tap(tester, find.byType(CheckboxListTile));
            await tester.pumpAndSettle();
            await _saveDialog(tester, title);
            await checkPublic(visible);
          }
        }
      } finally {
        publicClient.close();
      }

      // Production parser and persistence, with controlled server-side transport.
      await _section(tester, 'Processos');
      fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '$clientId');
      await tester.enterText(fields.at(1), _caseNumber);
      await _tap(tester, find.text('Importar do DataJud'));
      final caseTitle = find.text('tjpr — $_caseNumber');
      await _until(
        tester,
        () => caseTitle.evaluate().isNotEmpty,
        'processo importado do transporte controlado',
      );
      await _tap(tester, caseTitle);
      await tester.pumpAndSettle();
      expect(find.text('Classe sintética 1'), findsOneWidget);
      await _tap(tester, find.text('Sincronizar processo'));
      await _until(
        tester,
        () =>
            find.byType(CircularProgressIndicator).evaluate().isEmpty &&
            find.text('Consultando…').evaluate().isEmpty,
        'sincronização controlada',
      );
      await _http(tester, () async {
        final row = (await app.client.caseRecord.list(
          0,
        )).singleWhere((row) => row.number == _caseNumber);
        expectSync(row.legalClientId, clientId);
        expectSync(row.lastSyncedAt, isNotNull);
        expectSync(row.syncError, isNull);
        expectSync(row.className, 'Classe sintética 2');
        expectSync(
          jsonDecode(row.movementsJson),
          contains(containsPair('name', 'Movimento sintético 2')),
        );
      });

      final refreshToken = storage.value?.refreshToken;
      if (refreshToken == null) {
        fail('A sessão precisa de um token de renovação.');
      }
      await _tap(tester, find.text('Sair').first);
      await _until(
        tester,
        () => find.text('Entrar com e-mail').evaluate().isNotEmpty,
        'logout',
      );
      expect(app.client.auth.isAuthenticated, isFalse);
      expect(storage.value, isNull);
      expect(find.text('Área interna'), findsNothing);
      expect(find.text(_updatedName), findsNothing);
      // The session manager also clears storage if the HTTP logout fails.
      // Verify server-side revocation of the token used by this device.
      expect(
        await _http(
          tester,
          () => _requestError(
            app.client.jwtRefresh.refreshAccessToken(
              refreshToken: refreshToken,
            ),
          ),
        ),
        isA<RefreshTokenNotFoundException>(),
      );
      expect(
        await _http(
          tester,
          () => _requestError(app.client.contactAdmin.list(0)),
        ),
        isA<ServerpodClientException>().having(
          (error) => error.statusCode,
          'statusCode',
          401,
        ),
      );
      expect(tester.takeException(), isNull);
    } finally {
      // This runs on an assertion failure too. Container cleanup is the runner's
      // finally responsibility; no manual SQL cleanup or development mutation.
      await tester.pumpWidget(const SizedBox.shrink());
      try {
        if (app.client.auth.isAuthenticated) {
          await _http(tester, () => app.client.auth.signOutDevice());
        }
      } finally {
        app.client.close();
        await tester.pump(const Duration(seconds: 16));
        await tester.pumpAndSettle();
      }
    }
  }, skip: !_enabled);
}
