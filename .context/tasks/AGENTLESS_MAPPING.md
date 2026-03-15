# Agentless Mapping

> Phase 1 deliverable. Maps each agent role to its agentless pattern equivalent.
> Specifies what each pattern must preserve, what it can drop, and what the SKILL.md
> should focus on.
>
> **Date:** 2026-03-15  
> **Status:** Complete

---

## Pattern Directory

All patterns live in `.context/patterns/` as `SKILL.md` files with gerund naming.

| Agent | Pattern File | Core Capability |
|---|---|---|
| Manager | `.context/patterns/coordinating-work/SKILL.md` | Routing logic, delegation template, stopping conditions |
| Planner | `.context/patterns/planning-tasks/SKILL.md` | Task decomposition, task format, unknowns handling |
| Researcher | `.context/patterns/researching-options/SKILL.md` | Option evaluation, recommendation format, report structure |
| Architect | `.context/patterns/designing-systems/SKILL.md` | Decision-making framework, ADR writing, design principles |
| Coder | `.context/patterns/implementing-features/SKILL.md` | Read-first workflow, minimal change, context discipline |
| Tester | `.context/patterns/writing-tests/SKILL.md` | Test categories, coverage targets, bug report format |

Shared conventions extracted to: `.context/patterns/_shared/conventions.md`

---

## Detailed Mapping

### Manager → `coordinating-work`

**What to preserve:**
- Routing table (task type → which pattern to use) — becomes the pattern's core guidance
- Delegation template (`<task>`, `<context>`, `<output>`, `<criteria>` XML tags)
- Stopping conditions (4 conditions for human check-in)
- Check-in format (`⏸ Check-in:` block)
- Intake discipline (read `.context/project-overview.md` first, one question only)

**What to drop:**
- References to "routing to another agent" — user picks pattern directly
- Completion format that routes back to Manager — user sees output directly
- Agent selection as a gatekeeping step — becomes a direct-use guide for the user

**Pattern focus:** "When your task involves multiple steps or patterns, here's how to compose them
and when to stop for a check-in." Use sparingly — most tasks use 1–2 patterns directly.

**Degree of freedom:** Low (structured coordination with defined stopping rules)

---

### Planner → `planning-tasks`

**What to preserve:**
- The task format template (Verb+Noun, S/M/L, Depends on, Input, Output, Acceptance criteria, Scope out)
- "When to invoke" criteria (3+ steps, multiple agents, unclear scope)
- "Skip when" criteria (single well-defined task, user provided breakdown)
- Workflow: restate goal → inventory existing code → identify unknowns → write tasks → save plan
- Anti-over-planning and anti-under-planning warnings
- Explicit assumption flagging convention

**What to drop:**
- "Assigned to: [Agent]" field in task format — user assigns directly
- "Route to: Researcher/Architect" from unknowns handling — becomes "note this as a separate task"
- Completion signal routing back to Manager
- `createFiles` tool reference (becomes file write instruction in steps)

**Pattern focus:** How to take an ambiguous goal and produce an ordered, concrete task list.
Output is written to `.context/plans/[feature-name].md`.

**Degree of freedom:** Medium (structured output format, but discovery-driven process)

---

### Researcher → `researching-options`

**What to preserve:**
- "Good enough" bar (exhaustive research is itself a failure mode)
- Option evaluation criteria (recent commits, download stats, CVE history, license, TypeScript support, docs quality)
- Honest analysis requirement (state genuine downsides, confidence levels)
- Explicit recommendation requirement (never "here are options, you decide")
- Report structure (Recommendation → Options Evaluated table → Key Findings → Sources)
- Save to `.context/research/[topic-slug].md`

**What to drop:**
- "Route to: Architect if design decision follows directly" — user decides what comes next
- "Requested by: [Agent]" field in report header — just date and topic
- Completion signal with routing instructions

**Pattern focus:** How to investigate a technical question and produce an actionable, opinionated
recommendation. Output is a research report, not a list of options.

**Degree of freedom:** High (investigation-driven, varied inputs and outputs)

---

### Architect → `designing-systems`

**What to preserve:**
- Reversibility assessment heuristic (two-way door / one-way door)
- ≥2 options requirement before deciding
- Decision criteria: correctness, simplicity, performance, maintainability, familiarity, reversibility
- ADR format and location (`.context/decisions/ADR-NNN-title.md`)
- Design principles (boring technology, deletability, defer decisions, match scale, fail loudly)
- Pre-decision checks (attack surface, 10x scale, observable failures)
- "Do not contradict existing ADRs silently" rule

**What to drop:**
- Startup behavior check (context-review skill invocation) — this is a separate `_skills/context-review` skill the user can invoke directly
- "Route to: Researcher if blocked" — user decides next action
- "Route to: Manager" on completion
- "Coder guidance" section in completion format — becomes part of the ADR itself

**Pattern focus:** How to make a system design decision and document it as an ADR. The pattern
is for one decision at a time, not for designing entire systems in a session.

**Degree of freedom:** Medium (structured ADR output, but analysis is open-ended)

---

### Coder → `implementing-features`

**What to preserve:**
- Read-first discipline (spec → existing code → `.context/decisions/` before writing anything)
- Minimal change principle (smallest change that satisfies the spec, no YAGNI)
- One clarifying question rule (ask one focused question if acceptance criteria ambiguous)
- Self-review before declaring done (verify build/lint passes, read own diff)
- Constraint: no speculative refactors, no unasked features

