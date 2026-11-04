import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/calculator_hub_screen.dart';
import 'package:signcob_flutter/screens/admin_cases_screen.dart';
import 'package:signcob_flutter/screens/admin_contacts_screen.dart';
import 'package:signcob_flutter/screens/admin_dashboard_screen.dart';
import 'package:signcob_flutter/screens/admin_users_screen.dart';
import 'package:signcob_flutter/screens/calculators/financing_calculator_screen.dart';
import 'package:signcob_flutter/screens/calculators/revision_calculator_screen.dart';
import 'package:signcob_flutter/screens/calculators/stay_calculator_screen.dart';
import 'package:signcob_flutter/screens/calculators/work_accident_screen.dart';
import 'package:signcob_flutter/screens/contact_screen.dart';
import 'package:signcob_flutter/screens/privacy_screen.dart';
import 'package:signcob_flutter/screens/public_home_screen.dart';
import 'package:signcob_flutter/theme/signcob_theme.dart';

void main() {
  final pages = <String, Widget Function()>{
    'home': () => PublicHomeScreen(
      onCalculators: () {},
      onContact: () {},
      onAdmin: () {},
      onBlog: () {},
      onPartners: () {},
    ),
    'questionário': () => const WorkAccidentScreen(),
    'catálogo': () => const CalculatorHubScreen(),
    'financiamento': () => const FinancingCalculatorScreen(),
    'revisional': () => const RevisionCalculatorScreen(),
    'estadia': () => const StayCalculatorScreen(),
    'contato': () => ContactScreen(onSubmit: (_, _, _) async {}),
    'privacidade': () => const PrivacyScreen(),
    'área interna': () => AdminDashboardScreen(
      contacts: const Text('Contatos'),
      users: const Text('Usuários'),
      clients: const Text('Clientes'),
      cases: const Text('Processos'),
      articles: const Text('Blog'),
      partners: const Text('Parceiros'),
      debts: const Text('Dívidas'),
      fees: const Text('Honorários'),
      onSignOut: () async {},
    ),
    'contatos recebidos': () => AdminContactsScreen(
      loadContacts: (_) async => [
        ContactMessage(
          id: 1,
          name: 'Pessoa de exemplo para teste de apresentação',
          email: 'pessoa.exemplo@example.com',
          message: 'Mensagem de teste para verificar leitura e rolagem.',
          createdAt: DateTime.utc(2026, 11, 3),
        ),
      ],
      onSignOut: () async {},
    ),
    'contatos sem acesso': () => AdminContactsScreen(
      loadContacts: (_) async =>
          throw AccessDeniedException(message: 'Sem acesso de teste'),
      onSignOut: () async {},
    ),
    'usuários e permissões': () => AdminUsersScreen(
      loadUsers: (_) async => [
        ManagedUser(
          userId: '00000000-0000-0000-0000-000000000001',
          email: 'pessoa.exemplo@example.com',
          permissions: [],
        ),
      ],
      savePermissions: (_, _) async {},
    ),
    'usuários vazios': () => AdminUsersScreen(
      loadUsers: (_) async => [],
      savePermissions: (_, _) async {},
    ),
    'processos vazios': () => AdminCasesScreen(
      loadCases: (_) async => [],
      importCase: (_, _, _) async => throw StateError('Não deve importar'),
      syncCase: (_) async => throw StateError('Não deve sincronizar'),
    ),
    'processos sem acesso': () => AdminCasesScreen(
      loadCases: (_) async =>
          throw AccessDeniedException(message: 'Sem acesso de teste'),
      importCase: (_, _, _) async => throw StateError('Não deve importar'),
      syncCase: (_) async => throw StateError('Não deve sincronizar'),
    ),
  };

  for (final width in [320.0, 390.0, 768.0, 1440.0]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets('layout ${width.toInt()} px e texto $scale', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final page in pages.entries) {
          await tester.pumpWidget(
            MaterialApp(
              theme: SignCobTheme.dark,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                ),
                child: child!,
              ),
              home: page.value(),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '${page.key}: topo');

          final scrollable = find.byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          );
          if (scrollable.evaluate().isNotEmpty) {
            await tester.drag(scrollable.first, const Offset(0, -3000));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull, reason: '${page.key}: fim');
          }

          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        }
      });
    }
  }
}
