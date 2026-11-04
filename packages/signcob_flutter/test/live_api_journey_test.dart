import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/main.dart' as app;

// Explicit opt-in: requires the LOCAL development API and its EXISTING account.
// Never runs against a configurable remote host. Does not create accounts or
// change permissions. Only writes one fictional contact, removed by the local
// QA cleanup documented in docs/development/validacao-ponta-a-ponta.md.
const _enabled = bool.fromEnvironment('SIGNCOB_LIVE_QA');
const _marker = 'SignCob QA E2E 20261103';

class _MemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _value;
  @override
  Future<AuthSuccess?> get() async => _value;
  @override
  Future<void> set(AuthSuccess? value) async => _value = value;
}

Future<void> _until(WidgetTester tester, bool Function() ready) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (ready()) return;
    await tester.runAsync(
      () => Future<void>.delayed(
        const Duration(milliseconds: 100),
      ),
    );
  }
  fail('A jornada local não atingiu o estado esperado em 10 segundos.');
}

void main() {
  testWidgets('Flutter → HTTP → PostgreSQL: contato, login, áreas e logout', (
    tester,
  ) async {
    final previousOverrides = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = previousOverrides);
    tester.view.physicalSize = const Size(1440, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Read credentials privately; do not put secrets in args, logs or fixtures.
    final credentials = File(
      '../signcob_server/config/admin-initial-access.txt',
    ).readAsLinesSync();
    String credential(String name) => credentials
        .firstWhere((line) => line.startsWith('$name='))
        .substring(name.length + 1);
    app.client = Client('http://127.0.0.1:8080/')
      ..authSessionManager = FlutterAuthSessionManager(
        storage: _MemoryAuthStorage(),
      );
    addTearDown(() async {
      if (app.client.auth.isAuthenticated) {
        await app.client.auth.signOutDevice();
      }
      app.client.close();
    });
    await tester.runAsync(() => app.client.auth.initialize());
    await tester.runAsync(() async {
      await expectLater(
        app.client.contactAdmin.list(0),
        throwsA(
          isA<ServerpodClientException>().having(
            (error) => error.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });
    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contato').first);
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), _marker);
    await tester.enterText(fields.at(1), 'qa-e2e@example.invalid');
    await tester.enterText(
      fields.at(2),
      'Mensagem fictícia de verificação local.',
    );
    await tester.ensureVisible(find.text('Enviar mensagem'));
    await tester.tap(find.text('Enviar mensagem'));
    await _until(
      tester,
      () => find.text('Mensagem enviada com sucesso!').evaluate().isNotEmpty,
    );
    expect(find.text('Mensagem enviada com sucesso!'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Área administrativa').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      credential('email'),
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      credential('password'),
    );
    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await _until(tester, () => find.text('Área interna').evaluate().isNotEmpty);
    expect(app.client.auth.isAuthenticated, isTrue);

    Future<void> open(String label) async {
      final button = find.widgetWithText(OutlinedButton, label).first;
      await tester.ensureVisible(button);
      await tester.tap(button);
      await _until(
        tester,
        () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
      );
      expect(find.textContaining('Acesso restrito'), findsNothing);
      expect(find.textContaining('Não foi possível'), findsNothing);
      expect(tester.takeException(), isNull);
    }

    await open('Contatos');
    expect(find.text(_marker), findsOneWidget);
    for (final label in [
      'Clientes',
      'Processos',
      'Usuários e permissões',
      'Dívidas dos clientes',
      'Honorários e serviços',
      'Blog',
      'Parceiros',
    ]) {
      await open(label);
    }
    await tester.tap(find.text('Sair').first);
    await _until(tester, () => find.text('Entrar').evaluate().isNotEmpty);
    expect(app.client.auth.isAuthenticated, isFalse);
    expect(find.text(_marker), findsNothing);
    expect(find.text('Área interna'), findsNothing);
    app.client.close();
    await tester.pumpWidget(const SizedBox.shrink());
    // Real HttpClient idle-connection timers must drain before widget-test
    // invariants run (tearDown happens later).
    await tester.pump(const Duration(seconds: 16));
    await tester.pumpAndSettle();
  }, skip: !_enabled);
}
