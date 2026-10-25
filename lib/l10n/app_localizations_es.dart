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
  String get homeInProgress => 'Reto en progreso.';

  @override
  String get playDailyQuiz => 'Jugar reto diario';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get emptyState => 'No hay datos disponibles.';

  @override
  String get historyEmpty => 'Sin resultados todavía.';

  @override
  String get retry => 'Reintentar';

  @override
  String get dailyQuiz => 'Reto diario';

  @override
  String get history => 'Historial';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get gamesPlayed => 'Partidas jugadas';

  @override
  String get correctAnswers => 'Respuestas correctas';

  @override
  String get totalAnswers => 'Respuestas totales';

  @override
  String get accuracy => 'Precisión';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get longestStreak => 'Mejor racha';

  @override
  String get noQuestionsAvailable => 'No hay preguntas disponibles';

  @override
  String questionOfTotal(int current, int total) {
    return 'Pregunta $current/$total';
  }

  @override
  String get submitAnswer => 'Enviar';

  @override
  String get nextQuestion => 'Siguiente';

  @override
  String get finishQuiz => 'Finalizar';

  @override
  String get resultsTitle => 'Resultados';

  @override
  String get score => 'Puntuación';

  @override
  String scoreFormat(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String get feedbackPerfect => '¡Perfecto!';

  @override
  String get feedbackGreat => '¡Muy bien!';

  @override
  String get feedbackGood => 'Bien hecho.';

  @override
  String get feedbackAverage => 'Sigue practicando.';

  @override
  String get feedbackPoor => 'Sigue practicando.';

  @override
  String get backToHome => 'Volver al inicio';
}
