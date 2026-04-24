---
name: task-plan-phase-implementation
description: Load when the primary work is writing code and the path is clear. Provides the pre-dispatch checklist, @coder delegation structure, deviation handling, and progress tracking.
user-invocable: false
---

# Phase: Implementation

Load this skill when the task's **dominant focus targets code generation** and planning is finalized. For tasks with fuzzy boundaries, load `task-plan-phase-investigation` first. This skill omits test delegation — consult `task-plan-phase-testing`. Closure operations (retrospective, context refresh) reside in `task-plan-phase-completion`.

## Pre-Dispatch Validation

Before initiating any @coder step:

- [ ] Execute `git status --short`. Staged alterations from previous agent operations require commit or stash before dispatch — committing agents will incorporate unrelated staged files.
- [ ] Confirm current plan step embodies complete specifications: target files, pattern citations, acceptance thresholds.
- [ ] For file creation: explicitly mandate "commit the new file" as acceptance threshold. @coder agents commonly abandon new files untracked absent explicit directive.

## @coder Delegation Structure

All @coder dispatches require these components:

```
Step [N]: [step characterization]
Files to create/alter:
  - [file/path]: [required action]
Patterns for adherence:
  - [.context/standards/ or .context/architecture/ citation]
Research/architecture conclusions: [synopsis or "N/A"]
Acceptance thresholds:
  - [Concrete, verifiable outcome]
  - Commit all created/altered files
```

## Step Completion Confirmation

Following each @coder step:

1. Execute `git status --short` — confirm zero untracked new files persist.
2. Confirm acceptance threshold satisfaction.
3. Refresh `plan.md` `## Progress` section: mark step finalized, append outcome notation (`— [terse characterization of implementation/alterations]`).
4. For projects with build workflows: confirm build success before progression.

## Deviation Resolution

When @coder reports plan deviation (alternative methodology, unexpected obstruction, distinct files altered):

1. Document immediately in `plan.md` `## Decisions`.
2. Assess footprint: does deviation influence downstream steps?
3. For architectural deviation: consult @architect before progression.
4. For trivial deviation (identical outcome, distinct route): progress while preserving Decisions notation.
5. For repeated failures on identical obstacles: load `systematic-debugging` skill before retry.

## Progress Continuity

Maintain `plan.md` currency throughout:

- Mark finalized steps with outcome notations (beyond mere checkmarks).
- Channel emerging uncertainties to `## Open Questions / Blockers` as identified.
- Append newly identified files to `## Key Files`.

## Skill Interdependencies

- **`systematic-debugging`**: Load for repeated @coder failures on identical obstacles.
- **`task-plan-phase-architecture`**: When deviation resolution exposes architectural obstructions, load this skill.
- **`task-plan-phase-testing`**: For predominantly test-focused post-implementation effort, load the test skill next.
- **`task-plan`**: Use to refresh `plan.md` at step transitions.

**Excluded scope:** investigation, architectural audit, test delegation, retrospectives, closure files.
