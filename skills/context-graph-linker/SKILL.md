---
name: context-graph-linker
description: >
  Build and maintain a navigable graph of cross-linked markdown knowledge nodes
  in .context/ so agents can traverse from any concept to related decisions, tasks,
  and constraints. Use when initializing a repo, after completing tasks that introduce
  new decisions/patterns, or auditing broken links.
compatibility: Requires write access to .context/, graph/, and repository root files (CLAUDE.md, .github/copilot-instructions.md)
metadata:
  version: "1.0"
  author: agent-defs
---

# Skill: context-graph-linker

## Purpose

Build and maintain a navigable graph of cross-linked knowledge nodes
within `.context/` so any agent can retrieve relevant decisions, research,
constraints, and epics on demand — without loading everything upfront or
contradicting prior decisions.

This skill is NOT for linking agents or skills together. That is handled
by the Manager agent and CLAUDE.md. This skill operates exclusively on
project knowledge.

## Scope

This skill modifies files in the following locations:
- `.context/**/*.md` — Adds YAML frontmatter to all markdown files
- `.context/graph/` — Creates 5 report files (INDEX, ORPHANS, BROKEN, DRIFT, CHANGELOG)
- Repository root: `CLAUDE.md` or `.github/copilot-instructions.md` — Registers graph in agent instructions

Total estimated modifications: 50+ files depending on .context/ size.

---

## Pre-flight Checks

Run these checks before building the graph. If any fail, abort and notify the user.

**Check 1 — Repository initialized**
- Verify `.git/` directory exists in repository root
- If missing → Abort: "This skill requires a git repository. Run `git init` first."

**Check 2 — .context/ directory exists**
- Verify `.context/` directory exists with at least one markdown file
- If missing → Abort: ".context/ directory not found. Run initialize-repo skill first."

**Check 3 — Write permissions**
- Verify write access to `.context/`, repository root
- If denied → Abort: "Insufficient permissions to create graph/ directory and modify files."

---

## When to Use

- After `initialize-repo` to establish the initial graph
- After any task that produces a new decision, research finding, or epic
- When an agent contradicts or ignores a prior decision (drift signal)
- On-demand audit to find orphaned or disconnected knowledge

---

## Core Concepts

See Appendix for full node/edge type definitions.

---

## Front-Matter Convention

Every `.context/` file should open with:

```yaml
---
id: <unique-slug>
type: epic | story | decision | research | constraint | overview
title: <human readable title>
status: active | superseded | draft
related:
  - id: <slug>
    rel: parent | child | informed-by | constrains | supersedes | depends-on
---
```

---

## ⚠️ Side Effects

This skill makes bulk modifications:
1. **Adds YAML frontmatter** to all `.context/` markdown files (non-destructive, prepends metadata)
2. **Creates new directory** `.context/graph/` with 5 files
3. **Modifies root instructions** in CLAUDE.md or .github/copilot-instructions.md to register graph navigation

All changes are git-trackable. Review with `git diff` before committing.

---

## Instructions

### Step 1 — Inventory

Scan all markdown files under `.context/` only.
For each file, extract or infer: id, type, title, status.
If front-matter is missing, infer from filename and content — then write it.

### Step 2 — Infer Edges

For each node, read its content and infer relationships:

- References another concept or file by name → `informed-by`
- Scoped under a larger goal → `parent` epic
- Replaces or updates a prior decision → `supersedes`
- Imposes a limit on another node → `constrains`
- Cannot proceed without another story → `depends-on`

Append inferred edges to `related:` front-matter.
Do not overwrite manually set edges.

### Step 3 — Build the Index

Write `.context/graph/INDEX.md` in this format:

```markdown
# Project Knowledge Index

> This index is the entry point for on-demand context retrieval.
> Agents should query this index before acting on any task that
> touches architecture, technology choice, or project scope.

## Epics

- [[epic-slug]] — Title

## Stories

- [[story-slug]] — Title (parent: [[epic-slug]])

## Decisions

- [[decision-slug]] — Title (informed-by: [[research-slug]])

## Research

- [[research-slug]] — Title

## Constraints

- [[constraint-slug]] — Title (constrains: [[decision-slug]])
```

### Step 4 — Validate

Check for and report:

- **Orphans** — nodes with no edges → `.context/graph/ORPHANS.md`
- **Broken links** — slug referenced but file not found → `.context/graph/BROKEN.md`
- **Superseded actives** — a decision marked active but superseded by another → `.context/graph/DRIFT.md`
- **Constraint violations** — a story or decision that contradicts a constraint node → `.context/graph/DRIFT.md`

The `DRIFT.md` file is the primary signal for agents that something
in the project knowledge is out of sync with reality.

### Step 5 — Register the Index in Agent Instruction Files

Add the following block to both instruction files if not already present.
Both files must be updated together — the graph is only effective if all
agents that may work in this repo can discover and query it.

**For Claude Code — add to `CLAUDE.md`:**

```markdown
## Project Knowledge Graph

Before starting any task that involves architecture, technology choice,
or project scope — query `.context/graph/INDEX.md` to identify relevant
decisions, research, and constraints. Load only the files that are
relevant to the task. Do not load the entire `.context/` folder.
```

**For GitHub Copilot — add to `.github/copilot-instructions.md`:**

```markdown
## Project Knowledge Graph

Before starting any task that involves architecture, technology choice,
or project scope — query `.context/graph/INDEX.md` to identify relevant
decisions, research, and constraints. Load only the files that are
relevant to the task. Do not load the entire `.context/` folder.
```

If `.github/copilot-instructions.md` does not exist, create it with
only this block. Do not fabricate other Copilot instructions.

If either file already contains a knowledge graph section, update it
in place rather than appending a duplicate.

### Step 6 — Maintain After Every Task

After any task that creates or modifies a `.context/` file:

1. Add or update the file's front-matter `related:` block
2. Re-run Step 4 validation
3. Append one line to `.context/graph/CHANGELOG.md`:
   `[date] [node-id] [action] — reason`

---

## Output Contract

- `.context/graph/INDEX.md` — primary navigation surface for agents
- `.context/graph/ORPHANS.md` — disconnected nodes needing attention
- `.context/graph/BROKEN.md` — dangling slug references
- `.context/graph/DRIFT.md` — contradictions and superseded actives
- `.context/graph/CHANGELOG.md` — append-only change log

---

## Key Constraints

- Never modify files outside these paths: `.context/`, `graph/`, `CLAUDE.md`, `.github/copilot-instructions.md`
- Before modifying root instructions, confirm with user: "I will update [file] to register graph navigation. Proceed?"
- Operates on `.context/` only — never modifies `agents/`, `skills/`, or `prompts/`
- INDEX.md must remain human-readable — it is the primary navigation surface
- Agents load INDEX.md first, then fetch only relevant nodes — never the full folder
- DRIFT.md is the mechanism that makes this graph equivalent to mex's drift detection

---

## Appendix: Node and Edge Reference

### Node Types (`.context/` only)

| Type         | Location                | Purpose                             |
| ------------ | ----------------------- | ----------------------------------- |
| `epic`       | `.context/epics/`       | High-level goal or feature area     |
| `story`      | `.context/stories/`     | Scoped unit of work under an epic   |
| `decision`   | `.context/decisions/`   | ADR or architectural choice         |
| `research`   | `.context/research/`    | Technology evaluation or findings   |
| `constraint` | `.context/constraints/` | Non-negotiable rules or limits      |
| `overview`   | `.context/`             | Project-wide principles and context |

Create any missing folders. Do not create nodes outside `.context/`.

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

