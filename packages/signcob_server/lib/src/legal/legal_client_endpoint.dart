import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../access/current_permission.dart';
import '../generated/protocol.dart';

class LegalClientEndpoint extends Endpoint {
  Future<bool> _isManager(Session session) async {
    final info = session.authenticated!;
    if (!info.scopes.contains(const Scope('users.manage'))) return false;
    final user = await AuthServices.instance.authUsers.get(
      session,
      authUserId: UuidValue.withValidation(info.userIdentifier),
    );
    return !user.blocked && user.scopes.contains(const Scope('users.manage'));
  }

  String _identity(Session session) => UuidValue.withValidation(
    session.authenticated!.userIdentifier,
  ).toString().toLowerCase();

  Future<void> _requireAssignment(Session session, LegalClient client) async {
    if (!await _isManager(session) &&
        client.assignedLawyerId != _identity(session)) {
      throw AccessDeniedException(
        message: 'Cliente não atribuído a esta conta',
      );
    }
  }

  @override
  bool get requireLogin => true;

  Future<void> _authorize(Session session, String permission) async {
    if (!(session.authenticated?.scopes.contains(Scope(permission)) ?? false)) {
      throw AccessDeniedException(message: 'Acesso negado');
    }
    await requireCurrentPermission(session, permission);
  }

  String? _optional(String? value, int max) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized.length > max) throw ArgumentError('Campo excede o limite');
    return normalized;
  }

  LegalClient _validated(
    String name,
    String? email,
    String? phone,
    String? document,
  ) {
    final normalized = name.trim();
    if (normalized.isEmpty || normalized.length > 120) {
      throw ArgumentError('Nome inválido');
    }
    final address = _optional(email, 254);
    if (address != null &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(address)) {
      throw ArgumentError('E-mail inválido');
    }
    final now = DateTime.now().toUtc();
    return LegalClient(
      name: normalized,
      email: address,
      phone: _optional(phone, 30),
      document: _optional(document, 30),
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<List<LegalClient>> list(Session session, int offset) async {
    await _authorize(session, 'clients.read');
    if (offset < 0) throw ArgumentError.value(offset, 'offset');
    final manager = await _isManager(session);
    return LegalClient.db.find(
      session,
      where: manager
          ? null
          : (t) => t.assignedLawyerId.equals(_identity(session)),
      limit: 25,
      offset: offset,
      orderByList: (t) => [Order(column: t.name), Order(column: t.id)],
    );
  }

  Future<LegalClient> create(
    Session session,
    String name,
    String? email,
    String? phone,
    String? document,
  ) async {
    await _authorize(session, 'clients.write');
    return LegalClient.db.insertRow(
      session,
      _validated(
        name,
        email,
        phone,
        document,
      ).copyWith(assignedLawyerId: _identity(session)),
    );
  }

  Future<LegalClient> update(
    Session session,
    int id,
    String name,
    String? email,
    String? phone,
    String? document,
  ) async {
    await _authorize(session, 'clients.write');
    final validated = _validated(name, email, phone, document);
    final existing = await LegalClient.db.findById(session, id);
    if (existing == null) throw ArgumentError('Cliente não encontrado');
    await _requireAssignment(session, existing);
    return LegalClient.db.updateRow(
      session,
      validated.copyWith(
        id: id,
        createdAt: existing.createdAt,
        assignedLawyerId: existing.assignedLawyerId,
        ownerAuthUserId: existing.ownerAuthUserId,
      ),
    );
  }

  Future<LegalClient> bindOwner(
    Session session,
    int id,
    String? authUserId,
  ) async {
    await _authorize(session, 'users.manage');
    await _authorize(session, 'clients.read');
    await _authorize(session, 'clients.write');
    final existing = await LegalClient.db.findById(session, id);
    if (existing == null) throw ArgumentError('Cliente não encontrado');
    String? normalized;
    if (authUserId != null) {
      final uuid = UuidValue.withValidation(authUserId);
      final user = await AuthServices.instance.authUsers.get(
        session,
        authUserId: uuid,
      );
      if (user.blocked) throw ArgumentError('Identidade bloqueada');
      normalized = uuid.toString().toLowerCase();
    }
    return LegalClient.db.updateRow(
      session,
      existing.copyWith(
        ownerAuthUserId: normalized,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<LegalClient> assign(Session session, int id, String? lawyerId) async {
    await _authorize(session, 'users.manage');
    await _authorize(session, 'clients.read');
    await _authorize(session, 'clients.write');
    final existing = await LegalClient.db.findById(session, id);
    if (existing == null) throw ArgumentError('Cliente não encontrado');
    String? normalized;
    if (lawyerId != null) {
      final uuid = UuidValue.withValidation(lawyerId);
      final user = await AuthServices.instance.authUsers.get(
        session,
        authUserId: uuid,
      );
      if (user.blocked) throw ArgumentError('Identidade bloqueada');
      normalized = uuid.toString().toLowerCase();
    }
    return LegalClient.db.updateRow(
      session,
      existing.copyWith(
        assignedLawyerId: normalized,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }
}
