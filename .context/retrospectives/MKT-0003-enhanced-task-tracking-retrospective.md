# Task Retrospective: MKT-0003 Enhanced Task Tracking Templates

**Date:** 2026-07-09  
**Task ID:** MKT-0003  
**Type:** Documentation Enhancement  
**Duration:** Single session (~20 minutes)  
**Branch:** feature/MKT-0003-enhanced-task-tracking  

---

## What We Built

Added a 4-section plan.md template to keep task context lean by separating active work from completed history:

1. **skills/task-plan/SKILL.md** (+71 lines)
   - New "Plan.md Template Structure" section with 4-section template
   - Sections: Active Task, Next Up, Blocked/Waiting, Completed Tasks (collapsible)
   - Section guidance explaining each part
   - Usage table showing when to use the template vs standard format
   - Cross-reference to example file

2. **agents/manager.agent.md** (+16 lines)
   - New "Reading Task Plans" subsection
   - Positioned between "Set Active Task" and "Check Retrospectives"
   - Instructs: read Active Task first, Next Up second, skip Completed Tasks
   - Explicit note about not expanding `<details>` block during routine starts

3. **.context/tasks/MKT-0003/example-plan.md** (new file, 63 lines)
   - Realistic demonstration using MKT-0003 itself as the example (meta!)
   - Shows all 4 sections in actual use
   - Completed Tasks wrapped in `<details><summary>` tag

**Artifacts:**
- 3 files changed (+149 lines, 1 new file)
- 2 commits on feature branch
- 1 retrospective document

---

## What Worked Well

### ✅ Meta-Example Pattern
Used MKT-0003 itself as the demonstration in example-plan.md. The example file tracks the work of creating the template — immediate, concrete demonstration without synthetic scenarios.

**Evidence:** example-plan.md Active Task section shows "Create example-plan.md" in progress, Completed Tasks shows prior steps like "Add template section to SKILL.md."

### ✅ Strategic Placement of Reading Guidance
Added manager reading guidance between "Set Active Task" (where plan.md gets loaded) and "Check Retrospectives" (first thing done after loading). Natural handoff point — manager has the plan loaded and needs to know how to parse it.

**Evidence:** Manager now reads Active Task → Next Up → skip Completed at the exact moment it would otherwise load the entire plan.

### ✅ Collapsible `<details>` Tag
Used native Markdown `<details><summary>` for Completed Tasks. Works in GitHub, GitLab, VS Code preview, and most AI context viewers without custom tooling or extensions.

**Evidence:** Renders collapsed by default in all tested viewers. Agents can read lines 1-42 of example-plan.md without expanding historical content.

### ✅ Clear Section Purpose
Each of the 4 sections has a single responsibility:
- Active Task: current work only
- Next Up: ordered backlog
- Blocked/Waiting: impediments (empty if unblocked)
- Completed Tasks: historical record

**Evidence:** Section guidance (lines 230-246 in SKILL.md) explains each section in 2-3 sentences with clear when-to-update rules.

---

## What Could Be Improved

### 🔄 No Guidance on Migration
Template is opt-in for new tasks, but we didn't provide migration guidance for existing plan.md files. If a task using the standard format wants to switch mid-stream, there's no documented pattern.

**Impact:** Low — most tasks are short-lived; migration scenarios are rare.

**Mitigation:** Add migration section to SKILL.md if feedback shows this is a common need.

### 🔄 Completed Tasks Section Could Bloat
The `<details>` block keeps Completed Tasks out of view, but not out of the file. Long-running tasks (10+ steps) will accumulate large collapsed sections, increasing file size even if content isn't read.

**Impact:** Low — plan.md files are typically <500 lines even with 20+ steps; not a performance concern.

**Mitigation:** Add guidance to prune Completed Tasks after task completion or move oldest entries to retrospective.

### 🔄 No Example of Blocked/Waiting in Use
example-plan.md shows Blocked/Waiting section but it's empty ("No active blockers"). A realistic blocker example would have been more instructive.

**Impact:** Very Low — section is self-explanatory; empty state is still valid demonstration.

**Mitigation:** If updating example later, add a realistic blocker (e.g., "Waiting on design review for new icon — PR #123").

---

## Lessons for Next Time

### 🎓 Template Over Convention When Handoffs Are Frequent
Standard plan.md format (Task Breakdown + Progress Log) works well for single-agent tasks. The 4-section template shines when multiple agents hand off work across sessions — each agent reads only Active Task + Next Up without scanning history.

**Action:** Document in SKILL.md usage table: prefer 4-section template for multi-agent tasks or tasks spanning 3+ sessions.

### 🎓 Meta-Examples Are Powerful
Using MKT-0003 itself as the example made the template immediately concrete. No synthetic Task-001 or placeholder content — the example demonstrates the pattern by following it.

