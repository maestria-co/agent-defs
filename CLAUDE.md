# Agent-Defs — Copilot Customization Kit

This repository provides reusable **agents**, **skills**, and **prompts** for AI-assisted software development — structured as a standard `.copilot`-compatible folder.

See `skills/GUIDE.md` for the full skill selection guide.

## Structure

```
agents/          # Agent definitions (*.agent.md)
skills/          # Composable skills (each in its own folder with SKILL.md)
prompts/         # Reusable prompt files (*.prompt.md)
.context/        # Project context (decisions, retrospectives, tasks)
context_template/ # Template for generating .context/ in other projects
recipes/         # End-to-end workflow examples
build-guide/     # Build guide documentation
```

## Skills

Pick a skill directly based on your task:

| Task type                                   | Skill                    | File                                     |
| ------------------------------------------- | ------------------------ | ---------------------------------------- |
| Set up `.context/` for a new project        | `initialize-repo`        | `skills/initialize-repo/SKILL.md`        |
| Load project context at task start          | `context-loader`         | `skills/context-loader/SKILL.md`         |
| Update `.context/` after a task             | `context-maintenance`    | `skills/context-maintenance/SKILL.md`    |
| Discover and select the right skill         | `using-skills`           | `skills/using-skills/SKILL.md`           |
| Break a goal into ordered tasks             | `planning-tasks`         | `skills/planning-tasks/SKILL.md`         |
| Create/update a plan.md handoff document    | `task-plan`              | `skills/task-plan/SKILL.md`              |
| Triage: design first or implement directly  | `design-first`           | `skills/design-first/SKILL.md`           |
| Evaluate libraries or approaches            | `researching-options`    | `skills/researching-options/SKILL.md`    |
| Make an architecture decision (ADR)         | `designing-systems`      | `skills/designing-systems/SKILL.md`      |
| Write or modify code                        | `implementing-features`  | `skills/implementing-features/SKILL.md`  |
| Write or run tests                          | `writing-tests`          | `skills/writing-tests/SKILL.md`          |
| Debug a bug systematically                  | `systematic-debugging`   | `skills/systematic-debugging/SKILL.md`   |
| Universal agent constraints (always active) | `common-constraints`     | `skills/common-constraints/SKILL.md`     |
| Verify work before marking complete         | `verification-checklist` | `skills/verification-checklist/SKILL.md` |
| TDD practices and test quality              | `testing-discipline`     | `skills/testing-discipline/SKILL.md`     |
| Git commit conventions                      | `commit-discipline`      | `skills/commit-discipline/SKILL.md`      |
| Reflect after completing a task             | `task-retrospective`     | `skills/task-retrospective/SKILL.md`     |
| Promote patterns to reusable skills         | `knowledge-graduation`   | `skills/knowledge-graduation/SKILL.md`   |
| Orchestrate 3+ skills                       | `coordinating-work`      | `skills/coordinating-work/SKILL.md`      |
| Sync `.context/` docs with codebase         | `context-review`         | `skills/context-review/SKILL.md`         |
| Evaluate a SKILL.md file                    | `evaluate-skill`         | `skills/evaluate-skill/SKILL.md`         |

## Agents

The **Manager** is the primary entry point — start here for any multi-step task.
Specialist agents are invoked by the Manager via delegation.

| Agent      | File                         | Status | Skill equivalent        |
| ---------- | ---------------------------- | ------ | ----------------------- |
| Manager    | `agents/manager.agent.md`    | Active | `coordinating-work`     |
| Architect  | `agents/architect.agent.md`  | Legacy | `designing-systems`     |
| Planner    | `agents/planner.agent.md`    | Legacy | `planning-tasks`        |
| Researcher | `agents/researcher.agent.md` | Legacy | `researching-options`   |
| Coder      | `agents/coder.agent.md`      | Legacy | `implementing-features` |
| Tester     | `agents/tester.agent.md`     | Legacy | `writing-tests`         |

> Specialist agents are functional but still reference the legacy format. Use the
> corresponding skill directly for standalone work, or let the Manager delegate.

All agents follow: `agents/_shared/conventions.md`
Handoff protocol: `agents/_shared/handoff-protocol.md`

## Quick Start

See `QUICK_START.md` for copy-paste prompt templates for each skill.

## Workflow Recipes

See `recipes/` for end-to-end examples:

- `recipes/simple-task.md` — single bug fix
- `recipes/complex-task.md` — multi-file feature
- `recipes/design-task.md` — research + architecture decision
- `recipes/feature-workflow.md` — full OAuth 2.0 feature example

## Project Context

Before starting any task: `.context/project-overview.md`
Architecture decisions: `.context/decisions/`
Learning log: `.context/retrospectives/`
Skill shared conventions: `skills/_shared/conventions.md`

## Key Principles

- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **Context awareness** — write state to files before context clears; use git as checkpoints
- **Human checkpoints** — stop and check in after 3–5 major actions or before irreversible changes
- **Verify before done** — check each acceptance criterion explicitly before signaling completion
