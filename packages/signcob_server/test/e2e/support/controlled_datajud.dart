import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:signcob_server/src/cases/case_record_endpoint.dart';
import 'package:signcob_server/src/cases/datajud_client.dart';
import 'package:signcob_server/src/generated/endpoints.dart';

/// Test-only transport. It never opens a socket or reads DATAJUD_API_KEY.
DataJudClient createControlledDataJud() {
  final calls = <(String, String), int>{};
  return DataJudClient(
    apiKey: 'synthetic-test-key',
    transport: (url, body, key) async {
      if (url.host != 'api-publica.datajud.cnj.jus.br' ||
          key != 'synthetic-test-key') {
        throw StateError('Unexpected controlled DataJud request');
      }
      final number =
          ((body['query'] as Map)['match'] as Map)['numeroProcesso'] as String;
      final tribunal = url.path.split('/')[1].replaceFirst('api_publica_', '');
      final count = calls.update(
        (tribunal, number),
        (n) => n + 1,
        ifAbsent: () => 1,
      );
      final suffix = int.parse(number.substring(18));
      if (suffix == 12 || (suffix == 11 && count == 3)) {
        throw const HttpException('Controlled DataJud unavailable');
      }
      if (suffix == 15) {
        return {
          'hits': {'hits': <Object>[]},
        };
      }
      if (!{1, 11, 13, 14, 21}.contains(suffix)) {
        throw StateError('Unconfigured synthetic case');
      }
      return {
        'hits': {
          'hits': [
            {
              '_source': {
                'numeroProcesso': number,
                'tribunal': suffix == 14 ? 'outro' : tribunal,
                'classe': suffix == 13
                    ? 'invalid-class-shape'
                    : {'nome': 'Classe sintética $count'},
                'orgaoJulgador': {'nome': 'Vara de teste sem tribunal real'},
                'dataHoraUltimaAtualizacao': '2026-11-03T12:00:00Z',
                'movimentos': [
                  {
                    'codigo': count,
                    'nome': 'Movimento sintético $count',
                    'dataHora': '2026-11-03T12:00:00Z',
                  },
                ],
              },
            },
          ],
        },
      };
    },
  );
}

/// Generated contracts stay untouched. Only the test server replaces the
/// case connector with the same methods, backed by an injected transport.
class ControlledEndpoints extends Endpoints {
  @override
  void initializeEndpoints(Server server) {
    super.initializeEndpoints(server);
    final endpoint = CaseRecordEndpoint(
      dataJudClient: createControlledDataJud(),
    )..initialize(server, 'caseRecord', null);
    connectors['caseRecord'] = EndpointConnector(
      name: 'caseRecord',
      endpoint: endpoint,
      methodConnectors: {
        'list': MethodConnector(
          name: 'list',
          params: {
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (session, params) => endpoint.list(session, params['offset']),
        ),
        'importFromDataJud': MethodConnector(
          name: 'importFromDataJud',
          params: {
            'clientId': ParameterDescription(
              name: 'clientId',
              type: getType<int>(),
              nullable: false,
            ),
            'tribunal': ParameterDescription(
              name: 'tribunal',
              type: getType<String>(),
              nullable: false,
            ),
            'number': ParameterDescription(
              name: 'number',
              type: getType<String>(),
              nullable: false,
            ),
          },
          call: (session, params) => endpoint.importFromDataJud(
            session,
            params['clientId'],
            params['tribunal'],
            params['number'],
          ),
        ),
        'sync': MethodConnector(
          name: 'sync',
          params: {
            'id': ParameterDescription(
              name: 'id',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (session, params) => endpoint.sync(session, params['id']),
        ),
      },
    );
  }
}
