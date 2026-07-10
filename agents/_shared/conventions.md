# Shared Agent Conventions

All agents inherit these rules. When a convention here conflicts with an agent-specific rule, the **agent-specific rule wins**.

Skill-level conventions: `skills/_shared/conventions.md`

---

## Simplicity First

The most important principle. Before adding complexity: _does this demonstrably improve the outcome?_

- Start with the simplest approach. Add steps, agents, and abstractions only when simpler options fail.
- Prefer fewer moving parts. A 3-step solution beats a 7-step solution with the same outcome.
- One agent, one task. A single well-prompted agent beats three poorly-coordinated ones.
- Complexity compounds errors — each extra step multiplies failure chance. Keep chains short.

---

## Identity & Tone

- **Be direct.** Lead with the answer. No preamble ("Great question!", "Certainly!", "As an AI...").
- **Be concise.** Use the minimum words needed. Expand only when complexity requires it.
- **Be honest.** If you don't know, say so. If a request is outside your role, route to the right agent.
- **Match the user's register.** Technical language for technical users; plain English otherwise.

### Response length

| Request type                    | Target                              |
| ------------------------------- | ----------------------------------- |
| Simple question / clarification | 1–3 sentences                       |
| Task with 1–3 steps             | Short paragraphs, no headers        |
| Complex plan or design          | Headers, as long as needed          |
| Code output                     | Just the code + minimal explanation |

### Structured content — use XML tags

Wrap handoffs, reports, and multi-part outputs in semantic XML tags:

```xml
<task>Implement JWT validation middleware</task>
<context>Express.js app; see ADR-003 for auth strategy</context>
<constraints>Return 401 (not 403) for missing tokens</constraints>
<output>src/middleware/auth.js</output>
```

Standard tags: `<task>`, `<context>`, `<constraints>`, `<input>`, `<output>`, `<example>`, `<decision>`.

### Always include in responses

- What you did (or are doing)
- Why (when not obvious)
- What comes next (next step or handoff)

### Never include

Apologies for limitations · lengthy disclaimers · restating the user's question · filler ("Certainly!", "Of course!", "Great!")

---

## Handling Ambiguity

1. Attempt to infer intent from context before asking.
2. Ask **one question** to resolve the most important ambiguity.
3. If proceeding without asking: state your assumption explicitly.

```
Before I proceed, one question: [single focused question]?
(Say "proceed" and I'll assume [my assumption].)
```

---

## Tool Use

- Use tools purposefully — don't read files you don't need; don't search broadly when specific works.
- **Batch tool calls.** Make multiple independent calls in one turn rather than sequentially.
- Prefer reading over writing. Read and understand before making changes.
- Never delete working code unless explicitly instructed.

---

## Creating a New Agent

After creating any new agent file:

1. Run `python scripts/validate.py` immediately — catches missing frontmatter keys and broken skill references before they silently degrade behavior.
2. Fix all reported errors before proceeding to the next task.

Do not defer validation to the end of the phase; issues compound when caught late.

---

## Self-Verify Before Signaling Completion

Before declaring done and routing to the next agent:

1. Re-read acceptance criteria — check each one explicitly.
2. Check for regressions — did the change break anything adjacent?
3. Spot-check your output as if reviewing someone else's work.
4. Confirm artifacts exist — verify files are non-empty and at the expected paths.

Do not signal completion based on belief. Verify it.

---

## Context Window

- Read only what you need. Targeted searches over full-file reads for large files.
- When context is low: finish the current task first, then write state to `.context/` before stopping.
- Use git as a checkpoint — commit completed work before a context boundary.
- When resuming after a context reset: read `.context/overview.md`, run `git log --oneline -10`, check in-progress state files.

---

## Context Management

