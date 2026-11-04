import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_clients_screen.dart';

void main() {
  testWidgets('atribui advogado por operação separada', (tester) async {
    String? assigned;
    final row = LegalClient(
      id: 1,
      name: 'Ana',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AdminClientsScreen(
          loadClients: (_) async => [row],
          saveClient: (_, _, _, _, _) async => row,
          assignLawyer: (id, lawyerId) async {
            expect(id, 1);
            assigned = lawyerId;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Atribuir advogado'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'lawyer-id');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(assigned, 'lawyer-id');
  });
  testWidgets('valida nome e grava cliente sem exigir documento', (
    tester,
  ) async {
    String? savedName;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminClientsScreen(
          loadClients: (_) async => [],
          saveClient: (id, name, email, phone, document) async {
            savedName = name;
            return LegalClient(
              name: name,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Novo cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar cliente'));
    await tester.pump();
    expect(find.text('Informe o nome.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, ' Ana ');
    await tester.tap(find.text('Salvar cliente'));
    await tester.pumpAndSettle();
    expect(savedName, 'Ana');
    expect(find.text('Cliente salvo.'), findsOneWidget);
  });
  testWidgets('nega consulta sem exibir dados e oferece retry', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AdminClientsScreen(
          loadClients: (_) async =>
              throw AccessDeniedException(message: 'negado'),
          saveClient: (_, name, _, _, _) async => LegalClient(
            name: name,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Acesso restrito'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });
}
