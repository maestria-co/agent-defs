# standards/

Coding conventions and style decisions for this project.

## What belongs here

- **Project-specific style decisions** that go beyond what the linter enforces
- **Error handling patterns** — the single way errors are handled in this codebase
- **Naming conventions** — file, variable, function, class, and test naming rules

## Files

| File                    | Purpose                                                                     |
| ----------------------- | --------------------------------------------------------------------------- |
| `code-style.md`         | File organization, import ordering, comment conventions, formatting         |
| `naming-conventions.md` | Naming patterns for files, variables, functions, classes, tests, DB columns |
| `error-handling.md`     | Error types, logging rules, validation patterns, user-facing error format   |

## When to update

- A new convention is established in code review
- An old pattern is replaced — update the file, don't just add to it
- A retrospective entry identifies an inconsistency worth standardizing
- A new category of standard emerges (add a new file)
