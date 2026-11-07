import 'dart:io';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:signcob_server/src/access/partner_profile.dart';
import 'package:signcob_server/src/generated/endpoints.dart';
import 'package:signcob_server/src/generated/protocol.dart';

const _email = 'signcobadministrador@signcob.com.br';
const _accessPath = 'config/admin-initial-access.txt';

/// Explicit local bootstrap for the principal partner account. No emails sent.
/// Existing identities retain their password; no other account is created.
Future<void> main(List<String> args) async {
  if (args.isNotEmpty) {
    stderr.writeln(
      'Este comando não aceita argumentos; a conta autorizada é fixa.',
    );
    exitCode = 64;
    return;
  }
  final pod = Serverpod(['--mode=development'], Protocol(), Endpoints());
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode:
            (
              session, {
              required email,
              required accountRequestId,
              required verificationCode,
              required transaction,
            }) {},
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) {},
      ),
    ],
  );
  final session = await pod.createSession();
  try {
    final created = await session.db.transaction((tx) async {
      // Serialize repeated invocations without affecting other identities.
      await session.db.unsafeQuery(
        'SELECT pg_advisory_xact_lock(1094984801)',
        transaction: tx,
      );
      final existing = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.email.equals(_email),
        transaction: tx,
      );
      final users = AuthServices.instance.authUsers;
      if (existing != null) {
        final user = await users.get(
          session,
          authUserId: existing.authUserId,
          transaction: tx,
        );
        if (user.blocked) {
          throw StateError(
            'A conta existente está bloqueada; nenhuma alteração realizada.',
          );
        }
        await users.update(
          session,
          authUserId: user.id,
          scopes: partnerScopes(user.scopes),
          transaction: tx,
        );
        return false;
      }
      final accessFile = File(_accessPath);
      if (accessFile.existsSync()) {
        throw StateError(
          'Arquivo de acesso inicial já existe; nenhuma senha sobrescrita.',
        );
      }
      final random = Random.secure();
      const alphabet =
          'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789';
      final randomPart = List.generate(
        28,
        (_) => alphabet[random.nextInt(alphabet.length)],
      ).join();
      final password = 'Aa9!$randomPart';
      final user = await users.create(
        session,
        scopes: partnerScopes(const <Scope>[]),
        transaction: tx,
      );
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: _email,
        password: password,
        transaction: tx,
      );
      await accessFile.writeAsString(
        'email=$_email\npassword=$password\n# Perfil: sócio principal\n# Guarde este arquivo em local privado e altere a senha após o primeiro acesso.\n',
        flush: true,
      );
      return true;
    });
    stdout.writeln(
      created
          ? 'Conta principal criada. Acesso inicial salvo em $_accessPath (não exibido no console).'
          : 'Conta principal já existente: permissões atualizadas, senha preservada.',
    );
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
}
