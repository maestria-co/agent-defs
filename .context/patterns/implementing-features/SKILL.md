---
name: implementing-features
description: >
  Implements a feature, bug fix, or refactor from a clear specification. Use when:
  the task has clear acceptance criteria, a bug is diagnosed and the fix is understood,
  or code needs refactoring with a clear goal. Do not use when: the spec is unclear,
  an architecture decision still needs to be made, or the task needs to be broken into
  multiple steps first.
degree_of_freedom: low
---

# Skill: Implementing Features

## Purpose

Write the minimum correct code that satisfies the spec and matches existing patterns.
Read before you write. Implement minimally. Verify before declaring done.

Do not invoke this pattern if the spec is unclear or acceptance criteria are missing.
Use `planning-tasks` to define the task first, or ask one clarifying question.

---

## Pre-flight Checks

**Check 1 — Confirm the spec is complete**

Read the task specification. Verify it includes:
- What to build (feature/fix/refactor description)
- Acceptance criteria (testable conditions that define "done")
- Output location (which files to create or modify)

- If any of these is missing → ask one focused question to resolve the most critical gap.
  Do not start implementation until you can verify completion.
- If spec is complete → proceed.

**Check 2 — Read before writing**

Read in this order before writing a single line of code:

1. The spec and acceptance criteria
2. Existing code in the area being changed (patterns, naming, error handling)
3. `.context/decisions/` ADRs relevant to this area

- If an ADR constrains this implementation → follow it. Do not contradict ADRs silently.
- If you discover a conflict between the spec and an existing ADR → stop and surface it.

---

## Execution Steps

### Step 1 — Restate the Acceptance Criteria

Write out each acceptance criterion before touching code. This is your "definition of done."
You will check each criterion explicitly before completing this pattern.

### Step 2 — Identify the Scope

Determine exactly which files will change. List them before starting.

If you find that implementing the spec requires changing code significantly outside your
listed scope → stop. Surface this as a scope change before proceeding.

### Step 3 — Implement Minimally

Write the smallest change that satisfies the spec:
- Match existing naming conventions, error handling patterns, and code style
- No speculative refactors ("while I'm here I'll also...")
- No unasked features (YAGNI)
- One concern per function
- Inject dependencies; avoid global state — untestable code will fail in `writing-tests`

For bugs: fix the root cause, not just the symptom. State what the root cause was.

### Step 4 — Verify

Run the build. Confirm it compiles and passes lint.

- If build fails → fix before moving on. Do not hand off failing code.
- If you cannot run the build → note this explicitly in the output.

### Step 5 — Self-Review

Read your own diff as if you were reviewing someone else's work. Check:

- [ ] Every acceptance criterion is met
- [ ] No regressions introduced in adjacent code
- [ ] No secrets, tokens, or credentials committed
- [ ] Error paths handled explicitly (no silent swallows)
- [ ] No dead code (commented-out blocks, unused imports)

If any check fails → fix it before completing.

---

## Output Format

```
Implemented: [Task name]

Files changed:
- [path] — [what changed and why, if non-obvious]

Acceptance criteria:
- [x] [criterion — verified]
- [x] [criterion — verified]

Key decisions:
- [Any non-obvious choice made and why]
- [ADR followed: ADR-NNN if applicable]

Suggested next: writing-tests (verify implementation with tests)
```

---

## Examples

<examples>

<example>
<scenario>Implementing a new model and database migration</scenario>
<input>
<task>Create the OAuthProvider model and database migration.</task>
<context>
- Existing models in src/models/ using Sequelize ORM (see src/models/User.js for style)
- Database is PostgreSQL
- OAuthProvider needs: id, userId (FK → users), provider (google|github), providerId, 
  accessToken, refreshToken, expiresAt, createdAt, updatedAt
- Must not store tokens in plaintext — use encryption utility in src/lib/crypto.js
</context>
</input>
<output>
Implemented: OAuthProvider model and migration

Files changed:
- src/models/OAuthProvider.js — new Sequelize model with encrypted token fields
- db/migrations/20240315-create-oauth-provider.js — creates table, FK to users

Acceptance criteria:
- [x] Model includes userId foreign key referencing users table
- [x] accessToken and refreshToken encrypted via src/lib/crypto.js
- [x] Timestamps (createdAt, updatedAt) included
- [x] Migration runs without errors (verified on local DB)

Key decisions:
- Used crypto.encrypt() on accessToken and refreshToken fields per ADR-003
- Added index on (userId, provider) for common query pattern

Suggested next: writing-tests
</output>
</example>

<example>
<scenario>Fixing a bug with a known root cause</scenario>
<input>
<task>Fix: User login fails silently when email has uppercase letters.</task>
<context>
- Bug reported in src/services/auth.js line 47
- Root cause: email comparison is case-sensitive; DB stores lowercase, input is not normalized
- Acceptance criteria: login succeeds for mixed-case email; all existing login tests still pass
</context>
</input>
<output>
Implemented: Fix case-sensitive email comparison in login

Files changed:
- src/services/auth.js:47 — added .toLowerCase() on email before DB lookup

Root cause: email input was not normalized before lookup. DB stores emails lowercase
(enforced at registration) but login did not normalize input.

Acceptance criteria:
- [x] Login succeeds for mixed-case email (e.g., User@Example.com)
- [x] Login fails correctly for wrong password (unchanged behavior)
- [x] Existing login tests pass

Suggested next: writing-tests (add regression test for mixed-case email)
</output>
</example>

<example>
<scenario>Spec is ambiguous — pattern asks for clarification before starting</scenario>
<input>
<task>Update the user profile endpoint to support partial updates.</task>
<context>
- Endpoint: PATCH /users/:id
- No acceptance criteria provided
</context>
</input>
<output>
Before proceeding, one question: should missing fields in the PATCH body be ignored
(partial update) or treated as explicit nulls (clearing the field)?

Example: PATCH /users/1 with body { "name": "Alice" } — should "email" remain
unchanged or be set to null?

(If you want me to make an assumption and move forward, say "proceed" and I'll go
with: missing fields are ignored, only provided fields are updated.)
</output>
</example>

</examples>

---

## Constraints

- Do not modify code outside the defined task scope without explicit approval
- Do not make architecture decisions — if one is needed, stop and use `designing-systems`
- Do not signal completion without verifying all acceptance criteria
- Do not commit secrets — use environment variables
- Do not silently swallow errors — every failure path must handle failure explicitly
- Write testable code — inject dependencies, avoid global state
- Scope: reads and writes source code files; reads `.context/decisions/`
