---
name: task-plan-phase-implementation
description: Load when the primary work is writing code and the path is clear. Provides the pre-dispatch checklist, @coder delegation structure, deviation handling, and progress tracking.
user-invocable: false
---

# Phase: Implementation

Load this skill when the task's **primary concern is writing code** and the
plan is ready. For tasks where scope is unclear, load
`task-plan-phase-investigation` first. This skill does not cover testing
delegation — that is in `task-plan-phase-testing`. Completion (retro, context
updates) is in `task-plan-phase-completion`.

## Pre-Dispatch Checklist

Before dispatching any @coder step:

- [ ] Run `git status --short`. If staged changes exist from previous agent work, commit or stash them before dispatching — a committing agent will sweep unrelated staged changes into its commit.
- [ ] Confirm the plan's current step is fully specified: files, patterns, acceptance criteria.
- [ ] If the step creates new files: include "commit the new file" as an explicit acceptance criterion. @coder agents often leave new files untracked unless explicitly instructed to commit.

## @coder Dispatch Structure

Every @coder delegation must include all of these fields:

```
Step [N]: [description]
Files to create/modify:
  - [path/to/file]: [what to do]
Patterns to follow:
  - [reference to .context/standards/ or .context/architecture/]
Research/architecture findings: [summary or "N/A"]
Acceptance criteria:
  - [Specific, verifiable outcome]
  - Commit all created/modified files
```

## Step Completion Verification

After each @coder step completes:

1. Run `git status --short` — verify no untracked new files remain.
2. Confirm the acceptance criteria are met.
3. Update `plan.md` `## Progress` section: check the step, add an outcome note (`— [brief description of what was done/changed]`).
4. If the project has a build step: confirm the build passes before the next step.

## Deviation Handling

When @coder reports a deviation from the plan (different approach, unexpected blocker, different files touched):

1. Document immediately in `plan.md` `## Decisions`.
2. Assess impact: does the deviation affect subsequent steps?
3. If the deviation is architectural: consult @architect before proceeding.
4. If the deviation is minor (same outcome, different path): proceed, keeping the Decisions note.
5. If @coder fails on the same issue repeatedly: invoke `systematic-debugging` skill before retrying.

## Progress Tracking

Keep `plan.md` current throughout:

- Mark steps complete with outcome notes (not just checkmarks).
- Move new ambiguities to `## Open Questions / Blockers` as they arise.
- Add newly discovered files to `## Key Files`.

## Relationship to Other Skills

- **`systematic-debugging`**: Invoke when @coder fails on the same issue repeatedly.
- **`task-plan-phase-architecture`**: When deviation handling reveals an architectural blocker, load this skill.
- **`task-plan-phase-testing`**: If post-implementation work is primarily about tests, load the testing skill next.
- **`task-plan`**: Use to update `plan.md` at each step boundary.

**Does NOT cover:** investigation, architecture review, testing delegation, retrospective, completion docs.
