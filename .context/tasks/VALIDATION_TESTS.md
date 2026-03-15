# Validation Tests

> Phase 6 deliverable. Test plan for proving agentless patterns work on real-world tasks.
> Minimum 10 representative tasks required (Standard rigor per PRE_START_CHECKLIST).

---

## How to Run a Validation Test

1. Pick a task from the list below
2. Use the specified pattern with the given prompt template
3. Evaluate against the success criteria
4. Record results in `VALIDATION_RESULTS.md`

**Scoring:** Pass / Partial / Fail  
**Pass:** All success criteria met  
**Partial:** Most criteria met, one or two gaps  
**Fail:** Core output missing or wrong  

---

## Category 1: Planning (3 tests)

### V-01: Feature breakdown with unknowns

**Pattern:** `planning-tasks`

**Prompt:**
```
Use the planning-tasks skill.
<task>Add email verification to new user registration — users must verify before logging in.</task>
<context>
Stack: Node.js/Express, PostgreSQL, SendGrid
Existing: src/routes/auth.js (register + login), src/models/User.js
Constraints: must work with existing JWT session approach
</context>
```

**Success criteria:**
- [ ] Tasks are numbered, ordered, and atomic
- [ ] Unknown (email delivery reliability) flagged as research candidate
- [ ] Token storage decision flagged (DB vs. Redis vs. in-memory)
- [ ] Parallel tasks identified (email template + endpoint can be parallel)
- [ ] Output saved to `.context/tasks/` or clearly marked for saving
- [ ] No implementation in output (plan only)

---

### V-02: Refactor plan

**Pattern:** `planning-tasks`

**Prompt:**
```
Use the planning-tasks skill.
<task>Break down a refactor of the User model to extract authentication logic into a separate AuthService.</task>
<context>
Stack: Node.js, Sequelize
Files: src/models/User.js (300 lines, auth methods mixed with data methods)
Constraint: must not break existing tests; refactor in small commits
</context>
```

**Success criteria:**
- [ ] Breaking change risks identified
- [ ] Tasks are small enough to commit individually
- [ ] Test-first approach noted (update tests before refactoring)
- [ ] Reversibility heuristic applied (is this a one-way change?)

---

### V-03: Bug triage plan

**Pattern:** `planning-tasks`

**Prompt:**
```
Use the planning-tasks skill.
<task>Users report intermittent 401 errors on authenticated endpoints. Plan a debugging and fix workflow.</task>
<context>
Stack: Node.js/Express, JWT (jsonwebtoken), Redis for session blacklist
Symptom: ~5% of requests fail with 401, no pattern found in logs
</context>
```

**Success criteria:**
- [ ] Investigation steps precede fix steps
- [ ] Hypotheses listed (token expiry, clock skew, Redis connection, etc.)
- [ ] Each hypothesis has a verification step
- [ ] Reproducing test required before fix

---

## Category 2: Research (2 tests)

### V-04: Library selection

**Pattern:** `researching-options`

**Prompt:**
```
Use the researching-options skill.
<task>Which Node.js library should we use for sending transactional email? We need reliable delivery, good TypeScript support, and webhook support for delivery events.</task>
<context>
Stack: Node.js/TypeScript
Scale: ~1,000 emails/day
Providers considered: SendGrid, Postmark, Resend, nodemailer
Constraint: must have webhook support for bounce/delivery events
</context>
```

**Success criteria:**
- [ ] One library recommended (not "it depends")
- [ ] Recommendation includes version or SDK name
- [ ] Top 2-3 tradeoffs stated honestly
- [ ] Confidence level stated
- [ ] Report saved or clearly marked for `.context/tasks/[ID]/research.md`

---

### V-05: Architectural approach comparison

**Pattern:** `researching-options`

**Prompt:**
```
Use the researching-options skill.
<task>What are the tradeoffs between short-lived JWTs with refresh tokens vs. long-lived JWTs for a mobile + web application? Make a recommendation.</task>
<context>
App type: web (React) + mobile (React Native)
Scale: 50K users
Compliance: no specific regulatory requirements
Current: 7-day JWT, no refresh token
</context>
```

**Success criteria:**
- [ ] Security tradeoffs covered (revocation, exposure window)
- [ ] UX tradeoffs covered (logout behavior, silent refresh)
- [ ] One approach recommended with rationale
- [ ] Mobile-specific considerations noted

---

## Category 3: Design (2 tests)

### V-06: ADR for database choice

**Pattern:** `designing-systems`

**Prompt:**
```
Use the designing-systems skill.
<task>Decide whether to use PostgreSQL JSONB columns or a separate tables approach for storing user preferences (up to 50 key-value pairs per user).</task>
<context>
Stack: PostgreSQL, Sequelize
Scale: 100K users, preferences read on every login
Existing ADRs: none relevant
Reversibility: migration required to change — moderately irreversible
</context>
```

**Success criteria:**
- [ ] ADR written in standard format (Status, Decision, Rationale, Consequences, Rejected)
- [ ] Both options analyzed with honest tradeoffs
- [ ] Query pattern implications addressed
- [ ] Migration path noted
- [ ] Saved to `.context/decisions/`

---

### V-07: Two-way door — no ADR needed

**Pattern:** `designing-systems`

**Prompt:**
```
Use the designing-systems skill.
<task>Should OAuth helper functions go in src/lib/oauth/ or src/utils/oauth/?</task>
<context>
Existing: src/lib/auth/ (JWT helpers), src/utils/ (string formatting, date helpers)
No existing OAuth code yet
</context>
```

**Success criteria:**
- [ ] Correctly identified as two-way door (easy to reverse with a rename)
- [ ] No ADR written (correct behavior — skip for two-way doors)
- [ ] Recommendation given with brief rationale
- [ ] Output is concise (not a full ADR for a trivial decision)

