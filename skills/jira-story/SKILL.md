---
name: jira-story
user-invocable: true
description: >
  Format a structured story spec into a Jira-ready user story. Used by the
  product-manager agent to produce the final Jira output — do not gather
  requirements here, just format them. Also invocable directly when someone
  says "format this as a Jira ticket", "turn this spec into a Jira story",
  or "write this up for Jira".
---

# Skill: Jira Story

## Purpose

Receive a structured story spec and format it as a well-formed Jira user story.
This skill is a **formatter only** — it does not gather requirements, research
the codebase, or make technical decisions. Those steps belong to the
product-manager agent upstream.

---

## Input Expected

A structured spec containing some or all of:
- User story statement (persona / goal / benefit)
- Draft acceptance criteria
- Technical detail notes (affected components, API changes, data model)
- Dependencies and blocking tickets
- Open questions

If any of these are missing, format what is available and note the gaps in
the output's Open Questions section.

---

## Output Format

Produce a single Markdown block ready to paste into Jira (or save as `story.md`):

```
**Story:**
As a [specific persona],
I want [goal],
So that [measurable benefit]

---

**Acceptance Criteria:**

1. Given [context], when [action], then [result]
2. Given [context], when [action], then [result]
3. Given [context], when [action], then [result]
[Mark any inferred AC with `(inferred — pending PO confirmation)`]

---

**Technical Notes:**
- Affected Components: [list]
- API Changes: [list or "None"]
- Data Model Changes: [list or "None"]
- Key Files: [list]
- Cross-Cutting Concerns: [auth, caching, events — or "None"]
- Complexity Estimate: [S / M / L / XL]

---

**Dependencies:**
- Blocking Tickets: [ticket IDs or "None"]
- Required Resources: [list or "None"]
- Approvals Needed: [list or "None"]

---

**Open Questions:**
- Q: [question] — Owner: [PO / Tech Lead / etc.] — Assumed: [assumption made]
```

---

## Formatting Rules

- Persona must be specific — not "user" but e.g. "logged-in admin", "guest checkout user"
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
- One story per output — if the input describes multiple features, note that a split is recommended

