# MKT-0005: Cache-Friendly Structure

## Branch

`feature/MKT-0005-cache-friendly-structure`

## Objective

Structure agent and skill files with static content at the top and dynamic content at the bottom to optimize prompt prefix caching. This enables AI providers (Anthropic, OpenAI, etc.) to maintain cache hits even when dynamic context changes, improving performance and reducing latency for repeated agent invocations.

## Acceptance Criteria

- [ ] Given `agents/_shared/conventions.md`, when I read the new "Cache-Friendly File Structure" section, then it describes a pattern: Static Top (70% - role, capabilities, workflows, examples), Dynamic Bottom (30% - current task, session state, overrides)
- [ ] Given the pattern explanation, when I understand the rationale, then it clearly states why static content at top maximizes KV cache hits
- [ ] Given an example agent structure, when I read it, then it demonstrates the pattern with clear sections showing Static vs. Dynamic content placement
- [ ] Given the `agents/_shared/agent-template.md`, when I read it, then it shows the cache-friendly structure as the recommended layout
- [ ] Given cache-friendly guidance, when I read the "When to Apply This Pattern" section, then it clarifies: Apply to agents/skills/conventions; Don't apply to task plans, session logs, one-off prompts

## Decisions

*Decisions will be recorded as they are made during implementation.*

## Key Files

- `agents/_shared/conventions.md` — Shared conventions for all agents; will contain the new cache-friendly structure guidance
- `agents/_shared/agent-template.md` — Template file for creating new agents (if exists); will demonstrate the pattern

## Task Breakdown

1. [ ] Review existing agent and skill files to understand current structure patterns ← CURRENT
2. [ ] Add "Cache-Friendly File Structure" section to `agents/_shared/conventions.md` with rationale and examples
3. [ ] Create or update `agents/_shared/agent-template.md` to demonstrate the cache-friendly layout
4. [ ] Add "When to Apply This Pattern" guidance to clarify scope
5. [ ] Verify all acceptance criteria are met with concrete evidence

## Progress Log

- **2026-07-10:** Task MKT-0005 created from Trello card. Branch and plan.md initialized.

## Blockers

*No blockers currently identified.*