- **Reading:** At the start of any non-trivial task, check `.context/overview.md`, `.context/decisions/`, and relevant retrospective entries.
- **Writing:** Write to `.context/` when you make a significant decision (→ `decisions/`), complete a task with learnings (→ `retrospectives/`), or discover undocumented project facts (→ `overview.md`).
- **Task-scoped writing:** When a TASK-ID or STORY-ID was provided (i.e., you are working in the context of a named task), write **all** output artifacts under `.context/tasks/{TASK-ID}/` — not the generic folders. This co-locates every finding, analysis, and decision so the team (and future agents) can reconstruct what happened without hunting across the context tree.

  Use descriptive filenames within the task folder:
  | Agent | Filename |
  |-------|----------|
  | Researcher | `research-[topic].md` |
  | Code-Researcher | `code-analysis-[topic].md` |
  | Architect | `architecture-[topic].md` |
  | Planner | `plan.md` |
  | Product-Manager | `spec.md`, `story.md` |

  Still write permanent decisions (ADRs) to `.context/decisions/` — but also drop a reference file in the task folder pointing there.

---

## Stopping Conditions

Stop and check in with the user when:

- **Irreversible action** — file deletes, schema changes, auth changes not explicitly authorized
- **Scope has grown** — task is 3× larger than expected
- **Conflict with ADR** — proceeding would contradict an existing decision
- **3+ consecutive failures** — same approach tried 3 times with no progress
- **Missing critical info** — a business/product decision only the user can make
- **Side effects discovered** — task will break something outside scope

**Soft threshold:** After every 3–5 significant actions, produce a brief status update.

```
⏸ Check-in: [Task name]

Completed: [what's done]
Reason for stopping: [1–2 sentences]
Options:
1. [Option A]
2. [Option B]
Recommendation: Option [N] because [reason]
```

---

## Role Boundaries

- Do not do another agent's job. Invoke the correct role explicitly.
- Signal when you've hit your boundary: _"This requires [Architect/Planner/etc.] — routing there."_
- Small adjacent tasks under 2 minutes that are clearly part of your output are fine. Anything structural is not.

---

## Error Handling

```
Issue: [what went wrong]
Tried: [what was attempted]
Root cause: [your diagnosis]
Next step: [proposed action or who should handle it]
```

---

## Writing Code

Match existing style · write self-documenting code · comment only what isn't obvious · make the smallest change · no magic numbers · no dead code · validate inputs at boundaries · handle errors explicitly (never swallow exceptions).

---

## Security

Never commit secrets · never log PII or credentials · sanitize inputs crossing trust boundaries · flag security concerns even when outside current task scope.

---

## Agent Communication

Follow `_shared/handoff-protocol.md`. Always include: what you've done, what the next agent needs to do, relevant constraints, and where to write outputs.

---

## Cache-Friendly File Structure

Structure agent and skill files so **static content appears at the top** and **dynamic content appears at the bottom**. This is not a style preference — it is a technical requirement for prompt prefix caching to function.

### Why it matters

Cache systems (Anthropic, OpenAI) match prefixes starting from **byte 0**. The prefix hash covers every token from the beginning of the prompt to the cache breakpoint. If any token before the breakpoint changes — even one — the hash changes, and no prior cache entry matches. The result: a full re-computation on every request, even when 95% of the content below that change is identical.

**The rule:** static content at the top → stable prefix hash → cache hit on every subsequent call.  
**The failure mode:** dynamic content at the top → different prefix hash every request → cache miss on every call, paying full input cost each time.

### Static / Dynamic Content Split

Target a **70% static / 30% dynamic** split:

| Zone | Target | What Goes Here |
|------|--------|----------------|
| **Static Top** | ~70% | Role definition, capabilities, workflow steps, behavioral rules, few-shot examples, tool definitions, shared conventions |
| **Dynamic Bottom** | ~30% | Current task, user query, session state, runtime context, per-invocation overrides |

Content in the Static Top must be identical across every invocation of that agent or skill. Content in the Dynamic Bottom changes per request and must never appear before the cache breakpoint.

### Example Agent Structure

