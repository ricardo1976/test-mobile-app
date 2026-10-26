import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/app/services/advertising_service.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';
import 'package:cuanto_recuerdas/l10n/app_localizations.dart';
import 'package:cuanto_recuerdas/features/quiz/presentation/quiz_results_screen.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';

import '../../app/test_utils.dart';

class _InMemoryStorage implements ProgressStorage {
  StoredProgress _value = StoredProgress.empty();

  @override
  Future<StoredProgress> load() async => _value;

  @override
  Future<void> save(StoredProgress progress) async {
    _value = progress;
  }
}

class _DummyQuestionRepository implements QuestionRepository {
  @override
  Future<List<Question>> getAllQuestions() async => [];

  @override
  Future<List<Question>> getQuestionsByCategory(String categoryId) async => [];

  @override
  Future<List<Question>> getQuestionsByDecade(int decade) async => [];

  @override
  Future<Question?> getQuestionById(String id) async => null;

  @override
  Future<int> getSchemaVersion() async => 1;

  @override
  Future<void> load() async {}
}

Future<AppDependencies> _buildDeps() async {
  final questionRepository = _DummyQuestionRepository();
  final storage = _InMemoryStorage();
  final progressRepository = ProgressRepository(storage: storage);
  final dependencies = AppDependencies(
    questionRepository: questionRepository,
    progressStorage: storage,
    progressRepository: progressRepository,
    dailyQuizGenerator: const DailyQuizGenerator(),
    quizScorer: const QuizScorer(),
    streakCalculator: const StreakCalculator(),
    adService: const NoOpAdService(),
    settingsStorage: testSettingsStorage(),
  );
  await dependencies.initialize();
  return dependencies;
}

Widget _buildTestApp(AppDependencies deps, QuizResult result) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: QuizResultsScreen(dependencies: deps, result: result),
  );
}

void main() {
  testWidgets('shows score and feedback on results screen', (
    WidgetTester tester,
  ) async {
    final deps = await _buildDeps();
    final result = QuizResult(
      quizId: 'daily-1',
      answers: [
        QuizAnswer(questionId: 'q1', answerId: 'a1'),
        QuizAnswer(questionId: 'q2', answerId: 'a2'),
      ],
      correctAnswers: 2,
      totalQuestions: 2,
      completedAt: DateTime.now(),
    );
    await tester.pumpWidget(_buildTestApp(deps, result));
    await tester.pumpAndSettle();

    expect(find.text('Resultados'), findsOneWidget);
    expect(find.text('Puntuación'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('¡Perfecto!'), findsOneWidget);
    expect(find.text('Volver al inicio'), findsOneWidget);
  });
}
