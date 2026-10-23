import 'dart:convert';

import 'package:cuanto_recuerdas/features/quiz/data/question_bank_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('initial question bank meets the agreed distribution and schema', () async {
    final source = await rootBundle.loadString('assets/questions.json');
    final bank = jsonDecode(source) as Map<String, dynamic>;
    final questions = bank['questions'] as List<dynamic>;

    expect(validateQuestionBank(bank), isEmpty);
    expect(questions, hasLength(500));
    expect(
      questions.map((question) => (question as Map)['prompt']['es-ES']),
      hasLength(questions.length),
    );

    final categoryCounts = <String, int>{};
    final decadeCounts = <int, int>{};
    for (final question in questions.cast<Map<String, dynamic>>()) {
      categoryCounts.update(
        question['categoryId'] as String,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      decadeCounts.update(
        question['decade'] as int,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    expect(categoryCounts, {
      'television': 125,
      'music': 100,
      'cinema': 100,
      'video_games_technology': 75,
      'everyday_culture': 100,
    });
    expect(decadeCounts.keys, containsAll([1980, 1990, 2000]));
    for (final count in decadeCounts.values) {
      expect(count, inInclusiveRange(150, 180));
    }
  });
}
