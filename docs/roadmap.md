# ¿Cuánto recuerdas? — Development Roadmap

## 1. Purpose
This document defines the planned implementation roadmap for the first version of **¿Cuánto recuerdas?**, a nostalgic daily quiz application built with Flutter.

## 4. Epic hierarchy
| Epic reference | Epic title | Scope | Planned Issues |
|---|---|---|---|
| E01 | Foundation and Architecture | Project structure, localization, design foundations, dependency configuration | R01–R04 (completed) |
| E02 | Question Bank and Game Engine | Question models, content validation, deterministic selection, scoring | R05–R08 (completed) |
| E03 | Local Persistence and Progress | Storage, daily completion, statistics, streaks, history | R09–R11 (completed) |
| E04 | Application Services | Dependency wiring and advertising abstraction | R12–R13 (completed) |
| E05 | User Interface and Daily Experience | Navigation, onboarding, quiz flow, results, history, sharing | R14–R19 (completed) |
| E06 | Quality and Reliability | Automated testing, content integrity, accessibility and resilience | R20–R22 (completed) |
| E07 | Documentation and Release | Documentation, platform configuration, release validation | R23–R26 (in progress) |

---

# 5. Epic E01 — Foundation and Architecture

**Objective:** Establish a maintainable Flutter application foundation, including localization, shared UI foundations, and dependency configuration.

## R01 — Establish the Flutter project foundation

**Description**

Create or verify the initial Flutter project structure and establish the conventions required for Android and iOS development.

Keep the architecture simple and consistent with `docs/architecture.md`.

**Acceptance criteria**

- The application builds for Android and iOS.
- The repository follows the agreed source-code organization.
- Development, test, and build commands are documented or discoverable.
- No unnecessary architectural or third-party dependencies are introduced.
- Generated files are managed through the normal Flutter workflow.

**Dependencies:** None.

## R02 — Implement localization foundations

**Description**

Configure Flutter localization so that application text is independent of UI implementation and can support additional languages.

**Acceptance criteria**

- Spanish (Spain), `es-ES`, is the default locale.
- User-facing text is externalized using the project's localization mechanism.
- Locale configuration is compatible with Android and iOS.
- Missing translations are handled predictably.
- Tests verify the default locale and representative localized strings.
- Question content is not hard-coded directly into presentation widgets.

**Dependencies:** R01.

## R03 — Establish the shared design system

**Description**

Implement the reusable visual foundations for the modern retro style defined by the product documentation.

**Acceptance criteria**

- Shared color, typography, spacing, and component conventions are established.
- Reusable buttons, cards, and other required primitives are available where appropriate.
- Components support the required accessibility and localization constraints.
- The design is responsive to common mobile screen sizes.
- The implementation avoids unnecessary abstractions.

**Dependencies:** R01, R02.

## R04 — Configure application composition and state management

**Description**

Establish the application's composition root and the agreed state-management and dependency-injection approach.

**Acceptance criteria**

- Application dependencies have a clear creation and ownership strategy.
- Business logic is separated from presentation widgets.
- Persistent storage and external services can be replaced with test doubles.
- The application uses one coherent state-management approach.
- Unit and widget tests can instantiate the relevant components without production services.

**Dependencies:** R01.

---

# 6. Epic E02 — Question Bank and Game Engine

**Objective:** Implement the question domain, validated content, daily question selection, and scoring independently of the UI.

## R05 — Define the question and quiz domain models

**Description**

Create the immutable domain models required to represent questions, answers, quiz sessions, and quiz results.

**Acceptance criteria**

- Questions have stable, unique identifiers.
- Each question supports localized content.
- Each question contains exactly four answer options.
- Exactly one answer is correct.
- Each question has an explanation suitable for localization.
- Quiz sessions can represent question order and answer progress.
- Models have unit tests for their essential invariants.

**Dependencies:** R01, R02.

## R06 — Implement the versioned question bank

**Description**

Create the static, versioned question bank and the mechanism for loading and validating it.

**Acceptance criteria**

- The initial bank contains 500 questions across the five agreed categories.
- The category counts match the product scope.
- Questions use stable identifiers and the agreed data schema.
- Content is separated from presentation and supports localization.
- Invalid content is detected by automated validation.
- The bank can be loaded without a backend or network connection.
- A bank version is available for future schema and content evolution.

**Dependencies:** R05.

## R07 — Implement deterministic daily question selection

**Description**

Implement the selection algorithm that generates the five-question daily quiz.

**Acceptance criteria**

