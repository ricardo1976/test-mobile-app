import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../app/widgets/app_buttons.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/domain/models.dart';

class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({
    super.key,
    required this.dependencies,
    required this.result,
  });

  final AppDependencies dependencies;
  final QuizResult result;

  String _feedback(AppLocalizations l10n) {
    if (result.totalQuestions == 0) {
      return l10n.feedbackAverage;
    }
    final ratio = result.correctAnswers / result.totalQuestions;
    if (ratio >= 1.0) {
      return l10n.feedbackPerfect;
    }
    if (ratio >= 0.8) {
      return l10n.feedbackGreat;
    }
    if (ratio >= 0.6) {
      return l10n.feedbackGood;
    }
    if (ratio >= 0.4) {
      return l10n.feedbackAverage;
    }
    return l10n.feedbackPoor;
  }

  Future<void> _shareResult(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final text = l10n.shareResultText(
      result.correctAnswers,
      result.totalQuestions,
    );
    try {
      await dependencies.shareService.shareText(text);
    } catch (_) {
      // Do not corrupt quiz state on sharing errors.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.score,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.scoreFormat(
                    result.correctAnswers,
                    result.totalQuestions,
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  _feedback(l10n),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                AppPrimaryButton(
                  onPressed: () => _shareResult(context),
                  child: Text(l10n.shareResult),
                ),
                const SizedBox(height: 12),
                AppPrimaryButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(l10n.backToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
