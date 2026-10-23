import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../features/quiz/data/file_progress_storage.dart';
import '../features/quiz/data/progress_repository.dart';
import '../features/quiz/data/progress_storage.dart';
import '../features/quiz/data/question_repository.dart';
import '../features/quiz/domain/daily_quiz_generator.dart';
import '../features/quiz/domain/quiz_scorer.dart';
import '../features/quiz/domain/streak_calculator.dart';

class AppDependencies {
  AppDependencies({
    required this.questionRepository,
    required this.progressStorage,
    required this.progressRepository,
    required this.dailyQuizGenerator,
    required this.quizScorer,
    required this.streakCalculator,
  });

  final QuestionRepository questionRepository;
  final ProgressStorage progressStorage;
  final ProgressRepository progressRepository;
  final DailyQuizGenerator dailyQuizGenerator;
  final QuizScorer quizScorer;
  final StreakCalculator streakCalculator;

  Future<void> initialize() async {
    await questionRepository.load();
    await progressRepository.load();
  }

  static Future<AppDependencies> create({File? progressFile}) async {
    final file = progressFile ?? await _defaultProgressFile();
    final storage = FileProgressStorage(file);
    final progressRepository = ProgressRepository(storage: storage);
    final dependencies = AppDependencies(
      questionRepository: QuestionRepository(),
      progressStorage: storage,
      progressRepository: progressRepository,
      dailyQuizGenerator: const DailyQuizGenerator(),
      quizScorer: const QuizScorer(),
      streakCalculator: const StreakCalculator(),
    );
    await dependencies.initialize();
    return dependencies;
  }

  static Future<File> _defaultProgressFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/progress.json');
  }
}
