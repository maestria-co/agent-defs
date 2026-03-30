# domains/

Business and technical domain knowledge for this project.

## What belongs here

- **Core entities** with business rules that aren't obvious from the code — invariants, edge cases, relationships
- **Project-specific terminology** — words that have a meaning in this codebase that differs from general usage

## Files

| File          | Purpose                                                          |
| ------------- | ---------------------------------------------------------------- |
| `entities.md` | Domain models, business rules, relationships, and key code paths |
| `glossary.md` | Terms with project-specific meanings — prevents miscommunication |

## When to update

- A new domain entity or model is added to the codebase
- A business rule is discovered the hard way (especially after a bug)
- A term causes confusion between team members or AI agents
- Relationships between entities change
