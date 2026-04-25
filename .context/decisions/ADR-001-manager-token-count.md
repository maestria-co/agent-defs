# ADR-001: Manager Agent Token Count Tradeoff

**Date:** 2026-04-21
**Status:** Accepted
**Decided by:** mje0007 task review
**Supersedes:** —

## Context

The Manager agent (`agents/manager.agent.md`) sits at ~5,100 tokens — well above the GitHub Copilot red threshold (~1,500 tokens) and 3.4× over the general recommendation for orchestrator agents. Efforts to reduce it during mje0007 brought it down from ~6,000 tokens but could not reach the threshold without removing behavioral value.

## Decision

Accept the Manager's ~5,100-token size as a known, intentional tradeoff. Do not attempt further reduction by cutting the Anti-Rationalization or Behavior Tiers tables.

## Rationale

The two bulky sections — Anti-Rationalization table and Behavior Tiers — exist specifically because the orchestrator role is the highest-leverage agent in the system. Inconsistent manager behavior cascades to all sub-agents. The cost of a confused manager far outweighs the token overhead.

Trimming these sections in pursuit of the threshold would reduce behavioral predictability, which is the opposite of what the manager needs.

## Alternatives Considered

| Option | Why rejected |
|---|---|
| Remove Anti-Rationalization table | Causes manager to rationalize scope creep and premature completion — high behavioral risk |
| Compress Behavior Tiers to prose | Loses precision; tiers exist because gradations matter in routing decisions |
| Split into two agents (orchestrator + policy) | Adds complexity and communication overhead for minimal gain |

## Consequences

**Positive:**
- Manager behavior is consistent and well-defined across all invocations
- Anti-rationalization and behavior boundaries are explicit, not implicit

**Negative / tradeoffs:**
- Token count remains above the Copilot red threshold
- Future reviewers may flag the size without knowing this decision exists → this ADR prevents relitigating it

## Related

- `agents/manager.agent.md`
- `.context/retrospectives/2026-04-21-mje0007-safe-pattern-library.md`
