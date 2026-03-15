# Context Structure

> Phase 3 deliverable. Documents how `.context/` files flow through agentless pattern workflows.

---

## Overview

In the agentless system, `.context/` is the shared memory that replaces agent-to-agent message passing. Instead of one agent handing off to another, you read `.context/` before a pattern runs and write back to `.context/` after it completes.

```
Before pattern runs                 After pattern runs
─────────────────────               ──────────────────────
.context/project-overview.md   →    .context/decisions/ADR-NNN.md  (designing-systems)
.context/decisions/             →    .context/tasks/[ID]/plan.md    (planning-tasks)
.context/tasks/[ID]/brief.md   →    .context/tasks/[ID]/research.md (researching-options)
                                     .context/retrospectives/       (all patterns)
```

---

## Files Read by Each Pattern (Pre-flight)

| Pattern | Files read |
|---|---|
| `planning-tasks` | `project-overview.md`, `decisions/` (relevant), `tasks/[ID]/brief.md`, `tasks/[ID]/research.md` (if exists) |
| `researching-options` | `project-overview.md`, `tasks/[ID]/brief.md`, prior research reports in `tasks/[ID]/` |
| `designing-systems` | `project-overview.md`, `decisions/` (existing ADRs), `tasks/[ID]/plan.md` (if exists) |
| `implementing-features` | `project-overview.md`, `decisions/` (relevant), `tasks/[ID]/plan.md`, spec or brief |
| `writing-tests` | `project-overview.md`, implementation files being tested, `testing/` standards |
| `coordinating-work` | All of the above, plus `patterns/GUIDE.md` |

---

## Files Written by Each Pattern (Output)

| Pattern | Files written |
|---|---|
| `planning-tasks` | `.context/tasks/[ID]/plan.md` |
| `researching-options` | `.context/tasks/[ID]/research.md` (or `.context/research/[topic].md` for standing research) |
| `designing-systems` | `.context/decisions/ADR-NNN-[title].md` |
| `implementing-features` | Source code files (no direct `.context/` writes, but triggers retro entry) |
| `writing-tests` | Test files (no direct `.context/` writes, but bug reports → `tasks/[ID]/` ) |
| `coordinating-work` | Nothing directly — delegates to other patterns |

---

## Context Flow for Common Workflows

### Simple feature (1 pattern)
```
human reads: project-overview.md
    ↓
implementing-features runs
    ↓
human writes: retrospectives/ (optional)
```

### Standard feature (3 patterns)
```
human creates: tasks/[ID]/brief.md
    ↓
planning-tasks reads: project-overview.md + brief.md
planning-tasks writes: tasks/[ID]/plan.md
    ↓
implementing-features reads: project-overview.md + decisions/ + plan.md
(implementation happens)
    ↓
writing-tests reads: project-overview.md + implementation
(tests pass)
    ↓
human writes: retrospectives/YYYY-MM-DD.md
```

### Research-first feature (4 patterns)
```
human creates: tasks/[ID]/brief.md
    ↓
researching-options reads: project-overview.md + brief.md
researching-options writes: tasks/[ID]/research.md
    ↓
designing-systems reads: project-overview.md + decisions/ + research.md
designing-systems writes: decisions/ADR-NNN.md
    ↓
planning-tasks reads: project-overview.md + research.md + ADR-NNN.md + brief.md
planning-tasks writes: tasks/[ID]/plan.md
    ↓
implementing-features reads: project-overview.md + decisions/ + plan.md
    ↓
writing-tests reads: project-overview.md + implementation
```

---

## The `.context/tasks/[TASK-ID]/` Convention

For any medium or complex task, create a task directory before running patterns:

```
mkdir .context/tasks/TASK-ID
```

Then create `brief.md` with:
- What needs to be done (1 sentence)
- Acceptance criteria (checklist)
- Links to relevant files or issues

This becomes the input all patterns read. It's the equivalent of what the Manager agent previously provided to downstream agents.

---

## Difference from Agent System

| Agent system | Agentless |
|---|---|
| Manager reads context, routes to Planner | You read project-overview.md, run planning-tasks |
| Planner writes plan, routes to Coder | You run planning-tasks, then run implementing-features |
| Coder routes back to Manager on completion | implementing-features outputs a completion summary to you |
| State lives in agent handoff messages | State lives in `.context/tasks/[ID]/` files |
| Context passed via structured handoff | Context passed via `.context/` files + git |

The output is identical. The routing through a Manager is eliminated.

---

## Maintenance Rules

- **Task directories** — create at task start, never delete (historical record)
- **Research files** — if research has lasting project value (library choice, architectural finding), move it from `tasks/[ID]/research.md` to `research/[topic].md` at the root `.context/` level
- **ADRs** — always in `decisions/ADR-NNN-*.md`, numbered sequentially; superseded ADRs are marked but not deleted
- **Retrospectives** — rolling log; promote lessons to `standards/` or `architecture/` during weekly review
