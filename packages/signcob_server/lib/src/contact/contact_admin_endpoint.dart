import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../access/current_permission.dart';

/// Contact inbox available only to explicitly authorized operators.
class ContactAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {const Scope('contacts.read')};

  Future<List<ContactMessage>> list(Session session, int offset) async {
    await requireCurrentPermission(session, 'contacts.read');
    if (offset < 0) throw ArgumentError.value(offset, 'offset');
    return ContactMessage.db.find(
      session,
      limit: 25,
      offset: offset,
      orderByList: (t) => [
        Order(column: t.createdAt, orderDescending: true),
        Order(column: t.id, orderDescending: true),
      ],
    );
  }
}
