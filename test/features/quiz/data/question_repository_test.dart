import 'dart:convert';

import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the bundled bank and provides the supported queries', () async {
    final repository = QuestionRepository();

    final questions = await repository.getAllQuestions();

    expect(questions, hasLength(500));
    expect(await repository.getSchemaVersion(), 1);
    expect(
      await repository.getQuestionById(questions.first.id),
      questions.first,
    );
    expect(await repository.getQuestionById('missing-question'), isNull);
    expect(
      await repository.getQuestionsByCategory(questions.first.categoryId),
      isNotEmpty,
    );
    expect(
      await repository.getQuestionsByDecade(questions.first.decade),
      isNotEmpty,
    );
  });

  test('loads the asset only once for concurrent and later queries', () async {
    var loadCount = 0;
    final repository = QuestionRepository(
      assetLoader: () async {
        loadCount++;
        return jsonEncode(_validBank());
      },
    );

    await Future.wait([
      repository.getAllQuestions(),
      repository.getQuestionsByCategory('music'),
      repository.getSchemaVersion(),
    ]);
    await repository.getQuestionsByDecade(1990);

    expect(loadCount, 1);
  });

  test(
    'reports asset load, JSON decoding, and schema validation failures',
    () async {
      final assetFailure = QuestionRepository(
        assetLoader: () async => throw StateError('asset unavailable'),
      );
      await expectLater(
        assetFailure.load(),
        throwsA(
          isA<QuestionRepositoryException>().having(
            (error) => error.message,
            'message',
            contains('Unable to load'),
          ),
        ),
      );

      final jsonFailure = QuestionRepository(assetLoader: () async => '{');
      await expectLater(
        jsonFailure.load(),
        throwsA(
          isA<QuestionRepositoryException>().having(
            (error) => error.message,
            'message',
            contains('invalid JSON'),
          ),
        ),
      );

      final schemaFailure = QuestionRepository(
        assetLoader: () async => jsonEncode({
          'schemaVersion': 1,
          'questions': [{}],
        }),
      );
      await expectLater(
        schemaFailure.load(),
        throwsA(
          isA<QuestionRepositoryException>().having(
            (error) => error.message,
            'message',
            contains('failed validation'),
          ),
        ),
      );
    },
  );
}

Map<String, Object?> _validBank() => {
  'schemaVersion': 1,
  'questions': [
    {
      'id': 'music-1990-0001',
      'categoryId': 'music',
      'decade': 1990,
      'prompt': {'es-ES': 'Pregunta'},
      'answers': [
        {
          'id': 'a',
          'text': {'es-ES': 'A'},
          'isCorrect': true,
        },
        {
          'id': 'b',
          'text': {'es-ES': 'B'},
          'isCorrect': false,
        },
        {
          'id': 'c',
          'text': {'es-ES': 'C'},
          'isCorrect': false,
        },
        {
          'id': 'd',
          'text': {'es-ES': 'D'},
          'isCorrect': false,
        },
      ],
      'explanation': {'es-ES': 'Explicación'},
    },
  ],
};
