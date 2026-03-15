# Agent-Defs Pattern System

This repository provides composable task patterns for AI-assisted software development.

See @.context/patterns/GUIDE.md for the full pattern selection guide.

## Patterns (Primary)

Pick a pattern directly based on your task:

| Task type | Pattern | File |
|---|---|---|
| Break a goal into ordered tasks | `planning-tasks` | @.context/patterns/planning-tasks/SKILL.md |
| Evaluate libraries or approaches | `researching-options` | @.context/patterns/researching-options/SKILL.md |
| Make an architecture decision (ADR) | `designing-systems` | @.context/patterns/designing-systems/SKILL.md |
| Write or modify code | `implementing-features` | @.context/patterns/implementing-features/SKILL.md |
| Write or run tests | `writing-tests` | @.context/patterns/writing-tests/SKILL.md |
| Orchestrate 3+ patterns | `coordinating-work` | @.context/patterns/coordinating-work/SKILL.md |

## Quick Start

See @QUICK_START.md for copy-paste prompt templates for each pattern.

## Workflow Recipes

See `recipes/` for end-to-end examples:
- `recipes/simple-task.md` — single bug fix
- `recipes/complex-task.md` — multi-file feature
- `recipes/design-task.md` — research + architecture decision
- `recipes/feature-workflow.md` — full OAuth 2.0 feature example

## Project Context

Before starting any task: @.context/project-overview.md  
Architecture decisions: @.context/decisions/  
Learning log: @.context/retrospectives/
Pattern shared conventions: @.context/patterns/_shared/conventions.md

## Key Principles

- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **Context awareness** — write state to files before context clears; use git as checkpoints
- **Human checkpoints** — stop and check in after 3–5 major actions or before irreversible changes
- **Verify before done** — check each acceptance criterion explicitly before signaling completion

---

## Legacy: Multi-Agent System

> ⚠️ **Deprecated.** The agent system below still works but is no longer the recommended approach.
> Use the patterns above instead. See `MIGRATION_GUIDE.md` to convert.

| Agent | File | Pattern equivalent |
|---|---|---|
| Manager | agents/manager.agent.md | `coordinating-work` + direct pattern selection |
| Architect | agents/architect.agent.md | `designing-systems` |
| Planner | agents/planner.agent.md | `planning-tasks` |
| Researcher | agents/researcher.agent.md | `researching-options` |
| Coder | agents/coder.agent.md | `implementing-features` |
| Tester | agents/tester.agent.md | `writing-tests` |

Legacy workflow: `User → Manager → (Planner → Researcher?) → Architect? → Coder → Tester → Manager`

All agents follow: @agents/_shared/conventions.md  
Handoff protocol: @agents/_shared/handoff-protocol.md
