# tasks/

Per-task artifacts created during work. Each task gets its own subdirectory.

## Structure

```
tasks/
└── [TASK-ID]/
    ├── brief.md          # What needs to be done (created at start)
    ├── plan.md           # Ordered task breakdown (planning-tasks output)
    ├── research.md       # External knowledge gathered (researching-options output)
    ├── decisions.md      # Task-specific ADRs (designing-systems output)
    └── retrospective.md  # Post-task lessons learned
```

## Lifecycle

1. **Create** the `[TASK-ID]/` directory when starting a medium or complex task
2. **Write `brief.md`** first — document the goal and acceptance criteria
3. **Add artifacts** as each workflow phase produces them
4. **Write `retrospective.md`** when the task is complete
5. **Promote lessons** from the retrospective to the appropriate `.context/` subdirectory
6. **Prune** completed task directories after lessons are promoted (keep for 2-4 weeks)

## When to skip

Simple, single-file changes don't need a task directory. If it takes less than 30 minutes and touches 1-2 files, just do it and add a retrospective entry to `../retrospectives.md` if you learned something.
