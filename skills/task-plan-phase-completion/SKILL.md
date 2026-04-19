---
name: task-plan-phase-completion
description: Load after the primary concern skill's work is done, to close any task. Covers code review, context updates, retrospective, and completion summary.
user-invocable: false
---

# Phase: Completion

Load this skill after the primary concern skill's work is done — for any task
type. It covers the universal closing steps: code review, context updates,
retrospective, and completion summary. **Keep this skill minimal.** It loads
at the end of every task; token cost matters.

## @reviewer Delegation Structure

```
Feature: [description]
All changed files:
  - [path/to/file]: [what changed]
Relevant standards: [.context/standards/ references]
Review focus: [specific concern — security boundary, performance path, etc.]
```

Address all critical and moderate findings. Document minor findings in
`plan.md` `## Open Questions / Blockers` for follow-up.

## Context Update Checklist

After review and before closing the task, assess each item:

- [ ] **Domain files**: Did this task reveal new behavior, entities, or rules in any domain? If yes, update `.context/domains/[domain].md`.
- [ ] **Architecture files**: Did this task introduce or change a pattern? If yes, update `.context/architecture/patterns.md`.
- [ ] **Standards files**: Did this task establish a new convention? If yes, update the appropriate `.context/standards/` file.
- [ ] **Testing files**: Did this task reveal a new testing pattern? If yes, update `.context/testing/`.
- [ ] **decisions**: Did this task make a significant architectural decision not yet recorded? If yes, add it to `.context/decisions/`.
- [ ] **copilot-instructions.md**: Update ONLY for project-wide changes (new tech stack items, key command changes, high-level convention shifts). Do NOT add area-specific detail here.

Invoke `context-maintenance` if the update scope is broad (multiple files across multiple areas).

## Retrospective

Invoke the `task-retrospective` skill for the full retrospective process.

At minimum, answer these three questions:

1. What mistake or friction did we encounter that we should avoid next time?
2. What pattern or approach worked well that we should repeat?
3. What should be updated in `.context/` based on this experience?

Record findings in `.context/retrospectives/` (rolling log, keep last 10–15 entries). Promote each lesson to the appropriate `.context/` subdirectory.

## Completion Summary

```markdown
## Completion Summary
**Accomplished:** [1–2 sentences]
**Files changed:** [count and key paths]
**Tests:** [count added, pass/fail status]
**Follow-up work:** [technical debt or follow-up tasks, or "none"]
```

## Relationship to Other Skills

- **`task-retrospective`**: Invoke for full retrospective process.
- **`context-maintenance`**: Invoke if context updates are broad (multiple files across multiple areas).
- **`commit-discipline`**: Invoke for the final commit of completion docs, retro entries, and context updates.
- **`task-plan-phase-testing`**: If testing was not yet done, load that skill first before running completion.

**Does NOT cover:** investigation, architecture review, implementation dispatch, testing delegation.
