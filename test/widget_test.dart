import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/app.dart';
import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/app/services/advertising_service.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';

class _InMemoryStorage implements ProgressStorage {
  StoredProgress _value = StoredProgress.empty();

  @override
  Future<StoredProgress> load() async => _value;

  @override
  Future<void> save(StoredProgress progress) async {
    _value = progress;
  }
}

const _bank = '''
{
  "schemaVersion": 1,
  "questions": [
    {
      "id": "q1",
      "categoryId": "television",
      "decade": 1980,
      "prompt": {"es-ES": "Pregunta?"},
      "answers": [
        {"id": "a1", "text": {"es-ES": "A"}, "isCorrect": true},
        {"id": "a2", "text": {"es-ES": "B"}, "isCorrect": false},
        {"id": "a3", "text": {"es-ES": "C"}, "isCorrect": false},
        {"id": "a4", "text": {"es-ES": "D"}, "isCorrect": false}
      ],
      "explanation": {"es-ES": "Explicacion"}
    }
  ]
}
''';

void main() {
  testWidgets('shows the home screen', (WidgetTester tester) async {
    final questionRepository = QuestionRepository(
      assetLoader: () async => _bank,
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
    await tester.pumpWidget(CuantoRecuerdasApp(dependencies: dependencies));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(tester.takeException(), isNull);
  });
}
