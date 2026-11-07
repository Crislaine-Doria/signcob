import 'dart:convert';
import 'dart:io';

import '../config/local_env.dart';
import '../generated/protocol.dart';
import 'billing_provider.dart';
import 'billing_validation.dart';

typedef AsaasTransport =
    Future<({int statusCode, String body})> Function(
      String method,
      Uri uri,
      Map<String, String> headers,
      String? body,
    );

class AsaasSandboxProvider implements BillingProvider {
  AsaasSandboxProvider({
    required String? environment,
    required String? apiKey,
    String? accountId,
    AsaasTransport? requestTransport,
  }) : _environment = environment,
       _apiKey = apiKey,
       _accountId = accountId,
       _transport = requestTransport ?? _send;

  AsaasSandboxProvider.fromEnvironment()
    : this(
        environment: LocalEnv.get('ASAAS_ENV'),
        apiKey: LocalEnv.get('ASAAS_API_KEY'),
        accountId: LocalEnv.get('ASAAS_ACCOUNT_ID'),
      );

  final String? _environment;
  final String? _apiKey;
  final String? _accountId;
  final AsaasTransport _transport;
  static const _timeout = Duration(seconds: 10);

  @override
  void ensureCreationAvailable() {
    if (_environment != 'sandbox' ||
        _apiKey == null ||
        !RegExp(r'^\$aact_hmlg_[\x21-\x7e]+$').hasMatch(_apiKey) ||
        _apiKey.trim() != _apiKey ||
        _accountId == null ||
        !RegExp(r'^[A-Za-z0-9_-]{1,100}$').hasMatch(_accountId)) {
      throw billingError(
        'provider_configuration',
        'Configure a credencial e a conta Asaas sandbox no servidor.',
      );
    }
  }

  @override
  Future<String> verifyAccount() async {
    ensureCreationAvailable();
    final result = await _request('GET', ['myAccount', 'status']);
    if (result['id'] != _accountId) {
      throw billingError(
        'account_mismatch',
        'A credencial não corresponde à conta sandbox configurada.',
      );
    }
    return _accountId!;
  }

  @override
  Future<List<ProviderCustomer>> findCustomers(String document) async {
    final rows = await _list(['customers'], {'cpfCnpj': document});
    return rows.map((row) {
      final customer = _customer(row);
      if (customer.document != document) throw _invalidResponse();
      return customer;
    }).toList();
  }

  @override
  Future<ProviderCustomer> createCustomer({
    required String name,
    required String document,
    required String externalReference,
  }) async => _customer(
    await _request(
      'POST',
      ['customers'],
      body: {
        'name': name,
        'cpfCnpj': document,
        'externalReference': externalReference,
        'notificationDisabled': true,
      },
    ),
  );

  @override
  Future<ProviderPayment> createPayment(BillingChargeRecord charge) async {
    final amount = switch (charge.flow) {
      BillingFlow.single => <String, Object?>{
        'value': charge.amountCents / 100,
      },
      BillingFlow.installment => <String, Object?>{
        'installmentCount': charge.installmentCount,
        'totalValue': charge.amountCents / 100,
      },
      BillingFlow.recurring => throw billingError(
        'invalid_input',
        'Fluxo ainda em implementação.',
      ),
      null => throw billingError(
        'invalid_input',
        'Fluxo de cobrança ausente.',
      ),
    };
    return _payment(
      await _request(
        'POST',
        ['payments'],
        body: {
          'customer': charge.providerCustomerId,
          'billingType': _method(charge.method!),
          ...amount,
          'dueDate': charge.dueDate,
          'externalReference': charge.externalReference,
          'description': charge.kind == 'debt'
              ? 'SignCob - dívida'
              : 'SignCob - honorários/serviços',
        },
      ),
    );
  }

  @override
  Future<ProviderPayment> fetchPayment(String providerId) async {
    if (!_id(providerId, 'pay_')) throw _invalidResponse();
    return _payment(await _request('GET', ['payments', providerId]));
  }

  @override
  Future<List<ProviderPayment>> findPayments(
    String customerId,
    String externalReference,
  ) async {
    if (!_id(customerId, 'cus_')) throw _invalidResponse();
    return (await _list(
      ['payments'],
      {
        'customer': customerId,
        'externalReference': externalReference,
      },
    )).map(_payment).toList();
  }

  @override
  Future<List<ProviderPayment>> listInstallmentPayments(
    String installmentId,
  ) async {
    if (!_id(installmentId)) throw _invalidResponse();
    return (await _list(
      ['installments', installmentId, 'payments'],
      {},
    )).map(_payment).toList();
  }

