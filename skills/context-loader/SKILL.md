---
name: context-loader
description: >
  Teaches agents how to efficiently discover and read `.context/` files at the start
  of any task. Use when: starting a task and needing to load relevant project context,
  resuming work after a context reset, or determining which context files are relevant
  for a specific task type. Do not use when: you already have the needed context loaded.
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
| Feature implementation | `domains/` (relevant entity), `architecture/patterns-template.md`, `standards/code-style.md`      |
| Bug fix                | `domains/` (affected area), `testing/unit-testing.md`, `standards/error-handling.md`              |
| Refactoring            | `architecture/patterns-template.md`, `standards/code-style.md`, `standards/naming-conventions.md` |
| Test writing           | `testing/unit-testing.md`, `testing/integration-testing.md`, `standards/naming-conventions.md`    |
| Architecture decision  | `architecture/`, `decisions.md`, all relevant `domains/` files                                    |
| New domain work        | `domains/entities.md`, `domains/glossary.md`, `architecture/patterns-template.md`                 |
| CI/CD changes          | `workflows/ci-cd.md`, `workflows/branching.md`                                                    |
| UI/styling work        | `styling/style-guide-template.md`, `standards/code-style.md`                                      |

### Level 3 — Read When Resuming

1. `.context/retrospectives.md` — last few entries for recent lessons
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
| Discovering a non-obvious pattern      | Add to `architecture/patterns-template.md`                    |
| Finding inconsistent error handling    | Document the correct pattern in `standards/error-handling.md` |
| Making an architecture decision        | Create `decisions/ADR-NNN-title.md` via `designing-systems`   |
| Learning a lesson worth preserving     | Add entry to `retrospectives.md`                              |

---

## Constraints

- Do not read all `.context/` files at the start of every task — be selective
- Do not spend more than 2 minutes on context loading — if you can't find what you need, proceed and note the gap
- Do not modify `.context/` files during loading — that's `context-maintenance`
- Prefer targeted searches over full-file reads for large context directories
