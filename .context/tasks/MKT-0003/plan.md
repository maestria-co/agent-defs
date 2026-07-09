# Task Plan: MKT-0003 — Enhanced Task Tracking Templates

**Task ID:** MKT-0003  
**Type:** Documentation Enhancement  
**Priority:** P1  
**Effort:** 2h  
**Branch:** feature/MKT-0003-enhanced-task-tracking  

---

## Goal

Create a structured template for plan.md files that separates active work from completed tasks, keeping task context lean and avoiding re-reading completed items every session.

---

## Acceptance Criteria

1. ✅ Given the `skills/task-plan/SKILL.md`, when I read the new "Plan.md Template Structure" section, then it shows a 4-section template: Active Task, Next Up, Blocked/Waiting, and Completed Tasks (collapsed).

2. ✅ Given a plan.md using the template, when I read only the "Active Task" and "Next Up" sections, then I have sufficient context for current and upcoming work without loading completed items.

3. ✅ Given the "Completed Tasks" section, when I read plan.md, then it uses a `<details>` collapsible tag to keep it hidden by default.

4. ✅ Given the `agents/manager.agent.md`, when I read the new "Reading Task Plans" guidance, then it instructs to read Active Task first, Next Up second, and skip Completed Tasks unless needed for historical context.

5. ✅ Given the `.context/tasks/MKT-0002/example-plan.md` file, when I read it, then it demonstrates the template in actual use with realistic task examples.

---

## Steps

1. **[PENDING]** Analyze current task-plan skill and manager agent to understand current plan.md structure and identify where to add template guidance.

2. **[PENDING]** Design 4-section plan.md template: Active Task, Next Up, Blocked/Waiting, and Completed Tasks (collapsible).

3. **[PENDING]** Update `skills/task-plan/SKILL.md` with "Plan.md Template Structure" section showing the new template.

4. **[PENDING]** Update `agents/manager.agent.md` with "Reading Task Plans" guidance instructing to read Active Task first, Next Up second, skip Completed.

5. **[PENDING]** Create `.context/tasks/MKT-0002/example-plan.md` demonstrating the template with realistic task examples.

6. **[PENDING]** Test template clarity and usability: verify all 5 acceptance criteria are met.

7. **[PENDING]** Final verification: run checklist, commit, and prepare for completion.

---

## Context

**From Trello Card:**
- **Story:** As a task manager or agent, I want a structured template for plan.md files that separates active work from completed tasks, so that I can keep task context lean and avoid re-reading completed items every session.

**Affected Components:**
- `skills/task-plan/SKILL.md` — Add template structure section
- `agents/manager.agent.md` — Add reading guidance
- `.context/tasks/MKT-0002/example-plan.md` — New example file

**Complexity:** S (Small)  
**Effort:** 2h

---

## Decisions

None yet.

---

## Progress Log

- **2026-07-09 17:48** — Task created, branch feature/MKT-0003-enhanced-task-tracking created