```
[YAML frontmatter]                         ← Static — metadata never changes per invocation
# Agent Name                               ← Static
Role / identity paragraph                  ← Static
When to invoke / delegation protocol       ← Static
Process / workflow steps                   ← Static
Skills to apply                            ← Static
Output format                              ← Static
Behavior tiers                             ← Static
Constraints / anti-patterns                ← Static  ← CACHE BREAKPOINT (last static block)
──────────────────────────────────────────────────────────────────────────
# Current Task              (injected)     ← Dynamic — different every call
Task ID, description, acceptance criteria  ← Dynamic
Session context / prior turns              ← Dynamic
Runtime overrides                          ← Dynamic
```

The cache breakpoint (`cache_control: {type: "ephemeral"}` on Anthropic) belongs on the **last static block** — not on any dynamic block. Placing it on dynamic content means the breakpoint hash changes on every request; the cache system never finds a prior matching entry and writes a new one every time.

### When to Apply This Pattern

| Apply to | Don't apply to |
|----------|----------------|
| ✅ Agent definition files (`*.agent.md`) | ❌ Task plans (`.context/tasks/*/plan.md`) |
| ✅ Skill files (`SKILL.md`) | ❌ Session logs and conversation history |
| ✅ Shared conventions (`_shared/*.md`) | ❌ One-off or scratch prompts |
| ✅ Any reusable system prompt | ❌ Per-request messages injected at runtime |

### Measuring Cache Effectiveness

After restructuring a file, verify that caching is actually working by inspecting the usage fields returned with every API response.

**Metrics to check**

| Provider | Field | Meaning |
|----------|-------|---------|
| Anthropic | `cache_read_input_tokens` | Tokens served from cache (you paid 10% of base price) |
| Anthropic | `cache_creation_input_tokens` | Tokens written to cache (you paid 125% of base price) |
| OpenAI | `cached_tokens` | Tokens served from cache (discounted rate) |
| OpenAI | `cache_write_tokens` | Tokens written to cache (no extra cost pre-GPT-5.6; 125% for GPT-5.6+) |

**Interpreting the numbers**

| Scenario | cache_read / cached_tokens | cache_creation / cache_write | What it means |
|----------|---------------------------|------------------------------|---------------|
| First call (cold) | 0 | > 0 | Expected — cache is being written for the first time |
| Subsequent calls (warm) | > 0 | 0 | ✅ Working — prefix matched, served from cache |
| Every call | 0 | 0 | ❌ Not caching — prompt is below minimum threshold or structure is wrong |
| Every call | 0 | > 0 | ❌ Cache writes never hit — breakpoint lands on dynamic content |

**Validation steps**

Run this procedure after restructuring any agent or skill file:

1. Identify an agent you want to validate. Confirm its static content meets the minimum token threshold (512–4,096 tokens depending on model; 1,024 for OpenAI).
2. Invoke the agent 10 times with **identical static content** and a **different task** each time (varying only the Dynamic Bottom).
3. Log `cache_read_input_tokens` (or `cached_tokens`) and `cache_creation_input_tokens` (or `cache_write_tokens`) from each response.
4. Verify that calls 2–10 all show `cache_read > 0` and `cache_creation = 0`. Call 1 is expected to show `cache_creation > 0`.
5. Calculate cost savings: `(cache_read_tokens × 0.10) vs (full_input_tokens × 1.0)` — a well-structured agent should show roughly 90% savings on static tokens for calls 2–10.
6. Compare against your pre-restructure baseline. Hit rate should increase; cost per invocation should decrease.

**Warning signs**

- **`cache_read` is always 0 across all calls** → dynamic content is inside the static zone; the prefix hash changes every invocation. Find and move it below the cache breakpoint.
- **Both metrics are 0 on every call** → prompt is below the minimum cacheable threshold for the model in use. Expand static content until it crosses the threshold.
- **`cache_creation > 0` on every call** → the cache breakpoint is placed on dynamic content. Move the breakpoint to the last static block instead.

### Claude Code (Claude CLI) Specifics

> Source: `.context/tasks/MKT-0005/claude-cli-caching-research.md`

The cache-friendly structure pattern applies **more directly** to Claude Code than to GitHub Copilot CLI because caching is transparent — users can see hit/miss counts, control invalidation, and structure CLAUDE.md to maximize savings.

**CLAUDE.md file scopes**

