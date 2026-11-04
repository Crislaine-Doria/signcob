import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_negotiations_screen.dart';

void main() {
  test('valores monetários convertidos sem ponto flutuante', () {
    expect(parseNegotiationAmount('12,34'), 1234);
    expect(parseNegotiationAmount('1,2'), 120);
    expect(parseNegotiationAmount('0'), isNull);
    expect(parseNegotiationAmount('1.234,56'), isNull);
    expect(parseNegotiationAmount('1,234'), isNull);
    expect(parseNegotiationAmount('90000000000,01'), isNull);
  });
  testWidgets('criação preserva tipo honorários e centavos', (tester) async {
    final now = DateTime.utc(2026);
    int? cents;
    String? kind;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminNegotiationsScreen(
          kind: 'fees',
          loadNegotiations: (_, _) async => [],
          createNegotiation: (id, type, title, value) async {
            cents = value;
            kind = type;
            return Negotiation(
              legalClientId: id,
              kind: type,
              title: title,
              amountCents: value,
              status: 'draft',
              createdAt: now,
              updatedAt: now,
            );
          },
          changeNegotiation: (_, _, _) async => throw UnimplementedError(),
          loadHistory: (_) async => [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nova negociação'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '2');
    await tester.enterText(find.byType(TextFormField).at(1), 'Contrato');
    await tester.enterText(find.byType(TextFormField).at(2), '123,45');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(cents, 12345);
    expect(kind, 'fees');
  });
  testWidgets('acesso negado permite nova tentativa sem exibir dados', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminNegotiationsScreen(
          kind: 'debt',
          loadNegotiations: (_, _) async =>
              throw AccessDeniedException(message: 'negado'),
          createNegotiation: (_, _, _, _) async => throw UnimplementedError(),
          changeNegotiation: (_, _, _) async => throw UnimplementedError(),
          loadHistory: (_) async => [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Acesso restrito para esta conta.'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
