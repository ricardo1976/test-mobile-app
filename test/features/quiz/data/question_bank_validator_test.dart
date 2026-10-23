import 'package:cuanto_recuerdas/features/quiz/data/question_bank_validator.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> validQuestion({String id = 'q1'}) => {
  'id': id,
  'categoryId': 'music',
  'decade': 1990,
  'prompt': {'es-ES': 'Pregunta'},
  'explanation': {'es-ES': 'Explicación'},
  'answers': [
    {
      'id': 'a1',
      'text': {'es-ES': 'A'},
      'isCorrect': true,
    },
    {
      'id': 'a2',
      'text': {'es-ES': 'B'},
      'isCorrect': false,
    },
    {
      'id': 'a3',
      'text': {'es-ES': 'C'},
      'isCorrect': false,
    },
    {
      'id': 'a4',
      'text': {'es-ES': 'D'},
      'isCorrect': false,
    },
  ],
};

void main() {
  test('accepts a valid question bank', () {
    expect(
      validateQuestionBank({
        'schemaVersion': 1,
        'questions': [validQuestion()],
      }),
      isEmpty,
    );
  });

  test('reports duplicate IDs, invalid category and decade, and wrong answer count', () {
    final question = validQuestion()
      ..['categoryId'] = 'unknown'
      ..['decade'] = 1985;
    (question['answers'] as List).removeLast();
    final errors = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [question, validQuestion()],
    });
    expect(errors.join('\n'), contains('categoryId "unknown" is invalid'));
    expect(errors.join('\n'), contains('decade must be one of'));
    expect(errors.join('\n'), contains('exactly 4 answers'));
    expect(errors.join('\n'), contains('id "q1" is duplicated'));
  });

  test('rejects non-string categories', () {
    final question = validQuestion()..['categoryId'] = 123;
    final errors = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [question],
    });
    expect(
      errors.join('\n'),
      contains('questions[0].categoryId must be a string'),
    );
  });

  test('reports duplicate answer IDs', () {
    final question = validQuestion();
    (question['answers'] as List)[1]['id'] = 'a1';
    final errors = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [question],
    });
    expect(
      errors.join('\n'),
      contains('questions[0].answers[1].id "a1" is duplicated'),
    );
  });

  test('reports missing and multiple correct answers', () {
    final question = validQuestion();
    (question['answers'] as List)[0]['isCorrect'] = false;
    (question['answers'] as List)[1]['isCorrect'] = true;
    (question['answers'] as List)[2]['isCorrect'] = true;
    final multiple = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [question],
    });
    expect(multiple.join('\n'), contains('found 2'));

    for (final answer in question['answers'] as List) {
      answer['isCorrect'] = false;
    }
    final none = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [question],
    });
    expect(none.join('\n'), contains('none found'));
  });

  test('reports missing required fields and malformed JSON', () {
    final errors = validateQuestionBank({
      'schemaVersion': 1,
      'questions': [{}],
    });
    expect(errors.join('\n'), contains('questions[0].explanation is required'));
    expect(validateQuestionBankJson('{'), hasLength(1));
  });
}
