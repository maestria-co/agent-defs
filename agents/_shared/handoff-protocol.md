# Handoff Protocol

**A handoff is a complete package.** The receiving agent starts immediately without asking clarifying questions.

---

## Handoff Structure

```markdown
## Handoff: [Sending Agent] → [Receiving Agent]

**Task:** [One sentence]

**Context:**
- [Key background fact]
- [Link to relevant .context/ files]

**Inputs available:**
- [Artifact or file] — [brief description]

**Expected output:**
- [What to produce] — [where to write it]

**Constraints:**
- [Must-follow rules, prior decisions, ADR links]
```

---

## Example: Coder → Tester

```markdown
## Handoff: Coder → Tester

**Task:** Write tests for the OAuthProvider model.

**Context:**
- OAuthProvider model just implemented
- Existing tests in tests/models/ using Jest + Sequelize mock

**Inputs available:**
- src/models/OAuthProvider.js — just implemented
- tests/models/User.test.js — style reference

**Expected output:**
- tests/models/OAuthProvider.test.js — happy path, edge cases, 90%+ coverage

**Constraints:**
- Mock the database; no real DB connections in unit tests
- Must pass: npm test
```

---

## Completion Signal

```markdown
## Complete: [Agent Name]

**Task completed:** [One sentence]
**Outputs produced:** [file list]
**Decisions made:** [choices + rationale, ADR link if written]
**Blockers encountered:** [None | description + resolution]
**Recommended next step:** [what and who]
```

---

## Blocked Signal

```markdown
## Blocked: [Agent Name]

**Received from:** [Sending Agent]
**Cannot proceed because:** [what's missing or unclear]
**Specifically need:** [missing pieces]
**Suggested resolution:** [who should provide it]
```

---

## Routing Reference

| Need | Route to |
|---|---|
| Work broken into tasks | Planner |
| Information / research | Researcher |
| Design / tech decision | Architect |
| Code written or modified | Coder |
| Code tested or validated | Tester |
| User updated / work synthesized | Manager |

---

## Rules

1. Never skip the format for non-trivial work.
2. Always include `.context/` files the receiving agent should read.
3. Name specific output files — not just "write the code."
4. State constraints explicitly.
5. One task per handoff; use Planner for multiple tasks.
