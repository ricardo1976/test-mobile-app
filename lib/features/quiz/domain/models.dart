/// Immutable domain models used by the quiz and progress features.
///
/// User-visible question and answer text is stored by locale (for example,
/// `es-ES`) so domain data never assumes a single application language.
library;

typedef LocalizedText = Map<String, String>;

Map<String, String> _localizedText(LocalizedText value, String field) {
  if (value.isEmpty || value.keys.any((key) => key.trim().isEmpty) ||
      value.values.any((text) => text.trim().isEmpty)) {
    throw ArgumentError.value(value, field, 'Must contain non-empty locales and text');
  }
  return Map.unmodifiable(value);
}

void _nonEmpty(String value, String field) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, field, 'Must not be empty');
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  return a.entries.every((entry) => b[entry.key] == entry.value);
}

int _mapHash<K, V>(Map<K, V> value) => Object.hashAllUnordered(
      value.entries.map((entry) => Object.hash(entry.key, entry.value)),
    );

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _listHash<T>(List<T> value) => Object.hashAll(value);

/// A localized answer choice belonging to a question.
class Answer {
  Answer({required this.id, required LocalizedText text, required this.isCorrect})
      : text = _localizedText(text, 'text') {
    _nonEmpty(id, 'id');
  }

  final String id;
  final Map<String, String> text;
  final bool isCorrect;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as String,
        text: Map<String, String>.from(json['text'] as Map),
        isCorrect: json['isCorrect'] as bool,
      );

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'isCorrect': isCorrect};

  @override
  bool operator ==(Object other) =>
      other is Answer && other.id == id && other.isCorrect == isCorrect && _mapEquals(other.text, text);

  @override
  int get hashCode => Object.hash(id, isCorrect, _mapHash(text));
}

/// A localized multiple-choice question.
class Question {
  Question({
    required this.id,
    required this.categoryId,
    required this.decade,
    required LocalizedText prompt,
    required List<Answer> answers,
    LocalizedText? explanation,
  })  : prompt = _localizedText(prompt, 'prompt'),
        answers = List.unmodifiable(answers),
        explanation = explanation == null ? null : _localizedText(explanation, 'explanation') {
    _nonEmpty(id, 'id');
    _nonEmpty(categoryId, 'categoryId');
    if (decade < 1900 || decade % 10 != 0) {
      throw ArgumentError.value(decade, 'decade', 'Must be a decade year (for example, 1990)');
    }
    if (answers.length < 2 || answers.map((answer) => answer.id).toSet().length != answers.length) {
      throw ArgumentError.value(answers, 'answers', 'Must contain at least two uniquely identified answers');
    }
    if (answers.where((answer) => answer.isCorrect).length != 1) {
      throw ArgumentError.value(answers, 'answers', 'Must contain exactly one correct answer');
    }
  }

  final String id;
  final String categoryId;
  final int decade;
  final Map<String, String> prompt;
  final List<Answer> answers;
  final Map<String, String>? explanation;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        categoryId: json['categoryId'] as String,
        decade: json['decade'] as int,
        prompt: Map<String, String>.from(json['prompt'] as Map),
        answers: (json['answers'] as List)
            .map((answer) => Answer.fromJson(Map<String, dynamic>.from(answer as Map)))
            .toList(),
        explanation: json['explanation'] == null
            ? null
            : Map<String, String>.from(json['explanation'] as Map),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'decade': decade,
        'prompt': prompt,
        'answers': answers.map((answer) => answer.toJson()).toList(),
        if (explanation != null) 'explanation': explanation,
      };

  @override
  bool operator ==(Object other) => other is Question &&
      other.id == id && other.categoryId == categoryId && other.decade == decade &&
      _mapEquals(other.prompt, prompt) && _listEquals(other.answers, answers) &&
      (explanation == null ? other.explanation == null : other.explanation != null && _mapEquals(other.explanation!, explanation!));

  @override
  int get hashCode => Object.hash(id, categoryId, decade, _mapHash(prompt), _listHash(answers),
      explanation == null ? null : _mapHash(explanation!));
}

/// A question's position in a quiz.
class QuizQuestion {
  QuizQuestion({required this.questionId, required this.position}) {
    _nonEmpty(questionId, 'questionId');
    if (position < 0) throw ArgumentError.value(position, 'position', 'Must be zero or greater');
  }

  final String questionId;
  final int position;

  Map<String, dynamic> toJson() => {'questionId': questionId, 'position': position};
  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      QuizQuestion(questionId: json['questionId'] as String, position: json['position'] as int);

  @override
  bool operator ==(Object other) => other is QuizQuestion && other.questionId == questionId && other.position == position;
  @override
  int get hashCode => Object.hash(questionId, position);
}

/// A quiz definition and its ordered question references.
class Quiz {
  Quiz({required this.id, required List<QuizQuestion> questions, required this.createdAt})
      : questions = List.unmodifiable(questions) {
    _nonEmpty(id, 'id');
    if (questions.isEmpty ||
        questions.map((item) => item.position).toSet().length != questions.length ||
        questions.map((item) => item.questionId).toSet().length != questions.length) {
      throw ArgumentError.value(
        questions,
        'questions',
        'Must be non-empty with unique positions and question IDs',
      );
    }
  }

