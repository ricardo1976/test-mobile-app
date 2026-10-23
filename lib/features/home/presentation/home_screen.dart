import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../l10n/app_localizations.dart';

enum HomeStatus { loading, available, inProgress, completed, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeStatus _status = HomeStatus.loading;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await widget.dependencies.initialize();
      final completed = widget.dependencies.progressRepository.completedToday();
      final inProgress =
          !completed &&
          widget.dependencies.progressRepository.inProgressToday();
      if (!mounted) return;
      setState(() {
        _status = completed
            ? HomeStatus.completed
            : (inProgress ? HomeStatus.inProgress : HomeStatus.available);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = HomeStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildBody(context, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    switch (_status) {
      case HomeStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case HomeStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.homeLoadingError),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _initialize, child: Text(l10n.retry)),
            ],
          ),
        );
      case HomeStatus.available:
      case HomeStatus.inProgress:
      case HomeStatus.completed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _status == HomeStatus.completed
                  ? l10n.homeCompletedToday
                  : l10n.homeDailyAvailable,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/quiz'),
              child: Text(l10n.playDailyQuiz),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/history'),
              child: Text(l10n.viewHistory),
            ),
          ],
        );
    }
  }
}
