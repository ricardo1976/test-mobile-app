import 'dart:io';
import 'dart:convert';

import 'package:cuanto_recuerdas/features/quiz/data/file_progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/data/progress_storage.dart';
import 'package:cuanto_recuerdas/features/quiz/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'progress-storage-test-',
    );
  });

  tearDown(() async {
    await temporaryDirectory.delete(recursive: true);
  });

  File fileAt(String name) => File('${temporaryDirectory.path}/$name.json');

  group('FileProgressStorage', () {
    test('round-trips domain progress after recreating the service', () async {
      final file = fileAt('progress');
      final progress = StoredProgress(
        quizResults: [
          QuizResult(
            quizId: 'quiz-2026-10-23',
            answers: [
              QuizAnswer(questionId: 'q-1', answerId: 'a-2'),
              QuizAnswer(questionId: 'q-2', answerId: 'a-3'),
            ],
            correctAnswers: 1,
            totalQuestions: 2,
            completedAt: DateTime.utc(2026, 10, 23, 12, 30),
          ),
        ],
        dailyProgress: [
          DailyProgress(
            date: DateTime(2026, 10, 23),
            completedQuizzes: 1,
            correctAnswers: 1,
            totalAnswers: 2,
          ),
        ],
        statistics: GameStatistics(
          gamesPlayed: 1,
          correctAnswers: 1,
          totalAnswers: 2,
          currentStreak: 1,
          longestStreak: 3,
        ),
      );

      await FileProgressStorage(file).save(progress);
      final restored = await FileProgressStorage(file).load();

      expect(restored.quizResults, progress.quizResults);
      expect(restored.dailyProgress, progress.dailyProgress);
      expect(restored.statistics, progress.statistics);
      expect(
        (jsonDecode(await file.readAsString()) as Map)['formatVersion'],
        FileProgressStorage.currentFormatVersion,
      );
    });

    test(
      'replaces an existing file with a completed temporary write',
      () async {
        final file = fileAt('replace-existing');
        final storage = FileProgressStorage(file);
        final initial = StoredProgress.empty();
        final replacement = StoredProgress(
          quizResults: [],
          dailyProgress: [],
          statistics: GameStatistics(
            gamesPlayed: 1,
            correctAnswers: 2,
            totalAnswers: 5,
            currentStreak: 1,
            longestStreak: 1,
          ),
        );

        await storage.save(initial);
        await storage.save(replacement);

        final restored = await FileProgressStorage(file).load();
        expect(restored.statistics, replacement.statistics);
      },
    );

    test('keeps previous progress if writing a replacement fails', () async {
      final file = fileAt('preserved-progress');
      final previous = StoredProgress(
        quizResults: [],
        dailyProgress: [],
        statistics: GameStatistics(
          gamesPlayed: 2,
          correctAnswers: 3,
          totalAnswers: 5,
          currentStreak: 2,
          longestStreak: 4,
        ),
      );
      await FileProgressStorage(file).save(previous);

      final failingStorage = FileProgressStorage(
        file,
        temporaryFileWriter: (temporaryFile, contents) async {
          await temporaryFile.writeAsString(
            contents.substring(0, contents.length ~/ 2),
            flush: true,
          );
          throw const FileSystemException('Simulated interrupted write');
        },
      );

      await expectLater(
        failingStorage.save(StoredProgress.empty()),
        throwsA(isA<ProgressStorageIoException>()),
      );

      final restored = await FileProgressStorage(file).load();
      expect(restored.quizResults, previous.quizResults);
      expect(restored.dailyProgress, previous.dailyProgress);
      expect(restored.statistics, previous.statistics);
      expect(
        temporaryDirectory.listSync().where(
          (entry) => entry.path.startsWith('${file.path}.'),
        ),
        isEmpty,
      );
    });

    test(
      'returns an empty initial state when the file does not exist',
      () async {
        final progress = await FileProgressStorage(fileAt('missing')).load();

        expect(progress.quizResults, isEmpty);
        expect(progress.dailyProgress, isEmpty);
        expect(progress.statistics.gamesPlayed, 0);
        expect(progress.statistics.currentStreak, 0);
        expect(progress.statistics.longestStreak, 0);
      },
    );

    test('reports malformed JSON with a storage-specific error', () async {
      final file = fileAt('malformed');
      await file.writeAsString('{invalid');

      await expectLater(
        FileProgressStorage(file).load(),
        throwsA(isA<MalformedProgressDataException>()),
      );
    });

    test(
      'reports malformed model data with a storage-specific error',
      () async {
        final file = fileAt('invalid-model');
        await file.writeAsString(
          jsonEncode({
            'formatVersion': FileProgressStorage.currentFormatVersion,
            'quizResults': [42],
            'dailyProgress': [],
            'statistics': {
              'gamesPlayed': 0,
              'correctAnswers': 0,
              'totalAnswers': 0,
              'currentStreak': 0,
              'longestStreak': 0,
            },
          }),
        );

        await expectLater(
          FileProgressStorage(file).load(),
          throwsA(isA<MalformedProgressDataException>()),
        );
      },
    );

    test('reports an unsupported format version clearly', () async {
      final file = fileAt('future-version');
      await file.writeAsString(jsonEncode({'formatVersion': 99}));

      await expectLater(
        FileProgressStorage(file).load(),
        throwsA(
          isA<UnsupportedProgressFormatVersionException>().having(
            (error) => error.version,
            'version',
            99,
          ),
        ),
      );
    });

    test('surfaces filesystem failures as I/O errors', () async {
      final pathIsDirectory = Directory('${temporaryDirectory.path}/directory');
      await pathIsDirectory.create();

      await expectLater(
        FileProgressStorage(File(pathIsDirectory.path)).load(),
        throwsA(isA<ProgressStorageIoException>()),
      );

      await expectLater(
        FileProgressStorage(File(pathIsDirectory.path))
            .save(StoredProgress.empty()),
        throwsA(isA<ProgressStorageIoException>()),
      );
    });

    test('supports an in-memory fake through the storage interface', () async {
      final fake = _InMemoryProgressStorage();
      final progress = StoredProgress.empty();

      await fake.save(progress);

      expect(await fake.load(), same(progress));
    });
  });
}

class _InMemoryProgressStorage implements ProgressStorage {
  StoredProgress? _progress;

  @override
  Future<StoredProgress> load() async => _progress ?? StoredProgress.empty();

  @override
  Future<void> save(StoredProgress progress) async {
    _progress = progress;
  }
}