  final String id;
  final List<QuizQuestion> questions;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'questions': questions.map((item) => item.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'] as String,
        questions: (json['questions'] as List)
            .map((item) => QuizQuestion.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  bool operator ==(Object other) => other is Quiz && other.id == id && other.createdAt == createdAt && _listEquals(other.questions, questions);
  @override
  int get hashCode => Object.hash(id, createdAt, _listHash(questions));
}

/// The user's selected answer for a question in a quiz.
class QuizAnswer {
  QuizAnswer({required this.questionId, required this.answerId}) {
    _nonEmpty(questionId, 'questionId');
    _nonEmpty(answerId, 'answerId');
  }

  final String questionId;
  final String answerId;

  @override
  bool operator ==(Object other) =>
      other is QuizAnswer && other.questionId == questionId && other.answerId == answerId;

  @override
  int get hashCode => Object.hash(questionId, answerId);
}

/// The recorded outcome of a completed quiz.
class QuizResult {
  QuizResult({
    required this.quizId,
    required List<QuizAnswer> answers,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.completedAt,
  }) : answers = List.unmodifiable(answers) {
    _nonEmpty(quizId, 'quizId');
    if (answers.map((answer) => answer.questionId).toSet().length != answers.length) {
      throw ArgumentError.value(answers, 'answers', 'Must not contain multiple answers for one question');
    }
    if (correctAnswers < 0 || totalQuestions < 0 || correctAnswers > totalQuestions ||
        answers.length > totalQuestions) {
      throw ArgumentError('Result counts must be non-negative and cannot exceed totalQuestions');
    }
  }

  final String quizId;
  final List<QuizAnswer> answers;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime completedAt;
  int get answeredCount => answers.length;

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'answers': answers.map((answer) => {'questionId': answer.questionId, 'answerId': answer.answerId}).toList(),
        'correctAnswers': correctAnswers,
        'totalQuestions': totalQuestions,
        'completedAt': completedAt.toIso8601String(),
      };
  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        quizId: json['quizId'] as String,
        answers: (json['answers'] as List).map((item) {
          final answer = Map<String, dynamic>.from(item as Map);
          return QuizAnswer(questionId: answer['questionId'] as String, answerId: answer['answerId'] as String);
        }).toList(),
        correctAnswers: json['correctAnswers'] as int,
        totalQuestions: json['totalQuestions'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  @override
  bool operator ==(Object other) => other is QuizResult && other.quizId == quizId &&
      other.completedAt == completedAt && other.correctAnswers == correctAnswers &&
      other.totalQuestions == totalQuestions && _listEquals(other.answers, answers);
  @override
  int get hashCode => Object.hash(quizId, completedAt, correctAnswers, totalQuestions, _listHash(answers));
}

/// Progress for one calendar day, using a date normalized to local midnight.
class DailyProgress {
  DailyProgress({required DateTime date, required this.completedQuizzes, required this.correctAnswers, required this.totalAnswers})
      : date = DateTime(date.year, date.month, date.day) {
    if (completedQuizzes < 0 || correctAnswers < 0 || totalAnswers < 0 || correctAnswers > totalAnswers) {
      throw ArgumentError('Progress counts must be non-negative and correctAnswers cannot exceed totalAnswers');
    }
  }

  final DateTime date;
  final int completedQuizzes;
  final int correctAnswers;
  final int totalAnswers;

  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'completedQuizzes': completedQuizzes, 'correctAnswers': correctAnswers, 'totalAnswers': totalAnswers};
  factory DailyProgress.fromJson(Map<String, dynamic> json) => DailyProgress(
        date: DateTime.parse(json['date'] as String), completedQuizzes: json['completedQuizzes'] as int,
        correctAnswers: json['correctAnswers'] as int, totalAnswers: json['totalAnswers'] as int);

  @override
  bool operator ==(Object other) => other is DailyProgress && other.date == date && other.completedQuizzes == completedQuizzes && other.correctAnswers == correctAnswers && other.totalAnswers == totalAnswers;
  @override
  int get hashCode => Object.hash(date, completedQuizzes, correctAnswers, totalAnswers);
}

/// Aggregate lifetime play statistics.
class GameStatistics {
  GameStatistics({required this.gamesPlayed, required this.correctAnswers, required this.totalAnswers,
    required this.currentStreak, required this.longestStreak}) {
    if (gamesPlayed < 0 || correctAnswers < 0 || totalAnswers < 0 || currentStreak < 0 || longestStreak < 0 ||
        correctAnswers > totalAnswers || currentStreak > longestStreak) {
      throw ArgumentError('Statistics must be non-negative, with correctAnswers <= totalAnswers and currentStreak <= longestStreak');
    }
  }

  final int gamesPlayed;
  final int correctAnswers;
  final int totalAnswers;
  final int currentStreak;
  final int longestStreak;
  double get accuracy => totalAnswers == 0 ? 0 : correctAnswers / totalAnswers;

  Map<String, dynamic> toJson() => {'gamesPlayed': gamesPlayed, 'correctAnswers': correctAnswers,
    'totalAnswers': totalAnswers, 'currentStreak': currentStreak, 'longestStreak': longestStreak};
  factory GameStatistics.fromJson(Map<String, dynamic> json) => GameStatistics(
        gamesPlayed: json['gamesPlayed'] as int, correctAnswers: json['correctAnswers'] as int,
        totalAnswers: json['totalAnswers'] as int, currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int);

  @override
  bool operator ==(Object other) => other is GameStatistics && other.gamesPlayed == gamesPlayed && other.correctAnswers == correctAnswers && other.totalAnswers == totalAnswers && other.currentStreak == currentStreak && other.longestStreak == longestStreak;
  @override
  int get hashCode => Object.hash(gamesPlayed, correctAnswers, totalAnswers, currentStreak, longestStreak);
}
