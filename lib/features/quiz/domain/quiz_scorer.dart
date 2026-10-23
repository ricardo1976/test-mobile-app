import 'models.dart';

/// The evaluation of one submitted answer against its question's correct choice.
class ScoredAnswer {
  const ScoredAnswer({
    required this.questionId,
    required this.answerId,
    required this.correctAnswerId,
    required this.isCorrect,
  });

  final String questionId;
  final String answerId;
  final String correctAnswerId;
  final bool isCorrect;
}

/// The score and per-question evaluation for a completed quiz.
class ScoredQuizResult {
  ScoredQuizResult({required List<ScoredAnswer> answers})
    : answers = List.unmodifiable(answers),
      correctAnswers = answers.where((answer) => answer.isCorrect).length,
      incorrectAnswers = answers.where((answer) => !answer.isCorrect).length;

  final List<ScoredAnswer> answers;
  final int correctAnswers;
  final int incorrectAnswers;

  /// The score is the number of correct answers.
  int get score => correctAnswers;

  /// Accuracy expressed from 0 to 100.
  double get percentage => answers.isEmpty ? 0 : score * 100 / answers.length;
}

/// Evaluates answers for a completed quiz without depending on Flutter UI.
class QuizScorer {
  const QuizScorer();

  ScoredQuizResult score({
    required Quiz quiz,
    required Map<String, Question> questionsById,
    required List<QuizAnswer> answers,
  }) {
    final quizQuestionIds = quiz.questions
        .map((item) => item.questionId)
        .toSet();
    final submittedQuestionIds = answers
        .map((answer) => answer.questionId)
        .toSet();

    if (answers.length != quizQuestionIds.length ||
        submittedQuestionIds.length != answers.length ||
        submittedQuestionIds.length != quizQuestionIds.length ||
        !submittedQuestionIds.containsAll(quizQuestionIds)) {
      throw ArgumentError.value(
        answers,
        'answers',
        'Must contain exactly one answer for every quiz question',
      );
    }

    final scoredAnswers = <ScoredAnswer>[];
    for (final submitted in answers) {
      final question = questionsById[submitted.questionId];
      if (question == null) {
        throw ArgumentError.value(
          submitted.questionId,
          'questionsById',
          'Missing question for quiz answer',
        );
      }
      if (!quizQuestionIds.contains(question.id)) {
        throw ArgumentError.value(
          submitted.questionId,
          'answers',
          'Answer does not belong to this quiz',
        );
      }

      final correctAnswer = question.answers.singleWhere(
        (answer) => answer.isCorrect,
      );
      if (!question.answers.any((answer) => answer.id == submitted.answerId)) {
        throw ArgumentError.value(
          submitted.answerId,
          'answerId',
          'Answer does not belong to its question',
        );
      }

      scoredAnswers.add(
        ScoredAnswer(
          questionId: submitted.questionId,
          answerId: submitted.answerId,
          correctAnswerId: correctAnswer.id,
          isCorrect: submitted.answerId == correctAnswer.id,
        ),
      );
    }

    return ScoredQuizResult(answers: scoredAnswers);
  }
}
