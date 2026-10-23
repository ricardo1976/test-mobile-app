import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/app.dart';
import 'package:cuanto_recuerdas/app/dependencies.dart';

void main() {
  testWidgets('shows the home screen', (WidgetTester tester) async {
    final progressFile = File('${Directory.systemTemp.path}/progress_test.json');
    final dependencies = await AppDependencies.create(progressFile: progressFile);
    await tester.pumpWidget(CuantoRecuerdasApp(dependencies: dependencies));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(tester.takeException(), isNull);
  });
}
