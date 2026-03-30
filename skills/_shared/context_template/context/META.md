# .context/ Maintenance Guide

This file tells you (human or AI agent) how to maintain the `.context/` directory so it stays useful and doesn't rot.

---

## 1. Purpose

`.context/` is the shared memory store for this project. It holds the things that would take a new engineer (or a fresh AI context window) hours to reconstruct from reading the code: non-obvious decisions, established patterns, discovered pitfalls, and domain terminology.

Without it, every agent starts from zero. With it, every agent starts informed.

---

## 2. Separation of Concerns

| File | Role | Characteristics |
|---|---|---|
| `CLAUDE.md` / `copilot-instructions.md` | Big picture, short, project-wide rules | Under 100 lines. Changes rarely. Agent reads on every task. |
| `.context/` | Detailed, area-specific, evolving knowledge | Multiple files. Changes often. Agent reads relevant sections per task. |

Keep `CLAUDE.md` short by keeping detail here. If `CLAUDE.md` grows past 80 lines, promote content to `.context/`.

---

## 3. When to Update

Update `.context/` when any of the following happens:

1. **A new pattern is established** — in code review, PR feedback, or architectural discussion
2. **A standard evolves** — old pattern replaced with new one; update the file, don't just add
3. **Architecture changes** — new service, new layer, new integration
4. **A recurring bug is fixed** — document the root cause and fix so it doesn't recur
5. **A new domain entity or term is introduced** — update `domains/entities.md` and `domains/glossary.md`
6. **A workflow changes** — CI steps, branching rules, deployment process
7. **Context was recovered from scratch and something was missing** — whatever you had to re-derive belongs here

---

## 4. What Belongs Here

**High value — add this:**
- Non-obvious decisions with rationale (why we chose X over Y)
- Patterns discovered through painful refactors
- Recurring bug fixes with root cause
- Test strategies for tricky areas (auth, async, third-party mocks)
- Business rules that aren't obvious from the code

**Low value — don't add this:**
- Things immediately obvious from reading the code
- Things covered in official library or framework documentation
- One-off notes that are only relevant for a single PR

---

## 5. Retrospective Promotion

`retrospectives/` holds individual files per task (`YYYY-MM-DD-TASK-ID.md`). Lessons in them should be promoted to the appropriate subdirectory file during weekly review.

**Process:**
1. Open any file in `retrospectives/` with unchecked `[ ]` promotion items
2. Copy the lesson into the referenced file (e.g., `standards/error-handling.md`)
3. Check the box: `[x]`
4. Files older than 4 weeks with all items checked can be archived or deleted

---

## 6. Context Recovery

When resuming after a context reset, follow these steps in order:

1. Read `overview.md` — get oriented to the project
2. Run `git log --oneline -10` — see what's been done recently
3. Read the latest file in `retrospectives/` — see what the last task uncovered
4. Read any in-progress task files in `tasks/[TASK-ID]/` — see what was being worked on

Do not start implementing until you've completed all 4 steps.

---

## 7. Maintenance Schedule

| Cadence | Action |
|---|---|
| After each task | Add a retrospective entry to `retrospectives.md` |
| Weekly | Promote checked-off lessons from retrospectives to subdirectory files |
| Monthly | Prune stale content — remove anything that no longer reflects how the project works |
