import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_cases_screen.dart';

void main() {
  testWidgets('importação envia tribunal normalizado e mostra falha de configuração', (tester) async {
    String? tribunal;
    await tester.pumpWidget(MaterialApp(home: AdminCasesScreen(
      loadCases: (_) async => [],
      importCase: (_, value, _) async { tribunal = value; throw DataJudException(message: 'DataJud não configurado.'); },
      syncCase: (_) async => throw StateError('Não deve chamar'),
    )));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Identificador do cliente'), '2');
    await tester.enterText(find.widgetWithText(TextFormField, 'Número CNJ do processo'), '0000000-00.0000.0.00.0000');
    await tester.tap(find.text('Importar do DataJud'));
    await tester.pumpAndSettle();
    expect(tribunal, 'tjpr');
    expect(find.text('DataJud não configurado.'), findsOneWidget);
  });
  testWidgets('lista andamentos e sincroniza processo', (tester) async {
    final row = LegalCase(id: 1, legalClientId: 2, number: '00000000000000000000', tribunal: 'TJPR', movementsJson: '[{"name":"Distribuição","date":"2026-11-03"}]');
    var synced = false;
    await tester.pumpWidget(MaterialApp(home: AdminCasesScreen(
      loadCases: (_) async => [row],
      importCase: (_, _, _) async => row,
      syncCase: (_) async { synced = true; return row; },
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('TJPR — 00000000000000000000'));
    await tester.pumpAndSettle();
    expect(find.text('2026-11-03 — Distribuição'), findsOneWidget);
    await tester.ensureVisible(find.text('Sincronizar processo'));
    await tester.tap(find.text('Sincronizar processo'));
    await tester.pumpAndSettle();
    expect(synced, isTrue);
  });

  testWidgets('nega acesso e valida importação antes da consulta', (tester) async {
    var imports = 0;
    await tester.pumpWidget(MaterialApp(home: AdminCasesScreen(
      loadCases: (_) async => throw AccessDeniedException(message: 'Negado'),
      importCase: (_, _, _) async { imports++; throw StateError('Não deve chamar'); },
      syncCase: (_) async => throw StateError('Não deve chamar'),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Acesso restrito.'), findsOneWidget);
    await tester.tap(find.text('Importar do DataJud'));
    await tester.pumpAndSettle();
    expect(imports, 0);
    expect(find.text('Informe um identificador válido.'), findsOneWidget);
  });
}
