# Architecture

This document describes the technical architecture of ¿Cuánto recuerdas?.

## Principles
- Flutter is the application framework.
- Android and iOS are first-class targets.
- The application must support internationalization from the beginning.
- Spanish (`es-ES`) is the default language.
- User-facing strings and question content must be localizable.
- Platform-specific functionality must be isolated behind clear boundaries.
- Business logic should remain independent from presentation where practical.
- Keep dependencies minimal and justified.

## Structure
- `lib/app/` - App composition, dependencies, routing, theme, services
- `lib/features/quiz/` - Domain models, game logic, data repositories, presentation
- `lib/features/home/` - Home screen
- `lib/features/history/` - History/statistics
- `lib/features/onboarding/` - Onboarding flow
- `lib/l10n/` - Localization
- `assets/` - Question bank
- `tool/` - Validation utilities

## Domain models
The quiz domain is implemented in `lib/features/quiz/domain/models.dart` with immutable values and value equality. Question, answer, and explanation text are maps keyed by locale (BCP 47 tags such as `es-ES`). The version 1 question bank format, supported categories and decades, and its validator are documented in `docs/question-bank.md`. Bank questions require four answers and exactly one correct choice. Quizzes contain ordered question IDs rather than copies of question content.

Quiz results retain the selected answer IDs, correct and total question counts, and completion time. Daily progress stores answer counts for a local calendar date; game statistics store lifetime totals and current/longest streaks. These models expose JSON conversion for local persistence and question-bank loading.

## Persistence
Local file-based storage via `FileProgressStorage` with JSON format. `ProgressRepository` coordinates persistence, streak calculation, and statistics. Settings stored separately in `SettingsStorage`.

## Services
- `AdService` - advertising abstraction (no-op in V0.1)
- `ShareService` - result sharing via platform APIs

## Testing
- Unit tests for domain logic
- Widget tests for UI
- Content validation via `QuestionBankValidator`

## Verification
- `dart format .`
- `flutter analyze`
- `flutter test`
- `dart run tool/validate_questions.dart assets/questions.json`
