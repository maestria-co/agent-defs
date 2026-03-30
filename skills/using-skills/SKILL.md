---
name: using-skills
description: >
  Teaches agents how to discover, select, and invoke skills from the skill library.
  Use this skill whenever you're uncertain which skill applies to a task, when
  composing multiple skills for complex work, or when you need to understand what
  skills are available. This is your go-to when facing an ambiguous task and need
  to figure out the right approach before diving into implementation.
user-invocable: false
---

# Skill: Using Skills

## Purpose

Agents use this skill to navigate the skill library at runtime. It teaches discovery,
selection, invocation, and composition so agents can choose the right skill without
human guidance.

---

## Skill Discovery

### Where to Look

1. Read `skills/GUIDE.md` — the master index with quick-selection table and task-type mapping
2. Browse `skills/` directory — each subfolder contains a `SKILL.md`
3. Read `skills/_shared/conventions.md` — cross-cutting rules all skills follow

### Discovery Heuristic

When facing a task:

1. **Match by task type** — use the "Quick Selection" table in GUIDE.md
2. **Match by output** — what artifact do you need? Use the "Files Written" table
3. **Match by composition** — does this task chain multiple steps? Check "Pattern Pairs"
4. **No match** — the task may not need a skill. Use general agent capabilities.

---

## Skill Selection Rules

### Single-Skill Tasks (default)

Most tasks need exactly one skill. Pick it and go.

```
User asks: "Fix the login timeout bug"
→ implementing-features (clear bug fix with acceptance criteria)
```

### Multi-Skill Composition

Compose only when one skill's output feeds another skill's input.

```
User asks: "Design and implement a caching layer"
→ designing-systems (produces ADR with approach)
→ implementing-features (uses ADR as spec)
→ writing-tests (validates implementation)
```

### When Not to Use a Skill

- **Trivial questions** — answer directly
- **File reads or searches** — use tools directly
- **Conversation or clarification** — talk to the user
- **Already in-progress** — don't re-invoke a skill you're currently executing

---

## Skill Invocation Protocol

When invoking a skill:

1. **Read the SKILL.md** — every time. Don't rely on cached knowledge.
2. **Check pre-flight conditions** — most skills list what must be true before starting
3. **Follow the execution steps** — in order, skipping only steps marked optional
4. **Produce the specified output** — in the format the skill defines
5. **Self-verify** — check the skill's constraints before declaring done

### Invocation Template

```
I'm using the [skill-name] skill to handle this task.

Pre-flight:
- [x] Condition 1 met
- [x] Condition 2 met

Proceeding with execution steps...
```

---

## Composition Patterns

### Sequential Chain

Skills execute one after another, each consuming the previous output.

```
planning-tasks → implementing-features → writing-tests
```

**Rule:** Only chain when output A is input B. Independent tasks run separately.

### Research Fork

When planning reveals unknowns, fork into research before continuing.

```
planning-tasks
  ├── researching-options (unknown 1)
  ├── researching-options (unknown 2)
  └── continue with implementing-features
```

### Design Gate

When implementation requires an architecture decision, gate on design.

```
designing-systems (must complete first)
  └── implementing-features (uses ADR as spec)
```

---

## Skill Categories

### Infrastructure Skills

Setup and context management. Typically run once or periodically.

- `initialize-repo` — set up `.context/` for a new project
- `context-loader` — how to read `.context/` efficiently
- `context-maintenance` — keep `.context/` accurate
- `context-review` — full codebase scan to sync docs

### Planning & Design Skills

Define what to build and how. Run before implementation.

- `planning-tasks` — break goals into task lists
- `task-plan` — canonical plan format for handoffs
- `designing-systems` — architecture decisions (ADRs)
- `design-first` — triage: design first or implement directly?
- `researching-options` — evaluate libraries/approaches

### Implementation Skills

Build and validate. The core work loop.

- `implementing-features` — write/modify code
- `writing-tests` — write/run tests
- `systematic-debugging` — structured debugging process

### Discipline Skills

Cross-cutting quality practices. Referenced during other skills.

- `common-constraints` — universal agent rules
- `verification-checklist` — pre-completion checklist
- `testing-discipline` — TDD and test quality practices
- `commit-discipline` — git commit conventions

### Process Skills

Reflection and improvement. Run after tasks complete.

- `task-retrospective` — structured reflection
- `knowledge-graduation` — promote patterns to permanent docs

---

## Constraints

- Always read a skill's SKILL.md before invoking it — never work from memory
- Don't compose more than 4 skills in a single workflow without user confirmation
- If no skill matches the task, proceed without one — don't force-fit
- Follow skills/\_shared/conventions.md for all cross-cutting behaviors
- When a skill says "stop and check in with the user," do it — don't skip checkpoints
