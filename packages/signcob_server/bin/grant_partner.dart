import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:signcob_server/src/access/partner_profile.dart';
import 'package:signcob_server/src/generated/endpoints.dart';
import 'package:signcob_server/src/generated/protocol.dart';

/// Explicit local grant to an existing identity; never runs on registration.
Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Uso: dart bin/grant_partner.dart AUTH_USER_UUID');
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
    if (existing.blocked) {
      throw StateError('Conta bloqueada; nenhuma permissão concedida.');
    }
    await users.update(
      session,
      authUserId: id,
      scopes: partnerScopes(existing.scopes),
    );
    stdout.writeln(
      'Perfil sócio concedido para os módulos atuais. Saia e entre novamente.',
    );
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
}
