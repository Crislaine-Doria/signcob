import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/contact_screen.dart';

void main() {
  Future<void> fill(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), ' Ana ');
    await tester.enterText(find.byType(TextFormField).at(1), 'ana@example.com');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      ' Gostaria de atendimento. ',
    );
    await tester.ensureVisible(find.byType(FilledButton));
  }

  testWidgets('campos vazios impedem envio', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ContactScreen(
          onSubmit: (_, _, _) async {
            calls++;
          },
        ),
      ),
    );
    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(find.text('Informe seu nome.'), findsOneWidget);
    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua mensagem.'), findsOneWidget);
  });

  testWidgets(
    'envio aguarda resposta, impede duplicação e limpa após sucesso',
    (tester) async {
      final done = Completer<void>();
      final sent = <List<String>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: ContactScreen(
            onSubmit: (name, email, message) {
              sent.add([name, email, message]);
              return done.future;
            },
          ),
        ),
      );
      await fill(tester);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(sent.single, [
        'Ana',
        'ana@example.com',
        'Gostaria de atendimento.',
      ]);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(find.text('Enviando…'), findsOneWidget);
      done.complete();
      await tester.pumpAndSettle();
      expect(find.text('Mensagem enviada com sucesso!'), findsOneWidget);
      for (final field in tester.widgetList<TextFormField>(
        find.byType(TextFormField),
      )) {
        expect(field.controller!.text, isEmpty);
      }
    },
  );

  testWidgets('falha preserva valores e permite nova tentativa', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ContactScreen(
          onSubmit: (_, _, _) async {
            calls++;
            throw Exception('offline');
          },
        ),
      ),
    );
    await fill(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível enviar. Tente novamente.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      ' Ana ',
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });
}
