# Recipe: Full Feature Workflow

> **When to use:** New feature with unknowns — new external dependencies, significant architecture, multi-component.
> **Patterns:** All 5 (except coordinating-work — you ARE the coordinator here).
> **Total time:** Days to a sprint.

---

## Example: Add OAuth 2.0 authentication (Google + GitHub)

**Situation:** Current auth is email/password only. Adding social login.

---

### Step 0 — Create brief

Create `.context/tasks/oauth-auth/brief.md`:

```markdown
# Brief: OAuth 2.0 Authentication

## Goal
Add social login via Google and GitHub OAuth 2.0.

## Acceptance Criteria
- [ ] Users can sign in with Google account
- [ ] Users can sign in with GitHub account
- [ ] Existing email/password login continues to work
- [ ] OAuth accounts are linked to existing user by email (if match found)
- [ ] Tokens stored encrypted at rest
- [ ] /auth/google and /auth/github callback endpoints
- [ ] Frontend has "Login with Google" and "Login with GitHub" buttons

## Out of Scope
- OAuth account unlinking
- Additional providers (Twitter, etc.)
- Mobile app OAuth (web only)

## Timeline
Next sprint (2 weeks)
```

---

### Stage 1: Research (1-2 hours)

#### 1a — researching-options: JWT library

```
Use the researching-options skill.

<task>Which OAuth 2.0 library should we use for Node.js/Express? Evaluate passport.js vs. custom implementation vs. a newer alternative.</task>
<context>
Stack: Node.js/Express, existing JWT auth (jsonwebtoken)
Providers: Google, GitHub
Constraints: team familiar with Express middleware, prefer maintained libraries
</context>
```

Saved to: `.context/tasks/oauth-auth/research-oauth-library.md`

---

### Stage 2: Design (2-4 hours)

#### 2a — designing-systems: OAuth token storage

```
Use the designing-systems skill.

<task>Decide how to store OAuth provider tokens and link OAuth accounts to users.</task>
<context>
Research: .context/tasks/oauth-auth/research-oauth-library.md
Existing: User model (src/models/User.js), existing JWT session approach
Constraints: tokens must be encrypted at rest (compliance)
Options: separate OAuthProvider table vs. columns on User table
Reversibility: one-way door — schema migration required to change
</context>
```

Saved to: `.context/decisions/ADR-010-oauth-token-storage.md`

---

### Stage 3: Plan (30-60 minutes)

#### 3a — planning-tasks

```
Use the planning-tasks skill.

<task>Plan the OAuth 2.0 implementation.</task>
<context>
Brief: .context/tasks/oauth-auth/brief.md
Research: .context/tasks/oauth-auth/research-oauth-library.md
Decision: .context/decisions/ADR-010-oauth-token-storage.md
Stack: Node.js/Express, Sequelize, React
Existing: src/models/User.js, src/routes/auth.js, src/components/LoginPage.jsx
</context>
```

Expected output: `.context/tasks/oauth-auth/plan.md`

Typical plan:
```
Task 1 (M): OAuthProvider model + migration
Task 2 (M): Google OAuth strategy (passport-google-oauth20)
Task 3 (M): GitHub OAuth strategy (passport-github2)  ← parallel with Task 2
Task 4 (S): Account linking logic (match by email)
Task 5 (S): /auth/google and /auth/github callback routes
Task 6 (M): Frontend OAuth buttons + redirect handling
Task 7 (S): Update CLAUDE.md with OAuth env vars required
```

---

### Stage 4: Implement (iterative)

Run `implementing-features` for each task. Work through sequentially; Tasks 2 and 3 can be parallelized.

Example for Task 1:

```
Use the implementing-features skill.

<task>Create OAuthProvider model and migration.</task>
<context>
ADR: .context/decisions/ADR-010-oauth-token-storage.md
Spec:
- [ ] OAuthProvider table with userId (FK), provider, providerUserId, encryptedAccessToken, encryptedRefreshToken, createdAt
- [ ] userId FK → Users.id, cascade delete
- [ ] provider index for lookup performance
- [ ] tokens encrypted using existing encryption utility (src/utils/crypto.js)
Existing: src/models/User.js (for FK reference pattern), db/migrations/ (for style)
</context>
```

Commit each task: `git commit -m "feat(oauth): OAuthProvider model and migration"`

---

### Stage 5: Test (per task)

Run `writing-tests` after each implementation task. Don't save all tests for the end.

Example after Task 1:

```
Use the writing-tests skill.

<task>Write tests for OAuthProvider model.</task>
<context>
Implementation: src/models/OAuthProvider.js
Test file: tests/models/OAuthProvider.test.js
Required cases:
- Happy: create with all fields, retrieve by userId + provider
- Edge: null refreshToken allowed, max field lengths
- Error: duplicate userId+provider, missing required fields
- Security: tokens are encrypted at rest (decryptedValue !== storedValue)
</context>
```

---

### Stage 6: Final verification

After all tasks and tests are done:

```
Re-read: .context/tasks/oauth-auth/brief.md
Check every acceptance criterion:
[ x ] Users can sign in with Google account
[ x ] Users can sign in with GitHub account
...
```

Then write retrospective:

```markdown
# Retrospective: OAuth 2.0 Implementation

## What went well
- passport.js research saved us from building a custom flow
- ADR caught the token storage decision early — avoided a migration mid-sprint

## What slowed us down
- Account linking edge case (multiple Google accounts → same email) not in original brief
- Had to add Task 8 mid-sprint

## Lessons to promote
- [ ] Add OAuth edge cases to brief.md template (.context/tasks/)
- [ ] Update domains/entities.md with OAuthProvider entity
```

---

## Key Principle

You are the coordinator in this recipe. There's no `coordinating-work` pattern needed because the workflow is:

```
brief → research → decide → plan → [implement + test] × N → verify → retro
```

The sequence is linear. Each stage's output becomes the next stage's input. You manage the handoffs directly via `.context/tasks/` files — no orchestration pattern needed.

Use `coordinating-work` only if you need an AI to reason about which patterns to run and in what order. For a known workflow like this, you don't.
