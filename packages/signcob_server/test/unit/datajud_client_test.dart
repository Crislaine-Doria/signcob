import 'package:test/test.dart';
import 'package:signcob_server/src/cases/datajud_client.dart';
import 'package:signcob_server/src/generated/protocol.dart';

void main() {
  const number = '00000012020248160001';
  test('allowlist, exact source and query, sorted preferred source', () async {
    final client = DataJudClient(
      apiKey: 'test-only',
      transport: (url, body, key) async {
        expect(url.host, 'api-publica.datajud.cnj.jus.br');
        expect(url.path, '/api_publica_tjpr/_search');
        expect((body['query'] as Map)['match'], {'numeroProcesso': number});
        return {
          'hits': {
            'hits': [
              {
                '_source': {
                  'tribunal': 'TJPR',
                  'numeroProcesso': number,
                  'movimentos': [],
                },
              },
            ],
          },
        };
      },
    );
    expect((await client.fetch('tjpr', number))['tribunal'], 'TJPR');
    await expectLater(client.fetch('evil', number), throwsArgumentError);
    await expectLater(client.fetch('tjpr', 'abc'), throwsArgumentError);
  });
  test(
    'rejects missing key, different process, inconsistent court and malformed source',
    () async {
      await expectLater(
        DataJudClient(apiKey: '').fetch('tjpr', number),
        throwsA(isA<DataJudException>()),
      );
      for (final source in [
        {'tribunal': 'TJPR', 'numeroProcesso': '00000000000000000000'},
        {'tribunal': 'TRT9', 'numeroProcesso': number},
        {'tribunal': 'TJPR', 'numeroProcesso': number, 'movimentos': 'invalid'},
      ]) {
        final client = DataJudClient(
          apiKey: 'test',
          transport: (u, b, k) async => {
            'hits': {
              'hits': [
                {'_source': source},
              ],
            },
          },
        );
        await expectLater(
          client.fetch('tjpr', number),
          throwsA(isA<DataJudException>()),
        );
      }
    },
  );
}