| Scope | Location | When Loaded |
|-------|----------|-------------|
| User global | `~/.claude/CLAUDE.md` | Every session |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Every session at launch |
| Local (gitignored) | `./CLAUDE.local.md` | Every session |
| Subdirectory | `./subdir/CLAUDE.md` | On-demand when reading files in that directory |

CLAUDE.md content is loaded into the **"Project context"** cache layer — cached across turns within a session, written once at session start. Mid-session edits have no effect until the next session restart.

**200-line guideline**

Anthropic recommends keeping CLAUDE.md **under 200 lines**. Beyond that, adherence degrades and the cached prefix grows large enough to hurt rather than help. Apply the Static/Dynamic split from [Example Agent Structure](#example-agent-structure) — put stable rules first; keep dynamic or session-specific content out of CLAUDE.md entirely.

**Viewing cache metrics in Claude Code**

```
/usage
```

The `/usage` command reports `cache_creation_input_tokens` and `cache_read_input_tokens` per turn — the same fields described in the [Measuring Cache Effectiveness](#measuring-cache-effectiveness) table above. Use them to confirm that CLAUDE.md restructuring produced real cache hits.

**Cache invalidation triggers**

| Action | Effect |
|--------|--------|
| Switch model mid-session | ❌ Cache bust |
| Change effort level | ❌ Cache bust |
| Connect / disconnect MCP server (non-deferred) | ❌ Cache bust |
| `/compact` command | ❌ Cache bust |
| Upgrade Claude Code version | ❌ Cache bust |
| Edit CLAUDE.md mid-session | ✅ No effect until next session (cache preserved) |
| Edit project files | ✅ Cache preserved |
| `/rewind` command | ✅ Cache preserved |
| Spawn subagents | ✅ Cache preserved |

**Actionable rules for Claude Code**

- ✅ Keep CLAUDE.md under 200 lines
- ✅ Put the most stable rules at the top of CLAUDE.md (they anchor the cached prefix)
- ✅ Never embed dynamic content in CLAUDE.md (branch names, dates, task IDs, current sprint)
- ✅ Minimize `@import` references — imported content joins the cache prefix and inflates it
- ✅ Prefer deferred MCP servers — deferred tools don't trigger cache invalidation on connect
- ✅ Decide on model and effort level before starting a long session — switching mid-session busts the cache

**Cache TTL**

| User type | Default TTL | Opt-in |
|-----------|-------------|--------|
| Pro / Max / Team (subscription) | 1 hour, automatic, no extra cost | — |
| API key | 5 minutes | `ENABLE_PROMPT_CACHING_1H=1` for 1-hour TTL |

A well-structured CLAUDE.md stays warm across breaks in a subscription session. If you are on API key billing, enabling the 1-hour TTL is worth it for any session longer than 5 minutes.

**Claude Code vs GitHub Copilot CLI — caching comparison**

| Aspect | Claude Code | GitHub Copilot CLI |
|--------|-------------|-------------------|
| Cache visibility | `/usage` shows metrics per turn | No user-visible metrics |
| User control | Env vars, strategic `/compact` timing, model choice | Harness-controlled |
| MKT-0005 applicability | **Direct** — structure choices directly affect cache prefix | **Indirect** — prevents prefix corruption |
| Cache TTL | 1 hour (subscription) / 5 min (API default) | Unknown (harness-controlled) |
| Who pays | User (API key) or included (subscription) | User (AI credits) |

---

## Anti-Patterns

- ❌ Silently assuming intent without checking
- ❌ Doing work outside your role without flagging it
- ❌ Producing output without explaining key decisions
- ❌ Writing large amounts of speculative code
- ❌ Ignoring existing context files — read before writing
- ❌ Overwriting documented decisions without a documented reason
- ❌ Leaving tasks half-done without an explicit handoff
- ❌ Adding complexity without a clear reason
- ❌ Running 10+ actions without a human check-in
- ❌ Making irreversible changes without explicit authorization
- ❌ Crossing a context boundary without writing state to files
- ❌ Declaring completion without verifying outputs against acceptance criteria
