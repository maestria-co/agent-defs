# Handoff Protocol Analysis

> Phase 1 deliverable. Analyzes the full handoff protocol and shared conventions
> to identify what adds genuine value vs. what adds complexity. Output drives
> Phase 2 pattern design decisions.
>
> **Date:** 2026-03-15  
> **Status:** Complete

---

## Summary

The handoff protocol and agent conventions contain **significant value** — but most of it is
embedded inside the agent-routing structure that we're eliminating. The insight of this analysis:
**the valuable parts are the prompt discipline rules, not the routing infrastructure.**

| Category | Verdict | Disposition |
|---|---|---|
| Structured output formats | ✅ Value-add | Transfer to patterns |
| XML tag conventions | ✅ Value-add | Transfer to `_shared/conventions.md` |
| Context reading discipline | ✅ Value-add | Transfer as pre-flight checks |
| Self-verify before done | ✅ Value-add | Transfer to each pattern |
| One-question clarity rule | ✅ Value-add | Transfer to `_shared/conventions.md` |
| Stopping conditions | ✅ Value-add | Transfer to `coordinating-work` + shared |
| Acceptance criteria format | ✅ Value-add | Transfer to `planning-tasks` |
| Manager routing table | ⚠️ Neutral | Converts to user-facing selection guide |
| Agent-to-agent routing tails | ❌ Complexity | Drop — no routing needed |
| Completion signals back to Manager | ❌ Complexity | Drop — user sees output directly |
| Blocked handoff protocol | ❌ Complexity | Simplify — state blocker as plain output |
| "One task per handoff" rule | ❌ Complexity | Drop — patterns invoked per-task already |
| Agent role boundary enforcement | ❌ Complexity | Drop — user picks pattern; boundaries are natural |

---

## Part 1: What Adds Genuine Value

### 1.1 XML Tag Conventions (High Value)

**Source:** `agents/_shared/conventions.md` — "Use XML tags for structured content" section.

**The value:** XML tags sharply reduce model misinterpretation of structured content. Research
consistently shows this. The tags in use are:
- `<task>` — what to do
- `<context>` — background needed
- `<constraints>` — must-follow rules
- `<input>` — what's available
- `<output>` — expected artifact
- `<example>` — few-shot example (in `<examples>` for multiple)
- `<thinking>` — reasoning trace
- `<decision>` — decision record

**Action:** Transfer verbatim to `.context/patterns/_shared/conventions.md`. Include in every
pattern's example section. Make examples use XML wrapping.

---

### 1.2 Completion Signal Structure (High Value)

**Source:** `handoff-protocol.md` — Completion Signals section.

**The value:** The 5-part completion format (Task, Outputs, Decisions, Blockers, Next step)
ensures pattern output is self-contained and actionable. Without this, outputs become
ambiguous prose.

**Preserve as:** Each pattern's "Output Format" section should specify the completion structure
expected. In agentless form, "Recommended next step" replaces "Route to: [Agent]" — it's
advisory, not mandatory.

**Action:** Embed adapted completion format in each pattern's Execution Steps.

---

### 1.3 Context-Reading Discipline (High Value)

**Source:** Multiple agent files + conventions.md — "Read first" before acting.

**The value:** The discipline of reading `.context/project-overview.md` before starting a
non-trivial task prevents wasted effort and wrong-context implementations. Currently
enforced through Manager's turn protocol and Architect's startup behavior.

**In agentless:** Pre-flight checks in each SKILL.md take over this function. Each pattern's
pre-flight should specify exactly which `.context/` files to read before executing steps.

**Action:** Add a Pre-flight check to each pattern: "Read `.context/project-overview.md` if
it exists. Read any `.context/decisions/` ADRs relevant to this work."

---

### 1.4 Self-Verify Before Completion (High Value)

**Source:** `agents/_shared/conventions.md` — "Self-verify before signaling completion."

**The 4 checks:**
1. Re-read acceptance criteria — check each one explicitly
2. Check for regressions
3. Spot-check own output as reviewer
4. Confirm artifacts exist and are non-empty

**Action:** Transfer verbatim to `_shared/conventions.md`. Reference at the end of each
pattern's Execution Steps.

---

### 1.5 Stopping Conditions (High Value)

**Source:** `agents/_shared/conventions.md` + `manager.agent.md`.

**The 6 conditions:**
1. Irreversible change not explicitly authorized
2. Scope grew significantly beyond what was asked
3. Conflict with existing ADRs without mandate to supersede
4. 3+ consecutive failures without progress
5. Missing critical information only the user can provide
6. Unintended side effects discovered

**The soft threshold:** After every 3–5 significant actions in a long task, pause for a brief
status update.

**Action:** Transfer the check-in format (`⏸ Check-in:`) and the 6 conditions to
`coordinating-work/SKILL.md` and reference from `_shared/conventions.md`. This is especially
critical for the coordinating-work pattern since it orchestrates multiple steps.

---

### 1.6 Task Format (High Value → `planning-tasks`)

**Source:** `planner.agent.md` — task format template.

**The value:** The `Verb+Noun (S/M/L) / Assigned / Depends on / Input / Output / Acceptance criteria / Scope out` structure is excellent. It forces atomic, concrete, testable tasks and explicitly captures what's out of scope.

**Agentless adaptation:** Drop "Assigned to: [Agent]" field. Everything else transfers.

---

