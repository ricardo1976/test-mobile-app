import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:cuanto_recuerdas/app/dependencies.dart';
import 'package:cuanto_recuerdas/app/services/advertising_service.dart';
import 'package:cuanto_recuerdas/features/quiz/data/file_progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/data/question_repository.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/daily_quiz_generator.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/quiz_scorer.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/streak_calculator.dart';

class _FakeAdService implements AdService {
  int initializeCalls = 0;
  int showInterstitialCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }

  @override
  Future<void> showInterstitial() async {
    showInterstitialCalls++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NoOpAdService initialize and showInterstitial complete without side effects', () async {
    const service = NoOpAdService();

    await service.initialize();
    await service.showInterstitial();
  });

  test('AppDependencies allows replacing the ad service', () {
    final storage = FileProgressStorage(File('unused.json'));
    final progressRepository = ProgressRepository(storage: storage);
    final questionRepository = QuestionRepository(
      assetLoader: () async => '{"schemaVersion":1,"questions":[]}',
    );
    final custom = _FakeAdService();

    final dependencies = AppDependencies(
      questionRepository: questionRepository,
      progressStorage: storage,
      progressRepository: progressRepository,
      dailyQuizGenerator: const DailyQuizGenerator(),
      quizScorer: const QuizScorer(),
      streakCalculator: const StreakCalculator(),
      adService: custom,
    );

    expect(dependencies.adService, same(custom));
  });

  test('NoOpAdService does not interfere with quiz gameplay flow', () async {
    const service = NoOpAdService();
    await service.initialize();
    await service.showInterstitial();
    // Completes without throwing; gameplay unaffected.
  });
}
