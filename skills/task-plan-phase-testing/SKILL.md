---
name: task-plan-phase-testing
description: Load when the task's primary concern is tests — fixing failing tests, adding coverage to existing code, or implementing a feature test-first (TDD).
user-invocable: false
---

# Phase: Testing

Load this skill when the task's **primary concern is test quality**. This
includes: fixing failing tests, adding coverage to under-tested code, or
driving a feature implementation test-first (TDD). For tasks where testing is
just a trailing step after implementation — not the primary concern — load
`task-plan-phase-completion` instead, which covers light validation.

## When to Load This Skill

Load `task-plan-phase-testing` when the task matches any of these:

- **Failing tests**: Task is "fix the failing test suite" or "fix N broken tests"
- **Coverage**: Task is "add tests for X" or "bring coverage above N%"
- **TDD**: Task drives implementation via tests written first
- **Test refactor**: Task is cleaning up or restructuring existing tests

Do NOT load this skill when:
- Testing is one final verification step after implementation (use completion)
- The codebase has no tests and adding tests is not the stated goal

## @tester Delegation Structure

Every tester delegation must include all of these fields. The @tester agent
will invoke `testing-discipline` internally; you do not need to invoke it.

```
What to test: [feature, module, or failure description]
Files involved:
  - [path/to/file]: [what it does]
Test requirements from the plan: [list from plan.md acceptance criteria]
Existing test patterns: [reference to .context/testing/ files]
Specific scenarios to cover:
  - [scenario 1 — happy path]
  - [scenario 2 — error/edge case]
  - [scenario 3 — boundary condition]
Success criteria:
  - All specified scenarios have passing tests
  - No test smells (no mocking internals, no testing implementation details)
  - [coverage target, if any]
```

## Test Status Tracking

Add this table to `plan.md` `## Progress` section when dispatching @tester:

```markdown
| Test Area | Status | Notes |
|-----------|--------|-------|
| Unit — [component] | ⏸️ Pending | — |
| Integration — [flow] | ⏸️ Pending | — |
| Coverage | ⏸️ Pending | — |
| Bugs found | — | — |
```

Status: ⏸️ Pending · 🔄 In Progress · ✅ Done · ❌ Blocked

Update after @tester completes. If bugs are found, route each to a @coder step
before proceeding.

## Debugging Failing Tests

When tests are failing and the root cause is unclear:

1. If @tester fails to identify the cause after one pass, invoke `systematic-debugging` before re-dispatching.
2. If the same test fails across 3+ @tester attempts, invoke `systematic-debugging` — the root cause is structural, not incidental.
3. Document each debugging step in `plan.md` `## Decisions` as it runs.

## Relationship to Other Skills

- **`testing-discipline`**: @tester invokes this internally. You do not need to invoke it.
- **`systematic-debugging`**: Invoke when tests are failing and root cause is unclear after the first @tester pass, or after 3+ failed attempts.
- **`task-plan-phase-implementation`**: If fixing tests requires code changes, delegate those via the implementation skill, then return to testing.
- **`task-plan-phase-completion`**: Load after testing is done to close the task: code review, context updates, retrospective.

**Does NOT cover:** investigation, architecture, @coder dispatch, retrospective, context updates, completion summary.
