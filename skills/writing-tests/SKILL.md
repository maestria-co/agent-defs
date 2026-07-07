---
name: writing-tests
description: >
  Writes and runs a test suite for a piece of code, covering happy path, edge cases,
  error cases, and security cases. Use when: implementation is complete and needs
  test coverage, a bug needs a reproduction test and fix validation, or code needs
  coverage before a refactor. Do not use when: the code under test is not yet
  implemented, or the spec is still unclear.
degree_of_freedom: medium
---

# Skill: Writing Tests

## Purpose

Validate that code behaves correctly across the full range of inputs and conditions.
Tests verify the *contract* (observable behavior), not the *internals* (implementation
details). Tests coupled to internals break on refactors and create false confidence.

Think before writing. Read the spec and implementation first. Identify all the ways the
code can fail before writing a single test.

---

## Pre-flight Checks

**Check 1 — Read the implementation and spec**

Read both the spec/acceptance criteria and the implementation code before writing tests.

- If implementation does not exist → stop. Tests cannot be written for unimplemented code.
  Surface: "Implementation needed before tests can be written."
- If implementation exists but spec/acceptance criteria are missing → infer from the
  implementation's behavior and state your assumptions in the test file.

**Check 2 — Find the test framework and conventions**

Locate 2–3 existing test files in the same area. Identify:
- Test framework and runner (Jest, Vitest, pytest, etc.)
- Folder structure and naming convention (`*.test.ts`, `*.spec.js`, `tests/`)
- How mocks and fixtures are set up
- How async code is tested

- Write new tests that match these conventions exactly.
- If no tests exist in the codebase → use the framework in the project manifest (package.json, etc.).

---

## Execution Steps

### Step 1 — List Test Cases Before Writing

Write a comment block listing every test case you plan to write, grouped by category:

```
// Happy path:     valid input → expected output
// Edge cases:     null, empty, boundary values, special chars
// Error cases:    invalid input, missing required fields, downstream failures
// State cases:    before/after state transitions, concurrent writes
// Security cases: [only if code handles auth, external input, or file I/O]
//   - SQL injection / NoSQL injection
//   - Malformed or oversized inputs
//   - Missing/expired/tampered tokens
```

**See `references/code-patterns.md` for concrete test structure examples** (model testing, service testing, integration testing).

### Step 2 — Write Happy Path Tests

Verify that the code does what it's supposed to do for valid, expected input.
At minimum: one test per distinct success path.

### Step 3 — Write Edge Case Tests

Cover boundary conditions:
- Empty inputs (`""`, `[]`, `{}`, `null`, `undefined`)
- Boundary values (0, -1, max int, empty string vs. whitespace-only)
- Special characters in string inputs
- Date/time edge cases (midnight, DST transitions, leap years) if applicable

### Step 4 — Write Error Case Tests

Verify that failures are handled explicitly and produce correct error behavior:
- Invalid input returns the correct error code and message
- Missing required fields are rejected
- Downstream service failures are handled (do not crash, return appropriate error)
- Every error path is tested — no silent swallows

### Step 5 — Write Security Tests (If Applicable)

For code that handles authentication, authorization, or external input:
- SQL/NoSQL injection attempts produce errors, not data leaks
- Malformed tokens return 401, not 500
- Oversized inputs are rejected with 400/413, not crashing the service
- Unauthorized access to another user's resources returns 403

### Step 6 — Run the Suite

Run tests with the no-watch flag:
- Jest/Vitest: `--watchAll=false` or `--run`
- pytest: `pytest` (no watch by default)
- Other runners: ensure the process exits after running

**Coverage targets:**
- New code: ≥90%
- Bug fixes: must include a test that reproduces the bug and passes after the fix
- Refactors: coverage must not decrease from before the refactor

- If all tests pass and coverage is met → proceed to output.
- If tests fail → diagnose and fix tests (not the implementation, unless the implementation is wrong). **See `references/troubleshooting.md` for common failures and diagnostics.**
- If code is untestable (global state, no dependency injection) → report it. **See `references/edge-cases.md` for untestable patterns and how to unblock them.** Do not mock the thing under test.

### Step 7 — Report

Produce a test report.

---

## Output Formats

**All tests passing:**
```
Tests: ✅ All passing
Coverage: [X%] | Tests: N (unit: N, integration: N)
Files: [test files written or modified]

Suggested next: [next task in plan, or "done"]
```

**Tests failing or bugs found:**
```
Tests: ⚠️ N failing

Bugs:
- Bug: [description] | File: [path:line] | Input: [reproduction] | Expected: [value] | Actual: [value] | Severity: [low/medium/high]

Suggested next: implementing-features (fix bugs, then return to writing-tests)
```

**Code untestable:**
```
Tests: ❌ Blocked
Reason: [e.g., global state in src/services/auth.js:47, no dependency injection]

Suggested next: implementing-features (refactor for testability, then return to writing-tests)
```

---

## Constraints

- Do not write production code — route testability fixes to `implementing-features`
- Do not skip edge or security cases to hit coverage targets faster
- Do not mock the code under test or its internal utilities
- Always use no-watch flags — never leave a hanging test runner
- Always leave the test suite green before completing — do not hand off a broken suite
- Test the contract (behavior), not the internals (implementation)
- **See `references/edge-cases.md` for patterns that block testability** and how to report them to `implementing-features` for refactoring
- Scope: reads and writes test files; reads implementation files and spec; does not modify source code
