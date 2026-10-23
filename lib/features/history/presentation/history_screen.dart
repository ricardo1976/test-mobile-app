import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: FutureBuilder(
        future: dependencies.progressRepository.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = dependencies.progressRepository.quizResults;
          if (results.isEmpty) {
            return Center(child: Text(l10n.historyEmpty));
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index];
              return ListTile(
                title: Text(r.quizId),
                subtitle: Text('${r.correctAnswers}/${r.totalQuestions}'),
              );
            },
          );
        },
      ),
    );
  }
}
