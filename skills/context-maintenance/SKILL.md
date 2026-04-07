---
name: context-maintenance
description: >
  Keeps `.context/` documentation accurate and current. Use this skill after
  completing any non-trivial task, when you've learned something new about the
  project, when promoting lessons from retrospectives, when pruning stale task
  folders, or when you notice documentation that's outdated or duplicated. If you
  just finished a task and learned something worth preserving, this is the right
  skill — even if the user doesn't explicitly ask. For full codebase-level syncs,
  use `context-review` instead.
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

Lessons logged in `.context/retrospectives/` should graduate to permanent docs. This prevents
the retrospective from becoming an unread graveyard.

### Process

1. Open `retrospectives/`
2. Find entries with unchecked `[ ]` promotion items
3. For each unchecked item:
   - Read the target file (e.g., `standards.md`)
   - Add the lesson in the appropriate section — don't just append; integrate it
   - Check the box: `[x]`
4. Entries older than 4 weeks with all items checked → archive or delete

### Promotion Decision

| Lesson type                    | Promote to                                     |
| ------------------------------ | ---------------------------------------------- |
| Coding pattern or anti-pattern | `standards.md` or `standards.md`               |
| Naming discovery               | `standards.md`                                 |
| Test strategy or mock pattern  | `testing.md` or `testing.md`                   |
| Architecture insight           | `architecture.md`                              |
| Domain knowledge               | `domains/entities.md` or `domains/glossary.md` |
| Process improvement            | `workflows/` appropriate file                  |
| Decision rationale             | `decisions/index.md` (as a new ADR)            |

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
- Read `standards.md` — do conventions match recently-written code?
- If stale → update the specific sections

### Check 2 — Duplication

- Search for the same information in multiple files
- If found → consolidate into the canonical location, remove duplicates

### Check 3 — Drift

- Read `architecture.md` — do documented patterns match actual code?
- If code has diverged → either update the doc (if the code is correct) or flag the code (if the doc is correct)

### Check 4 — Bloat

- `.context/` files should be concise. If any file exceeds 300 lines, consider splitting.
- `retrospectives/` should have 10–15 entries max. Prune or archive older ones.

---

## Graph Sync

After any task that creates or modifies a `.context/` file, sync the knowledge graph:

```bash
bash scripts/graph-link.sh
```

This rebuilds `.context/graph/INDEX.md` and refreshes `ORPHANS.md`, `BROKEN.md`, and `DRIFT.md`.

### When to sync

| Situation | Action |
| --------- | ------ |
| New `.context/` file created | Run `graph-link.sh` |
| Existing `.context/` file updated | Run `graph-link.sh` |
| Auditing stale or orphaned nodes | Run `graph-link.sh --validate-only` |
| `.context/graph/` doesn't exist yet | Run `graph-link.sh` to initialize |

### After syncing

1. Review `ORPHANS.md` — link any disconnected nodes via their `related:` frontmatter
2. Review `DRIFT.md` — resolve contradictions before starting new work
3. If any file shows `description: TODO`, fill in the one-sentence description so INDEX entries are useful

### Frontmatter requirement

Every `.context/` file must have a `description:` field — one sentence an agent can read from INDEX.md to decide whether to open the file:

```yaml
---
id: auth-decisions
type: decision
title: Authentication Decisions
description: Documents the choice of JWT over sessions and the rationale for refresh token rotation.
status: active
related: []
---
```

---

## Constraints

- Do not touch source code during maintenance — only `.context/` files
- Do not delete retrospective entries that haven't been promoted yet
- Do not add generic advice — only project-specific knowledge belongs in `.context/`
- Preserve hand-authored content (business context, rationale) — only update factual details
- When in doubt about whether to update or create, update
