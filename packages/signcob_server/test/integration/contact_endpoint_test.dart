import 'package:signcob_server/src/generated/protocol.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Contact submission', (sessionBuilder, endpoints) {
    test('persists trimmed values and server timestamp', () async {
      final before = DateTime.now().toUtc();
      await endpoints.contact.submit(
        sessionBuilder,
        ' Ana ',
        ' ana@example.com ',
        ' Preciso de contato. ',
      );
      final rows = await ContactMessage.db.find(sessionBuilder.build());
      expect(rows, hasLength(1));
      expect(rows.single.name, 'Ana');
      expect(rows.single.email, 'ana@example.com');
      expect(rows.single.message, 'Preciso de contato.');
      expect(rows.single.createdAt.isBefore(before), isFalse);
    });

    test('rejects invalid inputs without inserting rows', () async {
      final cases = [
        ['', 'ana@example.com', 'Mensagem'],
        ['Ana', 'invalid', 'Mensagem'],
        ['Ana', 'ana@example.com', '   '],
        ['a' * 121, 'ana@example.com', 'Mensagem'],
        ['Ana', '${'a' * 250}@example.com', 'Mensagem'],
        ['Ana', 'ana@example.com', 'a' * 5001],
      ];
      for (final values in cases) {
        await expectLater(
          endpoints.contact.submit(
            sessionBuilder,
            values[0],
            values[1],
            values[2],
          ),
          throwsA(isA<ArgumentError>()),
        );
      }
      expect(await ContactMessage.db.find(sessionBuilder.build()), isEmpty);
    });
  });
}
