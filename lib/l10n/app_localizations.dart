import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto recuerdas?'**
  String get appTitle;

  /// No description provided for @homeLoadingError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la aplicación.'**
  String get homeLoadingError;

  /// No description provided for @homeCompletedToday.
  ///
  /// In es, this message translates to:
  /// **'Ya completaste el reto de hoy.'**
  String get homeCompletedToday;

  /// No description provided for @homeDailyAvailable.
  ///
  /// In es, this message translates to:
  /// **'Reto diario disponible.'**
  String get homeDailyAvailable;

  /// No description provided for @homeInProgress.
  ///
  /// In es, this message translates to:
  /// **'Reto en progreso.'**
  String get homeInProgress;

  /// No description provided for @playDailyQuiz.
  ///
  /// In es, this message translates to:
  /// **'Jugar reto diario'**
  String get playDailyQuiz;

  /// No description provided for @viewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver historial'**
  String get viewHistory;

  /// No description provided for @emptyState.
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles.'**
  String get emptyState;

  /// No description provided for @historyEmpty.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados todavía.'**
  String get historyEmpty;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @dailyQuiz.
  ///
  /// In es, this message translates to:
  /// **'Reto diario'**
  String get dailyQuiz;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay preguntas disponibles'**
  String get noQuestionsAvailable;

  /// No description provided for @questionOfTotal.
  ///
  /// In es, this message translates to:
  /// **'Pregunta {current}/{total}'**
  String questionOfTotal(int current, int total);

  /// No description provided for @submitAnswer.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get submitAnswer;

  /// No description provided for @nextQuestion.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get nextQuestion;

  /// No description provided for @finishQuiz.
  ///
  /// In es, this message translates to:
  /// **'Finalizar'**
  String get finishQuiz;

  /// No description provided for @resultsTitle.
  ///
  /// In es, this message translates to:
  /// **'Resultados'**
  String get resultsTitle;

  /// No description provided for @score.
  ///
  /// In es, this message translates to:
  /// **'Puntuación'**
  String get score;

  /// No description provided for @scoreFormat.
  ///
  /// In es, this message translates to:
  /// **'{correct}/{total}'**
  String scoreFormat(int correct, int total);

  /// No description provided for @feedbackPerfect.
  ///
  /// In es, this message translates to:
  /// **'¡Perfecto!'**
  String get feedbackPerfect;

  /// No description provided for @feedbackGreat.
  ///
  /// In es, this message translates to:
  /// **'¡Muy bien!'**
  String get feedbackGreat;

  /// No description provided for @feedbackGood.
  ///
  /// In es, this message translates to:
  /// **'Bien hecho.'**
  String get feedbackGood;

  /// No description provided for @feedbackAverage.
  ///
  /// In es, this message translates to:
  /// **'Sigue practicando.'**
  String get feedbackAverage;

  /// No description provided for @feedbackPoor.
  ///
  /// In es, this message translates to:
  /// **'Sigue practicando.'**
  String get feedbackPoor;

  /// No description provided for @backToHome.
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio'**
  String get backToHome;

  /// No description provided for @shareResult.
  ///
  /// In es, this message translates to:
  /// **'Compartir resultado'**
  String get shareResult;

  /// No description provided for @shareResultText.
  ///
  /// In es, this message translates to:
  /// **'He sacado {correct}/{total} en \"¿Cuánto recuerdas?\". ¡Pruébalo tú también!'**
  String shareResultText(int correct, int total);

  /// No description provided for @statistics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get statistics;

  /// No description provided for @gamesPlayed.
  ///
  /// In es, this message translates to:
  /// **'Partidas jugadas'**
  String get gamesPlayed;

  /// No description provided for @correctAnswers.
  ///
  /// In es, this message translates to:
  /// **'Respuestas correctas'**
  String get correctAnswers;

  /// No description provided for @totalAnswers.
  ///
  /// In es, this message translates to:
  /// **'Respuestas totales'**
  String get totalAnswers;

  /// No description provided for @accuracy.
  ///
  /// In es, this message translates to:
  /// **'Precisión'**
  String get accuracy;

  /// No description provided for @currentStreak.
  ///
  /// In es, this message translates to:
  /// **'Racha actual'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In es, this message translates to:
  /// **'Mejor racha'**
  String get longestStreak;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