---

## Category 4: Implementation (2 tests)

### V-08: New endpoint

**Pattern:** `implementing-features`

**Prompt:**
```
Use the implementing-features skill.
<task>Implement POST /auth/refresh — accept a refresh token in a httpOnly cookie, return a new access token.</task>
<context>
Spec:
- [ ] Reads refresh token from httpOnly cookie 'refresh_token'
- [ ] Returns 401 if missing or invalid
- [ ] Returns 200 with new access token in response body
- [ ] Refresh token itself is rotated (new refresh token issued)
- [ ] Old refresh token invalidated in Redis blacklist
Relevant files: src/routes/auth.js (register/login for pattern), src/middleware/auth.js
Stack: Express, ioredis, jsonwebtoken
</context>
```

**Success criteria:**
- [ ] All 5 spec items implemented
- [ ] Follows existing error format from auth.js
- [ ] One question asked if Redis key format is ambiguous (not assumed)
- [ ] No additional scope creep (no unrequested changes)

---

### V-09: Bug fix with constraints

**Pattern:** `implementing-features`

**Prompt:**
```
Use the implementing-features skill.
<task>Fix: PATCH /users/:id allows users to update other users' profiles. Authorization check is missing.</task>
<context>
Spec:
- [ ] Users can only update their own profile (req.user.id === params.id)
- [ ] Admin role bypasses this check
- [ ] Returns 403 (not 401) for authorization failures
- [ ] No change to existing validation logic
Relevant file: src/routes/users.js (updateProfile handler)
Constraint: only modify updateProfile handler, do not touch other handlers
</context>
```

**Success criteria:**
- [ ] Authorization check added before update logic
- [ ] Admin bypass implemented
- [ ] Returns 403 (not some other status)
- [ ] No other handlers modified
- [ ] Change is minimal (no refactoring beyond scope)

---

## Category 5: Testing (2 tests)

### V-10: Unit tests with edge cases

**Pattern:** `writing-tests`

**Prompt:**
```
Use the writing-tests skill.
<task>Write tests for the POST /auth/refresh endpoint implemented in V-08.</task>
<context>
Implementation: src/routes/auth.js (refreshToken handler)
Test framework: jest, supertest
Mock strategy: mock ioredis and jsonwebtoken
Required cases:
- Happy path: valid refresh token → new access token
- Edge: refresh token in blacklist
- Edge: expired refresh token
- Error: missing cookie
- Security: old refresh token is invalidated after use (rotation)
</context>
```

**Success criteria:**
- [ ] All 5 required cases covered
- [ ] Tests are independent (no shared state between tests)
- [ ] Redis mock correctly simulates blacklist
- [ ] Token rotation test verifies the old token is blacklisted
- [ ] All tests pass on clean run

---

### V-11: Test blocked by untestable code

**Pattern:** `writing-tests`

**Prompt:**
```
Use the writing-tests skill.
<task>Write tests for the email notification service (src/services/emailService.js).</task>
<context>
Implementation: src/services/emailService.js
Note: SendGrid client is instantiated at module level with new SendGridClient(process.env.SENDGRID_API_KEY)
Test framework: jest
</context>
```

**Success criteria:**
- [ ] Correctly identifies that module-level client prevents mocking
- [ ] Returns `❌ Blocked` result (not forced tests)
- [ ] Blocker is specific (not "can't test this")
- [ ] Suggests specific refactor: dependency injection for SendGrid client
- [ ] Does NOT write brittle tests that hit real API

---

## Combination Tests (2 tests)

### V-12: Research → Design → Implement chain

**Patterns:** `researching-options` → `designing-systems` → `implementing-features`

**Goal:** Choose and implement a password hashing approach for a new Node.js API.

**Flow:**
1. `researching-options`: bcrypt vs. argon2 vs. scrypt
2. `designing-systems`: write ADR based on research
3. `implementing-features`: implement per ADR

**Success criteria:**
- [ ] Research output feeds directly into design (no re-stating the question)
- [ ] ADR references research findings by name
- [ ] Implementation follows ADR constraints exactly
- [ ] Handoff between patterns is via `.context/` files (no information loss)

---

### V-13: Plan → Implement → Test chain

**Patterns:** `planning-tasks` → `implementing-features` → `writing-tests`

**Goal:** Add rate limiting to the login endpoint.

**Flow:**
1. `planning-tasks`: break down rate limiting implementation
2. `implementing-features`: implement per plan (one task at a time)
3. `writing-tests`: test the implementation

**Success criteria:**
- [ ] Plan has ≥3 tasks (middleware setup, endpoint integration, config)
- [ ] Implementation follows plan task order
- [ ] Tests cover rate limit exceeded case
- [ ] No coordination pattern needed — direct chain works

---

## Validation Scoring Summary

| ID | Pattern | Task Type | Pass / Partial / Fail | Notes |
|---|---|---|---|---|
| V-01 | planning-tasks | Feature breakdown | | |
| V-02 | planning-tasks | Refactor plan | | |
| V-03 | planning-tasks | Bug triage | | |
| V-04 | researching-options | Library selection | | |
| V-05 | researching-options | Approach comparison | | |
| V-06 | designing-systems | ADR decision | | |
| V-07 | designing-systems | Two-way door | | |
| V-08 | implementing-features | New endpoint | | |
| V-09 | implementing-features | Bug fix | | |
| V-10 | writing-tests | Full unit test | | |
| V-11 | writing-tests | Blocked test | | |
| V-12 | research+design+impl | Chain | | |
| V-13 | plan+impl+test | Chain | | |

**Pass threshold for Phase 7 gate:** ≥11/13 Pass, no Fails on core patterns (V-04 through V-10).
