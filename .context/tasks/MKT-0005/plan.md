# MKT-0005: Cache-Friendly Structure

## Branch

`feature/MKT-0005-cache-friendly-structure`

## Objective

Structure agent and skill files with static content at the top and dynamic content at the bottom to optimize prompt prefix caching. This enables AI providers (Anthropic, OpenAI, etc.) to maintain cache hits even when dynamic context changes, improving performance and reducing latency for repeated agent invocations.

## Acceptance Criteria

- [x] Given `agents/_shared/conventions.md`, when I read the new "Cache-Friendly File Structure" section, then it describes a pattern: Static Top (70% - role, capabilities, workflows, examples), Dynamic Bottom (30% - current task, session state, overrides)
- [x] Given the pattern explanation, when I understand the rationale, then it clearly states why static content at top maximizes KV cache hits
- [x] Given an example agent structure, when I read it, then it demonstrates the pattern with clear sections showing Static vs. Dynamic content placement
- [x] Given the `agents/_shared/agent-template.md`, when I read it, then it shows the cache-friendly structure as the recommended layout
- [x] Given cache-friendly guidance, when I read the "When to Apply This Pattern" section, then it clarifies: Apply to agents/skills/conventions; Don't apply to task plans, session logs, one-off prompts
- [x] Given the "Measuring Cache Effectiveness" section, when I read it, then it provides concrete steps to validate the pattern works (metrics to check, validation procedure, warning signs)

## Decisions

- **Decision:** Added "Measuring Cache Effectiveness" subsection to validate the pattern works
  **Rationale:** User question "how do we prove this had benefits?" revealed gap in acceptance criteria. Added concrete validation steps (run 10 times, check metrics, compare baseline) so teams can verify cache hit improvements.

## Key Files

- `agents/_shared/conventions.md` — Shared conventions for all agents; will contain the new cache-friendly structure guidance
- `agents/_shared/agent-template.md` — Template file for creating new agents (if exists); will demonstrate the pattern

## Task Breakdown

1. [x] Review existing agent and skill files to understand current structure patterns
2. [x] Add "Cache-Friendly File Structure" section to `agents/_shared/conventions.md` with rationale and examples
3. [x] Create `agents/_shared/agent-template.md` to demonstrate the cache-friendly layout
4. [x] Add "When to Apply This Pattern" guidance to clarify scope
5. [x] Add "Measuring Cache Effectiveness" subsection with validation steps
6. [ ] Verify all acceptance criteria are met with concrete evidence ← CURRENT

## Progress Log

- **2026-07-10 (16:00):** Added "Measuring Cache Effectiveness" subsection with metrics, validation steps, and warning signs. User question about proof prompted this enhancement.
- **2026-07-10 (15:30):** Created agent-template.md demonstrating cache-friendly structure. Added Cache-Friendly File Structure section to conventions.md.
- **2026-07-10 (15:00):** Completed structure survey and caching research. Agents are already 80-95% static. Manager is most dynamic (15-20%). Research confirms static-at-top is required for prefix caching to work.
- **2026-07-10:** Task MKT-0005 created from Trello card. Branch and plan.md initialized.

## Blockers

*No blockers currently identified.*
