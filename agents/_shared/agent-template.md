---
<!-- Replace all placeholder values below with real content for your agent. -->
name: [AgentName]
description: >
  [One-sentence role description.]

  Examples:
  - "[Example invocation phrase]"
  - "[Example invocation phrase]"

model: claude-sonnet-4.5
user-invocable: false
tools: ["read", "edit", "execute", "search"]
---

<!-- ============================================================
  AGENT TEMPLATE — Cache-Friendly Structure
  ============================================================
  This file is a starting point for creating a new agent.

  STRUCTURE RULE — static top, dynamic bottom:
    Prompt caches (Anthropic, OpenAI) match prefixes from byte 0.
    Any token that changes before the cache breakpoint invalidates
    the entire cache entry. Keep everything that is identical across
    invocations at the top; everything that changes per-call at the
    bottom. See agents/_shared/conventions.md § Cache-Friendly File
    Structure for full rationale and diagrams.

  HOW TO USE THIS TEMPLATE:
    1. Replace every [placeholder in brackets] with real content.
    2. Remove <!-- instructional comments --> when done.
    3. Delete sections that don't apply to your agent.
    4. Run `python scripts/validate.py` before committing.
    5. Add the new agent to the roster in agents/_shared/README.md.
  ============================================================ -->

<!-- ============================================================
  # STATIC ZONE (CACHE-FRIENDLY)
  Content below must be IDENTICAL across every invocation.
  Do not reference task IDs, session state, or per-call data here.
  ============================================================ -->

# [AgentName] Agent

[One-sentence identity statement — what this agent does and its core constraint.]

Follow `agents/_shared/conventions.md` for tone, format, and behavioral norms.

---

## Delegation Protocol

When @manager invokes this agent, it provides:

- [Input 1 — e.g., task specification with acceptance criteria]
- [Input 2 — e.g., relevant context files or domain knowledge]
- [Input 3 — e.g., prior decisions or constraints]

## When to Invoke

- [Condition that warrants invoking this agent]
- [Condition that warrants invoking this agent]

**Do not invoke for:** [excluded cases — what this agent explicitly does not handle].

---

## Process

1. **[Step name]**: [What to do and why.]
2. **[Step name]**: [What to do and why.]
3. **[Step name]**: [What to do and why.]
4. **[Step name]**: [What to do and why.]

---

## Skills to Apply

<!-- List skill files this agent relies on. Format: skill-name — what it provides. -->

- **[skill-name]** — [what it provides]
- **[skill-name]** — [what it provides]

---

## Context Needs

<!-- List files or directories this agent must read before starting work. -->

- `[path]` — [what to read and why]
- `[path]` — [what to read and why]

---

## Output Format

<!-- Define the exact format of this agent's completion report. -->

```
[Report header]: [task name]

[Section]:
- [item]

[Section]:
- [item]

Route to: [NextAgent]
```

---

## Escalation

- **[Condition]** → [who to route to and what to say]
- **[Condition]** → [who to route to and what to say]

---

## Behavior Tiers

### Hardcoded (Non-Negotiable)

- [Rule that is always on, no exceptions.]
- [Rule that is always on, no exceptions.]

### Default (On Unless Explicitly Disabled)

- [Rule that is on by default but can be turned off by caller.]
- [Rule that is on by default but can be turned off by caller.]

### Discretionary (Off Unless Explicitly Requested)

- [Behavior this agent can perform but only when asked.]

---

## Anti-Rationalization

| Rationalization | Reality | Correct Action |
|----------------|---------|----------------|
| "[Common excuse]" | [Why it's wrong] | [What to do instead] |
| "[Common excuse]" | [Why it's wrong] | [What to do instead] |

## Scope Guard

| Temptation | Why It's a Phantom Problem | Do Instead |
|-----------|---------------------------|------------|
| "[Out-of-scope action]" | [Why this is unnecessary] | [Correct action] |
| "[Out-of-scope action]" | [Why this is unnecessary] | [Correct action] |

---

## Constraints

<!-- Hard limits. Every agent should have at least a few. -->

- [Constraint — what this agent must never do.]
- [Constraint — what this agent must never do.]
- [Constraint — what this agent must never do.]

<!-- ============================================================
  CACHE BREAKPOINT
  Place `cache_control: {type: "ephemeral"}` on the LAST static
  block above when assembling the prompt programmatically. Do NOT
  place it on any block below this line — dynamic content changes
  every request, so caching it is a no-op and wastes write tokens.
  ============================================================ -->

<!-- ============================================================
  # DYNAMIC ZONE (RUNTIME INJECTION)
  Sections below are populated at invocation time by @manager or
  the calling orchestrator. They change on every call and must
  never appear before the cache breakpoint.
  ============================================================ -->

## Current Task

<!-- Injected at invocation. Example contents:
  **Task:** [Task ID] — [Task title]
  **Goal:** [What must be accomplished]
  **Acceptance criteria:**
  - [ ] [Criterion 1]
  - [ ] [Criterion 2]
  **Constraints:** [Any per-task overrides or restrictions]
-->

_Populated by @manager at invocation._

## Session Context

<!-- Injected when prior session state is relevant. Example contents:
  **Prior work:** [Summary of what was done in previous turns]
  **Decisions made:** [Key choices already locked in]
  **Blockers resolved:** [Issues that were raised and answered]
-->

_Populated when resuming a prior session or carrying forward context._

## Runtime Overrides

<!-- Injected only when the caller needs to change default behavior.
  Example: disable self-review, change output verbosity, etc.
  If absent, all Default behavior tiers apply unchanged.
-->

_Populated only when caller explicitly overrides defaults._

---

<!-- ============================================================
  USAGE NOTES
  - Cache-friendly structure guidance: agents/_shared/conventions.md
    § "Cache-Friendly File Structure"
  - Agent registration process: agents/_shared/README.md
    § "Adding New Agents"
  ============================================================ -->
