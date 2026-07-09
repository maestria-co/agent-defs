# MKT-0003: Enhanced Task Tracking Templates

**Branch:** `feature/MKT-0003-enhanced-task-tracking`

## Objective

Add a structured 4-section template to the `task-plan` skill so agents can resume
work without scanning through completed history. The template separates active work
from completed tasks, keeping context lean across sessions.

## Acceptance Criteria

- [ ] `skills/task-plan/SKILL.md` has "Plan.md Template Structure" section with 4-section template
- [ ] Template allows reading Active Task + Next Up without loading Completed Tasks
- [ ] Completed Tasks section uses `<details>` collapsible tag
- [ ] `agents/manager.agent.md` has "Reading Task Plans" guidance
- [ ] `example-plan.md` demonstrates template with realistic examples

## Key Files

- `skills/task-plan/SKILL.md` — skill definition; adding template section here
- `agents/manager.agent.md` — manager agent; adding reading guidance here
- `.context/tasks/MKT-0003/example-plan.md` — this file; the example itself

---

## Active Task

**Step:** Create example-plan.md  
**Status:** In Progress

Writing a realistic example of the 4-section template in use, pointed to by the
new "Plan.md Template Structure" section in `skills/task-plan/SKILL.md`.

## Next Up

1. Verify all acceptance criteria against changed files
2. Update MKT-0003 plan.md progress log and mark steps complete

## Blocked / Waiting

_(No active blockers)_

<details>
<summary>Completed Tasks</summary>

- [x] Read existing `skills/task-plan/SKILL.md` and `agents/manager.agent.md` — confirmed insertion points and formatting conventions
- [x] Add "Plan.md Template Structure" section to `skills/task-plan/SKILL.md` — 4-section template with guidance table and cross-reference
- [x] Add "Reading Task Plans" guidance to `agents/manager.agent.md` — inserted between "Set Active Task" and "Check Retrospectives" sections

</details>

---

## Decisions

- **Use `<details><summary>` for Completed Tasks:** Native Markdown collapsible; renders collapsed in GitHub and most AI context views without custom tooling.
- **Place reading guidance in manager agent between Set Active Task and Check Retrospectives:** That's the natural handoff point where the manager has a plan loaded and needs to know how to parse it.

## Progress Log

- **2026-07-09:** Task created. Added template section to SKILL.md, reading guidance to manager.agent.md, and this example file.
