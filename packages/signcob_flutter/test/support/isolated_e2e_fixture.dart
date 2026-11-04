import 'dart:convert';
import 'dart:io';

Map<String, dynamic> loadIsolatedE2eFixture() {
  final path = Platform.environment['SIGNCOB_E2E_MANIFEST'];
  if (path == null || path.isEmpty) {
    throw StateError('Execute tools/testing/run_isolated_e2e.dart na raiz.');
  }
  final Map<String, dynamic> fixture;
  final Uri api;
  try {
    fixture = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    api = Uri.parse(fixture['apiUrl'] as String);
  } on FormatException {
    // The decoder's original exception can include credentials.
    throw StateError('Manifesto isolado inválido.');
  }
  if (fixture['environment'] != 'signcob-isolated-e2e' ||
      fixture['database'] != 'signcob_e2e' ||
      api.scheme != 'http' ||
      api.host != '127.0.0.1' ||
      !api.hasPort ||
      api.port < 1024 ||
      api.port > 65535 ||
      const {8080, 8081, 8082, 8090, 8091, 9090, 9091}.contains(api.port) ||
      api.userInfo.isNotEmpty ||
      api.path != '/' ||
      api.hasQuery ||
      api.hasFragment) {
    throw StateError('Manifesto fora do ambiente descartável autorizado.');
  }
  return fixture;
}
