import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';

void main() {
  test('debug selection order', () {
    final questions = [
      Question(
        id: 'q1',
        categoryId: 'television',
        decade: 1980,
        prompt: {'es-ES': 'Pregunta 1?'},
        answers: [
          Answer(id: 'a1', text: {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(id: 'a2', text: {'es-ES': 'Mal 1'}, isCorrect: false),
          Answer(id: 'a3', text: {'es-ES': 'Mal 2'}, isCorrect: false),
          Answer(id: 'a4', text: {'es-ES': 'Mal 3'}, isCorrect: false),
        ],
        explanation: {'es-ES': 'Explicación 1'},
      ),
      Question(
        id: 'q2',
        categoryId: 'music',
        decade: 1990,
        prompt: {'es-ES': 'Pregunta 2?'},
        answers: [
          Answer(id: 'a1b', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a2b', text: {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(id: 'a3b', text: {'es-ES': 'Mal 2'}, isCorrect: false),
          Answer(id: 'a4b', text: {'es-ES': 'Mal 3'}, isCorrect: false),
        ],
        explanation: {'es-ES': 'Explicación 2'},
      ),
      Question(
        id: 'q3',
        categoryId: 'cinema',
        decade: 2000,
        prompt: {'es-ES': 'Pregunta 3?'},
        answers: [
          Answer(id: 'a1c', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a2c', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a3c', text: {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(id: 'a4c', text: {'es-ES': 'Mal'}, isCorrect: false),
        ],
        explanation: {'es-ES': 'Explicación 3'},
      ),
      Question(
        id: 'q4',
        categoryId: 'video_games_technology',
        decade: 1980,
        prompt: {'es-ES': 'Pregunta 4?'},
        answers: [
          Answer(id: 'a1d', text: {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(id: 'a2d', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a3d', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a4d', text: {'es-ES': 'Mal'}, isCorrect: false),
        ],
        explanation: {'es-ES': 'Explicación 4'},
      ),
      Question(
        id: 'q5',
        categoryId: 'everyday_culture',
        decade: 1990,
        prompt: {'es-ES': 'Pregunta 5?'},
        answers: [
          Answer(id: 'a1e', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a2e', text: {'es-ES': 'Correcta'}, isCorrect: true),
          Answer(id: 'a3e', text: {'es-ES': 'Mal'}, isCorrect: false),
          Answer(id: 'a4e', text: {'es-ES': 'Mal'}, isCorrect: false),
        ],
        explanation: {'es-ES': 'Explicación 5'},
      ),
    ];
    final now = DateTime.now();
    final localDate = DateTime(now.year, now.month, now.day);
    final quiz = const DailyQuizGenerator().generate(
      localDate: localDate,
      schemaVersion: 1,
      questions: questions,
    );
    // ignore: avoid_print
    print('FIRST_QUESTION_ID=${quiz.questions.first.questionId}');
    // ignore: avoid_print
    print('ORDER=${quiz.questions.map((q) => q.questionId).join(",")}');
    expect(quiz.questions.first.questionId, isNotNull);
  });
}
