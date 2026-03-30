# Retrospectives

Rolling log of lessons learned from completed tasks.

## Format

Each retrospective is a separate file named `YYYY-MM-DD-TASK-ID.md`.

Use this template:

```
# [TASK-ID] — [Task Name]
**Date:** YYYY-MM-DD

## What went well
- [Lesson learned]

## What could be improved
- [Issue encountered and solution applied]

## Promote to .context/
- [ ] standards/ — [specific lesson]
- [ ] architecture/ — [specific lesson]
- [ ] testing/ — [specific lesson]
```

## Maintenance

- After each task: create a new `YYYY-MM-DD-TASK-ID.md` file in this folder
- Weekly: open any files with unchecked `[ ]` promotion items, copy the lesson to the correct subdirectory, check the box
- Files older than 4 weeks with all items checked can be archived or deleted

Keeping individual files makes it easy for AI to load just the recent retrospectives without pulling the entire history into context.

## Example

See [2026-01-01-TASK-001-example.md](2026-01-01-TASK-001-example.md) for a sample entry.
