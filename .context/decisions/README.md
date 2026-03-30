# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records — lightweight documents that capture significant technical decisions made during the project.

---

## Why ADRs?

When working with AI agents, context about *why* something was built a certain way is just as important as the code itself. ADRs give agents (and humans) the reasoning behind past decisions so they don't accidentally undo or contradict them.

---

## ADR Index

| ID | Title | Status | Date |
|---|---|---|---|
| — | *(none yet — first one will be ADR-001)* | — | — |

---

## ADR Format

Create new ADRs as `ADR-NNN-short-title.md` in this directory. Use the template below:

```markdown
# ADR-NNN: [Short Title]

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Superseded | Deprecated  
**Decided by:** [Agent name or human name]  
**Supersedes:** [ADR-NNN if applicable]

## Context
[What situation or problem led to this decision? What forces were at play?]

## Decision
[What was decided? State it clearly in 1–3 sentences.]

## Rationale
[Why this option over the alternatives? What tradeoffs were accepted?]

## Alternatives Considered
| Option | Why rejected |
|---|---|
| Option A | [reason] |
| Option B | [reason] |

## Consequences
**Positive:**
- [benefit 1]

**Negative / tradeoffs:**
- [tradeoff 1]

## Related
- [Link to other ADRs, research docs, or retrospective entries]
```

---

## Rules

1. **Never delete ADRs.** If a decision is reversed, mark it "Superseded" and create a new ADR explaining why.
2. **One decision per ADR.** Don't bundle multiple decisions into one record.
3. **Update the index table** in this README when adding a new ADR.
4. **Keep it concise.** ADRs should be readable in under 2 minutes.
5. **Link to relevant ADRs** from agent handoff messages when they constrain the work.
