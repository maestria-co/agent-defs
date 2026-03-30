# [Project Name]

> Brief one-line description of what this project does.

## Project Context

See @.context/overview.md for project overview, tech stack, and current development phase.
See @.context/architecture.md for system structure, layers, and integration points.
See @.context/standards.md for coding conventions, naming, and patterns.
See @.context/testing.md for test framework, file conventions, and mocking patterns.
See @.context/decisions/ for architectural decisions (ADRs).

## Pattern System

Reusable task patterns are in `skills/`. Select a pattern by task type:

| Task | Skill |
|------|-------|
| Break a goal into ordered steps | `planning-tasks` |
| Evaluate libraries or approaches | `researching-options` |
| Architecture decisions and ADRs | `designing-systems` |
| Write or modify code | `implementing-features` |
| Write and run tests | `writing-tests` |
| Orchestrate multi-skill workflows | `coordinating-work` |

See `skills/GUIDE.md` for the full selection guide.

## Context Recovery

When resuming after a context reset:
1. Read `.context/overview.md`
2. Run `git log --oneline -10`
3. Read the latest file in `.context/retrospectives/`
4. Read any in-progress files in `.context/tasks/`
