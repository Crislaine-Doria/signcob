import 'dart:convert';
import 'dart:io';

import '../config/local_env.dart';
import '../generated/protocol.dart';
import 'billing_provider.dart';

typedef AsaasStatusTransport =
    Future<({int statusCode, String body})> Function(
      Uri uri,
      Map<String, String> headers,
    );

class AsaasSandboxProvider implements BillingProvider {
  AsaasSandboxProvider({
    required String? environment,
    required String? apiKey,
    AsaasStatusTransport? transport,
  }) : _environment = environment,
       _apiKey = apiKey,
       _transport = transport ?? _get;

  AsaasSandboxProvider.fromEnvironment()
    : this(
        environment: LocalEnv.get('ASAAS_ENV'),
        apiKey: LocalEnv.get('ASAAS_API_KEY'),
      );

  final String? _environment;
  final String? _apiKey;
  final AsaasStatusTransport _transport;
  static const _timeout = Duration(seconds: 10);

  String _sandboxKey() {
    final key = _apiKey;
    if (_environment != 'sandbox' ||
        key == null ||
        !RegExp(r'^\$aact_hmlg_[\x21-\x7e]+$').hasMatch(key) ||
        key.trim() != key) {
      throw BillingException(
        code: 'provider_configuration',
        message: 'Configure uma credencial Asaas sandbox no servidor.',
      );
    }
    return key;
  }

  @override
  Never ensureCreationAvailable() {
    _sandboxKey();
    // Enable creation after deciding billing methods and how to link the
    // internal client to a sandbox customer.
    throw BillingException(
      code: 'creation_disabled',
      message: 'Criação de cobrança Asaas ainda indisponível.',
    );
  }

  @override
  Future<({String id, BillingStatus status})> create(
    BillingCharge charge,
  ) async => ensureCreationAvailable();

  @override
  Future<BillingStatus> fetchStatus(String providerId) async {
    final key = _sandboxKey();
    if (!RegExp(r'^pay_[A-Za-z0-9_-]{1,100}$').hasMatch(providerId)) {
      throw _invalidResponse();
    }
    final uri = Uri(
      scheme: 'https',
      host: 'api-sandbox.asaas.com',
      pathSegments: ['v3', 'payments', providerId, 'status'],
    );
    final ({int statusCode, String body}) result;
    try {
      result = await _transport(uri, {
        'access_token': key,
        'User-Agent': 'SignCob/1.0',
        'Accept': 'application/json',
      }).timeout(_timeout);
    } catch (_) {
      throw _unavailable();
    }
    if (result.statusCode == 401 || result.statusCode == 403) {
      throw BillingException(
        code: 'provider_authentication',
        message: 'Credencial Asaas sandbox recusada.',
      );
    }
    if (result.statusCode != 200) {
      throw _unavailable();
    }

    final Object? body;
    try {
      body = jsonDecode(result.body);
    } on FormatException {
      throw _invalidResponse();
    }
    if (body is! Map<String, dynamic> || body['status'] is! String) {
      throw _invalidResponse();
    }
    return switch (body['status']) {
      'PENDING' => BillingStatus.pending,
      'OVERDUE' => BillingStatus.overdue,
      // Payment confirmation, refunds and disputes need business rules.
      _ => throw BillingException(
        code: 'unsupported_status',
        message: 'Estado do fornecedor ainda não suportado.',
      ),
    };
  }

  static BillingException _invalidResponse() => BillingException(
    code: 'provider_response',
    message: 'Resposta inválida do fornecedor de cobrança.',
  );

  static BillingException _unavailable() => BillingException(
    code: 'provider_unavailable',
    message: 'Fornecedor de cobrança indisponível.',
  );

  static Future<({int statusCode, String body})> _get(
    Uri uri,
    Map<String, String> headers,
  ) async {
    final client = HttpClient()..connectionTimeout = _timeout;
    try {
      return await (() async {
        final request = await client.getUrl(uri);
        request.followRedirects = false;
        headers.forEach(request.headers.set);
        final response = await request.close();
        if (response.statusCode != 200) {
          return (statusCode: response.statusCode, body: '');
        }
        final bytes = <int>[];
        await for (final chunk in response) {
          if (bytes.length + chunk.length > 8192) {
            throw const FormatException();
          }
          bytes.addAll(chunk);
        }
        return (statusCode: response.statusCode, body: utf8.decode(bytes));
      })().timeout(_timeout);
    } finally {
      client.close(force: true);
    }
  }
}
