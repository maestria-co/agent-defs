# Context Graph Index - Conversation Summary

## Background

The user is building a reusable convention for AI-assisted development using Claude Code. The core idea:

- **`CLAUDE.md`** — thin entry point in each repo, tells Claude about the `.context/` directory
- **`.context/`** — a directory of markdown files providing repo-specific context
- **`.context/overview.md`** — the index/graph that selectively loads only relevant context files per task, rather than flooding the context window

This convention is designed to be adopted across teams and repositories.

---

## Architecture

```
/mnt/skills/
  context-maintenance/
    SKILL.md                 # already created — rebuilds/repairs the graph
  graph-link/
    SKILL.md                 # created in separate session — handles graph linking

<repo>/
  CLAUDE.md                  # entry point, knows about .context/
  .context/
    overview.md              # graph index + task routing
    auth.md
    database.md
    api.md
    ...
```

---

## The Graph Index Concept

`overview.md` acts as a **routing layer** with two entry points:

### 1. Dependency Graph

Describes structural relationships between context files so Claude can traverse dependencies intelligently.

```markdown
## Context Graph

- auth.md → [database.md, middleware.md]
- api.md → [auth.md, schemas.md]
- database.md → [] # leaf node
```

### 2. Task Routing

Maps task intent to the relevant context files.

```markdown
## Task Routing

- "add endpoint" → [api.md, auth.md]
- "database migration" → [database.md]
- "authentication" → [auth.md, database.md, middleware.md]
```

---

## Maintenance Strategy

Two complementary approaches — not mutually exclusive:

### Pre-commit Hook

- **Incremental updates** triggered on code changes
- Detects which files changed, updates only affected context files and graph edges
- Zero friction, automatic

### `context-maintenance` Skill (already created)

- **Full rebuild** — re-analyzes entire repo, regenerates `overview.md` graph, prunes stale nodes
- Audits for orphaned or missing context files
- Suggests new context files based on code complexity
- Validates task routing still maps correctly
- Flags areas of the codebase with no context coverage

---

## Current Status

- [x] `.context/` convention established
- [x] `CLAUDE.md` entry point pattern defined
- [x] `context-maintenance` skill created
- [x] `graph-link` skill created (separate session)
- [x] Shell script created (separate session)
- [ ] `overview.md` graph schema — needs to be locked down
- [ ] Graph index feature completed
- [ ] Pre-commit hook implementation

---

## Next Steps

1. **Share `overview.md` schema** and `context-maintenance` SKILL.md to validate the schema is robust enough for reliable parsing
2. **Reconcile** the `graph-link` skill and shell script from the other session with this conversation
3. **Lock down the schema** — needs to handle edge cases:
   - Circular dependencies
   - Orphaned nodes
   - Partial task matches
   - Stale graph edges
4. **Complete the graphing feature** combining both sessions' work

---

## Key Design Principles

- `CLAUDE.md` stays **thin and portable** — just points to `.context/`
- Intelligence lives in the **graph**, not in `CLAUDE.md`
- **Progressive disclosure** — `overview.md` describes _what each file contains and when to use it_, not just lists them
- Schema must be **well-specified** so `context-maintenance` can parse and regenerate without breaking hand-authored sections
- Claude Code `@include` depth is capped at **5 levels** — keep graph traversal shallow
