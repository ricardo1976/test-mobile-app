import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/app/services/advertising_service.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';
import 'package:cuanto_recuerdas/features/quiz/presentation/quiz_screen.dart';
import 'package:cuanto_recuerdas/l10n/app_localizations.dart';

class _InMemoryStorage implements ProgressStorage {
  StoredProgress _value = StoredProgress.empty();
  @override
  Future<StoredProgress> load() async => _value;
  @override
  Future<void> save(StoredProgress progress) async {
    _value = progress;
  }
}

const _bankFive = '''
{
  "schemaVersion": 1,
  "questions": [
    {"id": "q1", "categoryId": "television", "decade": 1980, "prompt": {"es-ES": "Pregunta 1?"}, "answers": [{"id": "a1", "text": {"es-ES": "Correcta"}, "isCorrect": true}, {"id": "a2", "text": {"es-ES": "Mal 1"}, "isCorrect": false}, {"id": "a3", "text": {"es-ES": "Mal 2"}, "isCorrect": false}, {"id": "a4", "text": {"es-ES": "Mal 3"}, "isCorrect": false}], "explanation": {"es-ES": "Explicación 1"}},
    {"id": "q2", "categoryId": "music", "decade": 1990, "prompt": {"es-ES": "Pregunta 2?"}, "answers": [{"id": "a1b", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a2b", "text": {"es-ES": "Correcta"}, "isCorrect": true}, {"id": "a3b", "text": {"es-ES": "Mal 2"}, "isCorrect": false}, {"id": "a4b", "text": {"es-ES": "Mal 3"}, "isCorrect": false}], "explanation": {"es-ES": "Explicación 2"}},
    {"id": "q3", "categoryId": "cinema", "decade": 2000, "prompt": {"es-ES": "Pregunta 3?"}, "answers": [{"id": "a1c", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a2c", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a3c", "text": {"es-ES": "Correcta"}, "isCorrect": true}, {"id": "a4c", "text": {"es-ES": "Mal"}, "isCorrect": false}], "explanation": {"es-ES": "Explicación 3"}},
    {"id": "q4", "categoryId": "video_games_technology", "decade": 1980, "prompt": {"es-ES": "Pregunta 4?"}, "answers": [{"id": "a1d", "text": {"es-ES": "Correcta"}, "isCorrect": true}, {"id": "a2d", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a3d", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a4d", "text": {"es-ES": "Mal"}, "isCorrect": false}], "explanation": {"es-ES": "Explicación 4"}},
    {"id": "q5", "categoryId": "everyday_culture", "decade": 1990, "prompt": {"es-ES": "Pregunta 5?"}, "answers": [{"id": "a1e", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a2e", "text": {"es-ES": "Correcta"}, "isCorrect": true}, {"id": "a3e", "text": {"es-ES": "Mal"}, "isCorrect": false}, {"id": "a4e", "text": {"es-ES": "Mal"}, "isCorrect": false}], "explanation": {"es-ES": "Explicación 5"}}
  ]
}
''';

Future<AppDependencies> _buildDeps() async {
  final questionRepository = QuestionRepository(
    assetLoader: () async => _bankFive,
  );
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
  );
  await dependencies.initialize();
  return dependencies;
}

Widget _buildTestApp(AppDependencies deps) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: QuizScreen(dependencies: deps),
  );
}

void main() {
  testWidgets('debug current question text', (WidgetTester tester) async {
    final deps = await _buildDeps();
    await tester.pumpWidget(_buildTestApp(deps));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // ignore: avoid_print
    print(
      'CURRENT_TEXTS=${tester.widgetList(find.byType(Text)).map((w) => (w as Text).data).join("|")}',
    );
  });
}