  @override
  Future<ProviderSubscription> createSubscription(
    BillingChargeRecord charge,
  ) async => _subscription(
    await _request(
      'POST',
      ['subscriptions'],
      body: {
        'customer': charge.providerCustomerId,
        'billingType': _method(charge.method!),
        'value': charge.amountCents / 100,
        'nextDueDate': charge.dueDate,
        'cycle': _cycle(charge.cycle!),
        'externalReference': charge.externalReference,
        'description': charge.kind == 'debt'
            ? 'SignCob - dívida recorrente'
            : 'SignCob - honorários/serviços recorrentes',
      },
    ),
  );

  @override
  Future<List<ProviderSubscription>> findSubscriptions(
    String customerId,
    String externalReference,
  ) async {
    if (!_id(customerId, 'cus_')) throw _invalidResponse();
    return (await _list(
      ['subscriptions'],
      {'customer': customerId, 'externalReference': externalReference},
    )).map(_subscription).toList();
  }

  @override
  Future<ProviderSubscription> fetchSubscription(String subscriptionId) async {
    if (!_id(subscriptionId, 'sub_')) throw _invalidResponse();
    return _subscription(
      await _request('GET', ['subscriptions', subscriptionId]),
    );
  }

  @override
  Future<List<ProviderPayment>> listSubscriptionPayments(
    String subscriptionId,
  ) async {
    if (!_id(subscriptionId, 'sub_')) throw _invalidResponse();
    return (await _list(
      ['subscriptions', subscriptionId, 'payments'],
      {},
    )).map(_payment).toList();
  }

  String _method(BillingMethod method) => switch (method) {
    BillingMethod.pix => 'PIX',
    BillingMethod.boleto => 'BOLETO',
    BillingMethod.card => 'CREDIT_CARD',
  };

  String _cycle(BillingCycle cycle) => switch (cycle) {
    BillingCycle.weekly => 'WEEKLY',
    BillingCycle.biweekly => 'BIWEEKLY',
    BillingCycle.monthly => 'MONTHLY',
    BillingCycle.bimonthly => 'BIMONTHLY',
    BillingCycle.quarterly => 'QUARTERLY',
    BillingCycle.semiannually => 'SEMIANNUALLY',
    BillingCycle.yearly => 'YEARLY',
  };

  ProviderSubscription _subscription(Map<String, dynamic> row) {
    final id = row['id'];
    final customer = row['customer'];
    final reference = row['externalReference'];
    final value = row['value'];
    final nextDueDate = row['nextDueDate'];
    final status = row['status'];
    if (!_id(id, 'sub_') ||
        !_id(customer, 'cus_') ||
        (reference != null && reference is! String) ||
        value is! num ||
        !value.isFinite ||
        value <= 0 ||
        value > 90000000000 ||
        ((value * 100).round() - value * 100).abs() > 0.001 ||
        nextDueDate is! String ||
        !billingDate(nextDueDate) ||
        status is! String ||
        status.isEmpty ||
        status.length > 100) {
      throw _invalidResponse();
    }
    final method = switch (row['billingType']) {
      'PIX' => BillingMethod.pix,
      'BOLETO' => BillingMethod.boleto,
      'CREDIT_CARD' => BillingMethod.card,
      _ => throw _invalidResponse(),
    };
    final cycle = switch (row['cycle']) {
      'WEEKLY' => BillingCycle.weekly,
      'BIWEEKLY' => BillingCycle.biweekly,
      'MONTHLY' => BillingCycle.monthly,
      'BIMONTHLY' => BillingCycle.bimonthly,
      'QUARTERLY' => BillingCycle.quarterly,
      'SEMIANNUALLY' => BillingCycle.semiannually,
      'YEARLY' => BillingCycle.yearly,
      _ => throw _invalidResponse(),
    };
    return ProviderSubscription(
      id: id as String,
      customerId: customer as String,
      externalReference: reference as String?,
      method: method,
      amountCents: (value * 100).round(),
      nextDueDate: nextDueDate,
      cycle: cycle,
      rawStatus: status,
    );
  }

  ProviderCustomer _customer(Map<String, dynamic> row) {
    final id = row['id'];
    final document = row['cpfCnpj'];
    final reference = row['externalReference'];
    if (!_id(id, 'cus_') ||
        document is! String ||
        !RegExp(r'^[0-9]{11}([0-9]{3})?$').hasMatch(document) ||
        (reference != null && reference is! String) ||
        row['deleted'] == true) {
      throw _invalidResponse();
    }
    return ProviderCustomer(
      id: id as String,
      document: document,
      externalReference: reference as String?,
    );
  }

