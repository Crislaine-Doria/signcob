import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config/local_env.dart';
import '../generated/protocol.dart';

typedef DataJudTransport =
    Future<Map<String, dynamic>> Function(
      Uri url,
      Map<String, dynamic> body,
      String key,
    );

class DataJudClient {
  DataJudClient({String? apiKey, DataJudTransport? transport})
    : _key = apiKey ?? LocalEnv.get('DATAJUD_API_KEY'),
      _transport = transport ?? _request;
  final String? _key;
  final DataJudTransport _transport;
  static const tribunals = {'tjpr', 'trt9', 'trf4'};

  static String normalizeNumber(String input) {
    if (!RegExp(r'^[0-9.\-\s]+$').hasMatch(input)) {
      throw ArgumentError('Número CNJ inválido');
    }
    final number = input.replaceAll(RegExp(r'\D'), '');
    if (number.length != 20) {
      throw ArgumentError('Informe os 20 dígitos do número CNJ');
    }
    return number;
  }

  Future<Map<String, dynamic>> fetch(String tribunal, String input) async {
    if (!tribunals.contains(tribunal)) {
      throw ArgumentError('Tribunal não suportado');
    }
    final number = normalizeNumber(input);
    if (_key == null || _key.trim().isEmpty) {
      throw DataJudException(
        message: 'Configure DATAJUD_API_KEY no servidor para consultar o CNJ.',
      );
    }
    try {
      final result = await _transport(
        Uri.https(
          'api-publica.datajud.cnj.jus.br',
          '/api_publica_$tribunal/_search',
        ),
        {
          'size': 10,
          'query': {
            'match': {'numeroProcesso': number},
          },
        },
        _key,
      ).timeout(const Duration(seconds: 25));
      final hits = (result['hits'] as Map?)?['hits'];
      if (hits is! List) throw const FormatException();
      final sources = hits
          .whereType<Map>()
          .map((h) => h['_source'])
          .whereType<Map>()
          .where((s) => s['numeroProcesso']?.toString() == number)
          .toList();
      if (sources.isEmpty) {
        throw DataJudException(
          message: 'Processo não encontrado nos dados públicos do DataJud.',
        );
      }
      sources.removeWhere(
        (s) => s['tribunal']?.toString().toLowerCase() != tribunal,
      );
      if (sources.isEmpty) {
        throw DataJudException(
          message: 'Resposta do DataJud com tribunal inconsistente.',
        );
      }
      // A process can have multiple records/instances. Prefer the most recently updated.
      sources.sort(
        (a, b) => (b['dataHoraUltimaAtualizacao']?.toString() ?? '').compareTo(
          a['dataHoraUltimaAtualizacao']?.toString() ?? '',
        ),
      );
      final source = sources.first;
      if ((source['movimentos'] != null && source['movimentos'] is! List) ||
          (source['classe'] != null && source['classe'] is! Map) ||
          (source['orgaoJulgador'] != null &&
              source['orgaoJulgador'] is! Map)) {
        throw DataJudException(message: 'Resposta inválida do DataJud.');
      }
      return Map<String, dynamic>.from(sources.first);
    } on DataJudException {
      rethrow;
    } catch (_) {
      throw DataJudException(
        message: 'Não foi possível consultar o DataJud. Tente novamente.',
      );
    }
  }

  static Future<Map<String, dynamic>> _request(
    Uri uri,
    Map<String, dynamic> body,
    String key,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.postUrl(uri);
      request.followRedirects = false;
      request.headers.contentType = ContentType.json;
      request.headers.set('Authorization', 'APIKey $key');
      request.write(jsonEncode(body));
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      if (response.statusCode != 200) {
        throw const HttpException('DataJud indisponível');
      }
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 15))) {
        bytes.addAll(chunk);
        if (bytes.length > 2 * 1024 * 1024) throw const FormatException();
      }
      return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    } finally {
      client.close(force: true);
    }
  }
}
