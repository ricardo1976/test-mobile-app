---
name: github-workflow
description: Work with GitHub Issues, sub-issues, branches, commits, Pull Requests, and reviews following the repository workflow.
---

# GitHub Workflow

Use this skill whenever the task involves GitHub Issues, sub-issues, branches, commits, Pull Requests, or Pull Request reviews.

## Source of truth

GitHub is the system of record for development requirements and implementation status.

The linked Issue is the authoritative source for the requested behavior unless the user explicitly changes the requirements.

## Issues

Before implementing an Issue:

1. Read the complete Issue.
2. Read all acceptance criteria.
3. Read relevant comments.
4. Check linked or parent Issues.
5. Check related Pull Requests.
6. Identify dependencies.
7. Determine whether the Issue is sufficiently defined.

Do not invent missing requirements.

## Sub-issues

Create sub-issues only when:

- the parent Issue contains multiple independently implementable units;
- the units have clear boundaries;
- independent progress or review is useful.

Do not create sub-issues for trivial implementation steps.

## Branches

Use one dedicated branch per implementation unit.

Prefer descriptive branch names such as:

- `feature/<short-description>`
- `fix/<short-description>`
- `refactor/<short-description>`

Use the repository's existing branch naming convention if one exists.

## Commits

Commit messages must be written in English.

Use imperative wording.

Prefer concise messages such as:

- `Add daily question selection`
- `Fix question localization fallback`
- `Add tests for deterministic category selection`

Do not mix unrelated changes in the same commit.

## Pull Requests

Pull Request titles and descriptions must be written in English.

A Pull Request should:

- reference the GitHub Issue;
- summarize the implementation;
- explain relevant design decisions;
- describe verification performed;
- identify any known limitations.

Use GitHub's native issue-closing syntax when appropriate, for example:

`Closes #123`

Do not close an Issue manually when the Pull Request is intended to close it automatically.

## Review

A Pull Request must be independently reviewed before completion when the workflow requires review.

Reviewer findings must distinguish:

- BLOCKING
- RECOMMENDATION

Do not modify code as part of a review unless explicitly asked to switch from review to implementation.
