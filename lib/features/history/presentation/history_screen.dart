import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/dependencies.dart';
import '../../../features/quiz/domain/models.dart';
import '../../../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.dependencies.progressRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(locale);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final progress = widget.dependencies.progressRepository;
          final results = progress.quizResults;
          final stats = progress.statistics;

          if (results.isEmpty) {
            return Center(child: Text(l10n.historyEmpty));
          }

          return ListView(
            children: [
              _StatisticsSection(stats: stats, l10n: l10n),
              const Divider(),
              ...results.reversed.map(
                (r) => ListTile(
                  title: Text(dateFormat.format(r.completedAt)),
                  subtitle: Text('${r.correctAnswers}/${r.totalQuestions}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.stats, required this.l10n});

  final GameStatistics stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.statistics, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('${l10n.gamesPlayed}: ${stats.gamesPlayed}'),
          Text('${l10n.correctAnswers}: ${stats.correctAnswers}'),
          Text('${l10n.totalAnswers}: ${stats.totalAnswers}'),
          Text(
            '${l10n.accuracy}: ${(stats.accuracy * 100).toStringAsFixed(0)}%',
          ),
          Text('${l10n.currentStreak}: ${stats.currentStreak}'),
          Text('${l10n.longestStreak}: ${stats.longestStreak}'),
        ],
      ),
    );
  }
}
