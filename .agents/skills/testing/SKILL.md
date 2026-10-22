---
name: testing
description: Design, implement, and verify automated tests for Flutter application behavior.
---

# Testing

Use this skill whenever a change modifies behavior, business logic, state, persistence, localization, or important UI flows.

## Test selection

Prefer:

- unit tests for pure business logic;
- widget tests for widget behavior and interaction;
- integration tests for important end-to-end user flows.

## Test quality

Tests must verify observable behavior rather than implementation details where practical.

Include:

- normal cases;
- boundary cases;
- invalid inputs;
- empty states;
- error states;
- localization behavior when applicable;
- deterministic behavior where required.

Do not weaken an existing test simply to make an implementation pass.

Do not remove coverage without an explicit reason.

## Verification

Run the smallest relevant test set during development.

Before completion, run the broader relevant test suite and static analysis.

Report verification results accurately.
