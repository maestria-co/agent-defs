# Pattern Guide: When to Use Each Pattern

Quick reference for selecting and composing skills in `skills/`.

---

## Quick Selection

| If your task involves… | Use |
|---|---|
| Breaking a complex goal into ordered tasks | `planning-tasks` |
| Evaluating options or filling a knowledge gap | `researching-options` |
| Making a system design or technology decision | `designing-systems` |
| Writing or modifying code | `implementing-features` |
| Writing or running tests | `writing-tests` |
| Composing 3+ patterns for a complex workflow | `coordinating-work` |
| Syncing `.context/` docs with the codebase | `context-review` |
| Evaluating a SKILL.md file | `evaluate-skill` |

---

## When to Use One Pattern vs. Compose Multiple

**Use a single pattern directly** for most tasks. The overhead of composing multiple
patterns is only justified when outputs from one pattern are required inputs for another.

**Compose patterns when:**
- Planning → Implementation → Tests (outputs chain: plan feeds implementation, implementation feeds tests)
- Research → Design → Implementation (research informs a design decision that informs code)
- A task has 3+ truly distinct steps that can't be collapsed

**Do not compose when:**
- You're just doing one thing (implement a feature, write a test)
- Two patterns are independent (research and test-writing for separate features)
- Adding `coordinating-work` would be more ceremony than the task itself

---

## Pattern Pairs (Common Compositions)

### Design → Implement
```
designing-systems   →   implementing-features
```
Use when you need to decide *how* to build something before building it.
The ADR produced by `designing-systems` is the spec for `implementing-features`.

### Implement → Test
```
implementing-features   →   writing-tests
```
The most common composition. Use after every non-trivial implementation.

### Plan → Implement → Test
```
planning-tasks   →   implementing-features   →   writing-tests
```
For features with 3+ steps. The plan breaks it down; each task gets its own
`implementing-features` + `writing-tests` cycle.

### Research → Design
```
researching-options   →   designing-systems
```
Use when a design decision requires technical evidence before the decision can be made.
Research produces a recommendation; `designing-systems` turns it into a documented ADR.

### Full Stack (complex feature)
```
planning-tasks
  → researching-options   (for unknowns flagged in plan)
  → designing-systems     (for architecture decisions)
  → implementing-features (per task in plan)
  → writing-tests         (per implementation)
```

---

## Pattern Summaries

### `planning-tasks`
- **Input:** Ambiguous goal
- **Output:** `.context/plans/[feature].md` — ordered task list with acceptance criteria
- **When NOT to use:** Single well-defined task, or user already provided a breakdown
- **Degree of freedom:** Medium

### `researching-options`
- **Input:** A specific technical question
- **Output:** `.context/research/[topic].md` — recommendation with evidence
- **When NOT to use:** Obvious answers, business/product decisions
- **Degree of freedom:** High

### `designing-systems`
- **Input:** A design question or technology choice
- **Output:** `.context/decisions/ADR-NNN-title.md` — documented decision
- **When NOT to use:** Implementation details within an already-decided approach
- **Degree of freedom:** Medium

### `implementing-features`
- **Input:** Clear spec with acceptance criteria
- **Output:** Source code changes
- **When NOT to use:** Unclear spec, undecided architecture, no acceptance criteria
- **Degree of freedom:** Low

### `writing-tests`
- **Input:** Implemented code + spec
- **Output:** Test files with coverage report
- **When NOT to use:** Code not yet implemented
- **Degree of freedom:** Medium

### `coordinating-work`
- **Input:** Complex task requiring 3+ pattern types
- **Output:** Sequenced plan + completion summary
- **When NOT to use:** Single-pattern tasks, two independent patterns
- **Degree of freedom:** Low

---

## Choosing by Task Type

| Task type | Recommended pattern(s) |
|---|---|
| "Build this feature" (simple) | `implementing-features` → `writing-tests` |
| "Build this feature" (complex) | `planning-tasks` → `implementing-features` × N → `writing-tests` × N |
| "Fix this bug" | `implementing-features` → `writing-tests` (add regression test) |
| "Should we use library X or Y?" | `researching-options` |
| "How should we design this system?" | `designing-systems` |
| "What should we build next?" | `planning-tasks` |
| "Refactor this module" | `planning-tasks` (if non-trivial) → `implementing-features` → `writing-tests` |
| "Is our `.context/` up to date?" | `context-review` |
| "Review this SKILL.md file" | `evaluate-skill` |

---

## Shared Conventions

All skills follow the conventions in `skills/_shared/conventions.md`:
- XML tag structure for structured output
- One-question clarity rule
- Self-verify before completing
- Stopping conditions and check-in format
- Context window management
- Anti-patterns

---

## Files Written by Each Pattern

| Pattern | Writes to |
|---|---|
| `planning-tasks` | `.context/plans/` |
| `researching-options` | `.context/research/` |
| `designing-systems` | `.context/decisions/` |
| `implementing-features` | Source code files |
| `writing-tests` | Test files |
| `coordinating-work` | Orchestrates others; no direct file output |
| `context-review` | `.context/` documentation files |
