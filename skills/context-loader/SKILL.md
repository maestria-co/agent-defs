---
name: context-loader
description: >
  Teaches agents how to efficiently discover and read `.context/` files. Use this
  skill at the start of every task — any time you begin work on a feature, bug fix,
  refactoring, test writing, or architecture decision. Also use when resuming work
  after a context reset, switching between tasks, or whenever you're unsure which
  context files are relevant. If you're about to start coding without checking project
  context first, stop and use this skill.
---

# Skill: Context Loader

## Purpose

Efficiently load the right `.context/` files for the current task without reading
everything. Context windows are finite — loading irrelevant files wastes capacity
that should go to actual work.

This skill defines the loading order and selection strategy for different task types.

---

## Context Discovery Order

Always read in this order. Stop as soon as you have enough context for the task.

### Level 1 — Always Read (every task)

1. `CLAUDE.md` or `.github/copilot-instructions.md` — big picture, key commands
2. `.context/overview.md` — tech stack, architecture, current state

### Level 2 — Read Based on Task Type

| Task type              | Read these `.context/` files                                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------------- |
| Feature implementation | `domains/` (relevant entity), `architecture.md`, `standards.md`      |
| Bug fix                | `domains/` (affected area), `testing.md`, `standards.md`              |
| Refactoring            | `architecture.md`, `standards.md`, `standards.md` |
| Test writing           | `testing.md`, `testing.md`, `standards.md`    |
| Architecture decision  | `architecture.md`, `decisions/index.md`, all relevant `domains/` files                                    |
| New domain work        | `domains/entities.md`, `domains/glossary.md`, `architecture.md`                 |
| CI/CD changes          | `workflows/ci-cd.md`, `workflows/branching.md`                                                    |
| UI/styling work        | `styling.md` (if frontend project), `standards.md`                                      |

### Level 3 — Read When Resuming

1. `.context/retrospectives/` — last few entries for recent lessons
2. `.context/tasks/[TASK-ID]/plan.md` — if resuming a specific task
3. `git log --oneline -10` — recent commit history

---

## Reading Strategies

### Scan, Don't Read Everything

For large `.context/` directories:

1. List files first: `ls .context/domains/`
2. Read file headers (first 20 lines) to determine relevance
3. Read fully only the files that match your task

### Search Specifically

If you know what you're looking for:

- grep for entity names, pattern names, or error codes across `.context/`
- Don't read entire files hoping to stumble on relevant content

### Cache What You Found

After loading context, note the key facts in your working memory:

- Tech stack and version constraints
- Naming conventions for the area you're working in
- Relevant business rules or domain constraints
- Applicable ADRs

---

## When to Create New Context

During or after a task, create new `.context/` files when:

| Situation                              | Action                                                        |
| -------------------------------------- | ------------------------------------------------------------- |
| Working in an undocumented domain area | Create `domains/[area-name].md`                               |
| Discovering a non-obvious pattern      | Add to `architecture.md`                    |
| Finding inconsistent error handling    | Document the correct pattern in `standards.md` |
| Making an architecture decision        | Create `decisions/ADR-NNN-title.md` via `designing-systems`   |
| Learning a lesson worth preserving     | Add entry to `retrospectives/`                              |

---

## Constraints

- Do not read all `.context/` files at the start of every task — be selective
- Do not spend more than 2 minutes on context loading — if you can't find what you need, proceed and note the gap
- Do not modify `.context/` files during loading — that's `context-maintenance`
- Prefer targeted searches over full-file reads for large context directories