- Every daily quiz contains exactly five questions.
- Selection is deterministic for the same date, bank version, and relevant configuration.
- The selection mixes categories and decades according to the agreed rules.
- The algorithm avoids duplicate questions within a quiz.
- The algorithm handles bank changes and insufficient eligible content explicitly.
- Tests verify determinism, uniqueness, and distribution constraints.
- Time-zone and date-boundary behavior is explicitly tested.

**Dependencies:** R05, R06.

## R08 — Implement quiz execution and scoring

**Description**

Implement the domain logic for answering questions, tracking progress, and calculating quiz results.

**Acceptance criteria**

- A quiz follows a well-defined question sequence.
- An answer cannot be submitted more than once for the same question.
- Correct and incorrect answers are recorded accurately.
- The score is calculated consistently.
- Question explanations can be associated with the result of each answer.
- Completion is distinguishable from an in-progress session.
- Domain tests cover normal operation and invalid state transitions.

**Dependencies:** R05, R07.

---

# 7. Epic E03 — Local Persistence and Progress

**Objective:** Persist quiz progress and results locally so that the application works without accounts or backend services.

## R09 — Implement local storage and repository persistence

**Description**

Implement the persistence mechanism and repository abstractions required for local application data.

**Acceptance criteria**

- The application can persist and reload the data required by the domain.
- Storage implementation details remain outside presentation widgets.
- Repository contracts can be tested using in-memory or fake implementations.
- Stored data has a defined schema and migration strategy appropriate to V0.1.
- Storage failures are handled without silently corrupting progress.
- No backend or account dependency is introduced.

**Dependencies:** R04, R05.

## R10 — Persist daily quiz completion and results

**Description**

Persist daily quiz sessions and completed results, including the date, answers, and score.

**Acceptance criteria**

- A completed daily quiz remains completed after an application restart.
- The saved result contains sufficient information to reconstruct the user's historical result.
- Reopening the application does not accidentally reset a completed quiz.
- In-progress behavior is explicitly defined and consistently implemented.
- Duplicate completion records are prevented.
- Tests cover persistence, application restart scenarios, and date boundaries.

**Dependencies:** R08, R09.

## R11 — Implement statistics, streaks, and history

**Description**

Implement the local progress data and calculations required for statistics, consecutive-day streaks, and historical results.

**Acceptance criteria**

- Completed quizzes can be listed chronologically.
- Statistics are calculated from persisted results.
- Streak calculation follows a documented rule for consecutive local calendar days.
- Missed days and date boundaries are handled consistently.
- Statistics remain correct after application restart.
- Tests cover first completion, consecutive days, missed days, and historical data.

**Dependencies:** R09, R10.

---

# 8. Epic E04 — Application Services

**Objective:** Define the required service boundaries and prepare the advertising integration without introducing actual advertising in V0.1.

## R12 — Wire application dependencies and repositories

**Description**

Connect the domain, repositories, persistence, and application-level services through the composition root.

**Acceptance criteria**

- Application components receive dependencies through the agreed mechanism.
- Business logic does not instantiate infrastructure implementations directly.
- Test environments can replace production dependencies.
- Application startup and dependency initialization are covered by appropriate tests.
- No competing dependency-injection framework is introduced.

**Dependencies:** R04, R09.

## R13 — Introduce the advertising service abstraction

**Description**

Define an advertising service boundary that allows future monetization without coupling the application to an advertising SDK.

**Acceptance criteria**

- The advertising service contract is defined.
- A no-op implementation is used in V0.1.
- No AdMob SDK or active ad delivery is introduced.
- The application works when advertising is unavailable or disabled.
- Future implementations can be added without changing quiz domain logic.
- Tests verify that the no-op service does not interfere with gameplay.

**Dependencies:** R04, R12.

---

# 9. Epic E05 — User Interface and Daily Experience

**Objective:** Deliver the complete user-facing daily quiz experience, including results, progress, and sharing.

## R14 — Implement application navigation and home screen

**Description**

Create the main navigation structure and home screen for the daily quiz application.

**Acceptance criteria**

- The home screen reflects whether today's quiz is available, in progress, or completed.
- The user can access the daily quiz and historical results.
- Navigation follows the shared design system.
- All user-facing text is localized.
- Loading, empty, and error states are handled.
- Widget tests cover primary navigation and home-screen states.

**Dependencies:** R03, R04, R07, R10.

## R15 — Implement the daily quiz interface

**Description**

Implement the question and answer interface for the five-question daily quiz.

**Acceptance criteria**

- The interface presents one question at a time.
- All four answer options are displayed and selectable.
- Answer submission and progress follow the domain state.
- The interface handles correct and incorrect answers consistently.
- Question explanations are displayed according to the agreed game flow.
- The user cannot submit duplicate answers or skip required transitions.
- Layouts remain usable on common mobile screen sizes.
- Widget tests cover the principal quiz states.

