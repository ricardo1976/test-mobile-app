import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/app.dart';
import 'package:cuanto_recuerdas/app/dependencies.dart';

void main() {
  testWidgets('shows the home screen', (WidgetTester tester) async {
    final dependencies = await AppDependencies.create();
    await tester.pumpWidget(CuantoRecuerdasApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    expect(find.text('¿Cuánto recuerdas?'), findsOneWidget);
    expect(find.text('Jugar reto diario'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('es', 'ES'));
    expect(tester.takeException(), isNull);
  });
}
