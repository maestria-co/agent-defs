---
name: coordinating-work
description: >
  Orchestrates multiple patterns for a complex task that spans several steps or
  pattern invocations. Use when: a task requires 3+ distinct steps across different
  pattern types, the output of one pattern is the input to another, or you need to
  track progress and check in with the user at defined points. Do not use when: the
  task is a single pattern invocation, or two independent patterns that do not need
  to be sequenced.
degree_of_freedom: low
---

# Skill: Coordinating Work

## Purpose

Compose multiple patterns into a coherent workflow for tasks too complex for a single
pattern. Use sparingly — most tasks involve 1–2 patterns applied directly. Adding
coordination overhead to a simple task makes it slower, not better.

This pattern's primary value is: (1) the selection guide for picking the right pattern,
(2) the delegation template for structured task handoffs, and (3) the stopping conditions
for knowing when to pause and check in with the user.

---

## Pre-flight Checks

**Check 1 — Is coordination actually needed?**

Count the number of distinct pattern types this task will require.

- 1 pattern → use that pattern directly. Do not invoke this one.
- 2 patterns with a clear sequence → use them in sequence directly. No coordination needed.
- 3+ patterns, interdependent outputs, or complex branching → proceed with coordination.

**Check 2 — Read project context**

Read `.context/project-overview.md`. Identify the active task and any in-flight work.

---

## Execution Steps

### Step 1 — Understand the Full Scope

Restate what the task requires from start to finish. Ask one question if a critical piece
is missing. Do not proceed with an ambiguous scope — wrong assumptions waste all subsequent
work.

### Step 2 — Select Patterns

Use this selection guide to identify which patterns apply:

| If the task involves... | Use pattern |
|---|---|
| Breaking a complex goal into tasks | `planning-tasks` |
| Evaluating options / filling a knowledge gap | `researching-options` |
| Making a system design or tech decision | `designing-systems` |
| Writing or modifying code | `implementing-features` |
| Writing or running tests | `writing-tests` |
| Synchronizing `.context/` with the codebase | `_skills/context-review` |

For simple tasks with clear specs, skip `planning-tasks` and go directly to the relevant pattern.

### Step 3 — Sequence the Work

Order the patterns. For each step, produce a delegation block:

```
<task>[Specific scoped action for this step]</task>
<context>[Relevant decisions, file locations, constraints]</context>
<output>[Expected artifact and where to write it]</output>
<criteria>[How to know this step is done]</criteria>
```

Identify which steps can run in parallel (no output dependency between them) and note them.

### Step 4 — Check Stopping Conditions

Before proceeding with each major step, check whether a human check-in is needed.

**Stop and check in with the user when:**
1. An irreversible action (file deletes, schema changes, data migrations) is not explicitly authorized
2. Task scope has grown significantly beyond what was originally asked
3. A step conflicts with an existing ADR without a clear mandate to supersede it
4. 3+ consecutive failures without progress
5. A decision requires information only the user can provide
6. Unintended side effects discovered mid-task

**Soft threshold:** After every 3–5 significant actions, produce a brief status update even
if no blocker exists. This lets the user redirect early.

**Check-in format:**
```
⏸ Check-in: [Task name]

Completed:
- [What's done]

Reason for stopping:
[1–2 sentences]

Options:
1. [Option A — what happens if we proceed this way]
2. [Option B — alternative]

Recommendation: Option [N] because [brief reason]
```

### Step 5 — Synthesize Results

After all steps complete, verify:
- All artifacts exist and are non-empty
- Acceptance criteria are met
- No step's output contradicts another

Produce a completion summary.

---

## Output Format

```
Done: [Task name]

[2–3 sentence summary of what was built or decided]

Built:
- [artifact 1 and location]
- [artifact 2 and location]

Decisions made:
- [key choice and why]

Watch:
- [anything to monitor going forward]
```

---

## Examples

<examples>

<example>
<scenario>Full feature implementation: plan → research → implement → test</scenario>
<input>
<task>Add OAuth 2.0 authentication to the Express API. Support Google and GitHub.</task>
<context>
- App uses session-based auth (express-session)
- See .context/decisions/ADR-003-auth-strategy.md
- Must not break existing session auth
</context>
</input>
<output>
Step 1: planning-tasks
→ Produces: .context/plans/oauth-implementation.md (5 tasks, S/M/L breakdown)

Step 2: researching-options (Task 1 from plan — parallel safe with Step 3a)
<task>Research refresh token rotation approach for stateless Node.js API</task>
<context>ADR-003, stateless requirement, security-first</context>
<output>.context/research/oauth-refresh-tokens.md</output>
<criteria>≥2 approaches compared, explicit recommendation</criteria>

Step 3: implementing-features (Tasks 2–4 in sequence)
→ Produces: OAuthProvider model, migration, Google OAuth flow

Step 4: writing-tests
→ Produces: tests/models/OAuthProvider.test.js, tests/routes/auth/google.test.js

⏸ Check-in after Step 3: confirming Step 4 scope before writing tests
</output>
</example>

<example>
<scenario>Architecture decision followed by implementation</scenario>
<input>
<task>Add Redis caching to the user profile endpoint that's receiving 500 req/s.</task>
<context>
- Single Node.js instance today, scaling to 3 next quarter
- Team has no Redis experience
- 60-second cache TTL acceptable
</context>
</input>
<output>
Step 1: designing-systems
<task>Decide Redis vs. in-memory caching given multi-instance requirements</task>
<context>500 req/s, multi-instance next quarter, team unfamiliar with Redis</context>
<output>.context/decisions/ADR-007-caching-strategy.md</output>
<criteria>≥2 options evaluated, decision documented</criteria>

Step 2: implementing-features (after ADR written)
<task>Implement ioredis caching on GET /users/:id per ADR-007</task>
<context>ADR-007, existing middleware in src/middleware/</context>
<output>src/middleware/cache.js, updated src/routes/users.js</output>
<criteria>Cache hit served < 5ms, cache miss falls through to DB</criteria>

Step 3: writing-tests
→ Covers cache hit, cache miss, cache invalidation on write

Parallel opportunity: Steps 2 and 3 can be drafted concurrently
</output>
</example>

<example>
<scenario>Task that does NOT need coordination</scenario>
<input>
<task>Fix the case-sensitive email bug in the login service.</task>
</input>
<output>
This task does not need coordination. It's a single, well-defined bug fix with a
known root cause.

Use implementing-features directly:
- Fix: add .toLowerCase() normalization before DB lookup in src/services/auth.js
- Then use writing-tests to add a regression test
</output>
</example>

</examples>

---

## Constraints

- Do not use this pattern for single-pattern tasks — the overhead is not justified
- Do not write code directly — use `implementing-features` for all implementation
- Do not make architecture decisions directly — use `designing-systems`
- Always check stopping conditions before irreversible actions
- Do not run 10+ actions without a human check-in
- Do not declare complete without verifying that all artifacts exist and acceptance criteria are met
