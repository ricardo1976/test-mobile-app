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

Architecture decisions should be documented here when they become stable.
