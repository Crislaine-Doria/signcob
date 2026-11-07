import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'billing_provider.dart';
import 'billing_validation.dart';

class BillingCustomerService {
  BillingCustomerService(this.provider);

  final BillingProvider provider;

  Future<BillingCustomerRecord> resolve(Session session, int clientId) async {
    final client = await _client(session, clientId);
    final accountId = await provider.verifyAccount();
    final (record, reserved) = await session.db.transaction((tx) async {
      await session.db.unsafeQuery(
        'SELECT id FROM legal_client WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': clientId}),
        transaction: tx,
      );
      final current = await _client(session, clientId, transaction: tx);
      final document = billingDocument(current.document)!;
      await session.db.unsafeQuery(
        'SELECT pg_advisory_xact_lock(hashtextextended(@key, 0))',
        parameters: QueryParameters.named({
          'key': 'sandbox:$accountId:$document',
        }),
        transaction: tx,
      );
      final existing = await _record(session, accountId, clientId, tx: tx);
      if (existing != null) {
        if (existing.document != document) throw _identityConflict();
        return (existing, false);
      }
      final sameIdentity = await BillingCustomerRecord.db.findFirstRow(
        session,
        where: (row) =>
            row.environment.equals('sandbox') &
            row.accountId.equals(accountId) &
            row.document.equals(document),
        transaction: tx,
      );
      if (sameIdentity != null) throw _identityConflict();
      final now = DateTime.now().toUtc();
      final inserted = await BillingCustomerRecord.db.insertRow(
        session,
        BillingCustomerRecord(
          environment: 'sandbox',
          accountId: accountId,
          legalClientId: clientId,
          document: document,
          externalReference: 'signcob_customer_${const Uuid().v4()}',
          state: 'uncertain',
          createAttempted: false,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: tx,
      );
      return (inserted, true);
    });
    if (record.providerCustomerId != null) return record;
    if (!reserved) throw _uncertain();
    try {
      final matches = await provider.findCustomers(record.document);
      if (matches.length > 1) throw _identityConflict();
      final ProviderCustomer customer;
      if (matches.isEmpty) {
        final attempt = await _markCreation(session, record);
        if (attempt.providerCustomerId != null) return attempt;
        customer = await provider.createCustomer(
          name: client.name.trim(),
          document: record.document,
          externalReference: record.externalReference,
        );
        if (customer.externalReference != record.externalReference) {
          throw _uncertain();
        }
      } else {
        customer = matches.single;
      }
      return await _link(session, record, customer);
    } on BillingException catch (error) {
      if (error.code == 'customer_conflict') rethrow;
      throw _uncertain();
    } catch (_) {
      throw _uncertain();
    }
  }

  Future<BillingCustomerRecord> _markCreation(
    Session session,
    BillingCustomerRecord record,
  ) => session.db.transaction((tx) async {
    await session.db.unsafeQuery(
      'SELECT id FROM legal_client WHERE id = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': record.legalClientId}),
      transaction: tx,
    );
    final client = await _client(
      session,
      record.legalClientId,
      transaction: tx,
    );
    if (billingDocument(client.document) != record.document) {
      throw _identityConflict();
    }
    await session.db.unsafeQuery(
      'SELECT id FROM billing_customer WHERE id = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': record.id!}),
      transaction: tx,
    );
    final current = (await BillingCustomerRecord.db.findById(
      session,
      record.id!,
      transaction: tx,
    ))!;
    if (current.providerCustomerId != null) return current;
    if (current.createAttempted) throw _uncertain();
    return BillingCustomerRecord.db.updateRow(
      session,
      current.copyWith(
        createAttempted: true,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  });

  Future<BillingCustomerRecord> reconcile(Session session, int clientId) async {
    final client = await _client(session, clientId);
    final accountId = await provider.verifyAccount();
    final record = await _record(session, accountId, clientId);
    if (record == null) {
      throw billingError(
        'customer_missing',
        'Cadastro sandbox ainda não iniciado.',
      );
    }
    if (billingDocument(client.document) != record.document) {
      throw _identityConflict();
    }
    if (record.providerCustomerId != null) return record;
    final matches = await provider.findCustomers(record.document);
    if (matches.length > 1) throw _identityConflict();
    if (matches.isEmpty) throw _uncertain();
    if (record.createAttempted &&
        matches.single.externalReference != record.externalReference) {
      throw _uncertain();
    }
    return _link(session, record, matches.single);
  }

  Future<BillingCustomerRecord> _link(
    Session session,
    BillingCustomerRecord record,
    ProviderCustomer customer,
  ) async {
    if (customer.document != record.document ||
        !RegExp(r'^cus_[A-Za-z0-9_-]{1,100}$').hasMatch(customer.id)) {
      throw _identityConflict();
    }
    return session.db.transaction((tx) async {
      await session.db.unsafeQuery(
        'SELECT id FROM legal_client WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': record.legalClientId}),
        transaction: tx,
      );
      final client = await _client(
        session,
        record.legalClientId,
        transaction: tx,
      );
      if (billingDocument(client.document) != record.document) {
        throw _identityConflict();
      }
      await session.db.unsafeQuery(
        'SELECT id FROM billing_customer WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': record.id!}),
        transaction: tx,
      );
      final current = (await BillingCustomerRecord.db.findById(
        session,
        record.id!,
        transaction: tx,
      ))!;
      if (current.createAttempted &&
          customer.externalReference != current.externalReference) {
        throw _uncertain();
      }
      if (current.providerCustomerId != null) {
        if (current.providerCustomerId != customer.id) {
          throw _identityConflict();
        }
        return current;
      }
      final collision = await BillingCustomerRecord.db.findFirstRow(
        session,
        where: (row) =>
            row.environment.equals(record.environment) &
            row.accountId.equals(record.accountId) &
            row.providerCustomerId.equals(customer.id),
        transaction: tx,
      );
      if (collision != null && collision.id != record.id) {
        throw _identityConflict();
      }
      return BillingCustomerRecord.db.updateRow(
        session,
        current.copyWith(
          providerCustomerId: customer.id,
          state: 'linked',
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    });
  }

  Future<LegalClient> _client(
    Session session,
    int id, {
    Transaction? transaction,
  }) async {
    final client = await LegalClient.db.findById(
      session,
      id,
      transaction: transaction,
    );
    if (client == null) {
      throw AccessDeniedException(
        message: 'Cliente indisponível para esta conta.',
      );
    }
    if (client.name.trim().isEmpty ||
        billingDocument(client.document) == null) {
      throw billingError(
        'invalid_customer',
        'Cadastre nome e CPF/CNPJ válido do cliente antes de cobrar.',
      );
    }
    return client;
  }

  Future<BillingCustomerRecord?> _record(
    Session session,
    String accountId,
    int clientId, {
    Transaction? tx,
  }) => BillingCustomerRecord.db.findFirstRow(
    session,
    where: (row) =>
        row.environment.equals('sandbox') &
        row.accountId.equals(accountId) &
        row.legalClientId.equals(clientId),
    transaction: tx,
  );

  BillingException _uncertain() => billingError(
    'customer_uncertain',
    'Cadastro Asaas pendente de conciliação. Não inicie outro cadastro.',
  );

  BillingException _identityConflict() => billingError(
    'customer_conflict',
    'Vínculo do pagador requer conferência dos cadastros.',
  );
}
