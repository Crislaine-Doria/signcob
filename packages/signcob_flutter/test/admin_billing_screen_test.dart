import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_client/signcob_client.dart';
import 'package:signcob_flutter/screens/admin_billing_screen.dart';
import 'package:signcob_flutter/screens/admin_dashboard_screen.dart';
import 'package:signcob_flutter/theme/signcob_theme.dart';

final _now = DateTime.utc(2026, 11, 5);

BillingCharge _charge({
  BillingCreateRequest? request,
  String creationState = 'active',
  BillingFlow flow = BillingFlow.single,
  List<BillingPayment> payments = const [],
}) => BillingCharge(
  id: 11,
  legalClientId: request?.clientId ?? 7,
  negotiationId: request?.negotiationId,
  amountCents: request?.amountCents ?? 12345,
  dueDate: request?.dueDate ?? '2026-12-05',
  status: BillingStatus.pending,
  createdAt: _now,
  updatedAt: _now,
  idempotencyKey: request?.idempotencyKey,
  kind: request?.kind ?? 'debt',
  method: request?.method ?? BillingMethod.pix,
  flow: request?.flow ?? flow,
  installmentCount: request?.installmentCount,
  cycle: request?.cycle,
  creationState: creationState,
  subscriptionStatus: (request?.flow ?? flow) == BillingFlow.recurring
      ? 'ACTIVE'
      : null,
  providerGroupId: (request?.flow ?? flow) == BillingFlow.single
      ? null
      : 'group_synthetic',
  payments: payments,
);

BillingPayment _payment(int id, BillingStatus status) => BillingPayment(
  id: id,
  providerPaymentId: 'pay_synthetic_$id',
  amountCents: 6172,
  dueDate: '2026-12-05',
  installmentNumber: id,
  status: status,
  confirmedAt: status == BillingStatus.confirmed ? _now : null,
  receivedAt: status == BillingStatus.received ? _now : null,
  invoiceUrl: 'https://sandbox.asaas.com/i/synthetic$id',
);

class _Api {
  final requests = <BillingCreateRequest>[];
  final lookups = <(int, String)>[];
  List<BillingCharge> charges = [];
  Object? listFailure;
  Object? createFailure;
  Object? lookupFailure;
  Object? detailsFailure;
  BillingCharge? found;
  BillingCharge? reconciled;
  int refreshes = 0;
  int customerReconciliations = 0;
  int clientSearches = 0;
  int listCalls = 0;
  bool readyForBilling = true;
  final negotiationKinds = <String>[];
  BillingCharge Function(BillingCreateRequest)? result;
  Completer<BillingCharge>? pendingCreate;

  Future<List<BillingCharge>> list(String kind, int offset) async {
    listCalls++;
    if (listFailure case final failure?) throw failure;
    return charges;
  }

  Future<BillingCharge> create(BillingCreateRequest request) async {
    requests.add(request);
    if (createFailure case final failure?) throw failure;
    final charge = pendingCreate != null
        ? await pendingCreate!.future
        : (result?.call(request) ?? _charge(request: request));
    charges = [charge];
    return charge;
  }

  Future<BillingCharge?> find(int client, String key) async {
    lookups.add((client, key));
    if (lookupFailure case final failure?) throw failure;
    return found;
  }

  Future<BillingCharge> get(int id) async {
    if (detailsFailure case final failure?) throw failure;
    return charges.first;
  }

  Future<BillingCharge> refresh(int id) async {
    refreshes++;
    if (detailsFailure case final failure?) throw failure;
    final charge = reconciled ?? charges.first;
    charges = [charge];
    found = charge;
    return charge;
  }

  Future<BillingCustomerLink> reconcileCustomer(int id) async {
    customerReconciliations++;
    return BillingCustomerLink(clientId: id, state: 'linked');
  }

