import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signcob_flutter/screens/public_home_screen.dart';

void main() {
  testWidgets(
    'public home opens calculators and contact without authentication',
    (tester) async {
      var calculators = 0;
      var contacts = 0;
      var admin = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: PublicHomeScreen(
            onCalculators: () => calculators++,
            onContact: () => contacts++,
            onAdmin: () => admin++,
          ),
        ),
      );
      await tester.tap(find.text('Acessar calculadoras'));
      await tester.tap(find.text('Contato'));
      await tester.tap(find.text('Área administrativa'));
      expect(calculators, 1);
      expect(contacts, 1);
      expect(admin, 1);
    },
  );

  testWidgets('public home fits narrow viewport and remains scrollable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: PublicHomeScreen(
          onCalculators: () {},
          onContact: () {},
          onAdmin: () {},
        ),
      ),
    );
    await tester.scrollUntilVisible(find.text('Enviar mensagem'), 250);
    expect(find.text('Enviar mensagem'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
