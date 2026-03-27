# architecture/

Structural patterns and migration history for this project.

## What belongs here

- **Recurring patterns** established in code review or derived from ADRs — documented with real code paths and anti-patterns
- **Migration guides** for database schema changes, API version changes, or major refactors — always with rollback procedures

## Files

| File                          | Purpose                                                            |
| ----------------------------- | ------------------------------------------------------------------ |
| `patterns-template.md`        | Patterns the codebase has committed to (not aspirational — actual) |
| `migration-guide-template.md` | Log of schema/API migrations with rollback procedures              |

## When to update

- A new pattern is established in code review or an ADR
- A painful refactor reveals a pattern that should have been followed
- A database migration or major refactor ships
- An existing pattern is superseded (update, don't delete — mark deprecated)
