import 'package:flutter_test/flutter_test.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';

void main() {
  const calculator = StreakCalculator();
  final today = DateTime(2026, 10, 23, 12);

  DailyProgress progress(DateTime date, {int completedQuizzes = 1}) =>
      DailyProgress(
        date: date,
        completedQuizzes: completedQuizzes,
        correctAnswers: 0,
        totalAnswers: 0,
      );

  group('StreakCalculator', () {
    test('starts a streak on the first completed local day', () {
      final status = calculator.calculate(
        progress: [progress(today)],
        today: today,
      );

      expect(status.completedToday, isTrue);
      expect(status.completedYesterday, isFalse);
      expect(status.currentStreak, 1);
      expect(status.bestStreak, 1);
    });

    test('increments on the next day and counts a date only once', () {
      final status = calculator.calculate(
        progress: [
          progress(today.subtract(const Duration(days: 1))),
          progress(DateTime(2026, 10, 23, 8)),
          progress(DateTime(2026, 10, 23, 22)),
        ],
        today: today,
      );

      expect(status.completedToday, isTrue);
      expect(status.completedYesterday, isTrue);
      expect(status.currentStreak, 2);
      expect(status.bestStreak, 2);
    });

    test('keeps yesterday streak active but breaks after a full day gap', () {
      final yesterdayStatus = calculator.calculate(
        progress: [
          progress(DateTime(2026, 10, 21)),
          progress(DateTime(2026, 10, 22)),
        ],
        today: today,
      );
      expect(yesterdayStatus.completedYesterday, isTrue);
      expect(yesterdayStatus.currentStreak, 2);

      final brokenStatus = calculator.calculate(
        progress: [progress(DateTime(2026, 10, 21))],
        today: today,
      );
      expect(brokenStatus.completedToday, isFalse);
      expect(brokenStatus.completedYesterday, isFalse);
      expect(brokenStatus.currentStreak, 0);
      expect(brokenStatus.bestStreak, 1);
    });

    test('preserves a prior best streak and updates it for a longer run', () {
      final preserved = calculator.calculate(
        progress: [progress(today)],
        today: today,
        previousBestStreak: 5,
      );
      expect(preserved.bestStreak, 5);

      final updated = calculator.calculate(
        progress: [
          progress(DateTime(2026, 10, 20)),
          progress(DateTime(2026, 10, 21)),
          progress(DateTime(2026, 10, 22)),
          progress(today),
        ],
        today: today,
        previousBestStreak: 2,
      );
      expect(updated.currentStreak, 4);
      expect(updated.bestStreak, 4);
    });

    test('handles month and year boundaries using calendar dates', () {
      final status = calculator.calculate(
        progress: [
          progress(DateTime(2025, 12, 31)),
          progress(DateTime(2026, 1, 1)),
        ],
        today: DateTime(2026, 1, 1),
      );

      expect(status.currentStreak, 2);
      expect(status.bestStreak, 2);
    });

    test('handles the spring daylight-saving calendar boundary', () {
      // Spain advances from UTC+01:00 to UTC+02:00 on 2026-03-29.
      // Noon on consecutive local dates is therefore only 23 hours apart.
      const standardOffset = Duration(hours: 1);
      const daylightOffset = Duration(hours: 2);
      final previousLocalNoonUtc = DateTime.utc(
        2026,
        3,
        28,
        12,
      ).subtract(standardOffset);
      final currentLocalNoonUtc = DateTime.utc(
        2026,
        3,
        29,
        12,
      ).subtract(daylightOffset);

      expect(
        currentLocalNoonUtc.difference(previousLocalNoonUtc),
        const Duration(hours: 23),
      );

      // These are local civil date fields; the test does not use the machine's
      // time zone to construct or compare the dates.
      final status = calculator.calculate(
        progress: [progress(DateTime(2026, 3, 28, 12))],
        today: DateTime(2026, 3, 29, 12),
      );

      expect(status.completedYesterday, isTrue);
      expect(status.currentStreak, 1);
    });

    test('detects dates on either side of local midnight', () {
      final status = calculator.calculate(
        progress: [progress(DateTime(2026, 1, 2, 23, 59))],
        today: DateTime(2026, 1, 3, 0, 1),
      );

      expect(status.completedToday, isFalse);
      expect(status.completedYesterday, isTrue);
      expect(status.currentStreak, 1);
    });

    test('ignores incomplete progress days and future dates', () {
      final status = calculator.calculate(
        progress: [
          progress(DateTime(2026, 10, 22)),
          progress(today, completedQuizzes: 0),
          progress(DateTime(2026, 10, 24)),
        ],
        today: today,
      );

      expect(status.completedToday, isFalse);
      expect(status.completedYesterday, isTrue);
      expect(status.currentStreak, 1);
      expect(status.bestStreak, 1);
    });

    test('rejects a negative previous best streak', () {
      expect(
        () => calculator.calculate(
          progress: const [],
          today: today,
          previousBestStreak: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('LocalDate', () {
    test('compares dates without depending on local day duration', () {
      final before = LocalDate.fromDateTime(DateTime(2026, 3, 28, 23, 30));
      final after = LocalDate.fromDateTime(DateTime(2026, 3, 29, 0, 30));

      expect(after.differenceInDays(before), 1);
      expect(before.addDays(1), after);
    });
  });
}
