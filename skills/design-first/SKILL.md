---
name: design-first
description: >
  Triage whether a task needs architecture planning before implementation. Use when:
  starting a new task to decide if you should design first or implement directly.
  Routes to designing-systems when design is needed, or straight to implementation
  when it's not.
user-invocable: false
---

# Skill: Design First

## Purpose

Not every task needs an architecture design phase. This skill provides the triage
criteria to decide: design first, or implement directly? It prevents two failure modes:

1. Over-designing simple changes (wasted time)
2. Under-designing complex changes (rework, technical debt)

---

## Triage Decision

### Design First When:

- **New subsystem or module** — creating something that doesn't exist yet
- **Cross-cutting change** — affects 3+ modules or services
- **Data model change** — new tables, schema migrations, API contracts
- **Technology choice** — selecting a library, framework, or service
- **Irreversible decision** — hard to change later (database choice, API design)
- **Multiple valid approaches** — and it's not obvious which is best
- **Team dependency** — other people's code will depend on your design

### Implement Directly When:

- **Bug fix** — the design already exists; fix the implementation
- **Single-file change** — localized change with clear approach
- **Following an existing pattern** — the architecture already defines how
- **Clear specification** — acceptance criteria leave no ambiguity
- **Trivial feature** — add a field, adjust a threshold, update a message
- **Refactoring within a module** — improving internals without changing the interface

### Gray Area

When unsure, use this heuristic:

> **If you can describe the implementation in 3 sentences or fewer, implement directly.
> If you need more than 3 sentences, design first.**

---

## Design-First Workflow

When the triage says "design first":

1. **Use `designing-systems`** to produce an ADR (Architecture Decision Record)
2. **Review the ADR** — check it against requirements and constraints
3. **Then implement** — use the ADR as the spec for `implementing-features`

### Lightweight Design (most cases)

For changes that need _some_ design but not a full ADR:

```markdown
## Design Note: [Feature Name]

**Problem:** [What needs to be built/changed]

**Approach:** [How you'll do it]

**Key decisions:**

- [Decision 1]: [rationale]
- [Decision 2]: [rationale]

**Files affected:** [list]

**Risks:** [what could go wrong]
```

Write this in the task's `plan.md` under a "## Design" section. No need for a
separate ADR unless the decision has long-term implications.

### Full Design (major changes)

For decisions that affect the project long-term:

1. Use the `designing-systems` skill
2. Produce a formal ADR in `.context/decisions/`
3. Include alternatives considered and trade-offs
4. Get user confirmation before implementing

---

## Implement-Directly Workflow

When the triage says "implement directly":

1. **Check conventions** — read `.context/standards/` and existing code patterns
2. **Implement** — use `implementing-features`
3. **Test** — use `writing-tests`
4. **Verify** — use `verification-checklist`

No design document needed. If during implementation you discover the change is more
complex than expected, stop and switch to the design-first workflow.

---

## Complexity Signals

Watch for these signals during a task — they indicate you should pause and design:

| Signal                                 | What it means                        |
| -------------------------------------- | ------------------------------------ |
| "I need to change 5+ files"            | Cross-cutting concern — design first |
| "I'm not sure which approach to take"  | Multiple options — design first      |
| "This might break the existing API"    | Interface change — design first      |
| "I need to restructure the data model" | Schema change — design first         |
| "Other teams depend on this"           | Coordination needed — design first   |
| "I keep going back and forth"          | Unclear approach — stop and design   |

---

## Anti-Patterns

### Over-Design

```
Task: "Change the error message for invalid emails"
BAD:  Write a 3-page ADR about error message architecture
GOOD: Just change the string
```

### Under-Design

```
Task: "Add multi-tenant support to the database layer"
BAD:  Start coding immediately, figure out the approach as you go
GOOD: Design the tenancy model first, document the schema changes, then implement
```

### Design-by-Implementation

```
BAD:  Build three prototypes to "see which feels right"
GOOD: List the options, evaluate trade-offs on paper, pick one, build it once
```

---

## Constraints

- Triage every task before starting — even if briefly
- If you switch from implement-directly to design-first mid-task, document why
- Lightweight designs go in `plan.md`; formal designs go in `.context/decisions/`
- Design time should not exceed 20% of total task time for most changes
- Don't design in isolation — check `.context/` for existing patterns that may apply
