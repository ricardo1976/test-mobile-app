import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final questions = List<Question>.generate(
    5,
    (index) => Question(
      id: 'q$index',
      categoryId: 'general',
      decade: 1990,
      prompt: {'es-ES': 'Question $index'},
      answers: [
        Answer(
          id: 'correct$index',
          text: {'es-ES': 'Correct'},
          isCorrect: true,
        ),
        Answer(id: 'wrong$index', text: {'es-ES': 'Wrong'}, isCorrect: false),
      ],
    ),
  );
  final quiz = Quiz(
    id: 'daily-quiz',
    questions: List<QuizQuestion>.generate(
      5,
      (index) => QuizQuestion(questionId: 'q$index', position: index),
    ),
    createdAt: DateTime.utc(2026),
  );
  final questionsById = {
    for (final question in questions) question.id: question,
  };
  const scorer = QuizScorer();

  List<QuizAnswer> answersWithCorrectCount(int correctCount) =>
      List<QuizAnswer>.generate(
        5,
        (index) => QuizAnswer(
          questionId: 'q$index',
          answerId: index < correctCount ? 'correct$index' : 'wrong$index',
        ),
      );

  group('QuizScorer', () {
    for (var expectedCorrect = 0; expectedCorrect <= 5; expectedCorrect++) {
      test('scores $expectedCorrect/5 correctly', () {
        final result = scorer.score(
          quiz: quiz,
          questionsById: questionsById,
          answers: answersWithCorrectCount(expectedCorrect),
        );

        expect(result.correctAnswers, expectedCorrect);
        expect(result.incorrectAnswers, 5 - expectedCorrect);
        expect(result.score, expectedCorrect);
        expect(result.percentage, expectedCorrect * 20);
        expect(result.answers, hasLength(5));
        expect(
          result.answers.map((answer) => answer.isCorrect),
          List<bool>.generate(5, (index) => index < expectedCorrect),
        );
      });
    }

    test('preserves submitted and correct answer details', () {
      final result = scorer.score(
        quiz: quiz,
        questionsById: questionsById,
        answers: answersWithCorrectCount(1),
      );

      expect(result.answers.first.questionId, 'q0');
      expect(result.answers.first.answerId, 'correct0');
      expect(result.answers.first.correctAnswerId, 'correct0');
      expect(result.answers.last.answerId, 'wrong4');
      expect(result.answers.last.correctAnswerId, 'correct4');
    });

    test('rejects duplicate question answers', () {
      final answers = answersWithCorrectCount(1)
        ..add(answersWithCorrectCount(1).first);

      expect(
        () => scorer.score(
          quiz: quiz,
          questionsById: questionsById,
          answers: answers,
        ),
        throwsArgumentError,
      );
    });

    test('rejects incomplete submissions', () {
      expect(
        () => scorer.score(
          quiz: quiz,
          questionsById: questionsById,
          answers: answersWithCorrectCount(1)..removeLast(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects answers that do not belong to their question', () {
      final answers = answersWithCorrectCount(0)
        ..[0] = QuizAnswer(questionId: 'q0', answerId: 'wrong1');

      expect(
        () => scorer.score(
          quiz: quiz,
          questionsById: questionsById,
          answers: answers,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a missing question definition', () {
      final incompleteQuestions = Map<String, Question>.of(questionsById)
        ..remove('q4');

      expect(
        () => scorer.score(
          quiz: quiz,
          questionsById: incompleteQuestions,
          answers: answersWithCorrectCount(1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects question definitions stored under another question ID', () {
      final crossedQuestions = Map<String, Question>.of(questionsById)
        ..['q0'] = questionsById['q1']!
        ..['q1'] = questionsById['q0']!;

      expect(
        () => scorer.score(
          quiz: quiz,
          questionsById: crossedQuestions,
          answers: answersWithCorrectCount(1),
        ),
        throwsArgumentError,
      );
    });
  });
}
