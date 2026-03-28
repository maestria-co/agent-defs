---
name: task-plan
description: >
  Defines the canonical plan.md format used as a handoff document between agents
  and across context boundaries. Use when: creating a new task plan, resuming a
  task from a plan, or updating an in-progress plan. Not user-invocable — agents
  reference this when working with plan files.
user-invocable: false
---

# Skill: Task Plan

## Purpose

`plan.md` is a **handoff document** — it contains enough context for any agent
(or the same agent after a context clear) to resume work without re-reading the
entire codebase. It is not a progress tracker or a to-do list.

This skill defines the canonical format and rules for maintaining plan files.

---

## Canonical Format

Every `plan.md` lives in `.context/tasks/[TASK-ID]/plan.md` and follows this structure:

```markdown
# [TASK-ID]: [Short Title]

## Branch

`feature/TASK-ID-short-description`

## Objective

One paragraph. What are we building and why?

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Decisions

Key decisions made during planning or implementation.

- **Decision:** [What was decided]
  **Rationale:** [Why]

## Key Files

Files central to this task — helps the next agent load context fast.

- `path/to/file.ts` — [role in this task]
- `path/to/other.ts` — [role in this task]

## Task Breakdown

Ordered steps to complete the work.

1. [x] Step 1 — completed description
2. [ ] Step 2 — in progress description ← CURRENT
3. [ ] Step 3 — upcoming description

## Progress Log

Reverse-chronological entries. One per work session.

- **[Date/Session]:** What was accomplished, what's next

## Blockers

- [Blocker description] — [status: investigating / escalated / resolved]
```

---

## Section Guidance

### Objective

- One paragraph max
- Include the "why" — not just the "what"
- Should be understandable without additional context

### Acceptance Criteria

- Checkboxes (`- [ ]` / `- [x]`)
- Each criterion is independently verifiable
- Written from the user's perspective when possible
- Updated to `[x]` only when verified with evidence

### Decisions

- Record as you go — don't wait until the end
- Include rationale, not just the choice
- Reference ADRs in `.context/decisions/` for major decisions

### Key Files

- List only files actively touched or read for this task
- Update as the task reveals new files
- Remove files that turn out to be irrelevant

### Task Breakdown

- Ordered — dependencies flow top to bottom
- Mark current step with `← CURRENT`
- Check off completed steps with `[x]`
- Each step should be completable in one work session

### Progress Log

- Reverse chronological (newest first)
- Brief — 2–3 sentences per entry
- Always include "what's next" to guide resumption
- Write an entry at the end of every work session

### Blockers

- Only list actual blockers — not risks or concerns
- Include status so the next agent knows what's actionable
- Remove resolved blockers (or move to Decisions if the resolution was a decision)

---

## When to Create a Plan

| Situation                         | Create plan?                          |
| --------------------------------- | ------------------------------------- |
| Multi-step feature (3+ steps)     | Yes                                   |
| Bug fix requiring investigation   | Yes — helps track debugging progress  |
| Simple one-file change            | No — overkill                         |
| Refactoring across multiple files | Yes                                   |
| Research task                     | No — use `.context/research/` instead |

---

## When to Update a Plan

Update the plan whenever:

- A step is completed → check it off, add progress log entry
- A decision is made → add to Decisions section
- A new file becomes relevant → add to Key Files
- A blocker is found → add to Blockers
- Work session ends → add progress log entry with "what's next"

---

## Cold Resume Protocol

When resuming a task from a plan:

1. Read the plan's **Objective** and **Acceptance Criteria** — understand the goal
2. Read the **Task Breakdown** — find the `← CURRENT` marker
3. Read the **Progress Log** (latest entry) — understand where things left off
4. Read the **Key Files** — load relevant code context
5. Check **Blockers** — address any before proceeding
6. Continue from the current step

---

## Constraints

- Plan files live only in `.context/tasks/[TASK-ID]/plan.md`
- Never delete a plan for an in-progress task
- Always update the progress log before ending a work session
- Keep the plan concise — if any section exceeds 30 lines, it needs pruning
- The plan is the source of truth for task state — not chat history
