---
name: systematic-debugging
description: >
  4-phase debugging process for reliable issue resolution. Use when: investigating a bug,
  diagnosing unexpected behavior, or handling a production incident. Prevents symptom-chasing
  and ensures root causes are found and verified.
---

# Skill: Systematic Debugging

## Purpose

Replace ad-hoc debugging with a structured 4-phase process: Reproduce → Root-Cause Trace
→ Defense-in-Depth Fix → Verify. This prevents the most common debugging failures:
fixing symptoms instead of causes, and not verifying the fix actually works.

---

## Phase 1: Reproduce

**Goal:** Create a reliable, minimal reproduction of the bug.

### Steps

1. **Understand the report** — What was expected? What happened instead? Under what conditions?
2. **Reproduce exactly** — Follow the exact steps from the bug report
3. **Minimize** — Strip away unrelated factors until you have the smallest reproduction
4. **Document** — Write down the exact steps, inputs, and expected vs. actual output

### Reproduction Checklist

- [ ] Bug reproduces consistently (not intermittent — if intermittent, note the frequency)
- [ ] Reproduction is minimal (no unnecessary setup)
- [ ] Expected behavior is clearly defined
- [ ] Actual behavior is clearly described with evidence (logs, screenshots, output)

### If You Can't Reproduce

- Check environment differences (versions, config, data)
- Check timing/concurrency (race conditions may need specific load)
- Ask for more details from the reporter
- **Do not proceed to Phase 2 until you can reproduce or have strong evidence of the cause**

---

## Phase 2: Root-Cause Trace

**Goal:** Find the actual cause, not just the symptom.

### Techniques

#### Binary Search (for "it used to work")

```bash
# Find the commit that introduced the bug
git bisect start
git bisect bad          # current commit is broken
git bisect good <hash>  # this commit was working
# Test each commit git bisect provides
```

#### Trace Backwards

Start from the symptom and trace backwards through the code:

1. Where does the wrong output come from?
2. What function produces that value?
3. What inputs does that function receive?
4. Are those inputs correct? If not, trace further back.

#### Add Logging

When the code path is unclear:

```
// Temporary debugging — remove before committing
console.log('[DEBUG] value at checkpoint:', JSON.stringify(value));
```

Add logs at key decision points, not everywhere. Log the **values**, not just "reached here."

#### Eliminate Hypotheses

1. List possible causes (3–5 hypotheses)
2. For each, design a test that would confirm or eliminate it
3. Run the fastest/cheapest tests first
4. Cross off eliminated hypotheses

### Root Cause Confirmation

Before proceeding, confirm:

- [ ] You can explain **why** the bug occurs (not just **where**)
- [ ] The explanation accounts for all symptoms
- [ ] The explanation explains why it worked before (if it did)

---

## Phase 3: Defense-in-Depth Fix

**Goal:** Fix the root cause and add safeguards against recurrence.

### Fix Layers

1. **Primary fix** — Correct the root cause directly
2. **Validation layer** — Add input validation or assertions near the failure point
3. **Regression test** — Write a test that fails without the fix and passes with it

### Fix Quality Checks

- [ ] Fixes the root cause, not just the symptom
- [ ] Doesn't introduce new issues (check surrounding code)
- [ ] Follows project conventions (check `.context/standards/`)
- [ ] Handles related edge cases the original code missed
- [ ] Minimal change — don't refactor during a bug fix

### Anti-Patterns

| Anti-Pattern                                     | Why It's Bad                           | Do This Instead                          |
| ------------------------------------------------ | -------------------------------------- | ---------------------------------------- |
| Shotgun fix (change many things, hope one works) | Can't verify which change helped       | Change one thing at a time               |
| Workaround without root fix                      | Bug will resurface in a different form | Fix the root cause                       |
| Fix + large refactor                             | Mixes concerns, hard to review         | Fix first, refactor in a separate commit |
| Suppressing the error                            | Hides the symptom, cause remains       | Fix the cause, let errors surface        |

---

## Phase 4: Verify and Prevent

**Goal:** Prove the fix works and prevent regression.

### Verification Steps

1. **Run the reproduction** — the original bug steps should now produce correct behavior
2. **Run the regression test** — the test you wrote in Phase 3 passes
3. **Run the full test suite** — no existing tests broken
4. **Check edge cases** — test related scenarios that weren't in the original report
5. **Build succeeds** — no compile errors, warnings, or lint failures

### Evidence Required

```
## Bug Fix Verification
- Reproduction test: ✅ [paste test command and output]
- Regression test: ✅ [paste test name and result]
- Full suite: ✅ [paste summary - X passed, 0 failed]
- Build: ✅ [paste build output summary]
```

### Prevention

After fixing, consider:

- Should this type of bug be caught by a linter rule?
- Should input validation be added to prevent similar issues?
- Should documentation be updated (`.context/standards/` or API docs)?
- Should this be a retrospective lesson?

---

## Production Incidents

For bugs in production, add urgency constraints:

### Triage First

1. **Severity** — Is this blocking users? Losing data? Or cosmetic?
2. **Scope** — How many users are affected?
3. **Workaround** — Is there a temporary workaround while you investigate?

### Hotfix Protocol

1. Apply a minimal, targeted fix (Phase 3 primary fix only)
2. Deploy the fix
3. Then do the full Phase 2–4 analysis
4. Follow up with the defense-in-depth layers in a subsequent release

### Don't

- Don't rush Phase 2 (root cause) for production issues — a wrong fix is worse
- Don't skip Phase 4 (verify) — you need proof the fix works before deploying
- Don't expand scope during a production fix — fix only the reported issue

---

## Constraints

- Never skip Phase 1 (reproduce) — fixing a bug you can't reproduce is guessing
- Never declare "fixed" without Phase 4 evidence
- Remove all debug logging before committing
- If Phase 2 takes more than 30 minutes without progress, reassess your approach
- Follow the `common-constraints` escalation rule: 3 failed attempts → stop and report
