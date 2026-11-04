import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

final _credentialPattern = RegExp(
  r'sajrt:[A-Za-z0-9+/=:]+|(Aa9!)?[A-Za-z0-9_-]{48,}={0,2}(\.[A-Za-z0-9_-]+=*)*',
);

/// Run from the repository root with the Flutter SDK's Dart executable.
/// No package dependencies; all private state is confined to build/e2e/run-*.
Future<void> main(List<String> args) async {
  if (args.any((a) => a != '--inject-failure' && a != '--browser')) {
    stderr.writeln(
      'Usage: dart tools/testing/run_isolated_e2e.dart [--browser] [--inject-failure]',
    );
    exitCode = 64;
    return;
  }
  final root = Directory(Directory.current.resolveSymbolicLinksSync());
  final serverDir = Directory('${root.path}/packages/signcob_server');
  if (!File('${serverDir.path}/pubspec.yaml').existsSync()) {
    stderr.writeln('Run from the SignCob repository root.');
    exitCode = 64;
    return;
  }
  final runId =
      '${DateTime.now().toUtc().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 30)}';
  final containerName = 'signcob-e2e-$runId';
  final parent = Directory('${root.path}/build/e2e')
    ..createSync(recursive: true);
  String normalizedPath(String path) =>
      Platform.isWindows ? path.replaceAll('\\', '/').toLowerCase() : path;
  if (normalizedPath(parent.resolveSymbolicLinksSync()) !=
      normalizedPath('${root.path}/build/e2e')) {
    stderr.writeln('Refusing a redirected E2E workspace directory.');
    exitCode = 1;
    return;
  }
  final runtime = Directory('${parent.path}/run-$runId')..createSync();
  final manifest = File('${runtime.path}/fixture.json');
  final injectFailure = args.contains('--inject-failure');
  final browser = args.contains('--browser');
  final resultName = [
    'latest',
    if (browser) 'browser',
    injectFailure ? 'failure-probe' : 'result',
  ].join('-');
  final evidence = File('${parent.path}/$resultName.json');
  final dockerEnv = <String, String>{
    'POSTGRES_PASSWORD': base64Url.encode(
      List.generate(48, (_) => Random.secure().nextInt(256)),
    ),
  };
  Process? server;
  Process? flutter;
  Process? browserProcess;
  final browserCheckpoints = <String>[];
  const expectedCheckpoints = [
    'web-build-loaded',
    'signed-in',
    'client-created',
    'client-updated',
    'client-reloaded',
    'client-assigned-lawyer-a',
    'lawyer-a-client-visible',
    'lawyer-b-client-hidden',
    'client-reassigned-lawyer-b',
    'lawyer-a-client-hidden',
    'lawyer-b-client-visible',
    'signed-out',
    'internal-access-denied',
  ];
  Future<void>? serverOutputClosed;
  String? localDockerHost;
  var containerAttempted = false;
  var containerRemovalVerified = false;
  var completed = false;
  var cleanupOk = true;
  var stage = 'prepare';
  String? failure;
  final started = DateTime.now().toUtc();
  final signals = <StreamSubscription<ProcessSignal>>[];
  var interrupted = false;
  for (final signal in [
    ProcessSignal.sigint,
    if (!Platform.isWindows) ProcessSignal.sigterm,
  ]) {
    signals.add(signal.watch().listen((_) => interrupted = true));
  }

  Future<void> stopProcess(Process? process) async {
    if (process == null) return;
    final running = await Future.any([
      process.exitCode.then((_) => false),
      Future.delayed(Duration.zero, () => true),
    ]);
    if (!running) return;
    if (Platform.isWindows) {
      // Flutter starts a test engine child. Stop the tree before its parent.
      await Process.run('taskkill', [
        '/PID',
        '${process.pid}',
        '/T',
        '/F',
      ]).timeout(const Duration(seconds: 10));
    }
    process.kill();
    try {
      await process.exitCode.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      if (!Platform.isWindows) {
        process.kill(ProcessSignal.sigkill);
      }
      await process.exitCode.timeout(const Duration(seconds: 10));
    }
  }

  Future<ProcessResult> docker(
    List<String> arguments, {
    bool check = true,
  }) async {
    if (interrupted &&
        arguments.first != 'rm' &&
        arguments.first != 'container') {
      throw StateError('Interrupted by user.');
    }
    final process = await Process.start(
      'docker',
      [
        if (localDockerHost != null) ...['--host', localDockerHost!],
        ...arguments,
      ],
      environment: {...Platform.environment, ...dockerEnv}
        ..removeWhere(
          (key, _) =>
              localDockerHost != null &&
              {'DOCKER_HOST', 'DOCKER_CONTEXT'}.contains(key.toUpperCase()),
        ),
      includeParentEnvironment: false,
    );
    final output = process.stdout.transform(utf8.decoder).join();
    final errors = process.stderr.drain<void>();
    int code;
    try {
      code = await process.exitCode.timeout(const Duration(seconds: 45));
    } on TimeoutException {
      await stopProcess(process);
      throw StateError('Docker operation timed out: ${arguments.first}.');
    }
    await errors;
    final result = ProcessResult(process.pid, code, await output, '');
    if (check && result.exitCode != 0) {
      // Never emit raw Docker/server configuration or private output.
      throw StateError(
        'Docker operation failed: ${arguments.first} (exit ${result.exitCode}).',
      );
    }
    return result;
  }

  void copyDirectory(Directory source, Directory destination) {
    destination.createSync(recursive: true);
    for (final item in source.listSync(followLinks: false)) {
      final name = item.uri.pathSegments.where((p) => p.isNotEmpty).last;
      if (item is Directory) {
        copyDirectory(item, Directory('${destination.path}/$name'));
      } else if (item is File) {
        item.copySync('${destination.path}/$name');
      } else {
        throw StateError('Unexpected symlink in migration input.');
      }
    }
  }

  File flutterTool() {
    final snapshot = File.fromUri(
      File(
        Platform.resolvedExecutable,
      ).uri.resolve('../../flutter_tools.snapshot'),
    );
    if (!snapshot.existsSync()) {
      throw StateError('Run using Flutter SDK bin/cache/dart-sdk/bin/dart.');
    }
    return snapshot;
  }

  Future<int> waitForProcess(Process process, Duration timeout) async {
    final exited = Completer<int>();
    unawaited(process.exitCode.then(exited.complete));
    final deadline = DateTime.now().add(timeout);
    while (!exited.isCompleted) {
      if (interrupted) throw StateError('Interrupted by user.');
      if (DateTime.now().isAfter(deadline)) {
        throw StateError('Isolated E2E subprocess timed out.');
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    return exited.future;
  }

  Future<void> buildWeb() async {
    stage = 'build-web';
    flutter = await Process.start(Platform.resolvedExecutable, [
      flutterTool().path,
      '--suppress-analytics',
      'build',
      'web',
      '--no-pub',
      '--no-web-resources-cdn',
      '--base-href=/app/',
      '--output=${runtime.path}/web-build',
    ], workingDirectory: '${root.path}/packages/signcob_flutter');
    final out = flutter!.stdout.drain<void>();
    final err = flutter!.stderr.drain<void>();
    final code = await waitForProcess(flutter!, const Duration(minutes: 8));
    await Future.wait([out, err]);
    if (code != 0) throw StateError('Flutter web build failed (exit $code).');
  }

  Future<void> runBrowser() async {
    stage = 'browser';
    var failedStep = 'process';
    browserProcess = await Process.start(
      'node',
      [
        'tools/testing/browser/journey.mjs',
        manifest.path,
        if (injectFailure) '--inject-failure',
      ],
      workingDirectory: root.path,
      environment: {
        'TMPDIR': runtime.path,
        'TMP': runtime.path,
        'TEMP': runtime.path,
      },
    );
    final out = browserProcess!.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach((line) {
          if (browserCheckpoints.length < expectedCheckpoints.length &&
              line == expectedCheckpoints[browserCheckpoints.length]) {
            browserCheckpoints.add(line);
            stdout.writeln('Browser checkpoint: $line');
          } else if (const {
            'failed-launch',
            'failed-open-web-build',
            'failed-login-open',
            'failed-login-email',
            'failed-login-password',
            'failed-login-no-request',
            'failed-login-no-response',
            'failed-login-rejected',
            'failed-login-dashboard',
            'failed-create',
            'failed-open-edit',
            'failed-edit-name',
            'failed-save-edit',
            'failed-edit-rejected',
            'failed-edit-value',
            'failed-show-update',
            'failed-reread',
            'failed-assign-lawyer-a',
            'failed-check-lawyer-a-before',
            'failed-check-lawyer-b-before',
            'failed-assign-lawyer-b',
            'failed-check-lawyer-a-after',
            'failed-check-lawyer-b-after',
            'failed-logout',
            'failed-deny-access',
          }.contains(line)) {
            failedStep = line;
          }
        });
    // Browser diagnostics may contain the password or authorization headers.
    final err = browserProcess!.stderr.drain<void>();
    final code = await waitForProcess(
      browserProcess!,
      const Duration(minutes: 3),
    );
    await Future.wait([out, err]);
    if (injectFailure &&
        code == 23 &&
        browserCheckpoints.length == expectedCheckpoints.length - 2) {
      stage = 'injected-failure-after-browser-reassignment';
      throw StateError(
        'Intentional failure after browser confirmed reassignment and visibility.',
      );
    }
    if (code != 0 ||
        injectFailure ||
        browserCheckpoints.length != expectedCheckpoints.length) {
      throw StateError('Browser journey failed at $failedStep (exit $code).');
    }
  }

  Future<void> run() async {
    // Files created below can include disposable passwords and browser state.
    if (!Platform.isWindows) {
      final permissions = await Process.run('chmod', ['700', runtime.path]);
      if (permissions.exitCode != 0) {
        throw StateError(
          'Could not restrict permissions on the private runtime.',
        );
      }
    }
    if (browser) await buildWeb();
    stage = 'postgres';
    final hostOverride = Platform.environment['DOCKER_HOST'];
    final contextOverride = Platform.environment['DOCKER_CONTEXT'];
    final dockerHost =
        (contextOverride == null || contextOverride.isEmpty) &&
            hostOverride != null &&
            hostOverride.isNotEmpty
        ? hostOverride
        : (await docker([
            'context',
            'inspect',
            '--format',
            '{{.Endpoints.docker.Host}}',
          ])).stdout.toString().trim();
    if (!dockerHost.startsWith('npipe:////./pipe/') &&
        !dockerHost.startsWith('unix:///')) {
      throw StateError('The isolated runner requires a local Docker engine.');
    }
    localDockerHost = dockerHost;
    await docker(['info', '--format', '{{.ServerVersion}}']);
    containerAttempted = true;
    await docker([
      'run',
      '--detach',
      '--pull=never',
      '--name',
      containerName,
      '--label',
      'signcob.isolated-e2e=true',
      '--label',
      'signcob.e2e.run=$runId',
      '--tmpfs',
      '/var/lib/postgresql/data',
      '--publish',
      '127.0.0.1::5432',
      '--env',
      'POSTGRES_USER=postgres',
      '--env',
      'POSTGRES_DB=signcob_e2e',
      '--env',
      'POSTGRES_PASSWORD',
      'pgvector/pgvector:pg16',
    ]);
    final dataMounts = (await docker([
      'inspect',
      '--format',
      '{{json .HostConfig.Tmpfs}}',
      containerName,
    ])).stdout.toString().trim();
    final mounts = jsonDecode(dataMounts);
    if (mounts is! Map || !mounts.containsKey('/var/lib/postgresql/data')) {
      throw StateError('PostgreSQL data must be stored in temporary memory.');
    }
    final ports = (await docker([
      'port',
      containerName,
      '5432/tcp',
    ])).stdout.toString().trim();
    if (!RegExp(r'^127\.0\.0\.1:\d+$').hasMatch(ports)) {
      throw StateError('PostgreSQL must be published exclusively on loopback.');
    }
    final dbPort = int.parse(ports.split(':').last);
    if (dbPort == 8090 || dbPort == 9090) {
      throw StateError('Refusing known development/test port.');
    }
    var ready = false;
    for (var i = 0; i < 50; i++) {
      final result = await docker([
        'exec',
        containerName,
        'pg_isready',
        '-h',
        '127.0.0.1',
        '-U',
        'postgres',
        '-d',
        'signcob_e2e',
      ], check: false);
      if (result.exitCode == 0) {
        ready = true;
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    if (!ready) throw StateError('PostgreSQL startup timeout.');
    copyDirectory(
      Directory('${serverDir.path}/migrations'),
      Directory('${runtime.path}/migrations'),
    );
    File(
      '${serverDir.path}/pubspec.yaml',
    ).copySync('${runtime.path}/pubspec.yaml');
    stage = 'server';
    final childEnv = Map<String, String>.from(Platform.environment)
      ..removeWhere(
        (key, _) =>
            key.startsWith('SERVERPOD_') ||
            key.startsWith('DATAJUD_') ||
            key.startsWith('ASAAS_'),
      )
      ..addAll({
        'SIGNCOB_E2E_ISOLATED': 'signcob-isolated-e2e',
        'SIGNCOB_E2E_DB_PORT': '$dbPort',
        'SIGNCOB_E2E_DB_PASSWORD': dockerEnv['POSTGRES_PASSWORD']!,
        'SIGNCOB_E2E_MANIFEST': manifest.path,
        'SIGNCOB_E2E_BROWSER': '$browser',
        'SIGNCOB_E2E_INJECT_FAILURE': '${injectFailure && !browser}',
      });
    server = await Process.start(
      Platform.resolvedExecutable,
      [
        '--packages=${serverDir.path}/.dart_tool/package_config.json',
        '${serverDir.path}/test/e2e/support/server.dart',
      ],
      workingDirectory: runtime.path,
      environment: childEnv,
      includeParentEnvironment: false,
    );
    // Server output stays in the private runtime and is deleted at cleanup.
    final serverLogFile = File('${runtime.path}/server.log');
    final serverLog = serverLogFile.openWrite();
    serverOutputClosed = Future.wait([
      server!.stdout.forEach(serverLog.add),
      server!.stderr.forEach(serverLog.add),
    ]).whenComplete(serverLog.close);
    final died = Completer<int>();
    unawaited(server!.exitCode.then((code) => died.complete(code)));
    for (var i = 0; i < 180; i++) {
      if (interrupted) throw StateError('Interrupted by user.');
      if (manifest.existsSync()) break;
      if (died.isCompleted) {
        if (!browser) {
          await serverOutputClosed;
          final lines = serverLogFile.readAsLinesSync();
          final tail = lines.skip(max(0, lines.length - 15));
          for (final line in tail) {
            stderr.writeln(line.replaceAll(_credentialPattern, '[redacted]'));
          }
        }
        throw StateError(
          'Test server exited before readiness (exit ${await died.future}).',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    if (!manifest.existsSync()) {
      throw StateError('Server startup/fixture timeout.');
    }
    stdout.writeln(
      'Isolated PostgreSQL and real HTTP server ready; disposable identities prepared.',
    );
    if (browser) {
      await runBrowser();
      completed = true;
      stage = 'passed';
      return;
    }
    if (injectFailure) {
      stage = 'injected-failure-after-committed-fixture';
      throw StateError('Intentional failure after committed synthetic writes.');
    }
    stage = 'flutter';
    flutter = await Process.start(
      Platform.resolvedExecutable,
      [
        flutterTool().path,
        '--suppress-analytics',
        'test',
        '--no-pub',
        '--concurrency=1',
        '--dart-define=SIGNCOB_ISOLATED_E2E=true',
        'test/isolated_api_journeys_test.dart',
        'test/isolated_security_journeys_test.dart',
        '--reporter',
        'expanded',
      ],
      workingDirectory: '${root.path}/packages/signcob_flutter',
      environment: {'SIGNCOB_E2E_MANIFEST': manifest.path},
    );
    // Redact credential-shaped values even if a Flutter assertion prints
    // request details. Do not copy the private manifest into the report.
    final flutterLog = File('${parent.path}/latest-flutter.log').openWrite();
    Future<void> report(Stream<List<int>> stream, IOSink console) {
      return stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .forEach((line) {
            final safe = line.replaceAll(_credentialPattern, '[redacted]');
            console.writeln(safe);
            flutterLog.writeln(safe);
          });
    }

    final outDone = report(flutter!.stdout, stdout);
    final errDone = report(flutter!.stderr, stderr);
    final deadline = DateTime.now().add(const Duration(minutes: 8));
    final flutterExited = Completer<int>();
    unawaited(flutter!.exitCode.then(flutterExited.complete));
    try {
      while (!flutterExited.isCompleted) {
        if (interrupted) throw StateError('Interrupted by user.');
        if (DateTime.now().isAfter(deadline)) {
          throw StateError('Flutter isolated journeys timed out.');
        }
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
    } finally {
      if (!flutterExited.isCompleted) await stopProcess(flutter);
      await Future.wait([
        outDone,
        errDone,
      ]).timeout(const Duration(seconds: 10));
      await flutterLog.close();
    }
    final code = await flutterExited.future;
    if (code != 0) {
      throw StateError('Flutter isolated journeys failed (exit $code).');
    }
    completed = true;
    stage = 'passed';
  }

  try {
    await run();
  } catch (error) {
    failure = error is StateError
        ? error.message
        : error.runtimeType.toString();
    stderr.writeln('Isolated E2E failed at $stage: $failure');
    exitCode = 1;
  } finally {
    // Stop subprocesses before deleting their private files or database.
    try {
      await stopProcess(browserProcess);
    } catch (_) {
      cleanupOk = false;
      stderr.writeln('Cleanup failed for browser PID ${browserProcess?.pid}.');
    }
    try {
      await stopProcess(flutter);
    } catch (_) {
      cleanupOk = false;
      stderr.writeln('Cleanup failed for Flutter PID ${flutter?.pid}.');
    }
    try {
      await stopProcess(server);
      await serverOutputClosed?.timeout(const Duration(seconds: 10));
    } catch (_) {
      cleanupOk = false;
      stderr.writeln('Cleanup failed for server PID ${server?.pid}.');
    }
    if (containerAttempted) {
      try {
        await docker([
          'rm',
          '--force',
          '--volumes',
          containerName,
        ], check: false);
        final remaining = await docker([
          'container',
          'ls',
          '--all',
          '--quiet',
          '--filter',
          'label=signcob.e2e.run=$runId',
        ]);
        if (remaining.stdout.toString().trim().isNotEmpty) {
          throw StateError('Container still present.');
        }
        containerRemovalVerified = true;
      } catch (_) {
        cleanupOk = false;
        stderr.writeln('Cleanup failed for container $containerName.');
      }
    }
    try {
      // Verify the absolute target is our exact generated child of build/e2e.
      if (runtime.existsSync()) {
        final resolved = normalizedPath(runtime.resolveSymbolicLinksSync());
        if (resolved != normalizedPath('${root.path}/build/e2e/run-$runId')) {
          throw StateError('Refusing unsafe cleanup target.');
        }
        runtime.deleteSync(recursive: true);
      }
      if (runtime.existsSync()) throw StateError('Private runtime remains.');
    } catch (_) {
      cleanupOk = false;
      stderr.writeln('Cleanup failed for private runtime ${runtime.path}.');
    }
    for (final signal in signals) {
      await signal.cancel();
    }
    await evidence.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'environment': 'signcob-isolated-e2e',
        'startedAt': started.toIso8601String(),
        'finishedAt': DateTime.now().toUtc().toIso8601String(),
        'passed': completed && cleanupOk,
        'journeysPassed': completed,
        'stage': stage,
        'failure': failure,
        'injectedFailure': injectFailure,
        'containerCreationAttempted': containerAttempted,
        'containerRemovalVerified': containerRemovalVerified,
        'cleanupPassed': cleanupOk,
        'container': containerName,
        'privateRuntimeRemoved': !runtime.existsSync(),
        if (browser) 'browserCheckpoints': browserCheckpoints,
      }),
    );
    if (!cleanupOk) exitCode = 1;
    stdout.writeln(
      'Cleanup ${cleanupOk ? 'verified' : 'FAILED'}: disposable container/volumes and private runtime.',
    );
  }
}