  AdminBillingScreen page({String kind = 'debt', bool mayWrite = true}) =>
      AdminBillingScreen(
        kind: kind,
        mayWrite: () => mayWrite,
        loadCharges: list,
        createCharge: create,
        findIntent: find,
        getCharge: get,
        refreshCharge: refresh,
        reconcileCustomer: reconcileCustomer,
        loadClients: (query, offset) async {
          clientSearches++;
          return [
            BillingClientOption(
              id: 7,
              name: 'Cliente sintético',
              readyForBilling: readyForBilling,
            ),
          ];
        },
        loadNegotiations: (clientId, kind) async {
          negotiationKinds.add(kind);
          return [
            BillingNegotiationOption(
              id: 9,
              title: 'Acordo sintético',
              amountCents: 12345,
            ),
          ];
        },
      );
}

Future<void> _open(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(MaterialApp(theme: SignCobTheme.dark, home: page));
  await tester.pumpAndSettle();
}

Future<void> _choose<T>(
  WidgetTester tester,
  String label,
) async {
  final field = find.byType(DropdownButtonFormField<T>);
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _form(
  WidgetTester tester, {
  BillingFlow flow = BillingFlow.single,
  BillingMethod method = BillingMethod.pix,
  bool negotiation = true,
}) async {
  await tester.ensureVisible(find.text('Nova cobrança'));
  await tester.tap(find.text('Nova cobrança'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Selecionar cliente'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Cliente sintético'));
  await tester.pumpAndSettle();
  if (negotiation) await _choose<int>(tester, 'Acordo sintético');
  if (method == BillingMethod.card) {
    await _choose<BillingMethod>(tester, 'Cartão');
  }
  if (method == BillingMethod.boleto) {
    await _choose<BillingMethod>(tester, 'Boleto');
  }
  if (flow == BillingFlow.installment) {
    await _choose<BillingFlow>(tester, 'Parcelada');
  }
  if (flow == BillingFlow.recurring) {
    await _choose<BillingFlow>(tester, 'Recorrente');
  }
  await tester.enterText(
    find.byKey(const ValueKey('billing-amount')),
    '123,45',
  );
  await tester.enterText(
    find.byKey(const ValueKey('billing-date')),
    '2026-12-05',
  );
  if (flow == BillingFlow.installment) {
    await tester.enterText(find.byKey(const ValueKey('billing-count')), '2');
  }
}

Future<void> _submit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Criar no sandbox'));
  await tester.tap(find.text('Criar no sandbox'));
  await tester.pumpAndSettle();
}

