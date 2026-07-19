# Implementing Features — Code Patterns

**See also**: [`../SKILL.md`](../SKILL.md)

**In this guide:**
- Pattern 1: Creating new models with database migrations
- Pattern 2: Fixing bugs with known root causes
- Pattern 3: Handling ambiguous specifications

---

## Pattern 1: Creating New Models with Database Migrations

When implementing new entities (models, database tables, or data structures), follow this pattern to ensure consistency with existing code style and database conventions.

**Key principles:**
- Use existing ORM conventions (e.g., Sequelize in TypeScript projects)
- Encrypt sensitive fields (tokens, secrets, PII) per ADR guidelines
- Include timestamps for audit trails (`createdAt`, `updatedAt`)
- Define foreign keys and indexes for common query patterns
- Verify the migration runs without errors on the target database

**Example: OAuthProvider model and migration**

```
Task: Create the OAuthProvider model and database migration.

Context:
- Existing models in src/models/ using Sequelize ORM (see src/models/User.js for style)
- Database is PostgreSQL
- OAuthProvider needs: id, userId (FK → users), provider (google|github), providerId,
  accessToken, refreshToken, expiresAt, createdAt, updatedAt
- Must not store tokens in plaintext — use encryption utility in src/lib/crypto.js
```

**Output:**

```
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
```

**Checklist for this pattern:**
- [ ] Model file follows existing naming and structure (PascalCase, exports Sequelize model)
- [ ] All required fields are present with correct types
- [ ] Sensitive fields are encrypted using project's encryption utility
- [ ] Foreign key relationships are defined with correct constraints
- [ ] Timestamps (`createdAt`, `updatedAt`) are included
- [ ] Migration file is properly named with timestamp prefix
- [ ] Migration includes up and down functions
- [ ] Indexes are created for foreign keys and commonly queried fields
- [ ] Migration runs successfully on a test database

---

## Pattern 2: Fixing Bugs with Known Root Causes

When a bug has been diagnosed and the root cause identified, implement the fix by addressing the root cause (not just the symptom). Verify the fix resolves the issue and does not introduce regressions.

**Key principles:**
- Fix the root cause, not just the symptom
- Clearly state what the root cause was
- Verify existing tests still pass (no regressions)
- Make the smallest change that resolves the issue
- Document the root cause in the commit message

**Example: Case-sensitive email comparison in login**

```
Task: Fix — User login fails silently when email has uppercase letters.

Context:
- Bug reported in src/services/auth.js line 47
- Root cause: email comparison is case-sensitive; DB stores lowercase, input is not normalized
- Acceptance criteria: login succeeds for mixed-case email; all existing login tests still pass
```

**Output:**

```
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
```

**Checklist for this pattern:**
- [ ] Root cause is clearly identified and documented
- [ ] Fix addresses the root cause, not just the symptom
- [ ] Change is minimal and focused
- [ ] All existing tests pass
- [ ] Regression test is added (route to writing-tests skill)
- [ ] No unrelated changes are included
- [ ] Code style matches existing patterns

---

## Pattern 3: Handling Ambiguous Specifications

When the specification is incomplete or ambiguous, ask one focused clarifying question before proceeding. Do not make assumptions or proceed with guesses.

**Key principles:**
- Stop before writing code if the spec is unclear
- Ask one focused question that resolves the most critical gap
- Provide a suggested assumption you will proceed with if no clarification is given
- Do not start implementation until the ambiguity is resolved or an assumption is explicitly agreed upon

**Example: Ambiguous PATCH endpoint specification**

```
Task: Update the user profile endpoint to support partial updates.

Context:
- Endpoint: PATCH /users/:id
- No acceptance criteria provided
```

**Output:**

```
Before proceeding, one question: should missing fields in the PATCH body be ignored
(partial update) or treated as explicit nulls (clearing the field)?

Example: PATCH /users/1 with body { "name": "Alice" } — should "email" remain
unchanged or be set to null?

(If you want me to make an assumption and move forward, say "proceed" and I'll go
with: missing fields are ignored, only provided fields are updated.)
```

**Checklist for this pattern:**
- [ ] The spec is read carefully before any questions are asked
- [ ] The question focuses on the most critical gap, not a minor detail
- [ ] A suggested assumption is provided for the asker to accept or override
- [ ] No implementation begins until the clarification is resolved

---

## See Also

- **Pre-flight Checks** in main SKILL.md — validate your spec before choosing a pattern
- **writing-tests** skill — verify your implementation after coding
- **`.context/decisions/`** — check ADRs for architectural constraints before implementing

