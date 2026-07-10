# Task Plan: MKT-0004 — Output Verbosity Control

**Task ID:** MKT-0004  
**Type:** Documentation Enhancement  
**Priority:** P1  
**Effort:** 2h  
**Branch:** feature/MKT-0004-output-verbosity  

---

## Goal

Add output efficiency guidelines to agent definitions so agents use concise output for routine operations and verbose output only for complex work or errors, helping users focus on essential information.

---

## Acceptance Criteria

1. ✅ Given the `agents/manager.agent.md`, when I read the new "Output Efficiency Guidelines" section, then it distinguishes three scenarios: Routine Operations, Complex Operations, and Error Scenarios, with guidance for each.

2. ✅ Given a routine operation (reading files, running passing tests), when an agent responds, then it avoids preambles ("Great, let me..."), doesn't restate context, and provides only essential observation or next action.

3. ✅ Given a complex operation (debugging, architecture decisions), when an agent responds, then it provides reasoning and evidence for conclusions.

4. ✅ Given an error scenario, when an agent responds, then it always provides full context, stack traces, and step-by-step diagnosis regardless of other guidelines.

5. ✅ Given the `agents/coder.agent.md`, when I read the new "Code Output Efficiency" section, then it shows patterns for routine vs. complex code changes.

6. ✅ Given the `agents/tester.agent.md`, when I read the new "Test Output" section, then it shows concise summaries for passing tests and full output for failures.

---

## Steps

1. **[PENDING]** Analyze current agent output patterns to identify verbosity patterns and insertion points for efficiency guidelines.

2. **[PENDING]** Design output efficiency guidelines: define 3 scenarios (Routine, Complex, Error) with specific guidance for each.

3. **[PENDING]** Add "Output Efficiency Guidelines" section to `agents/manager.agent.md` distinguishing the 3 scenarios.

4. **[PENDING]** Add "Code Output Efficiency" section to `agents/coder.agent.md` showing patterns for routine vs complex code changes.

5. **[PENDING]** Add "Test Output" section to `agents/tester.agent.md` showing concise summaries for passing tests, full output for failures.

6. **[PENDING]** Test guidelines clarity: verify all 6 acceptance criteria are met.

7. **[PENDING]** Final verification: run checklist, commit, and prepare for completion.

---

## Context

**From Trello Card:**
- **Story:** As an agent user, I want agents to use concise output for routine operations and verbose output only for complex work or errors, so that I can focus on essential information and avoid unnecessary preambles for standard tasks.

**Affected Components:**
- `agents/manager.agent.md` — Add Output Efficiency Guidelines section
- `agents/coder.agent.md` — Add Code Output Efficiency section
- `agents/tester.agent.md` — Add Test Output section

**Complexity:** S (Small)  
**Effort:** 2h

---

## Decisions

None yet.

---

## Progress Log

- **2026-07-10 08:31** — Task created, branch feature/MKT-0004-output-verbosity created
