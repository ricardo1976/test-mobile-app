import 'dart:io';

import 'package:cuanto_recuerdas/features/quiz/data/question_bank_validator.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/validate_questions.dart <questions.json>',
    );
    exitCode = 64;
    return;
  }

  final file = File(arguments.single);
  if (!file.existsSync()) {
    stderr.writeln('Question bank not found: ${file.path}');
    exitCode = 66;
    return;
  }
  final errors = validateQuestionBankJson(file.readAsStringSync());
  if (errors.isEmpty) {
    stdout.writeln('Question bank is valid.');
    return;
  }
  for (final error in errors) {
    stderr.writeln('- $error');
  }
  exitCode = 1;
}