### 1.7 "Good Enough" Research Bar (High Value → `researching-options`)

**Source:** `researcher.agent.md` — "Set a 'good enough' bar — exhaustive research is itself a
failure mode."

**The value:** This single principle prevents unbounded research loops. Combined with the
"always recommend explicitly" rule (never "here are options, you decide"), it makes research
patterns produce actionable output rather than cognitive load transfer.

---

### 1.8 Reversibility Assessment (High Value → `designing-systems`)

**Source:** `architect.agent.md` — "Assess reversibility: Two-way door vs. One-way door."

**The value:** This heuristic correctly prioritizes effort. Two-way door decisions should be
made quickly with light documentation. One-way door decisions warrant the full ADR treatment.
Most teams over-document two-way doors and under-document one-way doors.

---

## Part 2: What Adds Complexity (Eliminate)

### 2.1 Agent-to-Agent Routing Tails

**Source:** Every agent's completion format — "Route to: Manager/Coder/Tester/etc."

**Why it's complexity:** In the agentless model, the user decides what happens next. Routing
tails in completion formats create the false impression that something must happen next and
that the agent is responsible for ensuring it. They also require the user to understand the
routing logic just to interpret an output.

**Replacement:** Each pattern's output can include an optional "suggested next step" note,
but it's advisory: *"If you need to implement this design, consider invoking
`implementing-features`."* Not a routing instruction — an informed suggestion.

---

### 2.2 Manager as Mandatory Entry Point

**Why it's complexity:** The Manager's value was as a router and orchestrator for a system
where specialists couldn't be invoked directly. In an agentless system, this routing layer
is pure overhead. Users who understand their task type can go directly to the right pattern.

**What survives:** The Manager's *selection guide* (the routing table showing task type → which
pattern to use) is valuable documentation. It becomes the `coordinating-work/SKILL.md` guide
and the `patterns/GUIDE.md` composition reference.

---

### 2.3 Structured Handoff Messages Between Agents

**Why it's complexity:** The 5-part handoff structure (Task/Context/Inputs/Expected Output/Constraints)
is necessary when one autonomous agent needs to brief another. In agentless use, the user
provides this context themselves through the conversation and `.context/` files.

**What survives:** The *structure of the handoff* is excellent as a checklist for users
invoking a pattern. It becomes the pre-flight check template: "Before invoking this pattern,
ensure you have: [task], [context], [inputs], [expected output], [constraints]."

---

### 2.4 Blocked/Incomplete Handoff Protocol

**Why it's complexity:** A 3-section blocked handoff format (Cannot Proceed Because / Specifically
Need / Suggested Resolution) is necessary for autonomous multi-agent systems where agents
communicate asynchronously. In agentless use, a blocker is just stated as output and the
user handles it.

**Replacement:** Each pattern's constraints section includes: "If you cannot proceed (missing
spec, ambiguous goal), state: 'I cannot proceed without [specific missing item]' and stop."

---

### 2.5 Role Boundary Enforcement Between Agents

**Why it's complexity:** Role boundaries in the current system serve two purposes: (1) keeping
agents from doing each other's jobs, and (2) triggering routing to the right agent when a
task is out of scope. Neither purpose applies in agentless use.

**What survives:** The role boundaries document *what each pattern is for*, which helps users
pick the right pattern. This becomes the `GUIDE.md` composition guide.

---

## Part 3: Handoff Examples — What to Preserve

The 4 handoff examples in `handoff-protocol.md` are high-quality illustrations of real workflow
steps. They're too good to discard.

| Example | Where it lives in patterns |
|---|---|
| Manager → Planner (OAuth task breakdown) | `coordinating-work/SKILL.md` as an `<example>` |
| Planner → Researcher (refresh token research) | `planning-tasks/SKILL.md` as an `<example>` showing unknowns routing |
| Planner → Coder (OAuthProvider model) | `planning-tasks/SKILL.md` as an `<example>` showing a concrete task |
| Coder → Tester (OAuthProvider tests) | `implementing-features/SKILL.md` as an `<example>` showing completion signal |

---

## Part 4: Net Simplification

### Lines of active documentation

| Category | Current | After |
|---|---|---|
| `conventions.md` | 290 lines | ~250 lines (drop agent-routing sections) |
| `handoff-protocol.md` | 218 lines | Archived; ~50 lines extracted into patterns |
| Agent files (6) | ~380 lines total | Archived; core discipline → patterns (~50 lines each) |
| **Total active** | **~888 lines** | **~450 lines** (~6 patterns × 75 lines avg) |

### Complexity removed

- Zero routing decisions needed
- Zero handoff message composition required
- Zero "which agent should handle this?" mental model required
- State management reduced to: read `.context/` before, write `.context/` after

### Value preserved

- All output format discipline
- All XML tag conventions
- All context-reading pre-flight discipline
- All stopping conditions and check-in formats
- All task/report/ADR output structures
- All "think first" and "read before write" disciplines

---

## Decisions for Phase 2

1. **Each pattern needs ≥2 real examples** drawn from the handoff-protocol.md examples above
2. **Pre-flight checks** should reference specific `.context/` files, not just generic guidance
3. **Completion format** in each pattern should include an optional "suggested next step" advisory
4. **`coordinating-work`** is the natural home for stopping conditions + check-in format
5. **Shared conventions** extracts ~250 lines from `agents/_shared/conventions.md`
