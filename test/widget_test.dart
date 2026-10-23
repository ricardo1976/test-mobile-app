import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/app.dart';
import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/features/quiz/data/file_progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';

void main() {
  testWidgets('shows the Spanish demonstration home screen', (
    WidgetTester tester,
  ) async {
    final storage = FileProgressStorage(File('progress.json'));
    final dependencies = AppDependencies(
      questionRepository: QuestionRepository(),
      progressStorage: storage,
      progressRepository: ProgressRepository(storage: storage),
      dailyQuizGenerator: const DailyQuizGenerator(),
      quizScorer: const QuizScorer(),
      streakCalculator: const StreakCalculator(),
    );

    await tester.pumpWidget(CuantoRecuerdasApp(dependencies: dependencies));
    expect(find.text('FASE DE DEMOSTRACIÓN'), findsOneWidget);
    expect(find.text('EL RETO DIARIO'), findsOneWidget);
    expect(find.text('El juego todavía no está activo.'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('es', 'ES'));
    expect(tester.takeException(), isNull);
  });
}
