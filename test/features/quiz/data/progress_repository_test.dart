import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';

class _InMemoryStorage implements ProgressStorage {
  StoredProgress _value = StoredProgress.empty();
  bool failOnSave = false;
  bool failOnLoad = false;

  @override
  Future<StoredProgress> load() async {
    if (failOnLoad) throw ProgressStorageIoException('load failed');
    return _value;
  }

  @override
  Future<void> save(StoredProgress progress) async {
    if (failOnSave) throw ProgressStorageIoException('save failed');
    _value = progress;
  }
}

void main() {
  test('first completion recorded', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo.load();
    final result = QuizResult(
      quizId: 'q1',
      answers: const [],
      correctAnswers: 0,
      totalQuestions: 5,
      completedAt: DateTime(2026, 10, 23, 10),
    );
    final outcome = await repo.recordQuiz(result);
    expect(outcome, QuizRecordResult.recorded);
    expect(repo.statistics.gamesPlayed, 1);
  });

  test('same-day duplicate ignored', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo.load();
    final result = QuizResult(
      quizId: 'q1',
      answers: const [],
      correctAnswers: 0,
      totalQuestions: 5,
      completedAt: DateTime(2026, 10, 23, 10),
    );
    await repo.recordQuiz(result);
    final outcome2 = await repo.recordQuiz(result);
    expect(outcome2, QuizRecordResult.duplicate);
    expect(repo.statistics.gamesPlayed, 1);
  });

  test('multiple distinct quizzes per day', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo.load();
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q1',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 10),
      ),
    );
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q2',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 11),
      ),
    );
    expect(repo.statistics.gamesPlayed, 2);
  });

  test('restores after recreation', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo.load();
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q1',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 10),
      ),
    );
    final repo2 = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo2.load();
    expect(repo2.statistics.gamesPlayed, 1);
  });

  test('storage failure propagates', () async {
    final storage = _InMemoryStorage();
    storage.failOnSave = true;
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 23),
    );
    await repo.load();
    expect(
      () => repo.recordQuiz(
        QuizResult(
          quizId: 'q1',
          answers: const [],
          correctAnswers: 0,
          totalQuestions: 5,
          completedAt: DateTime(2026, 10, 23, 10),
        ),
      ),
      throwsA(isA<ProgressStorageIoException>()),
    );
  });

  test('consecutive-day completion builds streak', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 25),
    );
    await repo.load();
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q1',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 10),
      ),
    );
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q2',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 24, 10),
      ),
    );
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q3',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 25, 10),
      ),
    );
    expect(repo.statistics.currentStreak, 3);
    expect(repo.statistics.longestStreak, 3);
  });

  test('missed day breaks streak', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 25),
    );
    await repo.load();
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q1',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 10),
      ),
    );
    await repo.recordQuiz(
      QuizResult(
        quizId: 'q3',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 25, 10),
      ),
    );
    expect(repo.statistics.currentStreak, 1);
    expect(repo.statistics.longestStreak, 1);
  });

  test('quiz results listed chronologically', () async {
    final storage = _InMemoryStorage();
    final repo = ProgressRepository(
      storage: storage,
      now: () => DateTime(2026, 10, 25),
    );
    await repo.load();
    await repo.recordQuiz(
      QuizResult(
        quizId: 'late',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 25, 12),
      ),
    );
    await repo.recordQuiz(
      QuizResult(
        quizId: 'early',
        answers: const [],
        correctAnswers: 0,
        totalQuestions: 5,
        completedAt: DateTime(2026, 10, 23, 8),
      ),
    );
    expect(repo.quizResults.map((r) => r.quizId).toList(), ['early', 'late']);
  });
}
