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

## GitHub Issues and incremental roadmap execution

- The roadmap in `docs/roadmap.md` is the initial source of planned work. GitHub Issues are created incrementally as the roadmap is executed.
- Do not assume that all roadmap items already have GitHub Issues.
- Before implementing a roadmap item, use `issue-analyst` to analyze its scope, acceptance criteria, dependencies, risks, and architectural impact.
- Once the item is sufficiently defined and ready for implementation, create a GitHub Issue containing its objective, scope, acceptance criteria, dependencies, and relevant constraints.
- Create sub-issues only when a roadmap item requires independently implementable work units.
- Link related Issues and Pull Requests whenever supported by the repository workflow.
- Avoid duplicate Issues by checking existing Issues before creating new ones.
- Do not create Issues for every minor implementation step. Create an Issue for each coherent unit of work that can be independently tracked and verified.
- Update `docs/roadmap.md` when its status, sequencing, scope, or dependencies change.
- If an item is blocked by a product or architecture decision, report the decision required instead of inventing requirements or creating misleading implementation tasks.
- Continue to the next eligible roadmap item after completing the current item, without requiring user confirmation for routine steps.
- Create Issues for parallel work only after verifying that the work items are sufficiently independent and their acceptance criteria are clear.

## Incremental execution workflow

1. Review the roadmap and identify the next eligible item or set of independent items.
2. Delegate analysis to `issue-analyst`.
3. Resolve material ambiguities or report decisions requiring user input.
4. Create or update the corresponding GitHub Issue or Issues.
5. Delegate implementation to `developer`.
6. Run tests, formatting, static analysis, and other relevant verification.
7. Create or update the Pull Request and request independent review from `pr-reviewer`.
8. Address blocking findings and repeat verification as necessary.
9. Update the Issue, Pull Request, and roadmap status to reflect the actual outcome.
10. Continue with the next eligible item.

Never claim that an Issue, commit, Pull Request, review, or verification step has been completed unless the corresponding action actually succeeded.

## Agent roles

Three specialized roles are available:

- `issue-analyst`
  - Analyzes GitHub Issues before implementation.
  - Identifies missing requirements, acceptance criteria, dependencies, risks, and architectural impact.
  - May propose or create sub-issues when appropriate and authorized.
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

## Agent coordination and delegation

The main Codex agent is responsible for coordinating specialized agents. These instructions apply whenever the environment supports subagent delegation.

### Mandatory coordination rules

- Use the configured specialized agents proactively. Do not require the user to name an agent or explicitly request delegation for routine development work.
- Treat this section as the default orchestration policy for the repository.
- Before starting implementation of a GitHub Issue, delegate its analysis to `issue-analyst`, unless an equivalent analysis has already been completed and remains valid for the current Issue state.
- Do not begin implementation until the analysis confirms that the Issue is sufficiently clear and its required dependencies are satisfied.
- If the analysis identifies blocking ambiguities, missing acceptance criteria, or unresolved architectural decisions, report them to the user or resolve them through the authorized Issue-management workflow before implementation.
- Once the Issue is ready, delegate implementation to `developer`.
- After a Pull Request has been created or updated and the implementation is ready for review, delegate an independent review to `pr-reviewer`.
- Address blocking review findings before declaring the work complete.
- The main agent must evaluate and coordinate the results returned by subagents. Delegation does not remove the main agent's responsibility for the overall outcome.
- Do not claim that an agent was invoked, that a review passed, or that a task was completed unless the corresponding action actually occurred and its result was checked.
- If a required subagent is unavailable or delegation fails, do not silently pretend that the workflow was followed. Explain the limitation and ask for authorization before replacing a mandatory independent review with a review performed by the main agent.

### Standard orchestration sequence

For a typical GitHub Issue, use this sequence:

1. **Analysis:** delegate to `issue-analyst`.
2. **Readiness decision:** the main agent checks the analysis, requirements, dependencies, and implementation scope.
3. **Implementation:** delegate to `developer` once the Issue is ready.
4. **Verification:** ensure the developer has run the relevant formatting, static analysis, and tests and has checked the acceptance criteria.
5. **Pull Request:** create or update the Pull Request according to the Git workflow and repository permissions.
6. **Independent review:** delegate to `pr-reviewer`.
7. **Resolution:** address blocking findings and repeat verification and review as necessary.
8. **Completion report:** summarize the outcome, verification results, Pull Request, and any remaining non-blocking recommendations to the user in Spanish.

### When to adapt the sequence

- Small, self-contained tasks may use a proportionate workflow when the requirements and implementation are already clear.
- If a previous valid analysis exists, reuse it instead of repeating the same work, provided the requirements and relevant code have not materially changed.
- A change to requirements, dependencies, or architecture that invalidates the previous analysis must be sent back to `issue-analyst`.
- A Pull Request that has changed materially after review must be reviewed again by `pr-reviewer`.
- Do not delegate independent tasks in parallel when they modify the same files, depend on each other's output, or are likely to cause conflicting changes.
- Parallelize independent work only when dependencies, scope boundaries, and file ownership make it safe.

### Responsibilities of the main agent

- Provide each subagent with the relevant Issue, acceptance criteria, dependencies, architectural context, and scope boundaries.
- Ensure subagents follow all instructions in this file, including the Language rules.
- Pass relevant analysis findings to the developer rather than expecting the developer to infer them.
- Ensure the reviewer has the actual Pull Request changes and requirements needed for an independent assessment.
- Do not ask `pr-reviewer` to implement fixes during its independent review. Route required changes to `developer`, then request another review.
- Resolve disagreements between subagents using the Issue requirements, product documentation, architecture documentation, and established repository conventions.
- Keep the user informed in Spanish when a decision, permission, or clarification is required.

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