**What to drop:**
- "Hand off to Tester" — user decides when to invoke writing-tests pattern
- "Ready for: Tester" in completion format — becomes "signal that code is ready for testing"
- Agent routing language throughout

**Pattern focus:** How to implement a specification with minimum scope creep and maximum
fidelity to existing patterns. Keeps a tight read-before-write discipline.

**Degree of freedom:** Low (spec-driven, minimal discretion)

---

### Tester → `writing-tests`

**What to preserve:**
- Think-first rule (read spec + implementation, identify failure modes before writing any test)
- Test categories requirement: happy path, edge cases (null/empty/bounds), error cases, state
  transitions, security cases for auth/external input code
- "Test the contract, not internals" principle
- Coverage targets (new code ≥90%, bug fix must reproduce + validate, refactors must not decrease)
- `--no-watch` / `--watchAll=false` flag reminder
- Bug report format (desc/file/input/expected/actual/severity)
- Test report format (pass/fail count, coverage %, test count)

**What to drop:**
- "Route to: Coder" for untestable code — becomes "note the refactoring needed"
- "Route to: Manager" when tests pass — becomes end of pattern
- "Received from: Coder" framing — pattern is invoked independently

**Pattern focus:** How to write a complete test suite for a piece of code — from analysis through
execution. The "think first" and "categories" discipline is the key value.

**Degree of freedom:** Medium (structured categories required, but test design is contextual)

---

## Shared Conventions → `_shared/conventions.md`

These sections from `agents/_shared/conventions.md` are universal and must transfer intact to
`.context/patterns/_shared/conventions.md`:

| Section | Action |
|---|---|
| Simplicity First | Transfer verbatim — core principle |
| Identity & Tone | Transfer verbatim |
| Response Format | Transfer verbatim (headers, bullets, tables, code blocks, length guidelines) |
| XML Tags | Transfer verbatim — `<task>`, `<context>`, `<constraints>`, `<input>`, `<output>`, `<example>`, `<thinking>`, `<decision>` |
| Self-verify before completion | Transfer verbatim |
| Handling Ambiguity | Transfer verbatim (one question rule, state assumption format) |
| Tool Use Policy | Transfer verbatim |
| Context Window Management | Transfer verbatim |
| Stopping Conditions | Transfer verbatim — critical for autonomous use |
| Error Handling | Transfer verbatim |
| Writing Code | Transfer verbatim |
| Security | Transfer verbatim |
| Anti-Patterns | Transfer verbatim |
| Role Boundaries | **Drop** — not applicable without roles |
| Communication Between Agents | **Drop** — no agent-to-agent routing |

---

## Handoff Protocol → What Survives

The 218-line `handoff-protocol.md` contains value worth extracting. Not all of it survives.

### Survives → Embed in individual patterns

| Protocol element | Where it goes |
|---|---|
| Delegation XML template (`<task>`, `<context>`, `<output>`, `<criteria>`) | `coordinating-work/SKILL.md` |
| Completion signal structure (outputs, decisions, blockers, next step) | Each pattern's output section |
| "Inputs available" discipline (name exact files) | Each pattern's Pre-flight check |
| Constraints section in handoffs | Already in `_shared/conventions.md` XML tags |
| Manager→Planner example | Becomes an example in `coordinating-work` |
| Planner→Coder example | Becomes an example in `planning-tasks` |
| Coder→Tester example | Becomes an example in `implementing-features` |

### Dropped → No longer needed

| Protocol element | Why dropped |
|---|---|
| Routing reference table | User picks pattern directly — no routing |
| "Route to: [Agent]" tails | Replaced by: "next suggested pattern: …" (advisory only) |
| Blocked handoff format | Simplified: state blocker as normal output |
| "One task per handoff" rule | No handoffs — patterns are invoked per task already |
| Agent-to-agent state passing | Replaced by `.context/` files as the shared state store |

---

## Context Flow: Agent System vs. Agentless

### Current (agent-based):
```
User request
  → Manager (reads .context/project-overview.md)
    → Planner (reads .context/plans/)
      → Researcher (reads .context/research/)
        → Architect (reads .context/decisions/)
          → Coder (reads .context/decisions/ + code)
            → Tester (reads implementation)
              → Manager (synthesizes)
                → User
```
State flows: agent-to-agent via handoff messages + `.context/` files.

### After (agentless):
```
User reads .context/project-overview.md (once, before starting)
  → User picks pattern(s) directly
    → Pattern reads its own .context/ files at start
      → Pattern produces output
        → User writes output to .context/ (plans/, research/, decisions/)
          → User picks next pattern with enriched context
```
State flows: user manages context; `.context/` files are the integration point.

**Key change:** The Manager's routing and state-threading function transfers to the user + `.context/` files. No orchestration layer needed.

---

## What Stays in `agents/` (Legacy Archive)

All 6 agent files move to `agents/_archive/` in Phase 7. They remain available as:
- Historical reference for teams already using the agent system
- Fallback for workflows that genuinely need multi-agent orchestration
- Source of truth for the handoff format (useful for research)

`agents/_shared/conventions.md` — canonical version moves to `.context/patterns/_shared/conventions.md`.
Original kept in `agents/_shared/` marked as superseded by patterns version.
