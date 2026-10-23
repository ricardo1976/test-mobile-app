import 'dart:convert';

/// Categories supported by the initial question bank.
const questionBankCategoryIds = <String>{
  'television',
  'music',
  'cinema',
  'video_games_technology',
  'everyday_culture',
};

/// Decades covered by the V0.1 product.
const questionBankDecades = <int>{1980, 1990, 2000};

/// Validates decoded `questions.json` content and returns human-readable errors.
///
/// The root object has `schemaVersion: 1` and a `questions` array. Text fields
/// (`text`, `prompt`, and `explanation`) are maps keyed by BCP 47 locale tags.
List<String> validateQuestionBank(Object? value) {
  final errors = <String>[];
  if (value is! Map) return ['Root must be a JSON object.'];

  if (value['schemaVersion'] != 1) {
    errors.add('schemaVersion must be 1.');
  }
  final questions = value['questions'];
  if (questions is! List) {
    errors.add('questions must be an array.');
    return errors;
  }

  final ids = <String>{};
  for (var i = 0; i < questions.length; i++) {
    final path = 'questions[$i]';
    final question = questions[i];
    if (question is! Map) {
      errors.add('$path must be an object.');
      continue;
    }
    for (final field in [
      'id',
      'categoryId',
      'decade',
      'prompt',
      'answers',
      'explanation',
    ]) {
      if (!question.containsKey(field) || question[field] == null) {
        errors.add('$path.$field is required.');
      }
    }

    final id = question['id'];
    if (id is String && id.trim().isNotEmpty) {
      if (!ids.add(id)) {
        errors.add('$path.id "$id" is duplicated.');
      }
    } else if (question.containsKey('id')) {
      errors.add('$path.id must be a non-empty string.');
    }

    final categoryId = question['categoryId'];
    if (categoryId is! String) {
      errors.add('$path.categoryId must be a string.');
    } else if (!questionBankCategoryIds.contains(categoryId)) {
      errors.add('$path.categoryId "$categoryId" is invalid.');
    }
    if (question['decade'] is! int ||
        !questionBankDecades.contains(question['decade'])) {
      errors.add(
        '$path.decade must be one of ${questionBankDecades.toList()..sort()}.',
      );
    }
    _validateLocalizedText(question['prompt'], '$path.prompt', errors);
    _validateLocalizedText(
      question['explanation'],
      '$path.explanation',
      errors,
    );

    final answers = question['answers'];
    if (answers is! List) {
      errors.add('$path.answers must be an array.');
      continue;
    }
    if (answers.length != 4) {
      errors.add('$path.answers must contain exactly 4 answers.');
    }
    var correctCount = 0;
    final answerIds = <String>{};
    for (var j = 0; j < answers.length; j++) {
      final answerPath = '$path.answers[$j]';
      final answer = answers[j];
      if (answer is! Map) {
        errors.add('$answerPath must be an object.');
        continue;
      }
      for (final field in ['id', 'text', 'isCorrect']) {
        if (!answer.containsKey(field) || answer[field] == null) {
          errors.add('$answerPath.$field is required.');
        }
      }
      final answerId = answer['id'];
      if (answerId is! String || answerId.trim().isEmpty) {
        errors.add('$answerPath.id must be a non-empty string.');
      } else if (!answerIds.add(answerId)) {
        errors.add('$answerPath.id "$answerId" is duplicated.');
      }
      _validateLocalizedText(answer['text'], '$answerPath.text', errors);
      if (answer['isCorrect'] is! bool) {
        errors.add('$answerPath.isCorrect must be a boolean.');
      } else if (answer['isCorrect'] == true) {
        correctCount++;
      }
    }
    if (correctCount == 0) {
      errors.add('$path must have one correct answer; none found.');
    }
    if (correctCount > 1) {
      errors.add('$path must have one correct answer; found $correctCount.');
    }
  }
  return errors;
}

void _validateLocalizedText(Object? value, String path, List<String> errors) {
  if (value is! Map || value.isEmpty) {
    errors.add('$path must be a non-empty locale-to-text object.');
    return;
  }
  for (final entry in value.entries) {
    if (entry.key is! String ||
        (entry.key as String).trim().isEmpty ||
        entry.value is! String ||
        (entry.value as String).trim().isEmpty) {
      errors.add('$path must contain non-empty locale tags and text.');
      return;
    }
  }
}

/// Decodes and validates a JSON question bank.
List<String> validateQuestionBankJson(String source) {
  try {
    return validateQuestionBank(jsonDecode(source));
  } on FormatException catch (error) {
    return ['Invalid JSON: ${error.message}'];
  }
}
