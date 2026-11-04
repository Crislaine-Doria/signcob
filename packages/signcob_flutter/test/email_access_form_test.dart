import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/theme/signcob_theme.dart';
import 'package:signcob_flutter/widgets/email_access_form.dart';

class _FakeClient extends Client {
  _FakeClient() : super('http://127.0.0.1:1/');
  final calls = <String>[];
  Completer<void>? loginGate;

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    calls.add(method);
    if (method == 'startRegistration' || method == 'startPasswordReset') {
      // Test-only synthetic Serverpod request UUID; no network or real account.
      // ignore: experimental_member_use
      return UuidValue.fromString('00000000-0000-0000-0000-000000000001') as T;
    }
    if (method == 'verifyRegistrationCode' ||
        method == 'verifyPasswordResetCode') {
      return 'synthetic-token' as T;
    }
    if (method == 'login') await loginGate?.future;
    throw StateError('Synthetic authentication failure');
  }
}

void main() {
  Future<void> tap(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Widget app(Client client) => MaterialApp(
    theme: SignCobTheme.dark,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
      child: child!,
    ),
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: EmailAccessForm(client: client),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  for (final width in [320.0, 390.0, 768.0, 1440.0]) {
    testWidgets(
      'email: sete etapas responsivas ${width.toInt()} px texto 2 sem serviço real',
      (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final client = _FakeClient();
        await tester.pumpWidget(app(client));
        await tester.pumpAndSettle();
        expect(find.text('Entrar com e-mail'), findsOneWidget);
        await tap(tester, 'Entrar');
        expect(client.calls, isEmpty);
        expect(find.text('Informe um e-mail válido.'), findsOneWidget);
        expect(find.text('Informe a senha.'), findsOneWidget);

        for (final registration in [false, true]) {
          await tap(
            tester,
            registration ? 'Criar conta' : 'Esqueci minha senha',
          );
          await tester.enterText(
            find.byKey(const ValueKey('auth-email')),
            'ficticio@example.com',
          );
          await tap(tester, 'Continuar');
          expect(find.text('Verificar código'), findsOneWidget);
          expect(tester.takeException(), isNull, reason: 'código');
          await tap(tester, 'Continuar');
          expect(find.text('Informe o código.'), findsOneWidget);
          await tester.enterText(
            find.byKey(const ValueKey('auth-code')),
            '123456',
          );
          await tap(tester, 'Continuar');
          expect(find.text('Definir senha'), findsOneWidget);
          await tap(tester, 'Salvar senha');
          expect(find.text('Informe a senha.'), findsOneWidget);
          await tester.enterText(
            find.byKey(const ValueKey('auth-password')),
            'senha-ficticia',
          );
          await tap(tester, 'Salvar senha');
          expect(
            find.textContaining('Não foi possível concluir.'),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull, reason: 'senha');
          await tap(tester, 'Voltar para entrar');
        }
        expect(
          client.calls,
          containsAll([
            'startPasswordReset',
            'verifyPasswordResetCode',
            'finishPasswordReset',
            'startRegistration',
            'verifyRegistrationCode',
            'finishRegistration',
          ]),
        );
        expect(client.calls, isNot(contains('login')));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'login bloqueia duplicação durante resposta e permite corrigir falha',
    (tester) async {
      final client = _FakeClient()..loginGate = Completer<void>();
      await tester.pumpWidget(app(client));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('auth-email')),
        'ficticio@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth-password')),
        'senha-ficticia',
      );
      await tester.ensureVisible(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Entrar'));
      await tester.pump();
      expect(find.text('Aguarde…'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(client.calls, ['login']);
      client.loginGate!.complete();
      await tester.pumpAndSettle();
      expect(find.textContaining('Não foi possível entrar.'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('auth-email')))
            .controller!
            .text,
        'ficticio@example.com',
      );
    },
  );
}
