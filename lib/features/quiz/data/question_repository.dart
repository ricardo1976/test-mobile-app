import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models.dart';
import 'question_bank_validator.dart';

typedef QuestionBankAssetLoader = Future<String> Function();

/// Loads and queries the bundled question bank without exposing its asset path.
class QuestionRepository {
  QuestionRepository({QuestionBankAssetLoader? assetLoader})
    : _assetLoader = assetLoader ?? _loadBundledAsset;

  static const _assetPath = 'assets/questions.json';

  final QuestionBankAssetLoader _assetLoader;
  Future<void>? _loadFuture;
  List<Question>? _questions;
  Map<String, Question>? _questionsById;
  int? _schemaVersion;

  static Future<String> _loadBundledAsset() =>
      rootBundle.loadString(_assetPath);

  /// Loads and validates the bank once. Concurrent callers share the same load.
  Future<void> load() => _loadFuture ??= _load();

  Future<void> _load() async {
    late final String source;
    try {
      source = await _assetLoader();
    } catch (error) {
      throw QuestionRepositoryException(
        'Unable to load the question bank asset: $error',
      );
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error) {
      throw QuestionRepositoryException(
        'The question bank contains invalid JSON: ${error.message}',
      );
    }

    final errors = validateQuestionBank(decoded);
    if (errors.isNotEmpty) {
      throw QuestionRepositoryException(
        'The question bank failed validation: ${errors.join(' ')}',
      );
    }

    try {
      final bank = Map<String, dynamic>.from(decoded! as Map);
      final questions = (bank['questions'] as List)
          .map(
            (item) => Question.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false);
      _questions = List.unmodifiable(questions);
      _questionsById = Map.unmodifiable({
        for (final question in questions) question.id: question,
      });
      _schemaVersion = bank['schemaVersion'] as int;
    } catch (error) {
      throw QuestionRepositoryException(
        'The validated question bank could not be converted to domain models: $error',
      );
    }
  }

  Future<List<Question>> getAllQuestions() async {
    await load();
    return _questions!;
  }

  Future<List<Question>> getQuestionsByCategory(String categoryId) async {
    await load();
    return List.unmodifiable(
      _questions!.where((question) => question.categoryId == categoryId),
    );
  }

  Future<List<Question>> getQuestionsByDecade(int decade) async {
    await load();
    return List.unmodifiable(
      _questions!.where((question) => question.decade == decade),
    );
  }

  Future<Question?> getQuestionById(String id) async {
    await load();
    return _questionsById![id];
  }

  /// Returns the declared JSON format version (`schemaVersion`).
  Future<int> getSchemaVersion() async {
    await load();
    return _schemaVersion!;
  }
}

/// A clear load, decode, or validation failure from [QuestionRepository].
class QuestionRepositoryException implements Exception {
  const QuestionRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'QuestionRepositoryException: $message';
}
