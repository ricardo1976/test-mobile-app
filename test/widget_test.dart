import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/app.dart';

void main() {
  testWidgets('shows the Spanish demonstration home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CuantoRecuerdasApp());
    expect(find.text('FASE DE DEMOSTRACIÓN'), findsOneWidget);
    expect(find.text('EL RETO DIARIO'), findsOneWidget);
    expect(find.text('El juego todavía no está activo.'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('es', 'ES'));
    expect(tester.takeException(), isNull);
  });
}
