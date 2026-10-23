import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../app/widgets/app_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/domain/models.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Quiz? _quiz;
  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswerId;
  bool _submitted = false;
  bool _loading = true;
  String? _error;
  final List<QuizAnswer> _answers = [];

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.dependencies.initialize();
      final questions = await widget.dependencies.questionRepository
          .getAllQuestions();
      final version = await widget.dependencies.questionRepository
          .getSchemaVersion();
      final now = DateTime.now();
      final localDate = DateTime(now.year, now.month, now.day);
      final quiz = widget.dependencies.dailyQuizGenerator.generate(
        localDate: localDate,
        schemaVersion: version,
        questions: questions,
      );
      final loadedQuestions = <Question>[];
      for (final qq in quiz.questions) {
        final q = questions.firstWhere(
          (question) => question.id == qq.questionId,
        );
        loadedQuestions.add(q);
      }
      if (!mounted) return;
      setState(() {
        _quiz = quiz;
        _questions = loadedQuestions;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  void _selectAnswer(String answerId) {
    if (_submitted) return;
    setState(() {
      _selectedAnswerId = answerId;
    });
  }

  void _submitAnswer() {
    if (_submitted) return;
    if (_selectedAnswerId == null) return;
    setState(() {
      _submitted = true;
    });
    _answers.add(
      QuizAnswer(questionId: _currentQuestion.id, answerId: _selectedAnswerId!),
    );
  }

  void _nextQuestion() {
    if (!_submitted) return;
    if (_isLastQuestion) {
      _finishQuiz();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswerId = null;
      _submitted = false;
    });
  }

  Future<void> _finishQuiz() async {
    if (_quiz == null) return;
    try {
      final questionsById = <String, Question>{};
      for (final question in _questions) {
        questionsById[question.id] = question;
      }
      final scorer = widget.dependencies.quizScorer;
      final scored = scorer.score(
        quiz: _quiz!,
        questionsById: questionsById,
        answers: _answers,
      );
      final result = QuizResult(
        quizId: _quiz!.id,
        answers: _answers,
        correctAnswers: scored.correctAnswers,
        totalQuestions: _questions.length,
        completedAt: DateTime.now(),
      );
      try {
        await widget.dependencies.progressRepository.recordQuiz(result);
      } catch (_) {}
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dailyQuiz)),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            AppPrimaryButton(onPressed: _loadQuiz, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    if (_questions.isEmpty) {
      return Center(child: Text(l10n.noQuestionsAvailable));
    }
    final question = _currentQuestion;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final prompt = question.prompt[locale] ?? question.prompt.values.first;
    final explanation = question.explanation == null
        ? null
        : (question.explanation![locale] ?? question.explanation!.values.first);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.questionOfTotal(_currentIndex + 1, _questions.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text(prompt, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                for (final answer in question.answers)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _AnswerOption(
                      answer: answer,
                      locale: locale,
                      isSelected: _selectedAnswerId == answer.id,
                      isSubmitted: _submitted,
                      onTap: () => _selectAnswer(answer.id),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!_submitted)
                  AppPrimaryButton(
                    onPressed: _selectedAnswerId == null ? null : _submitAnswer,
                    child: Text(l10n.submitAnswer),
                  )
                else ...[
                  if (explanation != null && explanation.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(explanation),
                      ),
                    ),
                  const SizedBox(height: 12),
                  AppPrimaryButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      _isLastQuestion ? l10n.finishQuiz : l10n.nextQuestion,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.answer,
    required this.locale,
    required this.isSelected,
    required this.isSubmitted,
    required this.onTap,
  });

  final Answer answer;
  final String locale;
  final bool isSelected;
  final bool isSubmitted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = answer.text[locale] ?? answer.text.values.first;
    Color? backgroundColor;
    if (isSubmitted) {
      if (answer.isCorrect) {
        backgroundColor = Colors.green.withValues(alpha: 0.2);
      } else if (isSelected && !answer.isCorrect) {
        backgroundColor = Colors.red.withValues(alpha: 0.2);
      }
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }
}
