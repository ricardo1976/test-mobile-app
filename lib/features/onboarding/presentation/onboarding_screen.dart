import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../app/widgets/app_buttons.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  Future<void> _completeOnboarding(BuildContext context) async {
    await dependencies.settingsStorage.setOnboardingCompleted();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.onboardingTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.onboardingSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.onboardingDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              AppPrimaryButton(
                onPressed: () => _completeOnboarding(context),
                child: Text(l10n.onboardingStart),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _completeOnboarding(context),
                child: Text(l10n.onboardingSkip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
