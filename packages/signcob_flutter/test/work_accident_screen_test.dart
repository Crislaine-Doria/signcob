import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/calculators/work_accident_screen.dart';

Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> toContext(WidgetTester tester) async {
  await tapText(tester, 'Acidente no local de trabalho');
  await tapText(tester, 'Mão ou dedos');
  await tapText(tester, 'Ainda estou em tratamento');
  tester
      .widget<DropdownButtonFormField<int>>(
        find.byType(DropdownButtonFormField<int>),
      )
      .onChanged!(35);
  await tester.pumpAndSettle();
  await tapText(tester, 'Continuar');
}

void main() {
  testWidgets('voltar preserva a seleção e a tela cabe em 320 pixels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: WorkAccidentScreen()));
    await tapText(tester, 'Acidente no local de trabalho');
    expect(find.text('Etapa 2 de 6'), findsOneWidget);
    await tapText(tester, 'Voltar');
    expect(find.text('Etapa 1 de 6'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('exige salário e tempo; valida contato sem inventar resultado', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WorkAccidentScreen()));
    await toContext(tester);
    expect(find.text('Etapa 5 de 6'), findsOneWidget);
    FilledButton next() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continuar'),
    );
    expect(next().onPressed, isNull);
    await tapText(tester, 'Até R\$ 2.000');
    expect(next().onPressed, isNull);
    await tapText(tester, 'Há menos de 1 mês');
    expect(next().onPressed, isNotNull);
    await tapText(tester, 'Continuar');
    expect(find.text('Etapa 6 de 6'), findsOneWidget);
    await tapText(tester, 'Ver minha indenização');
    expect(find.text('Informe seu nome.'), findsOneWidget);
    expect(find.text('Informe um telefone com DDD válido.'), findsOneWidget);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '(41) 99999-9999');
    await tester.enterText(fields.at(1), 'Ana Silva');
    await tester.enterText(fields.at(2), 'ana@example.com');
    await tapText(tester, 'Ver minha indenização');
    expect(find.text('Seu resumo está pronto'), findsOneWidget);
    expect(
      find.text(
        'Demonstração concluída. Nenhum pedido de contato foi enviado.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Não calculamos valor:'), findsOneWidget);
  });
}
