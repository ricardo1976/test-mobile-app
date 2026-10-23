---
name: flutter-development
description: Implement and verify Flutter and Dart application changes following project conventions and cross-platform requirements.
---

# Flutter Development

Use this skill when implementing Flutter or Dart code.

## Before coding

- Read the relevant Issue.
- Inspect existing Flutter architecture and patterns.
- Check existing state-management, dependency-injection, navigation, localization, and persistence approaches.
- Reuse existing patterns whenever possible.

## Implementation

- Keep widgets focused.
- Keep business logic outside presentation widgets where practical.
- Prefer immutable state.
- Avoid unnecessary rebuilds.
- Keep platform-specific code isolated.
- Avoid unnecessary dependencies.
- Follow existing project naming and folder conventions.

## Localization

The application is multilingual.

Spanish (`es-ES`) is the default language.

Never hard-code user-facing strings directly into widgets or business logic when the project localization mechanism provides an appropriate alternative.

New user-facing text must have a localization strategy.

Question content must also support localization.

## Verification

After implementation:

1. Format the affected Dart files.
2. Run static analysis.
3. Run relevant unit tests.
4. Run relevant widget tests.
5. Run integration tests when applicable.

Do not consider a Flutter implementation complete if relevant verification has not been performed.
Always execute flutter and dart external tools out of the sandbox.
