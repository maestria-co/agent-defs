---
name: task-plan-phase-completion
description: Load after the primary concern skill's work is done, to close any task. Covers code review, context updates, retrospective, and completion summary.
user-invocable: false
---

# Phase: Completion

Load this skill following primary concern skill finalization — for any task category. It addresses universal closure operations: code audit, context refresh, retrospective, and completion summary. **Sustain minimalism in this skill.** It loads at every task terminus; token expenditure is consequential.

## @reviewer Delegation Structure

```
Feature: [characterization]
All altered files:
  - [file/path]: [alteration characterization]
Relevant standards: [.context/standards/ citations]
Audit focus: [particular concern — security perimeter, performance pathway, etc.]
```

Remediate all critical and moderate conclusions. Archive minor conclusions in `plan.md` `## Open Questions / Blockers` for subsequent attention.

## Context Update Checklist

Post-audit and pre-closure, evaluate each element:

- [ ] **Domain files**: Did this task expose novel behaviors, entities, or business rules in any domain? If affirmative, refresh `.context/domains/[domain].md`.
- [ ] **Architecture files**: Did this task introduce or alter a pattern? If affirmative, refresh `.context/architecture/patterns.md`.
- [ ] **Standards files**: Did this task establish new conventions? If affirmative, refresh pertinent `.context/standards/` files.
- [ ] **Testing files**: Did this task reveal novel test patterns? If affirmative, refresh `.context/testing/`.
- [ ] **decisions**: Did this task produce significant architectural determinations not yet archived? If affirmative, append to `.context/decisions/`.
- [ ] **copilot-instructions.md**: Refresh EXCLUSIVELY for project-spanning alterations (new toolchain elements, command alterations, high-level convention shifts). AVOID region-specific detail here.

Load `context-maintenance` when refresh footprint is extensive (multiple files across multiple regions).

## Retrospective

Load `task-retrospective` skill for comprehensive retrospective execution.

Minimally, address these three queries:

1. What error or friction surfaced that merits future avoidance?
2. What pattern or methodology succeeded that merits repetition?
3. What `.context/` updates emerge from this experience?

Archive conclusions in `.context/retrospectives/` (rolling archive, sustain last 10–15 entries). Promote each lesson to appropriate `.context/` subdirectory.

## Completion Summary

```markdown
## Completion Summary
**Accomplished:** [1–2 sentence synopsis]
**Files altered:** [tally and notable paths]
**Tests:** [quantity appended, pass/fail status]
**Next effort:** [technical debt or next tasks, or "none"]
```

## Skill Interdependencies

- **`task-retrospective`**: Load for comprehensive retrospective execution.
- **`context-maintenance`**: Load when context refreshes span extensively (multiple files across multiple regions).
- **`commit-discipline`**: Load for terminal commit of closure files, retrospective entries, and context updates.
- **`task-plan-phase-testing`**: If tests remain incomplete, load that skill before executing completion.

**Excluded scope:** investigation, architectural audit, implementation orchestration, test delegation.
