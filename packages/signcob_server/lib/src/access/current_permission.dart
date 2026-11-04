import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

Future<void> requireCurrentPermission(
  Session session,
  String permission,
) async {
  final identifier = session.authenticated?.userIdentifier;
  if (identifier == null) throw AccessDeniedException(message: 'Acesso negado');
  final user = await AuthServices.instance.authUsers.get(
    session,
    authUserId: UuidValue.withValidation(identifier),
  );
  if (user.blocked || !user.scopes.contains(Scope(permission))) {
    throw AccessDeniedException(message: 'Acesso negado');
  }
}
