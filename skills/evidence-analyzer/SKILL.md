---
name: evidence-analyzer
description: >
  Use when evaluating whether evidence is sufficient to support a conclusion
  or action. Triggers on "is this enough evidence", "should I trust this data",
  "verify this claim", "is this test coverage sufficient", or before making
  any claim about system behavior.
---

# Skill: Evidence Analyzer

## Purpose

Analyze the quality and reliability of evidence before acting on it. Prevents decisions
based on insufficient, biased, or misinterpreted data.

---

## Process

### 1. Identify the Claim

**What conclusion is the evidence supposed to prove?**

- State the claim explicitly
- Distinguish between facts and interpretations
- Identify what action depends on this claim being true

### 2. Evaluate Source Quality

Classify evidence by source type:

**Primary sources** (most reliable):

- Logs from the actual system
- Test output from running tests
- Direct measurements (profiling, metrics, traces)
- Code that you can read and verify
- Errors or output you can reproduce

**Secondary sources** (moderately reliable):

- Documentation (check recency — when was it written?)
- Reports or summaries from others
- Historical data or past test results
- Stack Overflow or issue tracker discussions

**Tertiary sources** (treat as hypothesis, not evidence):

- Rumors or "I heard that..."
- Assumptions or "I think..."
- Extrapolations without verification
- "It should work because..." (theory without testing)

### 3. Check for Coverage Gaps

**Does the evidence cover all cases?**

- What scenarios **are** covered?
- What scenarios **are not** covered?
- Are there edge cases, error paths, or load conditions not represented?
- Is the evidence from the specific context in question? (right environment, right version, right data)

### 4. Check for Bias

**Was evidence collected in a way that could confirm what was already expected?**

- Was only "happy path" tested, ignoring error cases?
- Was evidence cherry-picked (showing successes, hiding failures)?
- Was the test designed to pass rather than to challenge the hypothesis?
- Is there selection bias (only looking at successful requests, ignoring failures)?

### 5. Check for Staleness

**Is this evidence from the current state of the system?**

- When was the evidence collected?
- Has the system changed since then? (code, config, data, infrastructure)
- Are you looking at the right branch, environment, or deployment?
- Is the documentation in sync with the code?

### 6. Assess Sufficiency

**Is there enough evidence to act?**

Use the Evidence Quality Matrix below to decide.

---

## Evidence Quality Matrix

| Quality      | Characteristics                                  | Action                               |
| ------------ | ------------------------------------------------ | ------------------------------------ |
| **Strong**   | Reproducible, primary source, covers all cases   | Proceed with confidence              |
| **Adequate** | Primary source, most cases covered, gaps noted   | Proceed, document gaps               |
| **Weak**     | Secondary source OR incomplete coverage          | Gather more before acting            |
| **Insufficient** | Assumption, single data point, unverifiable  | Do not act — investigate first       |

---

## Output Format

```
## Evidence Analysis: [claim being evaluated]

Claim: [the conclusion or action being considered]

Source quality: [Primary | Secondary | Tertiary]
Evidence type: [logs/tests/metrics/docs/assumptions/other]

Coverage:
- Covered: [scenarios/cases where evidence exists]
- Gaps: [scenarios/cases NOT covered]

Bias check:
- [any bias detected, or "none detected"]

Staleness:
- Collected: [when/from what version]
- Current as of: [date/version]
- Status: [Current | Stale | Unknown]

Sufficiency: [Strong | Adequate | Weak | Insufficient]

Recommendation:
[Proceed | Proceed with documented gaps | Gather more evidence | Do not act]

Reasoning: [1-2 sentences]
```

---

## Constraints

- **Never treat "it worked before" as current evidence** — systems change
- Test output from a **different environment** is weak evidence for production behavior
- A **passing test** is evidence of tested behavior — not of all behavior
- A **single data point** is not a pattern — look for multiple confirmations
- **Absence of evidence is not evidence of absence** — "no errors in logs" doesn't mean "no errors occurred" (maybe logging is broken)
- If evidence is **Insufficient** or **Weak**, do not proceed with the action — gather more evidence first
- Document all assumptions explicitly — they are hypotheses, not evidence
