import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'billing_customer_service.dart';
import 'billing_provider.dart';
import 'billing_validation.dart';

class BillingChargeService {
  BillingChargeService(this.provider);
  final BillingProvider provider;

  Future<BillingCharge> create(
    Session session,
    BillingCreateRequest request,
  ) async {
    validateBillingRequest(request);
    await _context(session, request);
    final existing = await _findRecord(
      session,
      request.clientId,
      request.idempotencyKey,
    );
    if (existing != null) {
      _same(existing, request);
      _scope(existing, await provider.verifyAccount());
      return _dispatch(session, existing);
    }
    provider.ensureCreationAvailable();
    final customer = await BillingCustomerService(
      provider,
    ).resolve(session, request.clientId);
    final (record, reserved) = await session.db.transaction((tx) async {
      await session.db.unsafeQuery(
        'SELECT id FROM legal_client WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': request.clientId}),
        transaction: tx,
      );
      await _context(session, request, transaction: tx);
      final previous = await _findRecord(
        session,
        request.clientId,
        request.idempotencyKey,
        transaction: tx,
      );
      if (previous != null) {
        _same(previous, request);
        _scope(previous, customer.accountId);
        return (previous, false);
      }
      final currentClient = (await LegalClient.db.findById(
        session,
        request.clientId,
        transaction: tx,
      ))!;
      if (billingDocument(currentClient.document) != customer.document) {
        throw billingError(
          'customer_conflict',
          'O documento do pagador foi alterado; confira o cadastro.',
        );
      }
      final now = DateTime.now().toUtc();
      final row = await BillingChargeRecord.db.insertRow(
        session,
        BillingChargeRecord(
          legalClientId: request.clientId,
          negotiationId: request.negotiationId,
          idempotencyKey: request.idempotencyKey,
          amountCents: request.amountCents,
          dueDate: request.dueDate,
          status: BillingStatus.awaitingProvider,
          createdAt: now,
          updatedAt: now,
          environment: 'sandbox',
          accountId: customer.accountId,
          kind: request.kind,
          method: request.method,
          flow: request.flow,
          installmentCount: request.installmentCount,
          cycle: request.cycle,
          providerCustomerId: customer.providerCustomerId,
          externalReference: 'signcob_charge_${const Uuid().v4()}',
          creationState: 'awaitingProvider',
          createAttempted: false,
        ),
        transaction: tx,
      );
      return (row, true);
    });
    if (!reserved) return _dispatch(session, record);
    return _dispatch(session, record);
  }

  Future<BillingCharge> _dispatch(
    Session session,
    BillingChargeRecord record,
  ) async {
    final (current, ownsAttempt) = await _markCreationAttempt(session, record);
    if (!ownsAttempt) return view(session, current);
    try {
      if (current.flow == BillingFlow.recurring) {
        final subscription = await provider.createSubscription(current);
        final payments = await provider.listSubscriptionPayments(
          subscription.id,
        );
        final updated = await session.db.transaction((tx) async {
          final locked = await _locked(session, current.id!, tx);
          return _applyRecurring(
            session,
            locked,
            subscription,
            payments,
            tx,
          );
        });
        return await view(session, updated);
      }
      final payment = await provider.createPayment(current);
      final installmentPayments = current.flow == BillingFlow.installment
          ? await provider.listInstallmentPayments(payment.installmentId ?? '')
          : null;
      final updated = await session.db.transaction((tx) async {
        final locked = await _locked(session, current.id!, tx);
        return locked.flow == BillingFlow.single
            ? _applySingle(session, locked, payment, tx)
            : _applyInstallment(
                session,
                locked,
                payment,
                installmentPayments!,
                tx,
              );
      });
      return await view(session, updated);
    } catch (_) {
      throw billingError(
        'creation_uncertain',
        'Resultado da criação pendente de conciliação. Preserve esta intenção.',
      );
    }
  }

  Future<(BillingChargeRecord, bool)> _markCreationAttempt(
    Session session,
    BillingChargeRecord record,
  ) => session.db.transaction((tx) async {
    final current = await _locked(session, record.id!, tx);
    if (current.providerId != null || current.creationState == 'active') {
      return (current, false);
    }
    if (current.createAttempted == true) return (current, false);
    final updated = await BillingChargeRecord.db.updateRow(
      session,
      current.copyWith(
        createAttempted: true,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
    return (updated, true);
  });

  Future<BillingCharge> get(Session session, int id) async =>
      view(session, await _get(session, id));

  Future<BillingCharge?> find(Session session, int clientId, String key) async {
    if (clientId <= 0 || !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(key)) {
      throw billingError(
        'invalid_input',
        'Identificação da intenção inválida.',
      );
    }
    final record = await _findRecord(session, clientId, key);
    return record == null ? null : view(session, record);
  }

  Future<List<BillingCharge>> list(
    Session session,
    String kind,
    int offset,
  ) async {
    if (!{'debt', 'fees'}.contains(kind) || offset < 0 || offset > 1000000) {
      throw billingError('invalid_input', 'Filtro de cobranças inválido.');
    }
    final rows = await BillingChargeRecord.db.find(
      session,
      where: (row) => row.kind.equals(kind),
      orderBy: (row) => row.id,
      orderDescending: true,
      limit: 25,
      offset: offset,
    );
    return Future.wait(rows.map((row) => view(session, row)));
  }

  Future<BillingCharge> refresh(Session session, int id) async {
    final account = await provider.verifyAccount();
    final updated = await session.db.transaction((tx) async {
      final record = await _locked(session, id, tx);
      _scope(record, account);
      if (record.flow == BillingFlow.recurring) {
        final subscription = record.providerGroupId == null
            ? await _findSubscription(record)
            : await provider.fetchSubscription(record.providerGroupId!);
        final payments = await provider.listSubscriptionPayments(
          subscription.id,
        );
        return _applyRecurring(
          session,
          record,
          subscription,
          payments,
          tx,
        );
      }
      if (record.flow == BillingFlow.installment) {
        final groupId =
            record.providerGroupId ?? await _findInstallmentGroup(record);
        final payments = await provider.listInstallmentPayments(groupId);
        return _applyInstallment(
          session,
          record,
          null,
          payments,
          tx,
          expectedGroupId: groupId,
        );
      }
      final ProviderPayment payment;
      if (record.providerId != null) {
        payment = await provider.fetchPayment(record.providerId!);
      } else {
        final matches = await provider.findPayments(
          record.providerCustomerId!,
          record.externalReference!,
        );
        if (matches.isEmpty) {
          throw billingError(
            'creation_uncertain',
            'Nenhuma cobrança inequívoca localizada. Preserve esta intenção.',
          );
        }
        if (matches.length != 1) {
          throw billingError(
            'reconciliation_conflict',
            'Mais de uma cobrança encontrada. Confira o fornecedor.',
          );
        }
        payment = matches.single;
      }
      return _applySingle(session, record, payment, tx);
    });
    return view(session, updated);
  }

  Future<String> _findInstallmentGroup(BillingChargeRecord record) async {
    final matches = await provider.findPayments(
      record.providerCustomerId!,
      record.externalReference!,
    );
    final groups = matches
        .where(
          (payment) =>
              payment.customerId == record.providerCustomerId &&
              payment.externalReference == record.externalReference &&
              payment.method == record.method &&
              payment.subscriptionId == null &&
              payment.installmentId != null,
        )
        .map((payment) => payment.installmentId!)
        .toSet();
    if (groups.isEmpty) {
      throw billingError(
        'creation_uncertain',
        'Nenhum parcelamento inequívoco localizado. Preserve esta intenção.',
      );
    }
    if (groups.length != 1) {
      throw billingError(
        'reconciliation_conflict',
        'Mais de um parcelamento encontrado. Confira o fornecedor.',
      );
    }
    return groups.single;
  }

  Future<ProviderSubscription> _findSubscription(
    BillingChargeRecord record,
  ) async {
    final matches = await provider.findSubscriptions(
      record.providerCustomerId!,
      record.externalReference!,
    );
    final exact = matches
        .where(
          (subscription) => _sameSubscription(
            record,
            subscription,
            requireOriginalDueDate: true,
          ),
        )
        .toList();
    if (exact.isEmpty) {
      throw billingError(
        'creation_uncertain',
        'Nenhuma assinatura inequívoca localizada. Preserve esta intenção.',
      );
    }
    if (exact.length != 1) {
      throw billingError(
        'reconciliation_conflict',
        'Mais de uma assinatura encontrada. Confira o fornecedor.',
      );
    }
    return exact.single;
  }

  bool _sameSubscription(
    BillingChargeRecord record,
    ProviderSubscription subscription, {
    required bool requireOriginalDueDate,
  }) =>
      subscription.customerId == record.providerCustomerId &&
      subscription.externalReference == record.externalReference &&
      subscription.method == record.method &&
      subscription.amountCents == record.amountCents &&
      (!requireOriginalDueDate || subscription.nextDueDate == record.dueDate) &&
      subscription.cycle == record.cycle;

  Future<BillingChargeRecord> _applyRecurring(
    Session session,
    BillingChargeRecord record,
    ProviderSubscription subscription,
    List<ProviderPayment> payments,
    Transaction tx,
  ) async {
    if (!_sameSubscription(
          record,
          subscription,
          requireOriginalDueDate: record.providerGroupId == null,
        ) ||
        (record.providerGroupId != null &&
            record.providerGroupId != subscription.id)) {
      throw billingError(
        'provider_response',
        'Assinatura retornada não corresponde à intenção.',
      );
    }
    final paymentIds = <String>{};
    for (final payment in payments) {
      if (!paymentIds.add(payment.id) ||
          payment.customerId != record.providerCustomerId ||
          payment.externalReference != record.externalReference ||
          payment.method != record.method ||
          payment.amountCents != record.amountCents ||
          payment.subscriptionId != subscription.id ||
          payment.installmentId != null ||
          payment.installmentNumber != null) {
        throw billingError(
          'provider_response',
          'Cobrança recorrente não corresponde à assinatura.',
        );
      }
    }
    for (final payment in payments) {
      await _observe(session, record, payment, tx);
    }
    final subscriptionStatus = switch (subscription.rawStatus) {
      'ACTIVE' => 'ACTIVE',
      'INACTIVE' => 'INACTIVE',
      'EXPIRED' => 'EXPIRED',
      _ => 'attention',
    };
    return BillingChargeRecord.db.updateRow(
      session,
      record.copyWith(
        providerGroupId: subscription.id,
        creationState: 'active',
        subscriptionStatus: subscriptionStatus,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  }

  Future<BillingChargeRecord> _applyInstallment(
    Session session,
    BillingChargeRecord record,
    ProviderPayment? firstResponse,
    List<ProviderPayment> payments,
    Transaction tx, {
    String? expectedGroupId,
  }) async {
    final groupId = expectedGroupId ?? firstResponse?.installmentId;
    final count = record.installmentCount;
    if (groupId == null || count == null || payments.length != count) {
      throw billingError(
        'provider_response',
        'Parcelamento retornado não corresponde à intenção.',
      );
    }
    final numbers = <int>{};
    var total = 0;
    for (final payment in payments) {
      final number = payment.installmentNumber;
      if (payment.customerId != record.providerCustomerId ||
          payment.externalReference != record.externalReference ||
          payment.method != record.method ||
          payment.installmentId != groupId ||
          payment.subscriptionId != null ||
          number == null ||
          number < 1 ||
          number > count ||
          !numbers.add(number) ||
          (number == 1 && payment.dueDate != record.dueDate)) {
        throw billingError(
          'provider_response',
          'Parcelas retornadas não correspondem à intenção.',
        );
      }
      total += payment.amountCents;
    }
    if (total != record.amountCents || numbers.length != count) {
      throw billingError(
        'provider_response',
        'A soma ou a quantidade das parcelas diverge da intenção.',
      );
    }
    if (firstResponse != null &&
        (firstResponse.installmentNumber != 1 ||
            !payments.any((payment) => payment.id == firstResponse.id))) {
      throw billingError(
        'provider_response',
        'A primeira parcela retornada não pertence ao parcelamento.',
      );
    }
    for (final payment in payments) {
      await _observe(session, record, payment, tx);
    }
    final first = payments.singleWhere(
      (payment) => payment.installmentNumber == 1,
    );
    return BillingChargeRecord.db.updateRow(
      session,
      record.copyWith(
        providerId: first.id,
        providerGroupId: groupId,
        creationState: 'active',
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  }

  Future<BillingChargeRecord> _applySingle(
    Session session,
    BillingChargeRecord record,
    ProviderPayment payment,
    Transaction tx,
  ) async {
    if (payment.customerId != record.providerCustomerId ||
        payment.externalReference != record.externalReference ||
        payment.method != record.method ||
        payment.amountCents != record.amountCents ||
        payment.dueDate != record.dueDate ||
        payment.installmentId != null ||
        payment.subscriptionId != null ||
        (record.providerId != null && record.providerId != payment.id)) {
      throw billingError(
        'provider_response',
        'Cobrança retornada não corresponde à intenção.',
      );
    }
    final (observed, changed) = await _observe(session, record, payment, tx);
    if (!changed &&
        record.creationState == 'active' &&
        record.status == observed.status) {
      return record;
    }
    return BillingChargeRecord.db.updateRow(
      session,
      record.copyWith(
        providerId: payment.id,
        status: observed.status,
        creationState: 'active',
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  }

  Future<(BillingPaymentRecord, bool)> _observe(
    Session session,
    BillingChargeRecord charge,
    ProviderPayment payment,
    Transaction tx,
  ) async {
    final existing = await BillingPaymentRecord.db.findFirstRow(
      session,
      where: (row) =>
          row.environment.equals(charge.environment!) &
          row.accountId.equals(charge.accountId!) &
          row.providerId.equals(payment.id),
      transaction: tx,
    );
    if (existing != null &&
        (existing.chargeId != charge.id ||
            existing.amountCents != payment.amountCents ||
            existing.dueDate != payment.dueDate ||
            existing.installmentNumber != payment.installmentNumber)) {
      throw billingError(
        'provider_response',
        'Identidade de pagamento conflitante.',
      );
    }
    final incoming = switch (payment.rawStatus) {
      'PENDING' => BillingStatus.pending,
      'OVERDUE' => BillingStatus.overdue,
      'CONFIRMED' => BillingStatus.confirmed,
      'RECEIVED' => BillingStatus.received,
      _ => BillingStatus.attention,
    };
    final now = DateTime.now().toUtc();
    final confirmedAt =
        existing?.confirmedAt ??
        (incoming == BillingStatus.confirmed ? now : null);
    final receivedAt =
        existing?.receivedAt ??
        (incoming == BillingStatus.received ? now : null);
    final status =
        incoming == BillingStatus.attention ||
            existing?.status == BillingStatus.attention
        ? BillingStatus.attention
        : receivedAt != null
        ? BillingStatus.received
        : confirmedAt != null
        ? BillingStatus.confirmed
        : existing?.status == BillingStatus.overdue
        ? BillingStatus.overdue
        : incoming;
    if (existing == null) {
      final inserted = await BillingPaymentRecord.db.insertRow(
        session,
        BillingPaymentRecord(
          chargeId: charge.id!,
          environment: charge.environment!,
          accountId: charge.accountId!,
          providerId: payment.id,
          amountCents: payment.amountCents,
          dueDate: payment.dueDate,
          installmentNumber: payment.installmentNumber,
          status: status,
          confirmedAt: confirmedAt,
          receivedAt: receivedAt,
          invoiceUrl: payment.invoiceUrl,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: tx,
      );
      return (inserted, true);
    }
    if (existing.status == status &&
        existing.confirmedAt == confirmedAt &&
        existing.receivedAt == receivedAt &&
        existing.invoiceUrl == payment.invoiceUrl) {
      return (existing, false);
    }
    final updated = await BillingPaymentRecord.db.updateRow(
      session,
      existing.copyWith(
        status: status,
        confirmedAt: confirmedAt,
        receivedAt: receivedAt,
        invoiceUrl: payment.invoiceUrl,
        updatedAt: now,
      ),
      transaction: tx,
    );
    return (updated, true);
  }

  Future<BillingCharge> view(Session session, BillingChargeRecord row) async {
    final payments = await BillingPaymentRecord.db.find(
      session,
      where: (table) => table.chargeId.equals(row.id!),
      orderBy: (table) => table.id,
    );
    final client = await LegalClient.db.findById(session, row.legalClientId);
    return BillingCharge(
      id: row.id!,
      legalClientId: row.legalClientId,
      negotiationId: row.negotiationId,
      amountCents: row.amountCents,
      dueDate: row.dueDate,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      idempotencyKey: row.idempotencyKey,
      kind: row.kind,
      method: row.method,
      flow: row.flow,
      installmentCount: row.installmentCount,
      cycle: row.cycle,
      providerGroupId: row.providerGroupId,
      creationState: row.creationState ?? 'legacy',
      subscriptionStatus: row.subscriptionStatus,
      clientName: client?.name,
      payments: payments
          .map(
            (payment) => BillingPayment(
              id: payment.id!,
              providerPaymentId: payment.providerId,
              amountCents: payment.amountCents,
              dueDate: payment.dueDate,
              installmentNumber: payment.installmentNumber,
              status: payment.status,
              confirmedAt: payment.confirmedAt,
              receivedAt: payment.receivedAt,
              invoiceUrl: payment.invoiceUrl,
            ),
          )
          .toList(),
    );
  }

  void _scope(BillingChargeRecord row, String account) {
    if (row.environment != 'sandbox' || row.accountId != account) {
      throw billingError(
        'account_mismatch',
        'A intenção pertence a outra configuração de conta.',
      );
    }
  }

  void _same(BillingChargeRecord row, BillingCreateRequest request) {
    if (row.amountCents != request.amountCents ||
        row.dueDate != request.dueDate ||
        row.negotiationId != request.negotiationId ||
        row.kind != request.kind ||
        row.method != request.method ||
        row.flow != request.flow ||
        row.installmentCount != request.installmentCount ||
        row.cycle != request.cycle) {
      throw billingError(
        'idempotency_conflict',
        'Chave de idempotência já usada com outros dados.',
      );
    }
  }

  Future<void> _context(
    Session session,
    BillingCreateRequest request, {
    Transaction? transaction,
  }) async {
    if (await LegalClient.db.findById(
          session,
          request.clientId,
          transaction: transaction,
        ) ==
        null) {
      throw _denied();
    }
    if (request.negotiationId != null) {
      final negotiation = await Negotiation.db.findById(
        session,
        request.negotiationId!,
        transaction: transaction,
      );
      if (negotiation?.legalClientId != request.clientId ||
          negotiation?.kind != request.kind) {
        throw _denied();
      }
    }
  }

  Future<BillingChargeRecord?> _findRecord(
    Session session,
    int clientId,
    String key, {
    Transaction? transaction,
  }) => BillingChargeRecord.db.findFirstRow(
    session,
    where: (row) =>
        row.legalClientId.equals(clientId) & row.idempotencyKey.equals(key),
    transaction: transaction,
  );

  Future<BillingChargeRecord> _get(
    Session session,
    int id, {
    Transaction? transaction,
  }) async {
    final record = await BillingChargeRecord.db.findById(
      session,
      id,
      transaction: transaction,
    );
    if (record == null) throw _denied();
    return record;
  }

  Future<BillingChargeRecord> _locked(
    Session session,
    int id,
    Transaction transaction,
  ) async {
    await session.db.unsafeQuery(
      'SELECT id FROM billing_charge WHERE id = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': id}),
      transaction: transaction,
    );
    return _get(session, id, transaction: transaction);
  }

  AccessDeniedException _denied() =>
      AccessDeniedException(message: 'Cobrança indisponível para esta conta.');
}
