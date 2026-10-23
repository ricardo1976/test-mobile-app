import '../domain/models.dart';
import '../domain/streak_calculator.dart';
import 'progress_storage.dart';

enum QuizRecordResult { recorded, duplicate }

class ProgressRepository {
  ProgressRepository({
    required this._storage,
    DateTime Function()? now,
    StreakCalculator? streakCalculator,
  }) : _now = now ?? DateTime.now,
       _streakCalculator = streakCalculator ?? const StreakCalculator();

  final ProgressStorage _storage;
  final DateTime Function() _now;
  final StreakCalculator _streakCalculator;

  StoredProgress _progress = StoredProgress.empty();
  bool _loaded = false;

  Future<StoredProgress> load() async {
    final loaded = await _storage.load();
    final sortedResults = [...loaded.quizResults]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));
    final stats = _recomputeStatistics(sortedResults, loaded.statistics);
    _progress = StoredProgress(
      quizResults: sortedResults,
      dailyProgress: loaded.dailyProgress,
      statistics: stats,
    );
    _recomputeStreak();
    _loaded = true;
    return _progress;
  }

  StoredProgress get progress => _progress;

  List<QuizResult> get quizResults => _progress.quizResults;
  List<DailyProgress> get dailyProgress => _progress.dailyProgress;
  GameStatistics get statistics => _progress.statistics;

  bool completedToday() {
    final today = LocalDate.fromDateTime(_now());
    return _progress.dailyProgress.any(
      (entry) =>
          LocalDate.fromDateTime(entry.date) == today &&
          entry.completedQuizzes > 0,
    );
  }

  bool completedQuizToday(String quizId) {
    final today = LocalDate.fromDateTime(_now());
    return _progress.quizResults.any(
      (result) =>
          result.quizId == quizId &&
          LocalDate.fromDateTime(result.completedAt) == today,
    );
  }

  Future<QuizRecordResult> recordQuiz(QuizResult result) async {
    if (!_loaded) {
      await load();
    }
    final today = LocalDate.fromDateTime(_now());
    final resultDate = LocalDate.fromDateTime(result.completedAt);
    if (resultDate != today) {
      // still record but use result date; duplicate check by day+quiz
    }
    final isDuplicate = _progress.quizResults.any(
      (existing) =>
          existing.quizId == result.quizId &&
          LocalDate.fromDateTime(existing.completedAt) ==
              LocalDate.fromDateTime(result.completedAt),
    );
    if (isDuplicate) {
      return QuizRecordResult.duplicate;
    }

    final newResults = [..._progress.quizResults, result]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));

    // Update daily progress for result date.
    final date = DateTime(
      result.completedAt.year,
      result.completedAt.month,
      result.completedAt.day,
    );
    final existingIndex = _progress.dailyProgress.indexWhere(
      (entry) => entry.date == date,
    );
    DailyProgress updatedDay;
    final newDaily = List<DailyProgress>.from(_progress.dailyProgress);
    if (existingIndex >= 0) {
      final existing = newDaily[existingIndex];
      updatedDay = DailyProgress(
        date: existing.date,
        completedQuizzes: existing.completedQuizzes + 1,
        correctAnswers: existing.correctAnswers + result.correctAnswers,
        totalAnswers: existing.totalAnswers + result.totalQuestions,
      );
      newDaily[existingIndex] = updatedDay;
    } else {
      updatedDay = DailyProgress(
        date: date,
        completedQuizzes: 1,
        correctAnswers: result.correctAnswers,
        totalAnswers: result.totalQuestions,
      );
      newDaily.add(updatedDay);
    }

    final stats = _progress.statistics;
    final newStats = GameStatistics(
      gamesPlayed: stats.gamesPlayed + 1,
      correctAnswers: stats.correctAnswers + result.correctAnswers,
      totalAnswers: stats.totalAnswers + result.totalQuestions,
      currentStreak: stats.currentStreak,
      longestStreak: stats.longestStreak,
    );

    _progress = StoredProgress(
      quizResults: newResults,
      dailyProgress: newDaily,
      statistics: newStats,
    );
    _recomputeStreak();
    await _storage.save(_progress);
    return QuizRecordResult.recorded;
  }

  void _recomputeStreak() {
    final status = _streakCalculator.calculate(
      progress: _progress.dailyProgress,
      today: _now(),
      previousBestStreak: _progress.statistics.longestStreak,
    );
    final stats = _progress.statistics;
    final newStats = GameStatistics(
      gamesPlayed: stats.gamesPlayed,
      correctAnswers: stats.correctAnswers,
      totalAnswers: stats.totalAnswers,
      currentStreak: status.currentStreak,
      longestStreak: status.bestStreak,
    );
    _progress = StoredProgress(
      quizResults: _progress.quizResults,
      dailyProgress: _progress.dailyProgress,
      statistics: newStats,
    );
  }

  GameStatistics _recomputeStatistics(
    List<QuizResult> results,
    GameStatistics existing,
  ) {
    return GameStatistics(
      gamesPlayed: results.length,
      correctAnswers: results.fold<int>(0, (sum, r) => sum + r.correctAnswers),
      totalAnswers: results.fold<int>(0, (sum, r) => sum + r.totalQuestions),
      currentStreak: existing.currentStreak,
      longestStreak: existing.longestStreak,
    );
  }
}
