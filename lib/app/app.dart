import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/history/presentation/history_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/quiz/presentation/quiz_screen.dart';
import '../l10n/app_localizations.dart';
import 'dependencies.dart';
import 'theme/app_theme.dart';

class CuantoRecuerdasApp extends StatelessWidget {
  const CuantoRecuerdasApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  static const Locale _locale = Locale('es', 'ES');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '?Cu?nto recuerdas?',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: AppTheme.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(dependencies: dependencies),
            );
          case '/quiz':
            return MaterialPageRoute(
              builder: (_) => QuizScreen(dependencies: dependencies),
            );
          case '/history':
            return MaterialPageRoute(
              builder: (_) => HistoryScreen(dependencies: dependencies),
            );
        }
        return null;
      },
    );
  }
}
