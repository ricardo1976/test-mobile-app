import 'dart:convert';
import 'dart:io';

import '../domain/models.dart';
import 'progress_storage.dart';

/// JSON file implementation for the small V0.1 progress dataset.
///
/// The application composition layer supplies a file in its platform-specific
/// application-support directory. Keeping that path outside this class avoids
/// coupling the domain or storage contract to a platform path provider.
class FileProgressStorage implements ProgressStorage {
  FileProgressStorage(this.file, {ProgressFileWriter? temporaryFileWriter})
    : _temporaryFileWriter = temporaryFileWriter ?? _writeTemporaryFile;

  static const int currentFormatVersion = 1;

  final File file;
  final ProgressFileWriter _temporaryFileWriter;

  @override
  Future<StoredProgress> load() async {
    try {
      final entityType = await FileSystemEntity.type(file.path);
      if (entityType == FileSystemEntityType.notFound) {
        return StoredProgress.empty();
      }
      if (entityType != FileSystemEntityType.file) {
        throw ProgressStorageIoException(
          'Progress path is not a regular file: ${file.path}',
        );
      }

      final decoded = jsonDecode(await file.readAsString());
      return _decodeProgress(decoded);
    } on ProgressStorageException {
      rethrow;
    } on FileSystemException catch (error) {
      throw ProgressStorageIoException(error.message);
    } on FormatException catch (error) {
      throw MalformedProgressDataException(error.message);
    } on Object catch (error) {
      throw MalformedProgressDataException(
        'Could not decode saved progress: $error',
      );
    }
  }

  @override
  Future<void> save(StoredProgress progress) async {
    final payload = {
      'formatVersion': currentFormatVersion,
      'quizResults': progress.quizResults
          .map((result) => result.toJson())
          .toList(),
      'dailyProgress': progress.dailyProgress
          .map((day) => day.toJson())
          .toList(),
      'statistics': progress.statistics.toJson(),
    };

    File? temporaryFile;
    try {
      await file.parent.create(recursive: true);
      temporaryFile = File(
        '${file.path}.$pid.${DateTime.now().microsecondsSinceEpoch}.tmp',
      );
      await _temporaryFileWriter(temporaryFile, jsonEncode(payload));
      await temporaryFile.rename(file.path);
      temporaryFile = null;
    } on FileSystemException catch (error) {
      await _deleteTemporaryFile(temporaryFile);
      throw ProgressStorageIoException(error.message);
    } on Object catch (error) {
      await _deleteTemporaryFile(temporaryFile);
      throw ProgressStorageIoException('Could not save progress: $error');
    }
  }

  static Future<void> _writeTemporaryFile(File file, String contents) async {
    await file.writeAsString(contents, flush: true);
  }

  static Future<void> _deleteTemporaryFile(File? file) async {
    if (file == null) return;
    try {
      if (await file.exists()) await file.delete();
    } on Object {
      // Preserve the original write/rename error if cleanup also fails.
    }
  }

  StoredProgress _decodeProgress(Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const MalformedProgressDataException(
        'Progress payload must be a JSON object.',
      );
    }

    final version = value['formatVersion'];
    if (version is! int) {
      throw const MalformedProgressDataException(
        'Progress payload must include an integer formatVersion.',
      );
    }
    if (version != currentFormatVersion) {
      throw UnsupportedProgressFormatVersionException(version);
    }

    try {
      final rawResults = value['quizResults'];
      final rawDays = value['dailyProgress'];
      final rawStatistics = value['statistics'];
      if (rawResults is! List || rawDays is! List || rawStatistics is! Map) {
        throw const FormatException(
          'Progress payload is missing quizResults, dailyProgress, or statistics.',
        );
      }

      return StoredProgress(
        quizResults: rawResults
            .map(
              (result) =>
                  QuizResult.fromJson(Map<String, dynamic>.from(result as Map)),
            )
            .toList(),
        dailyProgress: rawDays
            .map(
              (day) =>
                  DailyProgress.fromJson(Map<String, dynamic>.from(day as Map)),
            )
            .toList(),
        statistics: GameStatistics.fromJson(
          Map<String, dynamic>.from(rawStatistics),
        ),
      );
    } on FormatException catch (error) {
      throw MalformedProgressDataException(error.message);
    } on Object catch (error) {
      throw MalformedProgressDataException(
        'Progress payload does not match the domain models: $error',
      );
    }
  }
}

/// Writes the complete JSON payload to the temporary file and flushes it.
///
/// This callback is injectable so tests can reliably exercise interrupted
/// writes without relying on platform-specific filesystem permissions.
typedef ProgressFileWriter = Future<void> Function(File file, String contents);
