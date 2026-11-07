import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';
import 'current_permission.dart';

class AccessAdminEndpoint extends Endpoint {
  static const managedPermissions = {
    'negotiations.read',
    'negotiations.write',
    'contacts.read',
    'users.manage',
    'clients.read',
    'clients.write',
    'cases.read',
    'cases.write',
    'content.write',
    'chat.partner',
    'chat.lawyer',
    'chat.support',
    'chat.client',
  };
  @override
  bool get requireLogin => true;
  @override
  Set<Scope> get requiredScopes => {const Scope('users.manage')};

  Future<List<ManagedUser>> list(Session session, int offset) async {
    await requireCurrentPermission(session, 'users.manage');
    if (offset < 0) throw ArgumentError.value(offset, 'offset');
    final all = await AuthServices.instance.authUsers.list(session);
    all.sort((a, b) => a.id.toString().compareTo(b.id.toString()));
    final page = all.skip(offset).take(25);
    final result = <ManagedUser>[];
    for (final user in page) {
      final account = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(user.id),
      );
      result.add(
        ManagedUser(
          userId: user.id.toString(),
          email: account?.email,
          permissions:
              user.scopes
                  .map((s) => s.name)
                  .whereType<String>()
                  .where(managedPermissions.contains)
                  .toList()
                ..sort(),
        ),
      );
    }
    return result;
  }

  Future<void> setPermissions(
    Session session,
    String userId,
    List<String> permissions,
  ) async {
    await requireCurrentPermission(session, 'users.manage');
    if (permissions.any((p) => !managedPermissions.contains(p))) {
      throw ArgumentError('Permissão desconhecida');
    }
    final id = UuidValue.withValidation(userId);
    if (UuidValue.withValidation(
              session.authenticated!.userIdentifier,
            ).toString().toLowerCase() ==
            id.toString().toLowerCase() &&
        !permissions.contains('users.manage')) {
      throw ArgumentError(
        'Não é possível remover sua própria gestão de acessos',
      );
    }
    final users = AuthServices.instance.authUsers;
    final existing = await users.get(session, authUserId: id);
    await users.update(
      session,
      authUserId: id,
      scopes: {
        ...existing.scopes.where((s) => !managedPermissions.contains(s.name)),
        ...permissions.map(Scope.new),
      },
    );
  }
}
