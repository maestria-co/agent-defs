---
name: context-graph-linker
description: >
  Build and maintain a navigable graph of cross-linked markdown knowledge nodes
  in .context/ so agents can traverse from any concept to related decisions, tasks,
  and constraints. Use when initializing a repo, after completing tasks that introduce
  new decisions/patterns, or auditing broken links.
metadata:
  version: "2.0"
  author: agent-defs
---

# Skill: context-graph-linker

> **This skill is a thin pointer.** The graph-building logic lives in
> `scripts/graph-link.sh`. Ongoing sync is handled by the
> `context-maintenance` skill. This file explains when and why to use them.

## When to Use

| Situation | What to do |
| --------- | ---------- |
| Initializing graph for the first time | Run `bash scripts/graph-link.sh` |
| After any task that creates/modifies `.context/` files | Follow the **Graph Sync** step in `context-maintenance` |
| Auditing orphaned or broken links | Run `bash scripts/graph-link.sh --validate-only` |
| Graph is badly out of sync (full rebuild) | Run `bash scripts/graph-link.sh --rebuild` |

## What the Script Does

`scripts/graph-link.sh` performs four steps:

1. **Inventory** — scans `.context/` and ensures every file has YAML frontmatter (`id`, `type`, `title`, `description`, `status`, `related`). Extracts descriptions from file content when not set.
2. **Edge detection** — scans file content for `@mentions` and markdown links to other `.context/` files
3. **Build INDEX** — injects a Context Index table and dependency list into `.context/overview.md` (between `<!-- GRAPH:START -->` / `<!-- GRAPH:END -->` sentinels, preserving hand-authored content)
4. **Validate** — writes `ORPHANS.md`, `BROKEN.md` to `.context/graph/`, and appends to `CHANGELOG.md`

## Output Files

- `.context/overview.md` — Context Index table + dependency list injected via sentinel blocks
- `.context/graph/ORPHANS.md` — files with no links (not reachable from other context files)
- `.context/graph/BROKEN.md` — markdown links pointing to files that don't exist
- `.context/graph/CHANGELOG.md` — append-only run log

## Frontmatter Convention

Every `.context/` file must include a `description` field — one sentence that lets agents decide relevance from the index alone.

```yaml
---
id: auth-decisions
type: decision
title: Authentication Decisions
description: Documents the choice of JWT over sessions and the rationale for refresh token rotation.
status: active
related:
  - id: api-architecture
    rel: informed-by
---
```

### Node Types

| Type            | Location                 | Purpose                             |
| --------------- | ------------------------ | ----------------------------------- |
| `overview`      | `.context/`              | Project-wide principles and context |
| `architecture`  | `.context/`              | System structure, layers, integrations |
| `standards`     | `.context/`              | Code conventions, naming, patterns  |
| `testing`       | `.context/`              | Test strategy and conventions       |
| `decision`      | `.context/decisions/`    | ADR or architectural choice         |
| `retrospective` | `.context/retrospectives/` | Lessons learned per task          |
| `domain`        | `.context/domains/`      | Domain entities and glossary        |
| `workflow`      | `.context/workflows/`    | CI/CD and process documentation     |

### Edge Types

| Relationship  | Meaning                                                |
| ------------- | ------------------------------------------------------ |
| `parent`      | This story belongs to this epic                        |
| `child`       | This epic contains this story                          |
| `informed-by` | This decision was shaped by this research              |
| `constrains`  | This constraint limits this decision or story          |
| `supersedes`  | This decision replaces a prior one                     |
| `depends-on`  | This story cannot start until this other story is done |

When relationship type is ambiguous, default to `informed-by`.
Never delete or overwrite edges set manually by a human.
