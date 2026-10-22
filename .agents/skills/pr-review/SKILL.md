---
name: pr-review
description: Perform an independent, structured Pull Request review focused on correctness, requirements, architecture, tests, security, and regressions.
---

# Pull Request Review

Use this skill when reviewing a Pull Request.

## Review order

Review in this order:

1. Linked Issue and acceptance criteria.
2. Changed files and overall diff.
3. Business logic.
4. Architecture.
5. State and persistence behavior.
6. Localization.
7. Tests.
8. Error handling.
9. Security.
10. Performance and maintainability.

## Findings

Classify findings as:

### BLOCKING

A problem that should prevent merging.

Examples:

- incorrect behavior;
- missing required functionality;
- data corruption;
- security vulnerability;
- regression;
- inadequate test coverage for critical behavior;
- architecture violation that creates significant risk.

### RECOMMENDATION

A non-blocking improvement.

Do not turn stylistic preferences into blocking findings.

## Review independence

Do not assume the implementation is correct because tests pass.

Do not modify the implementation while reviewing.

Do not silently fix issues.

Report findings with:

- severity;
- location;
- problem;
- impact;
- recommended resolution.

Conclude with:

`APPROVED`

or

`CHANGES_REQUESTED`
