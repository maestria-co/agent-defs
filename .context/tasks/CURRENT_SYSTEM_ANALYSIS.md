# Current System Analysis

> Phase 1 deliverable. Documents the full 6-agent system as it exists today,
> including shared infrastructure and existing Agent Skills.
>
> **Date:** 2026-03-15  
> **Status:** Complete

---

## System Overview

The current system is a **6-agent workflow** with a central routing agent (Manager) delegating
to 5 specialists. Agents coordinate via a structured handoff protocol and shared conventions.

```
User → Manager → [Planner, Researcher, Architect, Coder, Tester] → Manager → User
```

All agents run on **claude-sonnet-4.5**. The system is defined by:

| File | Purpose |
|---|---|
| `agents/manager.agent.md` | Entry point, routing, synthesis |
| `agents/planner.agent.md` | Task decomposition |
| `agents/researcher.agent.md` | Technical investigation |
| `agents/architect.agent.md` | Design decisions + ADRs |
| `agents/coder.agent.md` | Implementation |
| `agents/tester.agent.md` | Testing + QA |
| `agents/_shared/conventions.md` | 290 lines of shared rules |
| `agents/_shared/handoff-protocol.md` | Structured message protocol |

---

## Agent-by-Agent Documentation

### Manager

**Role:** Primary interface, routing orchestrator, synthesizer.  
**Tools:** `agent`, `codebase`, `fetch`, `search`  
**Scope:** Never writes code, tests, or architecture decisions.

**Core behaviors:**

1. **Turn protocol** — at start of every turn: read `.context/project-overview.md`, identify active
   task, decide which agents are needed.

2. **Agent selection table:**

   | Task type | Agent |
   |---|---|
   | Breaking down a complex goal | Planner |
   | Evaluating options / research | Researcher |
   | System design or tech decisions | Architect |
   | Writing or modifying code | Coder |
   | Writing or running tests | Tester |
   | Synthesizing results | Manager (stays) |
   | Simple tasks with clear specs | Route directly (skip Planner) |

3. **Delegation template** (XML structured):
   ```xml
   <task>[Specific scoped action]</task>
   <context>[Relevant decisions, file locations, constraints]</context>
   <output>[Expected artifact and where to write it]</output>
   <criteria>[How to know it's done]</criteria>
   ```

4. **Stopping conditions** — stops and surfaces a check-in for:
   - Irreversible actions not explicitly authorized
   - Task scope grew significantly
   - 3+ consecutive agent failures
   - Decision requires user input

5. **Check-in format:**
   ```
   ⏸ Check-in: [Task name]
   Done: [what's complete]
   Reason: [1–2 sentences]
   Options: 1) [A]  2) [B]
   Recommendation: Option [N] — [brief reason]
   ```

6. **Completion format** (Done/Built/Decisions/Watch structure).

---

### Planner

**Role:** Breaks ambiguous goals into concrete, ordered, executable task lists.  
**Tools:** `codebase`, `search`, `createFiles`, `editFiles`  
**Scope:** Does not implement or make architecture decisions.

**When to invoke:** 3+ distinct steps, multiple agents on same feature, unclear scope.  
**Skip when:** single well-defined task, user provided step-by-step breakdown.

**Workflow:**
1. Understand goal → restate + identify success criteria
2. Inventory existing code
3. Identify unknowns (route planning blockers to Researcher/Architect)
4. Write tasks (atomic, ordered, concrete, no vague verbs)
5. Save to `.context/plans/[feature-name].md`

**Task format:**
```markdown
### Task N: [Verb + Noun] (S/M/L)
**Assigned to:** [Agent]
**Depends on:** Task N-1 | none
**Input:** [files, prior outputs]
**Output:** [named file or artifact]
**Acceptance criteria:**
- [ ] [Testable condition]
**Scope out:** [what's explicitly excluded]
```

**Completion format:** Plan name, file saved, task count (S/M/L split), unknowns routed, parallel
opportunities, "Ready for: Manager".

---

### Researcher

**Role:** Fills knowledge gaps so other agents can make informed decisions.  
**Tools:** `fetch`, `search`, `codebase`, `createFiles`  
**Scope:** Does not write production code or make final architecture decisions.

**When to invoke:** unknown blocks planning/implementation, library evaluation needed, multiple
valid options need comparison, security/compliance implications.  
**Skip when:** obvious answers, implementation details, business/product decisions.