**Dependencies:** R03, R08, R14.

## R16 — Implement the quiz results screen

**Description**

Present the completed quiz result, score, and relevant feedback.

**Acceptance criteria**

- The result screen shows the final score.
- Completion is persisted before the application treats the quiz as completed.
- The user can access the information defined by the result experience.
- The result remains consistent with the saved session.
- Error states during persistence are handled explicitly.
- Widget tests verify result rendering and navigation.

**Dependencies:** R10, R14, R15.

## R17 — Implement progress statistics and history screens

**Description**

Expose the statistics, streaks, and historical results available from local persistence.

**Acceptance criteria**

- The user can view previous quiz results.
- The user can view the supported aggregate statistics and current streak.
- Empty history is handled clearly.
- Displayed values agree with the domain calculations.
- Dates and other localized values use the selected locale.
- Widget tests cover empty, populated, and edge-case states.

**Dependencies:** R11, R14.

## R18 — Implement result sharing

**Description**

Allow users to share their daily quiz result using the platform's available sharing mechanism.

**Acceptance criteria**

- The user can invoke sharing from the result experience.
- The shared text contains the supported result information.
- Shared content is localized.
- The sharing implementation is isolated behind an appropriate boundary where useful.
- Cancellation or unavailability of the sharing mechanism does not corrupt quiz state.
- Tests cover result formatting and the relevant failure behavior.

**Dependencies:** R16.

## R19 — Implement onboarding and first-use experience

**Description**

Provide a lightweight first-use experience that explains the daily quiz and how it works.

**Acceptance criteria**

- The application explains the essential gameplay without requiring an account.
- The onboarding experience follows the product's modern retro visual direction.
- All text is localized.
- Onboarding completion or dismissal behaves consistently across application restarts.
- Returning users are not unnecessarily shown the initial onboarding again.
- Tests cover first launch and subsequent launches.

**Dependencies:** R03, R09, R14.

---

# 10. Epic E06 — Quality and Reliability

**Objective:** Verify the integrity of the content, reliability of the core experience, and accessibility of the application.

## R20 — Establish automated quality gates

**Description**

Provide a repeatable verification workflow for Flutter formatting, static analysis, unit tests, and widget tests.

**Acceptance criteria**

- The required verification commands are documented.
- Formatting and static analysis can be run consistently.
- Relevant automated tests run through the agreed development workflow.
- Failures are reported accurately.
- Existing tests are not weakened to make verification pass.
- The workflow is suitable for future CI integration.

**Dependencies:** R01.

## R21 — Validate question content and gameplay invariants

**Description**

Provide automated validation for the question bank and the most important gameplay invariants.

**Acceptance criteria**

- The question bank is checked for duplicate identifiers.
- Every question has four distinct answer options.
- Exactly one answer is correct.
- Required localized fields and explanations are validated.
- Category counts and total question count are verified.
- Daily selection and scoring invariants are covered by tests.
- Invalid content causes a clear, actionable validation failure.

**Dependencies:** R06, R07, R08.

## R22 — Verify accessibility, resilience, and platform behavior

**Description**

Verify usability and reliability across supported mobile platforms and common failure scenarios.

**Acceptance criteria**

- Primary flows support reasonable text scaling and accessibility labels.
- Touch targets and visual contrast are reviewed.
- Layout behavior is checked on common screen sizes.
- Local storage and sharing failures produce understandable outcomes.
- Critical flows are verified on Android and iOS.
- Relevant integration or widget tests cover important end-to-end scenarios.
- No network connectivity is required for core gameplay.

**Dependencies:** R09, R14, R15, R16.

---

# 11. Epic E07 — Documentation and Release

**Objective:** Keep project documentation aligned with the implementation and establish a repeatable V0.1 release process.

## R23 — Complete architecture and developer documentation

**Description**

Document the implemented architecture, major component boundaries, development workflow, and verification commands.

**Acceptance criteria**

- `docs/product.md` reflects the agreed product scope.
- `docs/architecture.md` reflects the implemented architecture.
- `docs/roadmap.md` reflects the current plan and status.
- Setup, testing, and build instructions are documented.
- Configuration and dependency decisions are documented where relevant.
- Documentation does not claim functionality that has not been implemented.

**Dependencies:** R01, R04, R12.

## R24 — Prepare Android and iOS release configuration

**Description**

Review the platform-specific configuration needed to build and distribute the initial version.

**Acceptance criteria**

