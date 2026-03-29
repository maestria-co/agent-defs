---
name: triage-orchestration
description: >
  Use when orchestrating a complete bug triage and fix cycle from report to
  resolution. Triggers on "triage this bug", "we have an incident", "walk through
  fixing this issue end-to-end", or when coordinating multiple agents to resolve
  a complex issue.
---

# Skill: Triage Orchestration

## Purpose

Orchestrate the 6-phase bug triage workflow from initial assessment through resolution
and follow-up. Ensures nothing is skipped and context is preserved across phases.
This skill prevents incomplete bug investigations and ensures every issue is properly
documented, reproduced, fixed, and verified.

---

## Phase 1: Initial Assessment

**Goal:** Gather complete information and classify the issue.

### Steps

1. **Gather information**
   - Logs (error messages, stack traces, application logs)
   - Reproduction steps from the reporter
   - Environment details (OS, browser, version, deployment)
   - When did this start? Did it ever work?

2. **Classify severity**
   - **Critical** — Production down, data loss, security breach
   - **High** — Core feature broken, many users affected, no workaround
   - **Medium** — Feature partially broken, workaround exists
   - **Low** — Cosmetic issue, enhancement, affects few users

3. **Classify type**
   - Bug (unexpected behavior)
   - Feature request (new capability)
   - Question (user education needed)
   - Incident (production issue requiring immediate action)

4. **Assign initial owner** — Who has context on this area?

### Assessment Checklist

- [ ] Reporter's original description captured verbatim
- [ ] Severity classification documented with rationale
- [ ] Environment and version information recorded
- [ ] Initial owner assigned
- [ ] If P0/Critical: escalation initiated

---

## Phase 2: Reproduction

**Goal:** Create a minimal, reliable reproduction case.

### Steps

1. **Verify in controlled environment**
   - Use the exact steps from the report
   - Match the reporter's environment as closely as possible
   - Document exact inputs and outputs

2. **Create minimal reproduction**
   - Strip away unrelated factors
   - Reduce to smallest possible reproduction
   - Write reproduction steps that anyone can follow

3. **Document expected vs. actual**
   ```
   Steps:
   1. [step]
   2. [step]
   
   Expected: [what should happen]
   Actual: [what happens instead]
   
   Evidence: [logs, screenshots, error messages]
   ```

### Cannot Reproduce?

If unable to reproduce after 3 attempts:

1. Check for environment differences
2. Request more information from reporter (specific versions, data, exact steps)
3. Mark as **needs more info**
4. Return to reporter with specific questions

**Do not proceed to Phase 3 without reproduction** — fixing an unreproduced bug is guessing.

---

## Phase 3: Root Cause Analysis

**Goal:** Find the actual cause, not just the symptom.

### Process

Use the **systematic-debugging** skill for this phase:

1. Trace backwards from the symptom
2. Identify where the incorrect behavior originates
3. Distinguish root cause from contributing factors
4. Explain **why** the bug occurs, not just **where**

### Root Cause Confirmation

- [ ] Can explain why the bug occurs
- [ ] Explanation accounts for all symptoms
- [ ] If it worked before, can explain what changed
- [ ] Have identified the specific code causing the issue

---

## Phase 4: Solution Design

**Goal:** Design the fix with appropriate scope and safeguards.

### Critical Issue Strategy

For Critical/P0 issues, design two solutions:

1. **Immediate workaround** — Quick mitigation to unblock users
2. **Proper fix** — Complete solution addressing root cause

Deploy workaround first, then proper fix in follow-up.

### Impact Assessment

Use the **impact-assessor** skill to evaluate:

- What code will change?
- What features could be affected?
- What tests need updating?
- Is this a breaking change?

### Architectural Review

Get architect review if:

- Fix requires structural changes
- Fix affects multiple systems/services
- Fix changes API contracts or data models
- Fix has performance implications

### Test Strategy

Define before coding:

- What regression test will prove the fix works?
- What edge cases must be tested?
- What existing tests might break?

---

## Phase 5: Implementation

**Goal:** Execute the fix with verification.

### Handoff to Coder

Route to @coder with full context package:

```
## Bug Fix Request

Issue: [brief description]
Root cause: [Phase 3 finding]
Solution: [Phase 4 design]
Affected files: [list from impact assessment]

Reproduction steps:
[from Phase 2]

Regression test requirements:
[from Phase 4 test strategy]

Reference: [ticket/issue link]
```

### Implementation Requirements

- [ ] Regression test written (must fail before fix, pass after)
- [ ] Fix resolves original issue exactly (run Phase 2 reproduction)
- [ ] No new issues introduced (run full test suite)
- [ ] Follows project coding standards (check `.context/standards/`)
- [ ] Debug logging removed before commit

---

## Phase 6: Follow-up

**Goal:** Confirm resolution and capture lessons.

### Steps

1. **Confirm with reporter**
   - Deploy the fix (or provide test build)
   - Ask reporter to verify using original reproduction steps
   - Close ticket only after reporter confirms

2. **Write retrospective**
   
   Add entry to `.context/retrospectives.md`:
   ```markdown
   ## [Date] — [Brief issue description]
   
   **What happened:** [symptom]
   **Root cause:** [actual cause from Phase 3]
   **Solution:** [what was changed]
   **Lesson:** [what we learned, what to watch for]
   **Prevention:** [what would catch this earlier next time]
   ```

3. **Update domain knowledge**
   
   If this revealed missing context, update `.context/domains/`:
   - New domain concepts learned
   - Common pitfalls in this area
   - Links to relevant code sections

4. **Close ticket**
   - Link to the fix commit/PR
   - Link to retrospective entry
   - Mark as resolved with verification date

### Follow-up Checklist

- [ ] Reporter confirmed resolution
- [ ] Retrospective entry written
- [ ] Domain knowledge updated if needed
- [ ] Ticket closed with links to fix and retrospective

---

## Escalation Paths

Know when to escalate immediately:

| Scenario | Action |
|----------|--------|
| Security vulnerability | Escalate to @manager with `[SECURITY]` prefix immediately |
| Data loss or corruption | Stop all writes, escalate with `[DATA]` prefix |
| Cannot reproduce after 3 attempts | Escalate to reporter for more information |
| Scope larger than expected | Check in with user before proceeding |
| Root cause unclear after 2 hours | Request help from domain expert or architect |

---

## Constraints

- Never skip Phase 2 (reproduction) — fixing an unreproduced bug is guessing
- Never skip Phase 6 (follow-up) — unconfirmed fixes are not resolved fixes
- Never expand scope during triage — fix the reported issue, file new tickets for discovered issues
- Remove all debug logging before committing
- Critical issues require both immediate workaround and proper fix — do not skip the proper fix
- Always document the root cause — "fixed it" without explanation helps no one