**Workflow:**
1. Scope the question precisely (set a "good enough" bar)
2. Investigate: viable options, project criteria, evidence (commits, stats, CVEs, license, docs)
3. Analyze honestly (state genuine downsides, uncertainty, confidence levels)
4. Recommend explicitly (name option, 2–3 reasons, acknowledge main tradeoff)
5. Save to `.context/research/[topic-slug].md`

**Report structure:**
```markdown
# Research: [Topic]
**Requested by:** [Agent] | **Date:** YYYY-MM-DD | **Status:** Complete

## Recommendation
> **[Option]** — [one sentence why]

## Options Evaluated
| Criterion | Option A | Option B | Option C |

## Key Findings
## Sources
```

**Completion format:** Topic, recommendation, main tradeoff, full report path, follow-up unknowns,
"Route to: Manager (or Architect if design decision follows)".

---

### Architect

**Role:** Makes system design and technology decisions; documents as ADRs.  
**Tools:** `codebase`, `search`, `fetch`, `createFiles`, `editFiles`  
**Scope:** Defines the blueprint; Coder implements from it.

**Special startup behavior:** On every invocation, checks `.context/cache/context_update.md`.
If absent or older than 5 days, runs the `context-review` skill first to synchronize
`.context/` with the codebase.

**When to invoke:** new technology/service, new system component design, non-trivial refactor,
resolving competing technical approaches, design questions from Planner/Coder.

**Workflow:**
1. Understand problem → state constraints, check existing ADRs
2. Assess reversibility (two-way door = move fast; one-way door = slow down)
3. Evaluate ≥2 options against: correctness, simplicity, performance, maintainability, familiarity, reversibility
4. Decide and document → write ADR to `.context/decisions/ADR-NNN-title.md`
5. Produce implementation guidance (API contracts, schemas, ASCII diagrams, patterns to follow/avoid)

**Design principles:**
- Prefer boring technology
- Optimize for deletability
- Defer decisions until needed
- Match the scale (10x current load, not 1000x imagined)
- Fail loudly

**Decision format:**
```
Decision: [What was decided — one sentence]
Rationale: [Why — 2–4 sentences]
Tradeoffs accepted:
- [What we gave up]
Full ADR: .context/decisions/ADR-NNN-title.md
```

---

### Coder

**Role:** Implements features and fixes from clear specifications.  
**Tools:** `editFiles`, `runCommands`, `codebase`, `search`, `usages`, `fetch`  
**Scope:** Implements only; routes architecture decisions to Architect.

**When to invoke:** clear spec with acceptance criteria, diagnosed bug with understood fix, clear
refactor goal.  
**Skip when:** unclear specs, architecture decisions, writing tests.

**Workflow:**
1. Read first (spec → existing code → `.context/decisions/`)
2. Clarify if needed (one question max)
3. Implement minimally (smallest change, no YAGNI, no speculative refactors)
4. Verify (build, lint, self-review diff)
5. Hand off to Tester

**Context needs:** `.context/decisions/`, existing code (naming/error patterns), manifest files.

**Completion format:** Task name, files changed with descriptions, key decisions, "Ready for: Tester".

---

### Tester

**Role:** Writes tests, runs them, reports coverage and bugs.  
**Tools:** `editFiles`, `runCommands`, `codebase`, `search`, `usages`

**When to invoke:** Coder signals done, bug needs reproduction + coverage, code needs coverage
before refactor.

**Workflow:**
1. Think first — read spec + implementation, identify all failure modes
2. Write across categories: happy path, edge cases (null/empty/bounds), error cases, state
   transitions, security cases (for auth/external input code)
3. Test the contract, not internals
4. Run with `--no-watch` / `--watchAll=false`
5. Report: all passing → Manager; bug found → file report + route to Coder

**Coverage targets:**
- New code: ≥90%
- Bug fixes: must reproduce bug + validate fix
- Refactors: coverage must not decrease

**Output formats:**
```
Bug: [desc] | File: [path] | Input: [repro] | Expected: [...] | Actual: [...] | Severity: [level]
Result: ✅ All passing | ⚠️ N failing | ❌ Blocked | Coverage: [X%] | Tests: N | Bugs: N
```

---

## Shared Infrastructure

### `agents/_shared/conventions.md` (290 lines)

The master rulebook inherited by all agents. Key sections:

