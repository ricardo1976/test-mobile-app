import 'models.dart';

/// Creates a stable, balanced selection for one local calendar date.
class DailyQuizGenerator {
  const DailyQuizGenerator();

  static const questionCount = 5;
  static const _mask64 = 0xFFFFFFFFFFFFFFFF;

  /// Selects five unique questions or throws when the bank is too small.
  ///
  /// The policy prioritizes category variety first, then decade variety.
  /// At each position it chooses from the least represented available
  /// category, then the least represented decade. A stable hash of the date,
  /// schema version, and question ID breaks ties and defines the order.
  Quiz generate({
    required DateTime localDate,
    required int schemaVersion,
    required List<Question> questions,
  }) {
    if (schemaVersion < 1) {
      throw ArgumentError.value(schemaVersion, 'schemaVersion');
    }
    if (questions.length < questionCount) {
      throw StateError(
        'Daily quiz requires at least $questionCount questions; '
        'received ${questions.length}.',
      );
    }
    final ids = questions.map((question) => question.id).toSet();
    if (ids.length != questions.length) {
      throw ArgumentError.value(
        questions,
        'questions',
        'Question IDs must be unique.',
      );
    }

    final date = DateTime(localDate.year, localDate.month, localDate.day);
    final seed =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}|$schemaVersion';
    final remaining = List<Question>.of(questions);
    final categoryCounts = <String, int>{};
    final decadeCounts = <int, int>{};
    final selected = <Question>[];

    while (selected.length < questionCount) {
      remaining.sort((a, b) {
        final categoryOrder = (categoryCounts[a.categoryId] ?? 0).compareTo(
          categoryCounts[b.categoryId] ?? 0,
        );
        if (categoryOrder != 0) return categoryOrder;
        final decadeOrder = (decadeCounts[a.decade] ?? 0).compareTo(
          decadeCounts[b.decade] ?? 0,
        );
        if (decadeOrder != 0) return decadeOrder;
        final rankOrder = _rank(seed, a.id).compareTo(_rank(seed, b.id));
        return rankOrder != 0 ? rankOrder : a.id.compareTo(b.id);
      });

      final question = remaining.removeAt(0);
      selected.add(question);
      categoryCounts.update(
        question.categoryId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      decadeCounts.update(
        question.decade,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final dateId =
        '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
    return Quiz(
      id: 'daily-$dateId-v$schemaVersion',
      questions: [
        for (var i = 0; i < selected.length; i++)
          QuizQuestion(questionId: selected[i].id, position: i),
      ],
      createdAt: date,
    );
  }

  int _rank(String seed, String questionId) {
    var hash = 0xCBF29CE484222325;
    for (final byte in '$seed|$questionId'.codeUnits) {
      hash = ((hash ^ byte) * 0x100000001B3) & _mask64;
    }
    return hash;
  }
}
