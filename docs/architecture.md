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

## Areas to define

- Application structure
- State management
- Dependency injection
- Navigation
- Localization
- Question model and question bank
- Daily selection algorithm
- Persistence
- Result sharing
- Advertising abstraction
- Testing strategy
- Platform integration

## Domain models

The initial quiz domain is implemented in `lib/features/quiz/domain/models.dart` with immutable values and value equality. Question, answer, and explanation text are maps keyed by locale (BCP 47 tags such as `es-ES`). Questions reference category IDs and decade years, and contain at least two uniquely identified answers with exactly one correct choice. Quizzes contain ordered question IDs rather than copies of question content.

Quiz results retain the selected answer IDs, correct and total question counts, and completion time. Daily progress stores answer counts for a local calendar date; game statistics store lifetime totals and current/longest streaks. These models expose JSON conversion for local persistence and question-bank loading. Persistence format changes should be versioned by the persistence layer when introduced.

Architecture decisions should be documented here when they become stable.
