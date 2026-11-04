import 'dart:io';

/// Local server configuration. Process environment always takes precedence.
class LocalEnv {
  static Map<String, String> _values = const {};

  static String? get(String key) =>
      resolve(key, environment: Platform.environment, local: _values);

  /// A missing file is expected in deployments using environment variables.
  static void load({String path = '.env'}) {
    final file = File(path);
    _values = file.existsSync() ? parse(file.readAsStringSync()) : const {};
  }

  static String? resolve(
    String key, {
    required Map<String, String> environment,
    required Map<String, String> local,
  }) => environment[key] ?? local[key];

  /// Supports KEY=value, whole-line comments and quoted literal values.
  /// Errors intentionally omit the input to avoid exposing credentials.
  static Map<String, String> parse(String source) {
    final result = <String, String>{};
    final lines = source.split(RegExp(r'\r?\n'));
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final separator = line.indexOf('=');
      if (separator < 1) _invalid(index);
      final key = line.substring(0, separator).trim();
      if (!RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(key) ||
          result.containsKey(key)) {
        _invalid(index);
      }
      var value = line.substring(separator + 1).trim();
      if (value.startsWith('"') || value.startsWith("'")) {
        final quote = value[0];
        if (value.length < 2 || !value.endsWith(quote)) _invalid(index);
        value = value.substring(1, value.length - 1);
        if (value.contains(quote)) _invalid(index);
      }
      result[key] = value;
    }
    return Map.unmodifiable(result);
  }

  static Never _invalid(int index) => throw FormatException(
    'Configuração .env inválida na linha ${index + 1}.',
  );
}
