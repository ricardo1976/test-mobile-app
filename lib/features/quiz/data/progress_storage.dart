import '../domain/models.dart';

/// Domain data persisted by a [ProgressStorage].
///
/// This value is deliberately independent of the storage implementation so
/// callers can use a file-backed store, an in-memory fake, or a future adapter.
class StoredProgress {
  StoredProgress({
    required List<QuizResult> quizResults,
    required List<DailyProgress> dailyProgress,
    required this.statistics,
  }) : quizResults = List.unmodifiable(quizResults),
       dailyProgress = List.unmodifiable(dailyProgress);

  factory StoredProgress.empty() => StoredProgress(
    quizResults: const [],
    dailyProgress: const [],
    statistics: GameStatistics(
      gamesPlayed: 0,
      correctAnswers: 0,
      totalAnswers: 0,
      currentStreak: 0,
      longestStreak: 0,
    ),
  );

  final List<QuizResult> quizResults;
  final List<DailyProgress> dailyProgress;
  final GameStatistics statistics;
}

/// Replaceable boundary for loading and saving local progress.
abstract interface class ProgressStorage {
  /// Returns [StoredProgress.empty] when no progress has been saved.
  Future<StoredProgress> load();

  /// Replaces the complete persisted progress snapshot.
  Future<void> save(StoredProgress progress);
}

/// Base class for errors reported by a progress storage implementation.
abstract class ProgressStorageException implements Exception {
  const ProgressStorageException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The saved content is not valid JSON or does not match the supported format.
class MalformedProgressDataException extends ProgressStorageException {
  const MalformedProgressDataException(super.message);
}

/// The saved content uses a format version this implementation cannot read.
class UnsupportedProgressFormatVersionException
    extends ProgressStorageException {
  const UnsupportedProgressFormatVersionException(this.version)
    : super('Progress format version $version is not supported.');

  final int version;
}

/// The local storage operation failed at the file-system boundary.
class ProgressStorageIoException extends ProgressStorageException {
  const ProgressStorageIoException(super.message);
}
