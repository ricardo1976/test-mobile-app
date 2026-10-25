# ¿Cuánto recuerdas? — Codex Instructions

## Project overview

- This repository contains the Flutter application "¿Cuánto recuerdas?".
- The application targets Android and iOS.
- The application must support multiple languages from the beginning.
- Spanish (Spain, `es-ES`) is the default application language.
- The product decisions and requirements are documented in `docs/product.md`.
- The technical architecture is documented in `docs/architecture.md`.
- The development roadmap is documented in `docs/roadmap.md`.

## Language

- Communicate with the user in Spanish unless the user explicitly requests another language.
- All project artifacts intended for the repository or external project-management systems must be written in English.
- This includes, but is not limited to:
  - Git commit messages
  - GitHub Issues
  - GitHub Issue titles and descriptions
  - Pull Request titles and descriptions
  - Technical documentation
  - Code comments and docstrings
  - Release notes and changelogs
- Do not switch the conversation language to English merely because a project artifact must be written in English.
- User-facing application text and question content must be localized according to the selected application language.
- Do not hard-code user-facing strings or question content in a single language.
- New user-facing content must be designed for localization, even when an `es-ES` translation is the only translation initially available.

## General engineering principles

- Prefer simple, maintainable solutions over unnecessary abstraction.
- Do not introduce dependencies without a clear justification.
- Reuse existing project patterns before introducing new ones.
- Do not make architectural changes implicitly as part of an unrelated feature.
- Preserve backward compatibility unless the Issue explicitly requires a breaking change.
- Do not modify generated files manually unless the project workflow explicitly requires it.

## Flutter and Dart

- Follow current Flutter and Dart best practices.
- Keep widgets focused and composable.
- Keep business logic out of presentation widgets whenever practical.
- Prefer immutable data structures and explicit state transitions.
- Keep platform-specific code isolated behind well-defined boundaries.
- Use the existing project state-management and dependency-injection patterns instead of introducing competing approaches.
- Run formatting and static analysis before considering an implementation complete.

## Testing

- Every non-trivial behavior change must include or update automated tests.
- Prefer unit tests for business logic.
- Use widget tests for UI behavior.
- Use integration tests for important end-to-end flows.
- Do not weaken or remove existing tests merely to make a change pass.
- A change is not complete until the relevant tests pass.

## Git workflow

- Work on a dedicated branch for each Issue.
- Do not commit directly to the default branch unless explicitly requested.
- Keep commits focused and logically coherent.
- Write commit messages in English.
- Use imperative wording for commit messages.
- Keep Pull Request titles and descriptions in English.
- Reference the GitHub Issue from the Pull Request.
- Do not merge a Pull Request unless explicitly requested or the repository workflow grants the agent permission to do so.

## GitHub Issues

- GitHub Issues are the system of record for development requirements.
- Treat an Issue as the equivalent of the former PBI in the previous development workflow.
- An Issue must contain a clear objective, scope, acceptance criteria, and relevant constraints before implementation starts.
- Do not implement an Issue that is materially ambiguous without first identifying the missing information.
- Use GitHub sub-issues when a feature is large enough to require independent implementation units.
- Do not create unnecessary sub-issues for small or self-contained changes.

## Development workflow

The preferred workflow is:

1. Analyze the GitHub Issue.
2. Identify missing requirements or ambiguities.
3. Review the relevant product and architecture documentation.
4. Determine whether the Issue is ready for implementation.
5. Create or update a development plan when the change is sufficiently complex.
6. Implement the change.
7. Add or update tests.
8. Run the relevant verification commands.
9. Review the resulting changes.
10. Create or update the Pull Request.
11. Perform an independent Pull Request review.
12. Address blocking findings before considering the work complete.

For changes involving CI, build configuration, dependencies, or SDK versions, require the developer agent to verify compatibility with the repository's declared toolchain and project constraints. The reviewer agent must independently check for version mismatches, weakened SDK constraints, and missing quality checks. Do not consider the task complete until verification results and any remaining limitations are reported.

## Agent roles

Three specialized roles are available:

- `issue-analyst`
  - Analyzes GitHub Issues before implementation.
  - Identifies missing requirements, acceptance criteria, dependencies, risks, and architectural impact.
  - May propose or create sub-issues when appropriate.
  - Does not implement application code.

- `developer`
  - Implements approved GitHub Issues or sub-issues.
  - Writes tests and performs verification.
  - Creates commits and Pull Requests when requested or when the workflow requires it.
  - Does not silently redefine product requirements.

- `pr-reviewer`
  - Independently reviews Pull Requests.
  - Checks requirements, architecture, correctness, security, testing, maintainability, and regressions.
  - Does not modify the implementation while performing the review.
  - Reports blocking findings separately from non-blocking recommendations.


## Definition of done

A change is considered complete only when:

- The implementation satisfies the Issue acceptance criteria.
- Relevant tests exist and pass.
- Static analysis and formatting pass.
- No known blocking review findings remain.
- User-facing strings are localized.
- Documentation is updated when the change affects documented behavior or architecture.
- GitHub Issue and Pull Request state accurately reflect the work.
- Git commits and GitHub artifacts are written in English.

## Flutter/Dart Toolchain and CI Consistency

### Source of truth

- The project uses Flutter and Dart. Keep the local development environment, repository toolchain configuration, and GitHub Actions CI compatible and aligned.
- The current development environment uses Flutter `3.47.7`. When configuring or updating CI, use this version unless an explicit, reviewed project decision establishes a different version.
- Before changing toolchain configuration, inspect `pubspec.yaml`, any Flutter version-manager configuration (such as `.fvmrc`), existing CI workflows, and the actual installed Flutter/Dart versions when available.
- If the repository defines an explicit Flutter SDK version, treat that configuration as the source of truth. Do not introduce a conflicting version in CI.
- If no repository-level version is defined, use the established project development version and keep the CI configuration consistent with it.

### Rules for CI workflows

- Before creating or modifying a Flutter CI workflow, verify that the selected Flutter version provides a Dart SDK compatible with the `environment.sdk` constraint in `pubspec.yaml`.
- Never choose an arbitrary or outdated Flutter version without checking its bundled Dart SDK.
- Never weaken or lower the project's Dart SDK constraint merely to make CI pass. Fix the toolchain configuration instead, unless a deliberate SDK compatibility change has been approved.
- Use a maintained, stable Flutter setup action and enable caching where appropriate.
- Print `flutter --version` and `dart --version` in CI to make the effective toolchain visible in logs.
- Preserve and execute the project's applicable quality checks, including dependency resolution, formatting, static analysis, question-bank validation, and tests.

### Verification and review

Before considering a CI change complete:

1. Confirm the Flutter version selected by CI matches the project's declared toolchain version.
2. Confirm the bundled Dart version satisfies `pubspec.yaml`.
3. Verify that `flutter pub get`, `dart format --set-exit-if-changed .`, `flutter analyze`, `dart run tool/validate_questions.dart`, and `flutter test` are executed by CI.
4. Run the checks locally when possible and inspect the GitHub Actions results when the workflow can be executed.
5. Report any checks that could not be executed or verified. Never claim that CI passes based only on inspecting the YAML.

These rules apply to every agent that creates, edits, reviews, or approves CI/toolchain changes. The coordinating agent must ensure that the final changes follow these rules before closing the task.