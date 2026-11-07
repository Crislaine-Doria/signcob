import 'package:serverpod/serverpod.dart';

import '../access/current_permission.dart';
import '../generated/protocol.dart';
import 'asaas_sandbox_provider.dart';
import 'billing_charge_service.dart';
import 'billing_customer_service.dart';
import 'billing_provider.dart';
import 'billing_validation.dart';

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
    BillingCreateRequest request,
  ) async {
    await _authorize(session, write: true);
    return BillingChargeService(_provider).create(session, request);
  }

  Future<BillingCharge> get(Session session, int id) async {
    await _authorize(session);
    return BillingChargeService(_provider).get(session, id);
  }

  Future<List<BillingCharge>> list(
    Session session,
    String kind,
    int offset,
  ) async {
    await _authorize(session);
    return BillingChargeService(_provider).list(session, kind, offset);
  }

  Future<BillingCharge?> findIntent(
    Session session,
    int clientId,
    String idempotencyKey,
  ) async {
    await _authorize(session);
    return BillingChargeService(
      _provider,
    ).find(session, clientId, idempotencyKey);
  }

  Future<BillingCharge> refresh(Session session, int id) async {
    await _authorize(session, write: true);
    return BillingChargeService(_provider).refresh(session, id);
  }

  Future<BillingCustomerLink> resolveCustomer(
    Session session,
    int clientId,
  ) async {
    await _authorize(session, write: true);
    final record = await BillingCustomerService(
      _provider,
    ).resolve(session, clientId);
    return BillingCustomerLink(clientId: clientId, state: record.state);
  }

  Future<BillingCustomerLink> reconcileCustomer(
    Session session,
    int clientId,
  ) async {
    await _authorize(session, write: true);
    final record = await BillingCustomerService(
      _provider,
    ).reconcile(session, clientId);
    return BillingCustomerLink(clientId: clientId, state: record.state);
  }

  Future<List<BillingClientOption>> listClients(
    Session session,
    String query,
    int offset,
  ) async {
    await _authorize(session);
    if (query.length > 120 || offset < 0 || offset > 1000000) {
      throw billingError('invalid_input', 'Filtro de clientes inválido.');
    }
    final clients = await LegalClient.db.find(
      session,
      where: (row) => row.name.ilike('%${query.trim()}%'),
      orderBy: (row) => row.id,
      limit: 25,
      offset: offset,
    );
    return clients
        .map(
          (client) => BillingClientOption(
            id: client.id!,
            name: client.name,
            readyForBilling:
                client.name.trim().isNotEmpty &&
                billingDocument(client.document) != null,
          ),
        )
        .toList();
  }

  Future<List<BillingNegotiationOption>> listNegotiations(
    Session session,
    int clientId,
    String kind,
  ) async {
    await _authorize(session);
    if (!{'debt', 'fees'}.contains(kind)) {
      throw billingError('invalid_input', 'Módulo de cobrança inválido.');
    }
    if (await LegalClient.db.findById(session, clientId) == null) {
      throw _accessDenied();
    }
    final rows = await Negotiation.db.find(
      session,
      where: (row) =>
          row.legalClientId.equals(clientId) & row.kind.equals(kind),
      orderBy: (row) => row.id,
      orderDescending: true,
      limit: 100,
    );
    return rows
        .map(
          (row) => BillingNegotiationOption(
            id: row.id!,
            title: row.title,
            amountCents: row.amountCents,
          ),
        )
        .toList();
  }

  Future<void> _authorize(Session session, {bool write = false}) async {
    final scopes = session.authenticated?.scopes;
    if (scopes == null ||
        !scopes.contains(const Scope('billing.read')) ||
        (write && !scopes.contains(const Scope('billing.write')))) {
      throw _accessDenied();
    }
    await requireCurrentPermission(session, 'billing.read');
    if (write) await requireCurrentPermission(session, 'billing.write');
  }

  AccessDeniedException _accessDenied() =>
      AccessDeniedException(message: 'Cobrança indisponível para esta conta.');
}
