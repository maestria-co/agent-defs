# Pattern Examples

> Phase 2 deliverable. Demonstrates each pattern applied to real tasks.
> These are condensed versions of the full examples embedded in each SKILL.md.

---

## How to Use These Examples

Each example shows: the pattern, the input, and the output shape.
Use them to calibrate what "good output" looks like for each pattern.

---

## `planning-tasks` Examples

### Example 1: Feature with multiple components

**Input task:** "Add OAuth 2.0 to the Express API. Support Google and GitHub."

**Output shape:**
```
Plan: OAuth 2.0 Authentication
Saved: .context/plans/oauth-implementation.md
Tasks: 5 total (S: 1, M: 2, L: 2)
Unknowns flagged: refresh token strategy (blocks Task 2)
Parallel: Tasks 4 and 5 can run after Task 3
```

Key: unknowns are flagged as research tasks before implementation tasks.

### Example 2: Don't plan this

**Input:** "Add a `last_login` field to User model."

**Output:** "This is a single well-defined action. Use `implementing-features` directly."

---

## `researching-options` Examples

### Example 1: Library selection

**Input:** "Which JWT library should we use for our Express/TypeScript API?"

**Output shape:**
```
Research complete: JWT Library Selection
Recommendation: jsonwebtoken — 50M+ weekly downloads, Auth0-maintained, full TS types
Main tradeoff: Sync crypto vs. jose's async WebCrypto (not a concern at moderate load)
Confidence: High
Full report: .context/research/jwt-library-selection.md
```

Key: one recommendation, not "here are your options."

### Example 2: Product decision disguised as research

**Input:** "Should we support social login or email/password only?"

**Output:** "This is a product decision, not a technical one. Route to product owner."

---

## `designing-systems` Examples

### Example 1: Architecture decision with ADR

**Input:** "Decide Redis vs. in-memory caching for user profile endpoint (500 req/s)."

**Output shape:**
```
Decision: Use Redis to support planned multi-instance deployment.
ADR: .context/decisions/ADR-007-caching-strategy.md
Tradeoffs accepted: Added Redis infrastructure dependency.
Implementation notes: ioredis, 60s TTL, write-through on profile updates.
```

Key: one decision, explicitly documented, includes what NOT to do.

### Example 2: Two-way door (no ADR needed)

**Input:** "Should OAuth helpers go in lib/ or utils/?"

**Output:** "Two-way door. No ADR needed. Use lib/oauth/ (consistent with lib/auth/)."

---

## `implementing-features` Examples

### Example 1: New model

**Input:** "Create the OAuthProvider model and migration."

**Output shape:**
```
Implemented: OAuthProvider model and migration
Files changed:
- src/models/OAuthProvider.js — new model, encrypted token fields
- db/migrations/20240315-create-oauth-provider.js — table + FK
Acceptance criteria: [x] userId FK, [x] encrypted tokens, [x] migration runs clean
```

### Example 2: Ambiguous spec — ask before starting

**Input:** "Update user profile to support partial updates." (no acceptance criteria)

**Output:** "Before I proceed, one question: should missing fields be ignored or treated as nulls?"

---

## `writing-tests` Examples

### Example 1: Full coverage report

**Input:** "Write tests for OAuthProvider model."

**Output shape:**
```
Tests: ✅ All passing
Coverage: 94% | Tests: 12 (unit: 12)
Files: tests/models/OAuthProvider.test.js
Cases: happy path (create/retrieve), edge (null userId, max token length),
       error (duplicate constraint), security (token encrypted at rest)
```

### Example 2: Blocked by untestable code

**Input:** "Write tests for token refresh service."

**Output:**
```
Tests: ❌ Blocked
Reason: Redis client is a module-level singleton with no injection point.
Suggested next: implementing-features — refactor for dependency injection.
```

---

## `coordinating-work` Examples

### Example 1: Full feature workflow

**Input:** "Add Redis caching to user profile endpoint."

**Sequenced steps:**
1. `designing-systems` — Redis vs. in-memory decision → ADR-007
2. `implementing-features` — ioredis integration per ADR-007
3. `writing-tests` — cache hit/miss/invalidation tests

### Example 2: Task that doesn't need coordination

**Input:** "Fix the case-sensitive email bug."

**Output:** "Single bug fix. Use `implementing-features` → `writing-tests` directly. No coordination needed."

---

## Pattern Decision Tree

```
Task involves code?
├── Yes, spec is clear          → implementing-features
├── Yes, spec unclear           → ask one question first
├── Yes, 3+ steps              → planning-tasks → implementing-features × N
└── Yes, architecture unclear  → designing-systems first

Task is a question?
├── Technical (library, approach) → researching-options
├── Architecture decision         → designing-systems
└── Product/business             → stop, route to stakeholder

Task is multi-pattern?
├── 1-2 patterns, clear sequence → use them directly, no coordination
└── 3+ patterns, interdependent  → coordinating-work
```