  ProviderPayment _payment(Map<String, dynamic> row) {
    final id = row['id'];
    final customer = row['customer'];
    final reference = row['externalReference'];
    final value = row['value'];
    final dueDate = row['dueDate'];
    final status = row['status'];
    final installment = row['installment'];
    final subscription = row['subscription'];
    final number = row['installmentNumber'];
    final invoiceUrl = row['invoiceUrl'];
    if (!_id(id, 'pay_') ||
        !_id(customer, 'cus_') ||
        (reference != null && reference is! String) ||
        value is! num ||
        !value.isFinite ||
        value <= 0 ||
        value > 90000000000 ||
        ((value * 100).round() - value * 100).abs() > 0.001 ||
        dueDate is! String ||
        !billingDate(dueDate) ||
        status is! String ||
        status.isEmpty ||
        status.length > 100 ||
        (installment != null && !_id(installment)) ||
        (subscription != null && !_id(subscription, 'sub_')) ||
        (number != null && (number is! int || number < 1)) ||
        (invoiceUrl != null &&
            (invoiceUrl is! String || !_invoice(invoiceUrl)))) {
      throw _invalidResponse();
    }
    final method = switch (row['billingType']) {
      'PIX' => BillingMethod.pix,
      'BOLETO' => BillingMethod.boleto,
      'CREDIT_CARD' => BillingMethod.card,
      _ => throw _invalidResponse(),
    };
    return ProviderPayment(
      id: id as String,
      customerId: customer as String,
      externalReference: reference as String?,
      method: method,
      amountCents: (value * 100).round(),
      dueDate: dueDate,
      rawStatus: status,
      installmentId: installment as String?,
      subscriptionId: subscription as String?,
      installmentNumber: number as int?,
      invoiceUrl: invoiceUrl as String?,
    );
  }

  bool _id(Object? value, [String prefix = '']) =>
      value is String &&
      RegExp('^$prefix[A-Za-z0-9_-]{1,100}\$').hasMatch(value);

  bool _invoice(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host == 'sandbox.asaas.com' &&
        uri.port == 443 &&
        uri.userInfo.isEmpty &&
        uri.path.startsWith('/i/');
  }

  Future<List<Map<String, dynamic>>> _list(
    List<String> path,
    Map<String, String> query,
  ) async {
    final result = <Map<String, dynamic>>[];
    var offset = 0;
    for (var page = 0; page < 50; page++) {
      final response = await _request(
        'GET',
        path,
        query: {...query, 'limit': '100', 'offset': '$offset'},
      );
      final data = response['data'];
      final hasMore = response['hasMore'];
      if (data is! List || hasMore is! bool || data.length > 100) {
        throw _invalidResponse();
      }
      for (final row in data) {
        if (row is! Map<String, dynamic>) throw _invalidResponse();
        result.add(row);
      }
      if (!hasMore) return result;
      if (data.isEmpty) throw _invalidResponse();
      offset += data.length;
    }
    throw _invalidResponse();
  }

  Future<Map<String, dynamic>> _request(
    String method,
    List<String> path, {
    Map<String, String>? query,
    Map<String, Object?>? body,
  }) async {
    ensureCreationAvailable();
    final uri = Uri(
      scheme: 'https',
      host: 'api-sandbox.asaas.com',
      pathSegments: ['v3', ...path],
      queryParameters: query,
    );
    final ({int statusCode, String body}) response;
    try {
      response = await _transport(method, uri, {
        'access_token': _apiKey!,
        'User-Agent': 'SignCob/1.0',
        'Accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json',
      }, body == null ? null : jsonEncode(body)).timeout(_timeout);
    } catch (_) {
      throw _unavailable();
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw billingError(
        'provider_authentication',
        'Credencial Asaas sandbox recusada.',
      );
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw _unavailable();
    }
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) throw _invalidResponse();
      return decoded;
    } on FormatException {
      throw _invalidResponse();
    }
  }

  BillingException _invalidResponse() => billingError(
    'provider_response',
    'Resposta inválida do fornecedor de cobrança.',
  );
  BillingException _unavailable() => billingError(
    'provider_unavailable',
    'Fornecedor de cobrança indisponível.',
  );

  static Future<({int statusCode, String body})> _send(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) async {
    final client = HttpClient()..connectionTimeout = _timeout;
    try {
      return await (() async {
        final request = await client.openUrl(method, uri);
        request.followRedirects = false;
        headers.forEach(request.headers.set);
        if (body != null) request.write(body);
        final response = await request.close();
        if (response.statusCode != 200 && response.statusCode != 201) {
          return (statusCode: response.statusCode, body: '');
        }
        final bytes = <int>[];
        await for (final chunk in response) {
          if (bytes.length + chunk.length > 1024 * 1024) {
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
