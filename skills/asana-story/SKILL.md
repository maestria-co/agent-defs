---
name: asana-story
user-invocable: true
description: >
  Format a structured story spec into an Asana-ready task. Used by the
  product-manager agent to produce the final Asana output — do not gather
  requirements here, just format them. Also invocable directly when someone
  says "format this for Asana", "create an Asana task for this", "write this
  up as an Asana story", or "turn this spec into an Asana ticket".
---

# Skill: Asana Story

## Purpose

Receive a structured story spec and format it as a well-formed Asana task.
This skill is a **formatter only** — it does not gather requirements, research
the codebase, or make technical decisions. Those steps belong to the
product-manager agent upstream.

---

## Input Expected

A structured spec containing some or all of:
- User story statement (persona / goal / benefit)
- Draft acceptance criteria
- Technical detail notes (affected components, API changes, data model)
- Dependencies and blocking tasks
- Open questions

If any of these are missing, format what is available and note the gaps in
the output's Open Questions section.

---

## Output Format

Produce a single Markdown block structured for Asana (or save as `story.md`).
Asana uses a flat task structure — the description field carries all detail.

```
**Task Name:**
[Action verb] + [outcome] — e.g. "Add date filter to order history"

**Assignee:** [leave blank — to be assigned in grooming]
**Due Date:** [leave blank — to be set in sprint planning]
**Priority:** [High / Medium / Low — if known]
**Tags/Labels:** [feature area, team, or component tags]

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
- Blocking Tasks: [task names/IDs or "None"]
- Required Resources: [list or "None"]
- Approvals Needed: [list or "None"]

### Open Questions
- Q: [question] — Owner: [PO / Tech Lead / etc.] — Assumed: [assumption made]
```

---

## Asana-Specific Notes

- **Task name** should be action-oriented and scannable in a board view — keep it under 60 chars
- **Subtasks** in Asana map to individual ACs or implementation steps — note them as candidates
  but do not create them; that is done during sprint planning
- **Custom fields** (if your Asana workspace uses them for story points, sprint, team):
  note placeholders like `Story Points: [to be set]` so they aren't forgotten
- ACs in Asana live in the description as a checklist (`- [ ]`) — format them that way

---

## Formatting Rules

- Task name must be action-oriented and specific — not "Login feature" but "Add SSO login via Google OAuth"
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
- One task per output — if the input describes multiple features, note that a split is recommended
