import 'dart:io';
import 'package:signcob_server/src/config/local_env.dart';
import 'package:test/test.dart';

void main() {
  test(
    'parses literals, quotes, comments and empty values without expansion',
    () {
      final values = LocalEnv.parse('''
# Comment
DATAJUD_API_KEY=
ASAAS_ENV = sandbox
QUOTED="literal=value"
SINGLE='hello world'
LITERAL=\$OTHER
''');
      expect(values['DATAJUD_API_KEY'], '');
      expect(values['ASAAS_ENV'], 'sandbox');
      expect(values['QUOTED'], 'literal=value');
      expect(values['SINGLE'], 'hello world');
      expect(values['LITERAL'], r'$OTHER');
    },
  );

  test('process environment takes precedence including empty values', () {
    expect(
      LocalEnv.resolve(
        'KEY',
        environment: {'KEY': 'process'},
        local: {'KEY': 'file'},
      ),
      'process',
    );
    expect(
      LocalEnv.resolve('KEY', environment: {'KEY': ''}, local: {'KEY': 'file'}),
      '',
    );
    expect(
      LocalEnv.resolve('KEY', environment: {}, local: {'KEY': 'file'}),
      'file',
    );
  });

  test('rejects malformed and duplicate entries without exposing values', () {
    for (final source in [
      'INVALID',
      '1KEY=secret',
      'KEY="secret',
      'KEY=secret\nKEY=other',
    ]) {
      expect(
        () => LocalEnv.parse(source),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'redacted',
            isNot(contains('secret')),
          ),
        ),
      );
    }
  });

  test('loads file and clears stale state when optional file is missing', () {
    final directory = Directory.systemTemp.createTempSync('signcob_env_test_');
    final file = File('${directory.path}/test.env');
    try {
      file.writeAsStringSync('SIGNCOB_TEST_LOCAL_VALUE=local');
      LocalEnv.load(path: file.path);
      expect(LocalEnv.get('SIGNCOB_TEST_LOCAL_VALUE'), 'local');
      LocalEnv.load(path: '${directory.path}/missing.env');
      expect(LocalEnv.get('SIGNCOB_TEST_LOCAL_VALUE'), isNull);
    } finally {
      file.deleteSync();
      directory.deleteSync();
    }
  });
}
