---
name: task-plan-phase-architecture
description: Load when the task's primary concern is structural decisions — new modules, shared library changes, new external integrations, schema changes, or cross-service boundaries.
user-invocable: false
---

# Phase: Architecture

Load this skill when the task's **dominant focus addresses structural evaluation or decision-making**. For implementation tasks encountering structural queries mid-execution, use `task-plan-phase-implementation` — it supplies guidance on @architect engagement for structural concerns emerging during coding. This skill addresses tasks where architectural determinations constitute primary effort, not intermediate checkpoints.

## Architect Consultation Matrix

| Trigger | Required? |
|---------|-------------|
| Fresh module or bounded context | Required |
| Shared/core library alterations | Required |
| External API or service connection | Required |
| Database schema modifications | Required |
| Authentication or authorization alterations | Required |
| Novel design pattern introduction | Required |
| Substantial cross-module refactoring | Required |
| Dependency addition with extensive transitive footprint | Required |
| Moderate isolated-module refactoring | Discretionary |
| Pattern replication from extant examples | Discretionary |
| Isolated component alteration, presentation-exclusive change | Omit |
| Straightforward remediation following documented patterns | Omit |

## @architect Delegation Structure

All architect dispatches require these elements:

```
Proposed alteration: [Plan's advocated methodology]
Current architectural context:
  - [Relevant fact from .context/architecture/]
  - [Applicable pattern from .context/standards/]
Targeted queries:
  - [Module structure compatibility query]
  - [Coupling or dependency footprint query]
  - [Testability or risk query]
Constraints:
  - [Non-negotiable requirements from user or .context/decisions.md]
```

## Applying Architect Output

Following architect evaluation:

1. Archive determination in `plan.md` `## Decisions` section:
   - Verdict (Approve / Approve with alterations / Reject)
   - Pre-implementation alterations demanded
   - Identified risks with mitigation strategies
2. On **conditional approval**: revise plan's implementation steps before @coder dispatch.
3. On **rejection**: return to @planner with architect rationale for methodology revision.
4. On **approval**: advance to implementation with architectural guidance archived in `plan.md`.

## Skill Interdependencies

- **`design-first`**: The @architect agent internally engages `design-first`. Direct engagement unnecessary.
- **`task-plan`**: Archive all architectural determinations in `plan.md` via `task-plan`.
- **`task-plan-phase-implementation`**: Load post-approval when primary effort transitions to code generation.

**Excluded scope:** investigation, @coder orchestration, tests, task closure.
