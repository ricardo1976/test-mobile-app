---
name: solution-architecture
description: Analyze architectural impact, dependencies, boundaries, and affected components before making significant changes.
---

# Solution Architecture

Use this skill when a change affects application architecture, shared components, persistence, state management, integrations, platform boundaries, or multiple application layers.

## Objectives

Determine:

- which components are affected;
- which boundaries are crossed;
- which dependencies are introduced or changed;
- whether the proposed design follows the existing architecture;
- whether documentation must be updated;
- whether the change introduces architectural debt.

## Process

1. Read `docs/architecture.md`.
2. Inspect the existing implementation.
3. Identify the affected components.
4. Identify dependencies and data flows.
5. Identify platform-specific behavior.
6. Identify persistence and state-management implications.
7. Compare the proposed change with existing architectural principles.
8. Identify risks and alternatives.
9. Recommend the smallest design that satisfies the requirements.

## Source of truth

Use the actual repository implementation as the source of truth for current behavior.

Use `docs/architecture.md` as the source of documented architectural intent.

If documentation and implementation disagree:

- report the discrepancy;
- do not silently rewrite architecture documentation;
- determine which source reflects the intended behavior before making architectural changes.

## Boundaries

Do not introduce new architectural patterns solely because they are fashionable or theoretically cleaner.

Prefer consistency with the existing application architecture unless there is a concrete reason to change it.

Architecture changes must be explicit and documented when they materially affect the system.
