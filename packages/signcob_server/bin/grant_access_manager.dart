import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/generated/endpoints.dart';
import 'package:signcob_server/src/generated/protocol.dart';

/// Run locally from the server package: dart bin/grant_access_manager.dart UUID.
/// Grants only users.manage to an existing identity, preserving other scopes.
Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Uso: dart bin/grant_access_manager.dart AUTH_USER_UUID');
    exitCode = 64;
    return;
  }
  final id = UuidValue.withValidation(args.single);
  final pod = Serverpod(['--mode=development'], Protocol(), Endpoints());
  pod.initializeAuthServices(tokenManagerBuilders: [JwtConfigFromPasswords()]);
  final session = await pod.createSession();
  try {
    final users = AuthServices.instance.authUsers;
    final existing = await users.get(session, authUserId: id);
    await users.update(
      session,
      authUserId: id,
      scopes: {...existing.scopes, const Scope('users.manage')},
    );
    stdout.writeln(
      'Permissão users.manage concedida. Saia e entre novamente no aplicativo.',
    );
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
}