- Android and iOS application identifiers and required metadata are reviewed.
- Display name, launcher icons, and required assets are configured.
- Versioning and build configuration are documented.
- Platform permissions are limited to those required by the application.
- Release build commands are documented.
- Platform-specific configuration does not introduce unnecessary permissions or services.

**Dependencies:** R14, R19.

## R25 — Execute end-to-end release verification

**Description**

Perform the final V0.1 verification against the agreed product requirements.

**Acceptance criteria**

- A new user can launch the application and complete onboarding.
- The daily quiz presents five questions and produces the expected result.
- Quiz completion persists across application restarts.
- Statistics, streaks, and history reflect persisted results.
- Result sharing works on supported platforms.
- Localization defaults to `es-ES`.
- Core gameplay works without an account, backend, analytics, or advertising.
- Relevant automated tests, static analysis, and platform builds pass.
- Known limitations are documented.

**Dependencies:** R15, R16, R17, R18, R19, R20, R21, R22, R24.

## R26 — Finalize V0.1 release documentation and handover

**Description**

Prepare the release notes and document the final state of the first version.

**Acceptance criteria**

- Release notes describe the implemented functionality and known limitations.
- Version and build information are consistent.
- Required setup and release documentation is complete.
- Remaining work is recorded as future roadmap scope rather than presented as completed functionality.
- The release readiness summary identifies verification performed and any outstanding non-blocking issues.

**Dependencies:** R23, R25.

---

# 12. Dependency overview

The following is the intended high-level order. It is not a requirement to execute every item strictly sequentially.

| Phase | Main work | Depends primarily on |
|---|---|---|
| 1 | R01–R04: Foundation | None |
| 2 | R05–R08: Domain, content, game engine | Foundation |
| 3 | R09–R13: Persistence and services | Domain and foundation |
| 4 | R14–R19: User experience | Game engine, persistence, shared UI |
| 5 | R20–R22: Quality | Relevant implementation work |
| 6 | R23–R24: Documentation and platform preparation | Foundation and application flows |
| 7 | R25–R26: Final verification and release | Feature completion and quality gates |

The coordinator must check the individual dependencies before starting each item. The phase table does not replace the dependency lists in the Issues.

# 13. Parallel execution guidelines

Parallel work is permitted when the relevant requirements are clear and the tasks do not compete for the same files or interfaces.

Potentially independent work includes:

- Localization foundations and dependency-composition conventions after the project structure is established.
- Question-bank validation and independent test infrastructure after the question schema is agreed.
- Documentation updates and platform preparation once their respective interfaces are stable.
- Independent UI components after their domain contracts are established.

Work that must respect dependency ordering includes:

- Question-bank implementation before final bank validation.
- Daily selection before the UI can consume the complete selection flow.
- Persistence contracts before dependent result-history functionality is implemented.
- Quiz execution and completion persistence before final result behavior is verified.
- Implementation and verification before the relevant Issue is considered complete.

When parallel work is selected, the coordinator must ensure that each developer has a clearly bounded scope, that shared contracts are agreed upon, and that integration is verified before dependent work proceeds.

# 14. Definition of done

A roadmap item is complete only when:

- Its GitHub Issue acceptance criteria are satisfied.
- Relevant automated tests exist and pass.
- Formatting and static analysis pass.
- Changes have been reviewed.
- Blocking review findings have been resolved.
- User-facing text is localized.
- Documentation is updated when required.
- The Issue and Pull Request reflect the actual state.
- Commits and GitHub artifacts are written in English.
- No unverified action is reported as completed.

The V0.1 roadmap is complete when R25 and R26 are satisfied and the application meets the agreed product scope.

# 15. Coordinator operating instructions

At the beginning of a roadmap execution session:

1. Read this document, `AGENTS.md`, `docs/product.md`, and `docs/architecture.md`.
2. Inspect the repository, GitHub state, existing Issues, and open Pull Requests.
3. Reconcile the roadmap with work that has already been completed.
4. Identify the next eligible roadmap item.
5. Delegate analysis, create the required GitHub hierarchy incrementally, and begin implementation only when requirements are ready.

After each completed item:

1. Record the actual outcome and verification evidence.
2. Update the corresponding Issue and Pull Request.
3. Update this roadmap if the item's status or dependencies changed.
4. Reassess which items are eligible for execution.
5. Continue automatically unless a material decision, authorization, or blocking dependency requires user input.

Do not create duplicate Epics or Issues. Reuse existing GitHub objects when they represent the same work, and preserve their history and links.

The coordinator must use the configured `issue-analyst`, `developer`, and `pr-reviewer` agents when delegation is available. If delegation is unavailable, it must report the limitation rather than falsely claiming that a specialized agent performed the work.