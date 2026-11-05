import 'package:serverpod/serverpod.dart';

import '../access/current_permission.dart';
import '../generated/protocol.dart';
import 'asaas_sandbox_provider.dart';
import 'billing_provider.dart';

class BillingEndpoint extends Endpoint {
  BillingEndpoint({BillingProvider? provider})
    : _provider = provider ?? AsaasSandboxProvider.fromEnvironment();

  final BillingProvider _provider;

  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {const Scope('billing.read')};

  Future<BillingCharge> create(
    Session session,
    int clientId,
    int? negotiationId,
    int amountCents,
    String dueDate,
    String idempotencyKey,
  ) async {
    await _authorize(session, write: true);
    final parsedDate = DateTime.tryParse('${dueDate}T00:00:00Z');
    if (amountCents <= 0 ||
        amountCents > 9000000000000 ||
        !RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(dueDate) ||
        parsedDate?.toIso8601String().split('T').first != dueDate ||
        dueDate.startsWith('0000') ||
        !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(idempotencyKey)) {
      throw BillingException(
        code: 'invalid_input',
        message: 'Dados da cobrança inválidos.',
      );
    }

    final (record, reserved) = await session.db.transaction((tx) async {
      // The existing client row serializes claims of a key for this client.
      final client = await session.db.unsafeQuery(
        'SELECT id FROM legal_client WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': clientId}),
        transaction: tx,
      );
      if (client.isEmpty) {
        throw _accessDenied();
      }
      final existing = await BillingChargeRecord.db.findFirstRow(
        session,
        where: (table) =>
            table.legalClientId.equals(clientId) &
            table.idempotencyKey.equals(idempotencyKey),
        transaction: tx,
      );
      if (existing != null) {
        if (existing.amountCents != amountCents ||
            existing.dueDate != dueDate ||
            existing.negotiationId != negotiationId) {
          throw BillingException(
            code: 'idempotency_conflict',
            message: 'Chave de idempotência já usada com outros dados.',
          );
        }
        return (existing, false);
      }
      if (negotiationId != null) {
        final negotiation = await Negotiation.db.findById(
          session,
          negotiationId,
          transaction: tx,
        );
        if (negotiation?.legalClientId != clientId) {
          throw _accessDenied();
        }
      }
      _provider.ensureCreationAvailable();
      final now = DateTime.now().toUtc();
      final row = await BillingChargeRecord.db.insertRow(
        session,
        BillingChargeRecord(
          legalClientId: clientId,
          negotiationId: negotiationId,
          idempotencyKey: idempotencyKey,
          amountCents: amountCents,
          dueDate: dueDate,
          status: BillingStatus.awaitingProvider,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: tx,
      );
      return (row, true);
    });
    if (!reserved) {
      return _toCharge(record);
    }

    // A crash after this point leaves the durable claim for reconciliation.
    // Never resend a claim that might have reached the provider.
    try {
      final result = await _provider.create(_toCharge(record));
      if (result.id.isEmpty || result.status != BillingStatus.pending) {
        throw StateError('Resposta inválida na criação.');
      }
      final updated = await BillingChargeRecord.db.updateRow(
        session,
        record.copyWith(
          providerId: result.id,
          status: result.status,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      return _toCharge(updated);
    } catch (_) {
      throw BillingException(
        code: 'creation_uncertain',
        message: 'Resultado da criação pendente de conciliação.',
      );
    }
  }

  Future<BillingCharge> get(Session session, int id) async {
    await _authorize(session);
    return _toCharge(await _getRecord(session, id));
  }

  Future<BillingCharge> refresh(Session session, int id) async {
    await _authorize(session, write: true);
    return session.db.transaction((tx) async {
      // Serialize observations for this charge to prevent stale updates.
      await session.db.unsafeQuery(
        'SELECT id FROM billing_charge WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': id}),
        transaction: tx,
      );
      final record = await _getRecord(session, id, transaction: tx);
      final providerId = record.providerId;
      if (providerId == null) {
        throw BillingException(
          code: 'creation_uncertain',
          message: 'Resultado da criação pendente de conciliação.',
        );
      }
      final status = await _provider.fetchStatus(providerId);
      if (status == record.status) {
        return _toCharge(record);
      }
      if (record.status != BillingStatus.pending ||
          status != BillingStatus.overdue) {
        throw BillingException(
          code: 'invalid_transition',
          message: 'Transição de cobrança inválida.',
        );
      }
      final updated = await BillingChargeRecord.db.updateRow(
        session,
        record.copyWith(status: status, updatedAt: DateTime.now().toUtc()),
        transaction: tx,
      );
      return _toCharge(updated);
    });
  }

  Future<void> _authorize(Session session, {bool write = false}) async {
    final scopes = session.authenticated?.scopes;
    if (scopes == null ||
        !scopes.contains(const Scope('billing.read')) ||
        (write && !scopes.contains(const Scope('billing.write')))) {
      throw _accessDenied();
    }
    await requireCurrentPermission(session, 'billing.read');
    if (write) {
      await requireCurrentPermission(session, 'billing.write');
    }
  }

  Future<BillingChargeRecord> _getRecord(
    Session session,
    int id, {
    Transaction? transaction,
  }) async {
    final record = await BillingChargeRecord.db.findById(
      session,
      id,
      transaction: transaction,
    );
    if (record == null) {
      throw _accessDenied();
    }
    return record;
  }

  AccessDeniedException _accessDenied() =>
      AccessDeniedException(message: 'Cobrança indisponível para esta conta.');

  BillingCharge _toCharge(BillingChargeRecord row) => BillingCharge(
    id: row.id!,
    legalClientId: row.legalClientId,
    negotiationId: row.negotiationId,
    amountCents: row.amountCents,
    dueDate: row.dueDate,
    status: row.status,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
