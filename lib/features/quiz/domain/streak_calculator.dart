import 'models.dart';

/// A calendar date in the device's local time zone, without a time component.
///
/// Date arithmetic is performed using UTC calendar values so local daylight
/// saving transitions do not change the number of calendar days between dates.
class LocalDate implements Comparable<LocalDate> {
  factory LocalDate.fromDateTime(DateTime dateTime) {
    final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return LocalDate._(local.year, local.month, local.day);
  }

  LocalDate._(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  LocalDate addDays(int days) {
    final date = DateTime.utc(year, month, day).add(Duration(days: days));
    return LocalDate._(date.year, date.month, date.day);
  }

  /// Returns the number of calendar days from [other] to this date.
  int differenceInDays(LocalDate other) => DateTime.utc(
    year,
    month,
    day,
  ).difference(DateTime.utc(other.year, other.month, other.day)).inDays;

  @override
  int compareTo(LocalDate other) {
    final yearOrder = year.compareTo(other.year);
    if (yearOrder != 0) return yearOrder;
    final monthOrder = month.compareTo(other.month);
    return monthOrder != 0 ? monthOrder : day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

/// The date-based quiz completion and streak state for a queried local day.
class StreakStatus {
  const StreakStatus({
    required this.completedToday,
    required this.completedYesterday,
    required this.currentStreak,
    required this.bestStreak,
  });

  final bool completedToday;
  final bool completedYesterday;
  final int currentStreak;
  final int bestStreak;
}

/// Calculates daily completion status and streaks without reading a clock.
class StreakCalculator {
  const StreakCalculator();

  /// Calculates streaks from daily progress entries as of [today].
  ///
  /// Only dates with at least one completed quiz count. Multiple entries for
  /// the same date are treated as one completion day. [previousBestStreak]
  /// preserves a best streak that may predate the supplied progress history.
  StreakStatus calculate({
    required Iterable<DailyProgress> progress,
    required DateTime today,
    int previousBestStreak = 0,
  }) {
    if (previousBestStreak < 0) {
      throw ArgumentError.value(previousBestStreak, 'previousBestStreak');
    }

    final localToday = LocalDate.fromDateTime(today);
    final completedDates = progress
        .where((entry) => entry.completedQuizzes > 0)
        .map((entry) => LocalDate.fromDateTime(entry.date))
        .where((date) => date.compareTo(localToday) <= 0)
        .toSet();
    final yesterday = localToday.addDays(-1);
    final completedToday = completedDates.contains(localToday);
    final completedYesterday = completedDates.contains(yesterday);

    final sortedDates = completedDates.toList()..sort();
    var bestFromHistory = 0;
    var runLength = 0;
    LocalDate? previous;
    for (final date in sortedDates) {
      if (previous != null && date.differenceInDays(previous) == 1) {
        runLength++;
      } else {
        runLength = 1;
      }
      if (runLength > bestFromHistory) bestFromHistory = runLength;
      previous = date;
    }

    var currentStreak = 0;
    if (completedToday || completedYesterday) {
      var date = completedToday ? localToday : yesterday;
      while (completedDates.contains(date)) {
        currentStreak++;
        date = date.addDays(-1);
      }
    }

    return StreakStatus(
      completedToday: completedToday,
      completedYesterday: completedYesterday,
      currentStreak: currentStreak,
      bestStreak: [
        previousBestStreak,
        bestFromHistory,
      ].reduce((left, right) => left > right ? left : right),
    );
  }
}