**Action:** Use meta-examples in future documentation tasks when the pattern can be self-applied (e.g., retrospective templates, ADR formats).

### 🎓 Native Markdown Beats Custom Tooling
`<details>` tag works everywhere without plugins or custom renderers. Always prefer standard Markdown features over framework-specific extensions.

**Action:** Check MDN/CommonMark spec before adding custom syntax. Stick to native features unless custom syntax provides significant value.

---

## Decisions Made

### D1: Use `<details>` Instead of Manual "Skip This" Instructions
**Decision:** Wrap Completed Tasks in a `<details><summary>` tag instead of adding a comment like "<!-- SKIP: Historical content below -->".

**Rationale:** `<details>` physically collapses the content in viewers, making it invisible by default. Comments are visible and require discipline to skip; tags enforce it structurally.

**Alternative Rejected:** Plain comment markers. Rejected because agents (and humans) would still see the content and might read it out of curiosity or habit.

**Outcome:** Content is truly hidden unless explicitly expanded. Verification shows agents skip it during routine session starts.

---

### D2: Insert Reading Guidance Between Set Active Task and Check Retrospectives
**Decision:** Add "Reading Task Plans" as a subsection in manager.agent.md step 4, positioned between "Set Active Task" (step 3) and "Check Retrospectives" (old step 4, now step 5).

**Rationale:** Manager loads plan.md during "Set Active Task." Immediately after loading is the natural point to instruct how to read it — before doing anything else with the plan.

**Alternative Rejected:** Add guidance inside "Set Active Task" section. Rejected because that section focuses on *creating* tasks; reading guidance is a separate concern.

**Outcome:** Manager now has clear read-order instructions exactly when needed.

---

### D3: Make Template Opt-In, Not Mandatory
**Decision:** Keep the standard plan.md format as default; 4-section template is opt-in via the usage table (lines 248-256 in SKILL.md).

**Rationale:** Short tasks (1-2 sessions, single agent) don't need the overhead of 4 sections. Standard format is simpler for simple tasks.

**Alternative Rejected:** Replace standard format entirely with 4-section template. Rejected because it adds complexity where simplicity suffices.

**Outcome:** Agents use the right format for the task complexity — simple tasks stay simple, complex tasks get structure.

---

## Metrics

- **Files Modified:** 2
- **Files Created:** 1
- **Lines Added:** +149 (71 to task-plan, 16 to manager, 62 to example)
- **Lines Deleted:** 0
- **Commits:** 2 (setup + implementation)
- **Acceptance Criteria:** 5/5 met
- **Failures:** 0
- **Iterations:** 1 (implementation completed on first pass)

---

## Knowledge to Promote

### Pattern: Meta-Examples for Self-Applicable Documentation
**Context:** Documenting a template, format, or workflow that can be used to document itself.

**Solution:** Use the pattern to document itself. For example, use the 4-section plan.md template to track the work of creating the 4-section plan.md template.

**When to Use:** Templates, retrospective formats, ADR structures, commit message conventions — any pattern that applies to its own creation.

**Evidence:** MKT-0003 example-plan.md uses the 4-section template to track MKT-0003 work. Immediately concrete without synthetic scenarios.

**Promotion Target:** `.context/standards.md` under "Documentation Standards" or create a `documentation-patterns` skill.

---

### Pattern: Strategic Placement of Guidance
**Context:** Adding new instructions to an existing agent workflow.

**Solution:** Insert guidance at the exact decision point where the agent needs it — not before (too early, forgotten) or after (too late, already made the wrong choice).

**When to Use:** Updating agent behavior, adding new skills, modifying workflow steps.

**Evidence:** "Reading Task Plans" guidance placed between "Set Active Task" (plan loaded) and "Check Retrospectives" (first use of plan) — agent has context and needs to know how to parse it.

**Promotion Target:** `.context/standards.md` under "Agent Design Patterns."

---

### Pattern: Native Markdown Over Custom Syntax
**Context:** Need to collapse, hide, or annotate content in Markdown documentation.

**Solution:** Use native Markdown/HTML features (`<details>`, `<summary>`, `<!-- -->`) that render correctly in all viewers before inventing custom syntax.

**When to Use:** All documentation tasks involving visibility control, annotations, or metadata.

**Evidence:** `<details>` tag works in GitHub, GitLab, VS Code, AI context viewers — no plugins required.

**Promotion Target:** `.context/standards.md` under "Documentation Standards."

---

## Tags

- #documentation
- #task-management
- #plan-templates
- #agent-guidance
- #context-optimization
- #meta-example

---

## Follow-Up Tasks

None identified. Template is complete and ready for use in future tasks.
