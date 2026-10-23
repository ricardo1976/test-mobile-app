// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '¿Cuánto recuerdas?';

  @override
  String get homeLoadingError => 'No se pudo cargar la aplicación.';

  @override
  String get homeCompletedToday => 'Ya completaste el reto de hoy.';

  @override
  String get homeDailyAvailable => 'Reto diario disponible.';

  @override
  String get playDailyQuiz => 'Jugar reto diario';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get emptyState => 'No hay datos disponibles.';

  @override
  String get retry => 'Reintentar';

  @override
  String get dailyQuiz => 'Reto diario';

  @override
  String get history => 'Historial';
}
