---
name: linear-story
user-invocable: true
description: >
  Format a structured story spec into a Linear-ready issue. Used by the
  product-manager agent to produce the final Linear output — do not gather
  requirements here, just format them. Also invocable directly when someone
  says "format this for Linear", "create a Linear issue for this", "write this
  up as a Linear ticket", or "turn this spec into a Linear story".
---

# Skill: Linear Story

## Purpose

Receive a structured story spec and format it as a well-formed Linear issue.
This skill is a **formatter only** — it does not gather requirements, research
the codebase, or make technical decisions. Those steps belong to the
product-manager agent upstream.

---

## Input Expected

A structured spec containing some or all of:
- User story statement (persona / goal / benefit)
- Draft acceptance criteria
- Technical detail notes (affected components, API changes, data model)
- Dependencies and blocking issues
- Open questions

If any of these are missing, format what is available and note the gaps in
the output's Open Questions section.

---

## Output Format

Produce a single Markdown block structured for Linear (or save as `story.md`).
Linear uses structured issue fields plus a Markdown description.

```
**Title:**
[Action verb] + [outcome] — e.g. "Add date filter to order history"

**Team:** [leave blank — to be assigned]
**Assignee:** [leave blank]
**Priority:** [Urgent / High / Medium / Low / No priority]
**Estimate:** [story points or T-shirt: XS/S/M/L/XL — if known]
**Cycle/Sprint:** [leave blank — set in planning]
**Labels:** [feature area, component, or type labels]
**Status:** Backlog

---

**Description:**

### Story
As a [specific persona],
I want [goal],
So that [measurable benefit]

### Problem Statement
[What problem this solves and why it matters]

### Acceptance Criteria

- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]
[Mark any inferred AC with `(inferred — pending PO confirmation)`]

### Technical Notes
- Affected Components: [list]
- API Changes: [list or "None"]
- Data Model Changes: [list or "None"]
- Key Files: [list]
- Cross-Cutting Concerns: [auth, caching, events — or "None"]
- Complexity Estimate: [S / M / L / XL]

### Dependencies
- Blocking Issues: [Linear issue IDs or "None"]
- Required Resources: [list or "None"]
- Approvals Needed: [list or "None"]

### Open Questions
- Q: [question] — Owner: [PO / Tech Lead / etc.] — Assumed: [assumption made]
```

---

## Linear-Specific Notes

- **Title** is the primary scannable label in Linear's list and board views — keep it under 60 chars
- **Sub-issues** in Linear map to implementation tasks — note them as candidates but do not
  create them; that is done during sprint planning
- **Estimate** maps to Linear's estimate field; use your team's scale (points or T-shirt)
- **Labels** in Linear are used for filtering (e.g., `bug`, `feature`, `backend`, `frontend`) —
  suggest appropriate labels based on the technical notes
- Linear supports `>` blockquotes for callouts — use them to highlight blockers or key decisions

---

## Formatting Rules

- Title must be action-oriented and specific — not "Auth feature" but "Implement Google OAuth SSO login"
- AC must be testable (Given/When/Then) — rewrite any AC that can't be verified as pass/fail
- Mark every inferred AC clearly — the PO must confirm these during grooming
- Technical Notes are for developers, not business logic — keep them factual
- Open Questions must include who should answer and what was assumed in the meantime
- Do not add requirements that weren't in the input spec — format only what exists

---

## Constraints

- No requirement gathering — receive the spec, format it, done
- No silent rewrites of ACs — if you rephrase for testability, note the change
- No implementation instructions in the story body — those go in Technical Notes
- One issue per output — if the input describes multiple features, note that a split is recommended
