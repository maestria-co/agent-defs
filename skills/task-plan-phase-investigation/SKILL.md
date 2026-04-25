---
name: task-plan-phase-investigation
description: Load when the task's scope is unclear, the approach is unknown, or research into external libraries or services is needed before planning is possible.
user-invocable: false
---

# Phase: Investigation

Load this skill when the task's **predominant challenge involves boundary comprehension or research accumulation**. When implementation pathways are self-evident (coding, tests), bypass this skill for applicable phase skill. When tasks are straightforward (isolated remediation, documented patterns), omit phase skills entirely.

## Context Accumulation Protocol

Prior to hypothesis construction or planning, read in sequence:

1. `.github/copilot-instructions.md` — project synopsis, toolchain, essential commands
2. `.context/overview.md` — architectural topology, component responsibilities
3. `.context/decisions.md` or `.context/decisions/` — historical determinations constraining current effort
4. `.context/retrospectives.md` or `.context/retrospectives/` — extract lessons relevant to this task category
5. Relevant `.context/domains/` files — domain entities, business constraints, API conventions for implicated regions
6. Pre-existing task directory (`plan.md`) when resuming post-compaction

## Complexity Classification

Classify before planning:

| Classification | Indicators |
|----------------|------------|
| **Simple** | Isolated component, zero architectural uncertainty, precedented patterns |
| **Medium** | Multi-component footprint, ordering requirements, limited architectural uncertainties |
| **Complex** | Module-crossing alterations, novel patterns, migration efforts, service-crossing boundaries, substantial unknowns |

- Simple → bypass task directory, sustain inline tracking.
- Medium or Complex → create task directory with `plan.md` immediately (load `task-plan` skill), before all other operations.

## When to Delegate to Researcher

**Delegate when:**
- Using particular library/framework versions where currency matters
- Upgrading dependencies with possible breaking alterations
- Implementing patterns whose contemporary best practices remain uncertain
- Connecting external services with unfamiliar current APIs/SDKs

**Bypass delegation when:**
- Methodology already captured in `.context/`
- Pure internal restructuring without external dependency concerns
- Bug remediation with diagnosed causation

## @researcher Delegation Structure

All researcher dispatches require these components:

```
Topic: [precise library/framework/technology]
Current version: [X.Y.Z] → Target version: [A.B.C] (when applicable)
Queries:
  - [Concrete query 1]
  - [Concrete query 2]
Decision informed by research: [Choice contingent on conclusions]
Constraints: [Task-relevant limitations]
```

## @planner Delegation Structure

All planner dispatches require these components:

```
Task: [TASK-ID with characterization]
Objective: [Achievement target and rationale]
Implicated domains: [Modules/artifacts/domains involved]
Complexity: Simple / Medium / Complex
Relevant context:
  - [Relevant constraint or pattern from .context/]
  - [Relevant constraint or pattern from .context/]
Research conclusions: [Researcher output synopsis, or "N/A — research unnecessary"]
Outstanding queries for planner: [Persisting ambiguities for planner resolution]
```

## Investigation-Driven Plans

When causation or boundaries are initially opaque (defects, ill-defined requests), deploy two-step plans immediately — avoid awaiting investigation finalization:

```markdown
## Progress
- [ ] Investigate: [symptom or unknown characterization] ← IN PROGRESS
- [ ] Revise this plan incorporating conclusions and subsequent actions
```

Establish task directory and `plan.md` containing these steps. Post-investigation, supersede them with comprehensive plan before commencing remediation effort.

## Investigation Completion Thresholds

Investigation concludes when these conditions hold:

- Boundaries fully comprehended — all implicated files and modules enumerated
- All substantial unknowns resolved or explicitly catalogued as Open Queries
- Plan contains ordered steps with artifact-level precision
- Inter-step dependencies identified
- Per-step acceptance thresholds established

Avoid advancing to architecture or implementation while unresolved queries could restructure the plan.

## Skill Interdependencies

- **`systematic-debugging`**: For bugs with obscure causation, load `systematic-debugging` during investigation to trace causation before planning remediation.
- **`design-first`**: When investigation exposes multiple viable implementation strategies, load `design-first` to evaluate and select prior to planning.
- **`task-plan`**: Governs `plan.md` structure and refresh triggers. This skill governs investigation methodology; `task-plan` governs plan documentation.
- **`task-plan-phase-implementation`**: Load post-investigation when primary effort transitions to code generation.
- **`task-plan-phase-testing`**: Load post-investigation when primary effort transitions to tests.

**Excluded scope:** architectural audit, @coder orchestration, validation delegation, retrospectives.