| Section | Lines | Content |
|---|---|---|
| Simplicity First | ~15 | Core Anthropic principle — start simple, resist over-engineering |
| Identity & Tone | ~10 | Direct, concise, honest, match register |
| Response Format | ~60 | Headers/bullets/tables/code blocks, length guidelines |
| XML Tags | ~25 | Semantic tag conventions: `<task>`, `<context>`, `<constraints>`, `<input>`, `<output>`, `<example>`, `<thinking>`, `<decision>` |
| Self-verify | ~10 | 4-step check before signaling completion |
| Handling Ambiguity | ~15 | Infer intent → one question → state assumption |
| Tool Use Policy | ~10 | Purposeful, batched, show work, prefer reading |
| Context Window Mgmt | ~35 | Read only what you need, write state when context runs low, git as checkpoint |
| Stopping Conditions | ~30 | When to check in with human (6 conditions), soft threshold (3–5 actions) |
| Role Boundaries | ~10 | Stay in lane, signal boundaries, small adjacent tasks ok |
| Error Handling | ~15 | State/tried/root-cause/next-step format |
| Writing Code | ~20 | Match style, self-documenting, minimal change, no secrets |
| Security | ~10 | No secrets, no PII logging, sanitize inputs |
| Communication Between Agents | ~5 | Use handoff-protocol.md |
| Anti-Patterns | ~15 | 12 explicit never-do-these |

### `agents/_shared/handoff-protocol.md` (218 lines)

Defines the structured message format for agent-to-agent work passing. Sections:

- **Handoff message structure** (5 required sections: Task, Context, Inputs, Expected Output,
  Constraints)
- **4 examples:** Manager→Planner, Planner→Researcher, Planner→Coder, Coder→Tester
- **Completion signal format** (Task, Outputs, Decisions, Blockers, Next step)
- **Blocked/incomplete handoff format**
- **Routing reference table**
- **5 rules** (never skip format, always include `.context/` files, be specific about outputs,
  state constraints, one task per handoff)

---

## Existing `_skills/` Directory

The repo already has two proper Anthropic-format Agent Skills:

### `_skills/context-review/SKILL.md`
- **Purpose:** Synchronizes `.context/` documentation with actual codebase state
- **Trigger:** Architect invokes at startup if cache is >5 days old
- **Format:** YAML frontmatter, Pre-flight checks (2), Execution Steps (4), Cache Write, Constraints
- **Writes to:** `.context/overview.md`, `.context/domains/`, `.context/architecture/`,
  `.context/standards/`, `.context/cache/context_update.md`
- **Status:** Active (referenced by architect.agent.md line 22)

### `_skills/evaluate-skill/SKILL.md`
- **Purpose:** Evaluates a SKILL.md file against AgentSkills specification
- **Trigger:** When user asks to review/audit/validate a SKILL.md file
- **Format:** YAML frontmatter with metadata + compatibility fields, Pre-flight checks (2),
  5-category evaluation rubric, 3-section output format
- **Key detail:** Has 5 evaluation categories (Structural, Description Quality, Body Content,
  Context Management, Security)
- **Status:** Active utility skill

**Note for Phase 2:** These two skills define the canonical SKILL.md format already in use in
this repo. New patterns in `.context/patterns/` must follow the same structural conventions
(YAML frontmatter, Pre-flight checks, numbered imperative steps, Constraints section).

---

## Pre-existing Bug: CLAUDE.md Broken References

`CLAUDE.md` references agents by incorrect paths. **Fixed in this phase** (see Phase 1 task p1-t8).

| Was | Corrected to |
|---|---|
| `agents/manager.md` | `agents/manager.agent.md` |
| `agents/architect.md` | `agents/architect.agent.md` |
| `agents/planner.md` | `agents/planner.agent.md` |
| `agents/researcher.md` | `agents/researcher.agent.md` |
| `agents/coder.md` | `agents/coder.agent.md` |
| `agents/tester.md` | `agents/tester.agent.md` |
| `agents/README.md` | `agents/_shared/README.md` |

---

## Summary

| Dimension | Current State |
|---|---|
| Agent files | 6 `.agent.md` files |
| Shared docs | 2 files, ~508 lines total |
| Existing SKILL.md skills | 2 (`context-review`, `evaluate-skill`) |
| Routing overhead | Manager reads every request, selects agent, structures handoff |
| State management | `.context/` files + agent-to-agent handoff messages |
| Handoff protocol | 218-line structured format with 4 example pairs |
| Context reading | Architect does it at startup; others do it per-task |
| XML conventions | Defined in conventions.md, used in handoffs and delegation |
| Model | All agents: claude-sonnet-4.5 |
