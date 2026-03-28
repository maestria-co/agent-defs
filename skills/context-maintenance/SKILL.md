---
name: context-maintenance
description: >
  Keeps `.context/` documentation accurate and current. Use when: completing a task
  and needing to update docs with new learnings, promoting lessons from retrospectives
  to permanent docs, pruning stale task folders, or resolving duplication between
  `.context/` files. Do not use when: scanning the full codebase to sync (use
  `context-review` instead).
---

# Skill: Context Maintenance

## Purpose

Keep `.context/` accurate without letting it rot or bloat. This skill covers the
ongoing maintenance tasks: promoting retrospective insights, pruning stale content,
deciding when to update vs. create, and avoiding duplication.

Use `context-review` for full codebase scans. Use this skill for incremental updates
after individual tasks.

---

## Retrospective Promotion Workflow

Lessons logged in `retrospectives.md` should graduate to permanent docs. This prevents
the retrospective from becoming an unread graveyard.

### Process

1. Open `retrospectives.md`
2. Find entries with unchecked `[ ]` promotion items
3. For each unchecked item:
   - Read the target file (e.g., `standards/error-handling.md`)
   - Add the lesson in the appropriate section — don't just append; integrate it
   - Check the box: `[x]`
4. Entries older than 4 weeks with all items checked → archive or delete

### Promotion Decision

| Lesson type                    | Promote to                                                    |
| ------------------------------ | ------------------------------------------------------------- |
| Coding pattern or anti-pattern | `standards/code-style.md` or `standards/error-handling.md`    |
| Naming discovery               | `standards/naming-conventions.md`                             |
| Test strategy or mock pattern  | `testing/unit-testing.md` or `testing/integration-testing.md` |
| Architecture insight           | `architecture/patterns-template.md`                           |
| Domain knowledge               | `domains/entities.md` or `domains/glossary.md`                |
| Process improvement            | `workflows/` appropriate file                                 |
| Decision rationale             | `decisions.md` (as a new ADR)                                 |

---

## When to Update vs. Create

| Situation                               | Action                                                    |
| --------------------------------------- | --------------------------------------------------------- |
| New information about an existing topic | **Update** the existing file                              |
| Existing file is wrong or outdated      | **Update** — replace the stale content                    |
| Completely new topic area               | **Create** a new file in the appropriate subdirectory     |
| Information exists in multiple places   | **Consolidate** into a single file and remove duplicates  |
| A pattern applies to only one area      | **Update** the area-specific file, don't create a new one |

**Rule of thumb:** If you're tempted to create a new file, first check if the content
belongs in an existing one. Fewer, richer files beats many sparse ones.

---

## Task Folder Management

Task folders in `.context/tasks/[TASK-ID]/` are ephemeral by default.

### Lifecycle

1. **Active tasks:** Keep all artifacts (brief, plan, research, decisions)
2. **Completed tasks (< 2 weeks):** Keep — lessons may not yet be promoted
3. **Completed tasks (2–4 weeks):** Promote remaining lessons, then delete the folder
4. **Completed tasks (> 4 weeks):** Delete unless the task contains a reference design

### Pruning Process

```bash
# Find task folders older than 4 weeks
find .context/tasks/ -name "plan.md" -mtime +28 -exec dirname {} \;
```

For each old folder:

1. Check if retrospective was written and lessons promoted
2. If yes → delete the folder
3. If no → write the retrospective first, promote lessons, then delete

---

## Quality Checks

Run these periodically (or after every 3–5 tasks):

### Check 1 — Staleness

- Read `overview.md` — does the tech stack still match manifest files?
- Read `standards/` — do conventions match recently-written code?
- If stale → update the specific sections

### Check 2 — Duplication

- Search for the same information in multiple files
- If found → consolidate into the canonical location, remove duplicates

### Check 3 — Drift

- Read `architecture/patterns-template.md` — do documented patterns match actual code?
- If code has diverged → either update the doc (if the code is correct) or flag the code (if the doc is correct)

### Check 4 — Bloat

- `.context/` files should be concise. If any file exceeds 300 lines, consider splitting.
- `retrospectives.md` should have 10–15 entries max. Prune or archive older ones.

---

## Constraints

- Do not touch source code during maintenance — only `.context/` files
- Do not delete retrospective entries that haven't been promoted yet
- Do not add generic advice — only project-specific knowledge belongs in `.context/`
- Preserve hand-authored content (business context, rationale) — only update factual details
- When in doubt about whether to update or create, update
