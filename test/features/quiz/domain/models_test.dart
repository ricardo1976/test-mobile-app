import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final answer1 = Answer(
    id: 'a1',
    text: const {'es-ES': 'Respuesta'},
    isCorrect: true,
  );
  final answer2 = Answer(
    id: 'a2',
    text: const {'es-ES': 'Otra'},
    isCorrect: false,
  );
  final question = Question(
    id: 'q1',
    categoryId: 'music',
    decade: 1990,
    prompt: const {'es-ES': 'Pregunta'},
    answers: [answer1, answer2],
    explanation: const {'es-ES': 'Explicación'},
  );
  final quizQuestion = QuizQuestion(questionId: 'q1', position: 0);
  final quizAnswer = QuizAnswer(questionId: 'q1', answerId: 'a1');
  final timestamp = DateTime.utc(2026, 10, 22, 12);

  group('value equality', () {
    test('compares answer and question values including nested collections', () {
      expect(
        Answer(id: 'a1', text: const {'es-ES': 'Respuesta'}, isCorrect: true),
        answer1,
      );
      expect(
        Question(
          id: 'q1',
          categoryId: 'music',
          decade: 1990,
          prompt: const {'es-ES': 'Pregunta'},
          answers: [answer1, answer2],
          explanation: const {'es-ES': 'Explicación'},
        ),
        question,
      );
      expect(
        answer1.hashCode,
        Answer(id: 'a1', text: const {'es-ES': 'Respuesta'}, isCorrect: true)
            .hashCode,
      );
      expect(question, isNot(Question(
        id: 'q1',
        categoryId: 'music',
        decade: 1990,
        prompt: const {'es-ES': 'Pregunta distinta'},
        answers: [answer1, answer2],
      )));
    });

    test('compares quiz, result, progress and statistics by value', () {
      expect(QuizQuestion(questionId: 'q1', position: 0), quizQuestion);
      expect(QuizAnswer(questionId: 'q1', answerId: 'a1'), quizAnswer);
      expect(
        Quiz(id: 'quiz1', questions: [quizQuestion], createdAt: timestamp),
        Quiz(id: 'quiz1', questions: [quizQuestion], createdAt: timestamp),
      );
      expect(
        QuizResult(
          quizId: 'quiz1', answers: [quizAnswer], correctAnswers: 1,
          totalQuestions: 2, completedAt: timestamp,
        ),
        QuizResult(
          quizId: 'quiz1', answers: [quizAnswer], correctAnswers: 1,
          totalQuestions: 2, completedAt: timestamp,
        ),
      );
      expect(
        DailyProgress(date: timestamp, completedQuizzes: 1, correctAnswers: 1, totalAnswers: 2),
        DailyProgress(date: DateTime.utc(2026, 10, 22), completedQuizzes: 1, correctAnswers: 1, totalAnswers: 2),
      );
      expect(
        GameStatistics(gamesPlayed: 1, correctAnswers: 1, totalAnswers: 2, currentStreak: 1, longestStreak: 2),
        GameStatistics(gamesPlayed: 1, correctAnswers: 1, totalAnswers: 2, currentStreak: 1, longestStreak: 2),
      );
    });
  });

  group('JSON serialization', () {
    test('round-trips answer and question', () {
      expect(Answer.fromJson(answer1.toJson()), answer1);
      expect(Question.fromJson(question.toJson()), question);
    });

    test('round-trips quiz question, quiz, result, progress and statistics', () {
      final quiz = Quiz(id: 'quiz1', questions: [quizQuestion], createdAt: timestamp);
      final result = QuizResult(
        quizId: 'quiz1', answers: [quizAnswer], correctAnswers: 1,
        totalQuestions: 2, completedAt: timestamp,
      );
      final progress = DailyProgress(
        date: timestamp, completedQuizzes: 1, correctAnswers: 1, totalAnswers: 2,
      );
      final statistics = GameStatistics(
        gamesPlayed: 1, correctAnswers: 1, totalAnswers: 2,
        currentStreak: 1, longestStreak: 2,
      );

      expect(QuizQuestion.fromJson(quizQuestion.toJson()), quizQuestion);
      expect(Quiz.fromJson(quiz.toJson()), quiz);
      expect(QuizResult.fromJson(result.toJson()), result);
      expect(DailyProgress.fromJson(progress.toJson()), progress);
      expect(GameStatistics.fromJson(statistics.toJson()), statistics);
    });
  });

  group('basic validation', () {
    test('rejects empty identifiers and invalid localized text', () {
      expect(() => Answer(id: ' ', text: const {'es-ES': 'A'}, isCorrect: true),
          throwsArgumentError);
      expect(() => Answer(id: 'a', text: const {'es-ES': ' '}, isCorrect: true),
          throwsArgumentError);
      expect(() => Question(
        id: 'q', categoryId: 'c', decade: 1990,
        prompt: const {}, answers: [answer1, answer2],
      ), throwsArgumentError);
    });

    test('requires a valid decade, two unique answers, and exactly one correct answer', () {
      expect(() => Question(
        id: 'q', categoryId: 'c', decade: 1991,
        prompt: const {'es-ES': 'P'}, answers: [answer1, answer2],
      ), throwsArgumentError);
      expect(() => Question(
        id: 'q', categoryId: 'c', decade: 1990,
        prompt: const {'es-ES': 'P'}, answers: [answer1, answer1],
      ), throwsArgumentError);
      expect(() => Question(
        id: 'q', categoryId: 'c', decade: 1990,
        prompt: const {'es-ES': 'P'}, answers: [answer2, answer2],
      ), throwsArgumentError);
    });

    test('rejects duplicate positions, duplicate questions, and negative positions', () {
      expect(() => QuizQuestion(questionId: 'q1', position: -1), throwsArgumentError);
      expect(() => Quiz(
        id: 'quiz1',
        questions: [quizQuestion, QuizQuestion(questionId: 'q2', position: 0)],
        createdAt: timestamp,
      ), throwsArgumentError);
      expect(() => Quiz(
        id: 'quiz1',
        questions: [quizQuestion, QuizQuestion(questionId: 'q1', position: 1)],
        createdAt: timestamp,
      ), throwsArgumentError);
    });

    test('rejects inconsistent result counts, including more correct than answered', () {
      expect(() => QuizResult(
        quizId: 'quiz1', answers: const [], correctAnswers: 2,
        totalQuestions: 2, completedAt: timestamp,
      ), throwsArgumentError);
      expect(() => QuizResult(
        quizId: 'quiz1', answers: [quizAnswer], correctAnswers: 2,
        totalQuestions: 3, completedAt: timestamp,
      ), throwsArgumentError);
      expect(() => QuizResult(
        quizId: 'quiz1',
        answers: [quizAnswer, QuizAnswer(questionId: 'q1', answerId: 'a2')],
        correctAnswers: 0, totalQuestions: 2, completedAt: timestamp,
      ), throwsArgumentError);
    });

    test('rejects invalid progress and statistics counts', () {
      expect(() => DailyProgress(
        date: timestamp, completedQuizzes: -1, correctAnswers: 0, totalAnswers: 0,
      ), throwsArgumentError);
      expect(() => DailyProgress(
        date: timestamp, completedQuizzes: 0, correctAnswers: 2, totalAnswers: 1,
      ), throwsArgumentError);
      expect(() => GameStatistics(
        gamesPlayed: 0, correctAnswers: 0, totalAnswers: 0,
        currentStreak: 2, longestStreak: 1,
      ), throwsArgumentError);
    });
  });
}
