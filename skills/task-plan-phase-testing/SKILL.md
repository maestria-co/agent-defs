---
name: task-plan-phase-testing
description: Load when the task's primary concern is tests — fixing failing tests, adding coverage to existing code, or implementing a feature test-first (TDD).
user-invocable: false
---

# Phase: Testing

Load this skill when the task's **dominant focus targets test quality**. This encompasses: remediating failing tests, augmenting coverage for under-tested implementations, or implementing features via test-driven development (TDD). For tasks treating testing as trailing test step rather than primary objective — load `task-plan-phase-completion` instead, which addresses lightweight tests.

## When to Load This Skill

Load `task-plan-phase-testing` when tasks exhibit these characteristics:

- **Failing tests**: Task targets "remediate failing test suite" or "repair N broken tests"
- **Coverage expansion**: Task targets "add tests for X" or "elevate coverage beyond N%"
- **TDD methodology**: Task implements features via test-first approach
- **Test restructuring**: Task involves refactoring or cleaning extant test suites

Bypass when:
- Tests represent terminal confirmation step post-implementation (use completion)
- Implementation lacks tests and test addition isn't stated objective

## @tester Delegation Structure

All tester dispatches require these components. The @tester agent internally loads `testing-discipline`; direct loading unnecessary.

```
What to test: [feature, module, or failure characterization]
Implicated files:
  - [file/path]: [operational purpose]
Test requirements from plan: [plan.md acceptance criteria catalog]
Extant test patterns: [.context/testing/ citations]
Targeted scenarios for tests:
  - [scenario 1 — nominal execution]
  - [scenario 2 — error/boundary scenario]
  - [scenario 3 — edge scenario]
Success thresholds:
  - All catalogued scenarios possess passing tests
  - Zero test smells (no internal mocking, no implementation detail tests)
  - [coverage threshold, when specified]
```

## Test Status Monitoring

Insert this matrix into `plan.md` `## Progress` section when dispatching @tester:

```markdown
| Test Domain | Status | Annotations |
|-------------------|--------|-------------|
| Unit — [component] | ⏸️ Pending | — |
| Integration — [flow] | ⏸️ Pending | — |
| Coverage | ⏸️ Pending | — |
| Defects discovered | — | — |
```

Status indicators: ⏸️ Pending · 🔄 In Progress · ✅ Complete · ❌ Obstructed

Refresh post-@tester completion. Channel discovered defects to @coder steps before progression.

## Debugging Failing Tests

When tests fail with opaque causation:

1. Following initial @tester pass without causation identification, load `systematic-debugging` before re-dispatch.
2. Following 3+ @tester attempts on identical failures, load `systematic-debugging` — causation is architectural, not superficial.
3. Archive each diagnosis action in `plan.md` `## Decisions` as performed.

## Skill Interdependencies

- **`testing-discipline`**: @tester loads internally. Direct loading unnecessary.
- **`systematic-debugging`**: Load when test failures exhibit unclear causation following initial @tester pass, or following 3+ failed attempts.
- **`task-plan-phase-implementation`**: For test remediation requiring code alterations, dispatch via implementation skill, then resume tests.
- **`task-plan-phase-completion`**: Load post-test completion to finalize task: code audit, context refresh, retrospective.

**Excluded scope:** investigation, architecture, @coder orchestration, retrospectives, context updates, completion summary.
