import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/home/presentation/home_screen.dart';
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
      title: '¿Cuánto recuerdas?',
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
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.dailyQuiz),
                ),
                body: Center(
                  child: Text(AppLocalizations.of(context)!.dailyQuiz),
                ),
              ),
            );
          case '/history':
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.history),
                ),
                body: Center(
                  child: Text(AppLocalizations.of(context)!.history),
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}
