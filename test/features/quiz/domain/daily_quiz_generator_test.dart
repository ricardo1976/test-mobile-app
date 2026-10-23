import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const generator = DailyQuizGenerator();
  final questions = [
    for (var i = 0; i < 30; i++)
      Question(
        id: 'q$i',
        categoryId: ['music', 'cinema', 'television'][i % 3],
        decade: [1980, 1990, 2000][(i ~/ 3) % 3],
        prompt: const {'es-ES': 'Pregunta'},
        answers: [
          Answer(id: 'a', text: const {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(
            id: 'b',
            text: const {'es-ES': 'Incorrecta'},
            isCorrect: false,
          ),
        ],
      ),
  ];

  List<String> selected(DateTime date, int version) => generator
      .generate(localDate: date, schemaVersion: version, questions: questions)
      .questions
      .map((question) => question.questionId)
      .toList();

  test('same date, schema version, and bank yield the same ordered quiz', () {
    final first = generator.generate(
      localDate: DateTime(2026, 10, 23, 8),
      schemaVersion: 1,
      questions: questions,
    );
    final second = generator.generate(
      localDate: DateTime(2026, 10, 23, 22),
      schemaVersion: 1,
      questions: questions,
    );

    expect(second, first);
  });

  test('date and schema version affect selection order', () {
    final baseline = selected(DateTime(2026, 10, 23), 1);
    expect(selected(DateTime(2026, 10, 24), 1), isNot(baseline));
    expect(selected(DateTime(2026, 10, 23), 2), isNot(baseline));
  });

  test('selects five unique questions with category and decade balance', () {
    final quiz = generator.generate(
      localDate: DateTime(2026, 10, 23),
      schemaVersion: 1,
      questions: questions,
    );
    final byId = {for (final question in questions) question.id: question};
    final selectedQuestions = quiz.questions
        .map((item) => byId[item.questionId]!)
        .toList();

    expect(quiz.questions, hasLength(5));
    expect(quiz.questions.map((item) => item.questionId).toSet(), hasLength(5));
    expect(quiz.questions.map((item) => item.position), [0, 1, 2, 3, 4]);
    expect(
      selectedQuestions.map((question) => question.categoryId).toSet(),
      hasLength(3),
    );
    expect(
      selectedQuestions.map((question) => question.decade).toSet(),
      hasLength(3),
    );
    expect(quiz.id, 'daily-20261023-v1');
    expect(quiz.createdAt, DateTime(2026, 10, 23));
  });

  test('balances available categories before repeating any category', () {
    final smallBank = [
      for (final category in ['music', 'cinema'])
        for (var i = 0; i < 3; i++)
          Question(
            id: '$category-$i',
            categoryId: category,
            decade: 1980 + (i % 3) * 10,
            prompt: const {'es-ES': 'Pregunta'},
            answers: [
              Answer(id: 'a', text: const {'es-ES': 'Sí'}, isCorrect: true),
              Answer(id: 'b', text: const {'es-ES': 'No'}, isCorrect: false),
            ],
          ),
    ];
    final quiz = generator.generate(
      localDate: DateTime(2026, 10, 23),
      schemaVersion: 1,
      questions: smallBank,
    );
    final categories = quiz.questions
        .map(
          (item) =>
              smallBank.singleWhere((q) => q.id == item.questionId).categoryId,
        )
        .toList();

    expect(categories.where((category) => category == 'music'), hasLength(3));
    expect(categories.where((category) => category == 'cinema'), hasLength(2));
  });

  test('throws a clear error when fewer than five questions are available', () {
    expect(
      () => generator.generate(
        localDate: DateTime(2026, 10, 23),
        schemaVersion: 1,
        questions: questions.take(4).toList(),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('at least 5'),
        ),
      ),
    );
  });

  test('rejects duplicate IDs and invalid schema versions', () {
    expect(
      () => generator.generate(
        localDate: DateTime(2026, 10, 23),
        schemaVersion: 0,
        questions: questions,
      ),
      throwsArgumentError,
    );
    expect(
      () => generator.generate(
        localDate: DateTime(2026, 10, 23),
        schemaVersion: 1,
        questions: [...questions.take(5), questions.first],
      ),
      throwsArgumentError,
    );
  });
}
