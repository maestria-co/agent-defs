# Handoff Protocol

This document defines how agents hand work off to each other. Consistent handoffs ensure no context is lost between agents and that every agent has what it needs to begin work immediately.

---

## Core Principle

**A handoff is a complete package.** The receiving agent should be able to start immediately without asking clarifying questions. If the handoff is incomplete, the receiving agent should request the missing pieces before proceeding.

---

## Handoff Message Structure

Every handoff must include these five sections:

```markdown
## Handoff: [Sending Agent] → [Receiving Agent]

**Task:** [One sentence: what needs to be done]

**Context:**
- [Key background fact 1]
- [Key background fact 2]
- [Link to any relevant .context/ files]

**Inputs available:**
- [Artifact or file 1] — [brief description]
- [Artifact or file 2] — [brief description]

**Expected output:**
- [What the receiving agent should produce]
- [Where it should be written (file path, comment, etc.)]

**Constraints:**
- [Any must-follow rules, deadlines, or limitations]
- [Prior decisions that must be respected — link to ADRs if applicable]
```

---

## Handoff Examples

### Manager → Planner
```markdown
## Handoff: Manager → Planner

**Task:** Break down the task of adding OAuth 2.0 authentication to the existing Express API.

**Context:**
- The app currently uses session-based auth with express-session
- The team wants to support Google and GitHub OAuth providers
- See .context/project-overview.md for tech stack details
- See .context/decisions/ADR-003-auth-strategy.md for prior auth decisions

**Inputs available:**
- .context/project-overview.md — tech stack, existing architecture
- src/middleware/auth.js — current auth implementation

**Expected output:**
- A numbered task list with clear inputs, outputs, and acceptance criteria per task
- Identification of any unknowns that need Researcher input
- Estimated complexity per task (S/M/L)

**Constraints:**
- Must not break existing session-based auth for internal routes
- Google OAuth must be implemented first (business priority)
```

### Planner → Researcher
```markdown
## Handoff: Planner → Researcher

**Task:** Research the best approach for refresh token rotation with OAuth 2.0 in a stateless Node.js API.

**Context:**
- We're building OAuth 2.0 support (see Planner output)
- The API is stateless — no server-side sessions for OAuth tokens
- Security is a primary concern

**Inputs available:**
- Planner task list (above)
- .context/decisions/ADR-003-auth-strategy.md

**Expected output:**
- Comparison of at least 2 approaches (pros/cons/tradeoffs)
- A recommendation with justification
- Any relevant security considerations or OWASP guidance
- Written to .context/research/oauth-refresh-tokens.md

**Constraints:**
- Focus on Node.js/Express ecosystem specifically
- Avoid vendor-specific solutions (no Firebase Auth, Auth0, etc.)
```

### Planner → Coder
```markdown
## Handoff: Planner → Coder

**Task:** Implement Task 2: Create the OAuthProvider model and database migration.

**Context:**
- Full task list is in .context/plans/oauth-implementation.md
- Existing models are in src/models/ using Sequelize ORM
- Database is PostgreSQL

**Inputs available:**
- .context/plans/oauth-implementation.md — full task list
- src/models/User.js — example model to follow for style
- .context/decisions/ADR-003-auth-strategy.md — auth decisions

**Expected output:**
- src/models/OAuthProvider.js
- db/migrations/YYYYMMDD-create-oauth-provider.js
- Unit tests are NOT required here — Tester handles those

**Constraints:**
- Follow existing Sequelize patterns in src/models/
- Include timestamps (createdAt, updatedAt)
- userId foreign key must reference the users table
```

### Coder → Tester
```markdown
## Handoff: Coder → Tester

**Task:** Write tests for the OAuthProvider model and migration.

**Context:**
- OAuthProvider model was just implemented
- Existing tests are in tests/models/ using Jest + Sequelize mock

**Inputs available:**
- src/models/OAuthProvider.js — just implemented
- db/migrations/YYYYMMDD-create-oauth-provider.js — just implemented
- tests/models/User.test.js — example test to follow

**Expected output:**
- tests/models/OAuthProvider.test.js
- All happy path and edge cases covered
- Coverage target: 90%+ for new code

**Constraints:**
- Use Jest (already installed)
- Mock the database — no real DB connections in unit tests
- Test file must pass: npm test
```

---

## Completion Signals

When an agent finishes its task, it sends a completion signal back to the Manager:

```markdown
## Complete: [Agent Name]

**Task completed:** [One sentence summary]

**Outputs produced:**
- [File or artifact 1]
- [File or artifact 2]

**Decisions made:**
- [Any significant choices made and why]
- [Link to ADR if one was written]

**Blockers / issues encountered:**
- [None] OR [Description + what was done about it]

**Recommended next step:**
- [What should happen next, and which agent should handle it]
```

---

## Incomplete or Blocked Handoffs

If a receiving agent cannot proceed with the handoff as given:

```markdown
## Blocked: [Agent Name]

**Received from:** [Sending Agent]
**Cannot proceed because:** [Clear description of what's missing or unclear]

**Specifically need:**
- [Missing piece 1]
- [Missing piece 2]

**Suggested resolution:**
- [Who should provide the missing piece, or what decision needs to be made]
```

---

## Handoff Routing Reference

| If you need... | Route to... |
|---|---|
| Work broken into tasks | Planner |
| Information or research | Researcher |
| A design or tech decision | Architect |
| Code written or modified | Coder |
| Code tested or validated | Tester |
| User updated / work synthesized | Manager |
| A new agent role needed | Manager (to escalate) |

---

## Rules

1. **Never skip the handoff format** for non-trivial work. For trivial one-liner requests, a shortened version is acceptable.
2. **Always include the `.context/` files** the receiving agent should read.
3. **Be specific about outputs** — name the files, not just "write the code."
4. **State constraints explicitly** — don't make the receiving agent re-derive them.
5. **One task per handoff.** If multiple tasks need doing, send multiple handoffs or route through the Planner.