void main() {
  for (final flow in BillingFlow.values) {
    for (final method in BillingMethod.values) {
      testWidgets('jornada $flow com $method mantém pagamentos individuais', (
        tester,
      ) async {
        final api = _Api();
        api.result = (request) => _charge(
          request: request,
          payments: [
            _payment(1, BillingStatus.confirmed),
            if (flow != BillingFlow.single) _payment(2, BillingStatus.received),
          ],
        );
        await _open(tester, api.page(kind: 'fees'));
        await _form(tester, flow: flow, method: method);
        if (flow == BillingFlow.recurring) {
          await _choose<BillingCycle>(tester, 'Trimestral');
        }
        await _submit(tester);
        expect(api.requests, hasLength(1));
        final request = api.requests.single;
        expect(request.clientId, 7);
        expect(request.negotiationId, 9);
        expect(request.kind, 'fees');
        expect(request.flow, flow);
        expect(request.amountCents, 12345);
        expect(request.idempotencyKey, isNotEmpty);
        expect(
          request.installmentCount,
          flow == BillingFlow.installment ? 2 : null,
        );
        expect(
          request.cycle,
          flow == BillingFlow.recurring ? BillingCycle.quarterly : null,
        );
        expect(api.negotiationKinds, ['fees']);
        expect(
          find.textContaining('Cobrança criada no sandbox.'),
          findsOneWidget,
        );
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        expect(find.text('Confirmado · saldo indisponível'), findsOneWidget);
        if (flow != BillingFlow.single) {
          expect(find.text('Recebido · saldo disponível'), findsOneWidget);
        }
        if (flow == BillingFlow.recurring) {
          expect(find.text('Assinatura: Ativa'), findsOneWidget);
        }
        await tester.tap(find.text('Conciliar no sandbox'));
        await tester.pumpAndSettle();
        expect(api.refreshes, 1);
        expect(api.requests, hasLength(1));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('data e quantidade inválidas não enviam cobrança', (
    tester,
  ) async {
    final api = _Api();
    await _open(tester, api.page());
    await _form(
      tester,
      flow: BillingFlow.installment,
      method: BillingMethod.card,
    );
    await tester.enterText(
      find.byKey(const ValueKey('billing-date')),
      '2026-02-30',
    );
    await tester.enterText(find.byKey(const ValueKey('billing-count')), '13');
    await _submit(tester);
    expect(api.requests, isEmpty);
    expect(find.text('Informe uma data válida em AAAA-MM-DD.'), findsOneWidget);
    expect(find.text('Informe uma quantidade válida.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cliente sem documento não envia cobrança', (tester) async {
    final api = _Api()..readyForBilling = false;
    await _open(tester, api.page());
    await _form(tester);
    await _submit(tester);
    expect(api.requests, isEmpty);
    expect(
      find.textContaining('Complete o documento do cliente'),
      findsOneWidget,
    );
  });

  testWidgets('timeout recupera reserva e concilia sem repetir criação', (
    tester,
  ) async {
    final api = _Api()..createFailure = TimeoutException('sintético');
    api.found = _charge(creationState: 'awaitingProvider');
    api.reconciled = _charge();
    await _open(tester, api.page());
    await _form(tester, negotiation: false);
    await _submit(tester);
    expect(api.requests, hasLength(1));
    expect(api.lookups.single, (7, api.requests.single.idempotencyKey));
    final create = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Nova cobrança'),
    );
    expect(create.onPressed, isNull);
    await tester.tap(find.text('Consultar solicitação'));
    await tester.pumpAndSettle();
    expect(api.requests, hasLength(1));
    expect(api.refreshes, 1);
    expect(find.text('Solicitação em acompanhamento'), findsNothing);
    expect(find.textContaining('Cobrança criada no sandbox.'), findsOneWidget);
  });

  testWidgets(
    'cadastro incerto concilia e retoma explicitamente a mesma intenção',
    (tester) async {
      final api = _Api()
        ..createFailure = BillingException(
          code: 'customer_uncertain',
          message: 'sintético',
        );
      await _open(tester, api.page());
      await _form(tester);
      await _submit(tester);
      expect(api.requests, hasLength(1));
      final originalKey = api.requests.single.idempotencyKey;
      expect(find.text('Retomar mesma solicitação'), findsNothing);
      await tester.tap(find.text('Conciliar cadastro'));
      await tester.pumpAndSettle();
      expect(api.requests, hasLength(1));
      expect(api.customerReconciliations, 1);
      api.createFailure = null;
      await tester.tap(find.text('Retomar mesma solicitação'));
      await tester.pumpAndSettle();
      expect(api.requests, hasLength(2));
      expect(api.requests.last.idempotencyKey, originalKey);
      expect(api.requests.last.amountCents, api.requests.first.amountCents);
    },
  );

  testWidgets('consulta falha antes de retomar não dispara outra criação', (
    tester,
  ) async {
    final api = _Api()
      ..createFailure = BillingException(
        code: 'provider_configuration',
        message: 'sintético',
      );
    await _open(tester, api.page());
    await _form(tester);
    await _submit(tester);
    expect(find.text('Retomar mesma solicitação'), findsOneWidget);
    api.lookupFailure = TimeoutException('sintético');
    await tester.tap(find.text('Retomar mesma solicitação'));
    await tester.pumpAndSettle();
    expect(api.requests, hasLength(1));
    expect(find.text('Solicitação em acompanhamento'), findsOneWidget);
  });

  testWidgets(
    'reserva recuperada após reabrir bloqueia nova cobrança até conciliação',
    (tester) async {
      final api = _Api()
        ..charges = [_charge(creationState: 'awaitingProvider')];
      api.reconciled = _charge();
      await _open(tester, api.page());
      expect(
        find.textContaining('Há uma solicitação pendente'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Nova cobrança'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Conciliar no sandbox'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Nova cobrança'),
            )
            .onPressed,
        isNotNull,
      );
      expect(api.requests, isEmpty);
    },
  );

  testWidgets('somente leitura vê detalhes sem operações de escrita', (
    tester,
  ) async {
    final api = _Api()
      ..charges = [
        _charge(payments: [_payment(1, BillingStatus.received)]),
      ];
    await _open(tester, api.page(mayWrite: false));
    expect(find.text('Nova cobrança'), findsNothing);
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Recebido · saldo disponível'), findsOneWidget);
    expect(find.text('Conciliar no sandbox'), findsNothing);
    expect(find.text('Consultar registro'), findsOneWidget);
    expect(api.requests, isEmpty);
  });

  testWidgets('revogação nos detalhes remove dados e operações da tela', (
    tester,
  ) async {
    final api = _Api()..charges = [_charge()];
    await _open(tester, api.page());
    api.detailsFailure = AccessDeniedException(message: 'sintético');
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Acesso restrito para esta conta.'), findsWidgets);
    expect(find.text('Conciliar no sandbox'), findsNothing);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('Nova cobrança'), findsNothing);
  });

  testWidgets(
    'falha de listagem permite tentar novamente e negação não vaza dados',
    (tester) async {
      final api = _Api()
        ..listFailure = AccessDeniedException(message: 'sintético');
      await _open(tester, api.page());
      expect(find.text('Acesso restrito para esta conta.'), findsOneWidget);
      expect(find.text('Nova cobrança'), findsNothing);
      api.listFailure = null;
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nenhuma cobrança'), findsOneWidget);
      expect(find.text('Nova cobrança'), findsOneWidget);
    },
  );

  testWidgets(
    'navegar entre áreas preserva solicitação e logout descarta estado',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = _Api()..createFailure = TimeoutException('sintético');
      var signedOut = false;
      await _open(
        tester,
        AdminDashboardScreen(
          contacts: const Text('Lista de contatos'),
          users: const Text('Lista de usuários'),
          billingDebts: api.page(),
          billingFees: api.page(kind: 'fees'),
          onSignOut: () async => signedOut = true,
        ),
      );
      await tester.tap(find.text('Cobranças de dívidas'));
      await tester.pumpAndSettle();
      await _form(tester);
      await _submit(tester);
      final originalKey = api.requests.single.idempotencyKey;
      await tester.tap(find.text('Contatos'));
      await tester.pumpAndSettle();
      expect(find.text('Solicitação em acompanhamento'), findsNothing);
      await tester.tap(find.text('Cobranças de honorários'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Cobranças de honorários e serviços'),
        findsOneWidget,
      );
      await tester.tap(find.text('Cobranças de dívidas'));
      await tester.pumpAndSettle();
      expect(find.text('Solicitação em acompanhamento'), findsOneWidget);
      await tester.tap(find.text('Consultar solicitação'));
      await tester.pumpAndSettle();
      expect(api.lookups.last.$2, originalKey);
      expect(api.requests, hasLength(1));
      await tester.tap(find.text('Sair'));
      await tester.pump();
      expect(signedOut, isTrue);
      expect(find.text('Solicitação em acompanhamento'), findsNothing);
    },
  );

  testWidgets(
    'resposta atrasada da sessão anterior não aparece na nova sessão',
    (tester) async {
      final api = _Api()..pendingCreate = Completer<BillingCharge>();
      await _open(
        tester,
        KeyedSubtree(key: const ValueKey('session-a'), child: api.page()),
      );
      await _form(tester, method: BillingMethod.boleto);
      await tester.tap(find.text('Criar no sandbox'));
      await tester.pump();
      expect(api.requests, hasLength(1));
      final other = _Api();
      await _open(
        tester,
        KeyedSubtree(key: const ValueKey('session-b'), child: other.page()),
      );
      api.pendingCreate!.complete(_charge(request: api.requests.single));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nenhuma cobrança'), findsOneWidget);
      expect(find.textContaining('Cobrança criada no sandbox.'), findsNothing);
      expect(find.text('Solicitação em acompanhamento'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'rejeição anterior à reserva permite corrigir mantendo a mesma solicitação',
    (tester) async {
      final api = _Api()
        ..createFailure = BillingException(
          code: 'invalid_input',
          message: 'sintético',
        );
      await _open(tester, api.page());
      await _form(tester);
      await _submit(tester);
      final key = api.requests.single.idempotencyKey;
      await tester.tap(find.text('Corrigir solicitação'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Selecionar cliente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cliente sintético'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('billing-amount')),
        '234,56',
      );
      api.createFailure = null;
      await _submit(tester);
      expect(api.requests, hasLength(2));
      expect(api.requests.last.idempotencyKey, key);
      expect(api.requests.last.amountCents, 23456);
      expect(api.lookups.length, greaterThanOrEqualTo(3));
    },
  );

  testWidgets(
    'menu sem billing.read fica desabilitado sem consultar cobranças',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = _Api();
      await _open(
        tester,
        AdminDashboardScreen(
          contacts: const SizedBox.shrink(),
          users: const SizedBox.shrink(),
          billingDebts: api.page(),
          billingFees: api.page(kind: 'fees'),
          mayReadBilling: () => false,
          onSignOut: () async {},
        ),
      );
      for (final label in ['Cobranças de dívidas', 'Cobranças de honorários']) {
        expect(
          tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, label),
              )
              .onPressed,
          isNull,
        );
      }
      expect(api.listCalls, 0);
    },
  );

  for (final width in [320.0, 390.0, 768.0, 1440.0]) {
    testWidgets(
      'painel completo navega nas duas áreas de cobrança em $width px',
      (tester) async {
        tester.view.physicalSize = Size(width, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final api = _Api();
        await tester.pumpWidget(
          MaterialApp(
            theme: SignCobTheme.dark,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(2)),
              child: child!,
            ),
            home: AdminDashboardScreen(
              contacts: const Text('Lista de contatos'),
              users: const Text('Lista de usuários'),
              clients: const SizedBox.shrink(),
              cases: const SizedBox.shrink(),
              articles: const SizedBox.shrink(),
              partners: const SizedBox.shrink(),
              debts: const SizedBox.shrink(),
              fees: const SizedBox.shrink(),
              billingDebts: api.page(),
              billingFees: api.page(kind: 'fees'),
              onSignOut: () async {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        for (final label in [
          'Cobranças de dívidas',
          'Cobranças de honorários',
        ]) {
          if (width < 600) {
            await _choose<int>(tester, label);
          } else {
            await tester.tap(find.widgetWithText(OutlinedButton, label));
            await tester.pumpAndSettle();
          }
          await tester.scrollUntilVisible(
            find.textContaining('Nenhuma cobrança'),
            200,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          expect(find.textContaining('Nenhuma cobrança'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets(
      'cobranças e formulário cabem em $width px com texto ampliado',
      (tester) async {
        tester.view.physicalSize = Size(width, 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final api = _Api()
          ..charges = [
            _charge(
              flow: BillingFlow.recurring,
              payments: [_payment(1, BillingStatus.received)],
            ),
          ];
        await tester.pumpWidget(
          MaterialApp(
            theme: SignCobTheme.dark,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(2)),
              child: child!,
            ),
            home: api.page(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'lista');
        await tester.ensureVisible(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'detalhes');
        await tester.ensureVisible(find.text('Fechar'));
        await tester.tap(find.text('Fechar'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Nova cobrança'));
        await tester.tap(find.text('Nova cobrança'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'formulário');
        await tester.ensureVisible(find.text('Selecionar cliente'));
        await tester.tap(find.text('Selecionar cliente'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'seletor de cliente');
      },
    );
  }
}
