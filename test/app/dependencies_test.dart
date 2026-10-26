import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/features/quiz/data/file_progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';

import 'test_utils.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('create() wires and initializes the repositories', () async {
    final tempDir = await Directory.systemTemp.createTemp('deps-create');
    final file = File('${tempDir.path}/progress.json');

    final dependencies = await AppDependencies.create(progressFile: file);

    expect(dependencies.progressStorage, isA<FileProgressStorage>());
    expect(dependencies.progressRepository, isA<ProgressRepository>());

    final questions = await dependencies.questionRepository.getAllQuestions();
    expect(questions, isNotEmpty);
    expect(dependencies.progressRepository.progress.quizResults, isEmpty);
  });

  test('create() uses the caller-supplied progress file', () async {
    final tempDir = await Directory.systemTemp.createTemp('deps-caller');
    final file = File('${tempDir.path}/progress.json');

    final dependencies = await AppDependencies.create(progressFile: file);

    expect((dependencies.progressStorage as FileProgressStorage).file, file);
  });

  test('initializes question bank and progress eagerly', () async {
    final tempDir = await Directory.systemTemp.createTemp('deps');
    final file = File('${tempDir.path}/progress.json');
    final storage = FileProgressStorage(file);
    final progressRepository = ProgressRepository(storage: storage);
    final questionRepository = QuestionRepository(
      assetLoader: () async => rootBundle.loadString('assets/questions.json'),
    );

    final dependencies = AppDependencies(
      questionRepository: questionRepository,
      progressStorage: storage,
      progressRepository: progressRepository,
      dailyQuizGenerator: const DailyQuizGenerator(),
      quizScorer: const QuizScorer(),
      streakCalculator: const StreakCalculator(),
      settingsStorage: testSettingsStorage(),
    );

    await dependencies.initialize();

    final questions = await questionRepository.getAllQuestions();
    expect(questions, isNotEmpty);
    expect(progressRepository.progress.quizResults, isEmpty);
  });

  test('dependencies are replaceable', () {
    final storage = FileProgressStorage(File('unused.json'));
    final progressRepository = ProgressRepository(storage: storage);
    final questionRepository = QuestionRepository(
      assetLoader: () async => '{"schemaVersion":1,"questions":[]}',
    );
    final dependencies = AppDependencies(
      questionRepository: questionRepository,
      progressStorage: storage,
      progressRepository: progressRepository,
      dailyQuizGenerator: const DailyQuizGenerator(),
      quizScorer: const QuizScorer(),
      streakCalculator: const StreakCalculator(),
    );
    expect(dependencies.questionRepository, same(questionRepository));
    expect(dependencies.progressRepository, same(progressRepository));
  });
}
