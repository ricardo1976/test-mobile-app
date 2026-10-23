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
