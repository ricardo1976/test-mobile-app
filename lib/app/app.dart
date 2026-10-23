import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/home/presentation/home_screen.dart';
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
      supportedLocales: const [_locale],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
              builder: (_) =>
                  const Scaffold(body: Center(child: Text('Reto diario'))),
            );
          case '/history':
            return MaterialPageRoute(
              builder: (_) =>
                  const Scaffold(body: Center(child: Text('Historial'))),
            );
        }
        return null;
      },
    );
  }
}
