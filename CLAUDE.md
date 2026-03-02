# Agent System

This repository defines a reusable multi-agent system for software development teams.

See @agents/README.md for the full agent roster, workflow, and usage guide.

## Agent Roles

| Agent | File | When to use |
|---|---|---|
| Manager | agents/manager.md | All new requests — start here |
| Architect | agents/architect.md | System design, tech decisions, ADRs |
| Planner | agents/planner.md | Breaking goals into ordered tasks |
| Researcher | agents/researcher.md | Evaluating options, filling knowledge gaps |
| Coder | agents/coder.md | Writing and modifying code |
| Tester | agents/tester.md | Writing tests, validating implementations |

## Workflow

```
User → Manager → (Planner → Researcher?) → Architect? → Coder → Tester → Manager
```

Always start with the Manager. The Manager routes to specialists.

## Shared Rules

All agents follow: @agents/_shared/conventions.md  
Handoff protocol: @agents/_shared/handoff-protocol.md

## Project Context

Before starting any task: @.context/project-overview.md  
Architecture decisions: @.context/decisions/  
Learning log: @.context/retrospectives/

## Key Principles

- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **Context awareness** — write state to files before context clears; use git as checkpoints
- **Human checkpoints** — stop and check in after 3–5 major actions or before irreversible changes
- **Verify before done** — check each acceptance criterion explicitly before signaling completion
