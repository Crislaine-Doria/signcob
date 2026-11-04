import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:signcob_server/src/access/partner_profile.dart';
import 'package:signcob_server/src/generated/protocol.dart';
import 'package:signcob_server/src/web/routes/app_config_route.dart';

import 'controlled_datajud.dart';

String _secret() {
  final random = Random.secure();
  return base64Url.encode(List.generate(48, (_) => random.nextInt(256)));
}

/// Test-only entry point. It never loads the application's .env or config.
Future<void> main() async {
  final env = Platform.environment;
  final manifestPath = env['SIGNCOB_E2E_MANIFEST'];
  final dbPort = int.tryParse(env['SIGNCOB_E2E_DB_PORT'] ?? '');
  final dbPassword = env['SIGNCOB_E2E_DB_PASSWORD'];
  final webBuild = Directory('web-build');
  final serveWeb = env['SIGNCOB_E2E_BROWSER'] == 'true';
  if (env['SIGNCOB_E2E_ISOLATED'] != 'signcob-isolated-e2e' ||
      manifestPath == null ||
      dbPort == null ||
      dbPort <= 0 ||
      dbPort == 8090 ||
      dbPort == 9090 ||
      dbPassword == null ||
      dbPassword.isEmpty ||
      (serveWeb && !File('${webBuild.path}/index.html').existsSync()) ||
      File('config/passwords.yaml').existsSync() ||
      File('.env').existsSync()) {
    throw StateError('Isolated E2E runner context required.');
  }
  final localServer = ServerConfig(
    port: 0,
    publicHost: '127.0.0.1',
    publicPort: 0,
    publicScheme: 'http',
  );
  final pod = Serverpod(
    ['--mode=test', '--apply-migrations'],
    Protocol(),
    ControlledEndpoints(),
    config: ServerpodConfig(
      runMode: 'test',
      apiServer: localServer,
      webServer: serveWeb ? localServer : null,
      database: DatabaseConfig(
        host: '127.0.0.1',
        port: dbPort,
        user: 'postgres',
        password: dbPassword,
        name: 'signcob_e2e',
      ),
      sessionLogs: SessionLogConfig(
        persistentEnabled: false,
        consoleEnabled: false,
      ),
      futureCallExecutionEnabled: false,
    ),
  );
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfig(
        algorithm: JwtAlgorithm.hmacSha512(SecretKey(_secret())),
        refreshTokenHashPepper: _secret(),
      ),
    ],
    identityProviderBuilders: [
      EmailIdpConfig(
        secretHashPepper: _secret(),
        // No email transport and no verification codes in logs.
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
  // Serverpod 3.2.3 binds its API socket on anyIPv6 internally. Reject every
  // non-loopback peer using the actual socket address, never forwarded headers.
  Handler loopbackOnly(Handler next) => (request) async {
    final address = InternetAddress.tryParse(
      request.connectionInfo.remote.address.toString(),
    );
    final bytes = address?.rawAddress;
    final mappedLoopback =
        bytes != null &&
        bytes.length == 16 &&
        bytes.take(10).every((b) => b == 0) &&
        bytes[10] == 255 &&
        bytes[11] == 255 &&
        bytes[12] == 127;
    if (!(address?.isLoopback ?? false) && !mappedLoopback) {
      return Response.forbidden();
    }
    return next(request);
  };
  pod.server.addMiddleware(loopbackOnly);
  if (serveWeb) {
    pod.webServer.addMiddleware(loopbackOnly, '/');
    pod.webServer.addRoute(
      _BrowserAppConfig(() => pod.server.port),
      '/app/assets/assets/config.json',
    );
    // The build is separate from the manifest, logs, migrations and profile.
    pod.webServer.addRoute(FlutterRoute(webBuild), '/app');
  }
  await pod.start();
  if (serveWeb && pod.webServer.port == null) {
    throw StateError('Isolated web server did not start.');
  }
  final session = await pod.createSession();
  try {
    // This check runs before the first write, in addition to the config guard.
    final db = await session.db.unsafeQuery('SELECT current_database()');
    if (db.single.single != 'signcob_e2e') {
      throw StateError('Unexpected database; refusing fixture writes.');
    }
    final users = <String, Map<String, Object?>>{};
    final lawyerScopes = {
      const Scope('clients.read'),
      const Scope('clients.write'),
      const Scope('cases.read'),
      const Scope('cases.write'),
      const Scope('negotiations.read'),
      const Scope('negotiations.write'),
    };
    for (final role in [
      'manager',
      'lawyerA',
      'lawyerB',
      'owner',
      'noScopes',
      'blocked',
      'revoked',
    ]) {
      final scopes = switch (role) {
        'lawyerA' || 'lawyerB' => lawyerScopes,
        'owner' => {const Scope('cases.read')},
        'noScopes' => <Scope>{},
        _ => partnerScopes(const <Scope>[]),
      };
      final user = await AuthServices.instance.authUsers.create(
        session,
        scopes: scopes,
      );
      final password = 'Aa9!${_secret()}';
      final email = '${role.toLowerCase()}@signcob-e2e.invalid';
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: password,
      );
      final fixture = users[role] = {
        'userId': user.id.toString(),
        'email': email,
        'password': password,
      };
      if (role == 'blocked') {
        final priorAuth = await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: user.id,
          method: 'email',
          scopes: scopes,
        );
        fixture['authSuccess'] = priorAuth.toJson();
        await AuthServices.instance.authUsers.update(
          session,
          authUserId: user.id,
          blocked: true,
        );
      }
    }
    if (env['SIGNCOB_E2E_INJECT_FAILURE'] == 'true') {
      await ContactMessage.db.insertRow(
        session,
        ContactMessage(
          name: 'Cleanup failure probe',
          email: 'cleanup@signcob-e2e.invalid',
          message: 'Committed synthetic fixture before injected failure.',
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }
    final target = File('$manifestPath.tmp');
    await target.writeAsString(
      jsonEncode({
        'environment': 'signcob-isolated-e2e',
        'database': 'signcob_e2e',
        'apiUrl': 'http://127.0.0.1:${pod.server.port}/',
        if (serveWeb) 'webUrl': 'http://127.0.0.1:${pod.webServer.port}/app/',
        'users': users,
      }),
      flush: true,
    );
    await target.rename(manifestPath);
    stdout.writeln('SIGNCOB_E2E_READY');
  } finally {
    await session.close();
  }
}

class _BrowserAppConfig extends WidgetRoute {
  _BrowserAppConfig(this.apiPort);

  final int Function() apiPort;

  @override
  Future<WebWidget> build(Session session, Request request) async =>
      AppConfigWidget(apiUrl: 'http://127.0.0.1:${apiPort()}/');
}
