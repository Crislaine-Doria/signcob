import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../access/current_permission.dart';
import '../generated/protocol.dart';

class NegotiationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  String _identity(Session s) => UuidValue.withValidation(
    s.authenticated!.userIdentifier,
  ).toString().toLowerCase();
  Future<void> _authorize(Session s, String scope) async {
    if (!s.authenticated!.scopes.contains(Scope(scope))) {
      throw AccessDeniedException(message: 'Acesso negado');
    }
    await requireCurrentPermission(s, scope);
  }

  Future<bool> _manager(Session s) async {
    if (!s.authenticated!.scopes.contains(const Scope('users.manage'))) {
      return false;
    }
    final user = await AuthServices.instance.authUsers.get(
      s,
      authUserId: UuidValue.withValidation(_identity(s)),
    );
    return !user.blocked && user.scopes.contains(const Scope('users.manage'));
  }

  Future<void> _client(Session s, int id, {Transaction? transaction}) async {
    final client = await LegalClient.db.findById(
      s,
      id,
      transaction: transaction,
    );
    if (client == null ||
        (!await _manager(s) && client.assignedLawyerId != _identity(s))) {
      throw AccessDeniedException(
        message: 'Negociação indisponível para esta conta',
      );
    }
  }

  void _kind(String kind) {
    if (!{'debt', 'fees'}.contains(kind)) throw ArgumentError('Fluxo inválido');
  }

  Future<List<Negotiation>> list(
    Session session,
    int offset,
    String kind,
  ) async {
    await _authorize(session, 'negotiations.read');
    _kind(kind);
    if (offset < 0) throw ArgumentError('Página inválida');
    final manager = await _manager(session);
    final clients = manager
        ? <LegalClient>[]
        : await LegalClient.db.find(
            session,
            where: (t) => t.assignedLawyerId.equals(_identity(session)),
          );
    if (!manager && clients.isEmpty) return [];
    return Negotiation.db.find(
      session,
      where: (t) =>
          t.kind.equals(kind) &
          (manager
              ? Constant.bool(true)
              : t.legalClientId.inSet(clients.map((c) => c.id!).toSet())),
      limit: 25,
      offset: offset,
      orderByList: (t) => [
        Order(column: t.createdAt, orderDescending: true),
        Order(column: t.id, orderDescending: true),
      ],
    );
  }

  Future<Negotiation> create(
    Session session,
    int clientId,
    String kind,
    String title,
    int amountCents,
  ) async {
    await _authorize(session, 'negotiations.read');
    await _authorize(session, 'negotiations.write');
    _kind(kind);
    final text = title.trim();
    if (text.isEmpty ||
        text.length > 200 ||
        amountCents <= 0 ||
        amountCents > 9000000000000) {
      throw ArgumentError('Dados inválidos');
    }
    return session.db.transaction((tx) async {
      await _client(session, clientId, transaction: tx);
      final now = DateTime.now().toUtc();
      final row = await Negotiation.db.insertRow(
        session,
        Negotiation(
          legalClientId: clientId,
          kind: kind,
          title: text,
          amountCents: amountCents,
          status: 'draft',
          createdAt: now,
          updatedAt: now,
        ),
        transaction: tx,
      );
      await NegotiationEvent.db.insertRow(
        session,
        NegotiationEvent(
          negotiationId: row.id!,
          toStatus: 'draft',
          occurredAt: now,
          actorAuthUserId: _identity(session),
        ),
        transaction: tx,
      );
      return row;
    });
  }

  Future<Negotiation> transition(
    Session session,
    int id,
    String toStatus,
    String? note,
  ) async {
    await _authorize(session, 'negotiations.read');
    await _authorize(session, 'negotiations.write');
    final text = note?.trim();
    if (text != null && text.length > 2000) {
      throw ArgumentError('Nota muito longa');
    }
    return session.db.transaction((tx) async {
      // Lock only this negotiation before validating its current transition.
      await session.db.unsafeQuery(
        'SELECT id FROM negotiation WHERE id = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': id}),
        transaction: tx,
      );
      final row = await Negotiation.db.findById(session, id, transaction: tx);
      if (row == null) {
        throw AccessDeniedException(message: 'Negociação indisponível');
      }
      await _client(session, row.legalClientId, transaction: tx);
      final allowed = {
        'draft': {'proposed', 'cancelled'},
        'proposed': {'accepted', 'rejected', 'cancelled'},
      };
      if (!(allowed[row.status]?.contains(toStatus) ?? false)) {
        throw ArgumentError('Transição inválida');
      }
      final now = DateTime.now().toUtc();
      final updated = await Negotiation.db.updateRow(
        session,
        row.copyWith(status: toStatus, updatedAt: now),
        transaction: tx,
      );
      await NegotiationEvent.db.insertRow(
        session,
        NegotiationEvent(
          negotiationId: id,
          fromStatus: row.status,
          toStatus: toStatus,
          occurredAt: now,
          actorAuthUserId: _identity(session),
          note: text == null || text.isEmpty ? null : text,
        ),
        transaction: tx,
      );
      return updated;
    });
  }

  Future<List<NegotiationEvent>> history(Session session, int id) async {
    await _authorize(session, 'negotiations.read');
    final row = await Negotiation.db.findById(session, id);
    if (row == null) {
      throw AccessDeniedException(message: 'Negociação indisponível');
    }
    await _client(session, row.legalClientId);
    return NegotiationEvent.db.find(
      session,
      where: (t) => t.negotiationId.equals(id),
      limit: 100,
      orderByList: (t) => [Order(column: t.occurredAt), Order(column: t.id)],
    );
  }
}
