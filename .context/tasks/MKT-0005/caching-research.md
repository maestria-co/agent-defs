# Research: Prompt Prefix Caching Mechanisms and Best Practices

**Requested by:** Manager | **Date:** 2026-07-10 | **Status:** Complete | **Task:** MKT-0005

---

## How Prompt Prefix Caching Works

Prompt prefix caching works by storing the computed key-value (KV) tensor representations
from the model's attention layers for a given prefix of tokens. When a subsequent request
arrives with the same prefix, the model skips re-processing those tokens and reads the
pre-computed state directly — reducing both latency and cost. The critical word is
**prefix**: the cache only matches content that is byte-for-byte identical starting from
the very beginning of the prompt. Any single character difference anywhere in the prefix
invalidates all cache entries that overlap with it. This is why content ordering is
everything: stable content must come first so the hash stays consistent across requests.

**Anthropic (Claude)** implements caching via explicit `cache_control` markers or an
automatic mode. The full prompt is processed in a fixed hierarchy: `tools` → `system` →
`messages` (in that order). A cache entry is a hash of all content up to and including the
marked block. When a request is made, the system checks for a matching cache entry; on a
miss it processes the full prompt and writes a new cache entry. Cache reads cost only 10%
of the base input token price — a 90% savings. Cache writes cost 125% of the base price
(a 25% premium). The cache has a default 5-minute TTL that resets for free on each hit; an
optional 1-hour TTL is available at 2× the base write price.

**OpenAI (GPT-4o and later)** implements caching automatically, with no code changes
required. Requests are routed based on a hash of the prompt's initial prefix (~first 256
tokens) to servers that recently processed the same content. When a matching prefix is
found in server memory, those tokens are billed at the cached rate. Cache lifetime is
5–10 minutes of inactivity (in-memory) for most models, and up to 24 hours with extended
retention. For GPT-5.6+ models, explicit cache breakpoints are available (similar to
Anthropic's `cache_control`) and cache writes cost 1.25× the uncached input rate.

---

## Best Practices for Cache-Friendly Structure

- **Put static content at the very top.** The cache prefix must match from byte 0. Stable
  content (role definition, capabilities, workflows, rules, examples) placed first ensures
  the prefix hash never changes, guaranteeing cache hits on every subsequent request.

- **Put dynamic content at the bottom.** Per-request data (current task, user query,
  session state, runtime overrides) belongs after the cache breakpoint. Changing content
  here does not affect the hash of the static prefix above it.

- **Place the cache breakpoint on the last static block — not on any dynamic block.**
  Anthropic's documentation explicitly warns: "A common mistake is marking a block that
  changes every request (e.g., one containing a timestamp). The lookback never finds a
  stable entry at that position — you pay for a write on every request and never get a
  read."

- **Never embed per-request variables before the breakpoint.** Timestamps, user IDs,
  current task IDs, session tokens, or any request-scoped data placed before the breakpoint
  changes the prefix hash on every call — defeating caching entirely.

- **Respect the content hierarchy.** Anthropic's cache invalidation cascade is:
  - Modify `tools` → invalidates tools + system + messages caches
  - Modify `system` → invalidates system + messages caches
  - Modify `messages` → invalidates only messages cache
  
  Therefore, tool definitions and system instructions should be the most stable content.
  Keep them identical across requests whenever possible.

- **Meet the minimum token threshold.** Content shorter than the minimum is silently not
  cached (no error is returned). Minimums by model:
  - **512 tokens:** Claude Fable 5, Claude Mythos 5
  - **1,024 tokens:** Claude Opus 4.8, Claude Sonnet 5/4.6/4.5, Opus 4.1/4, GPT-4o+
  - **2,048 tokens:** Claude Opus 4.7, Claude Haiku 3.5
  - **4,096 tokens:** Claude Opus 4.6/4.5, Claude Haiku 4.5, Claude Mythos Preview
  
  If a prompt falls just below the threshold, expanding the static content to cross it is
  almost always worth the marginal size increase.

- **Use a consistent `prompt_cache_key` (OpenAI).** Provide a stable key for requests
  sharing the same prefix to ensure routing to the same server. Keep traffic under ~15
  requests/minute per key.

- **Maintain a steady request stream.** Both providers' caches are eviction-based. A
  cache entry that isn't used eventually expires. High-frequency agents benefit most;
  rarely-invoked agents may not hold cache between calls and should consider the 1-hour TTL
  option (Anthropic) or extended retention (OpenAI).

- **Monitor cache performance.** Use `cache_read_input_tokens` / `cache_creation_input_tokens`
  (Anthropic) or `cached_tokens` / `cache_write_tokens` (OpenAI) in usage responses to
  verify caching is working. Both fields being 0 means the prompt wasn't cached (usually
  below minimum length).

---

## Recommended Static/Dynamic Content Split

The **70% static / 30% dynamic** split recommended in the MKT-0005 acceptance criteria
aligns well with provider guidance. A practical breakdown for agent/skill files:

### Static Zone (top ~70%) — always identical across invocations

| Content Type | Examples | Rationale |
|---|---|---|
| Agent role & identity | "You are a Researcher agent..." | Never changes per-invocation |
| Core capabilities | What the agent can/cannot do | Stable by definition |
| Process / workflow steps | Step-by-step methodology | Changes only on file edits |
| Behavioral rules | Hardcoded / default / discretionary | Version-controlled |
| Few-shot examples | Input/output pairs | Stable reference material |
| Tool definitions | Tool names, descriptions, parameters | Change only on capability changes |
| Shared conventions | `agents/_shared/conventions.md` content | Project-wide constant |
| Error handling patterns | Escalation logic, anti-patterns | Stable reference |

### Dynamic Zone (bottom ~30%) — varies per invocation

| Content Type | Examples | Rationale |
|---|---|---|
| Current task | Task ID, description, acceptance criteria | Different every call |
| User message / query | The actual input being processed | Always unique |
| Session state | Prior turn history, working memory | Grows each turn |
| Runtime context | Sprint state, PR number, branch name | Changes frequently |
| Situational overrides | "For this task, prioritize X" | Per-invocation |

---

## Why Static-at-Top Maximizes Cache Hits

Cache systems match **prefixes** — contiguous token sequences starting from position 0.
The mathematical consequence is straightforward:

- If static content is at the **top**, the first N tokens of every request are identical.
  The prefix hash matches. Cache hit.
- If dynamic content is at the **top**, the first token that differs (e.g., a new task
  description) produces a different hash. No match against any prior entry. Cache miss —
  even though 95% of the content below it is identical.

The analogy: imagine a library sorted by the first word of every book. If you rearrange
the first word, you land in a completely different section. The rest of the book doesn't
matter. The same is true for prompt prefix caches — the prefix (the beginning) determines
the lookup key entirely.

For agent and skill files specifically: the role definition, capabilities, workflows, and
examples are constant across every invocation of that agent. They should appear first so
they form a stable, cacheable prefix. The task assigned to the agent in any given session
is different every time — it belongs at the bottom, after the stable material is cached.

Additionally, Anthropic's lookup mechanism (the "lookback window") searches backward from
the breakpoint up to 20 blocks for a prior cache write. If the breakpoint is placed on the
last static block (not on the dynamic content that follows it), the lookback will
consistently find the written entry and serve a cache hit.

---

## Technical Constraints to Consider

| Constraint | Anthropic (Claude) | OpenAI (GPT-4o+) |
|---|---|---|
| **Minimum cacheable size** | 512–4,096 tokens (model-dependent) | 1,024 tokens |
| **Default cache TTL** | 5 minutes (resets on hit, free) | 5–10 min inactivity |
| **Extended TTL** | 1 hour (2× write price) | Up to 24 hours (extended retention) |
| **Cache write cost** | 1.25× base input price | No extra cost (pre-GPT-5.6); 1.25× for GPT-5.6+ |
| **Cache read cost** | 0.10× base input price (90% savings) | Discounted (model-dependent) |
| **Max explicit breakpoints** | 4 per request | 4 per request (GPT-5.6+) |
| **Lookback window** | 20 blocks | N/A (prefix hash routing) |
| **What invalidates cache** | Any change to content at/before breakpoint | Any change to exact prefix |
| **Cross-organization sharing** | Not shared | Not shared |
| **Parallel request behavior** | Cache entry available after first response starts | Same |
| **Supported content types** | Text, images, tools, documents, tool results | Text, images, tools, audio, files, structured output |

### Key "Gotchas"

1. **Tools invalidate everything.** On Anthropic, modifying any tool definition
   invalidates the tools cache, system cache, AND messages cache. Keep tool definitions
   frozen during active usage or version them carefully.

2. **Below-threshold content is silently skipped.** No error is thrown if a prompt is too
   short to cache. Always verify via usage fields.

3. **Parallel requests don't share a cache write.** The first request in a parallel batch
   must complete before subsequent requests can hit its cache entry. For agent swarms
   making concurrent calls with the same prefix, only the first request pays the write
   cost; subsequent ones hit the cache only after it completes.

4. **The 20-block lookback is finite.** In a long growing conversation, if more than 20
   new blocks are appended since the last cache write, the prior entry falls out of the
   lookback window. Use a second explicit breakpoint anchored at the stable system content
   to guarantee a write is always within the window.

5. **Automatic caching places the breakpoint on the last block** — if that last block is
   dynamic (the user's message), it will never cache. Use an explicit breakpoint on the
   last static block instead for agent-invocation patterns.

---

## Recommendation for MKT-0005 Implementation

The 70/30 static/dynamic split is well-grounded in both provider documentation and
caching mechanics. The guidance to put static content at the top is not a convention
preference — it is a technical requirement for prefix caching to function at all.

For agent files, the recommended canonical structure is:

```
[YAML frontmatter]         ← static metadata
# Agent Name               ← static
Role / identity paragraph  ← static
Delegation protocol        ← static  
Scope / when to use        ← static
Process / methodology      ← static  ← CACHE BREAKPOINT HERE
Skills to apply            ← static
Report structure           ← static
Behavior tiers             ← static
Anti-patterns / constraints ← static
---                                                   
# Current Task (injected at invocation time)  ← dynamic
Task ID, description, acceptance criteria      ← dynamic
Session context / prior turns                  ← dynamic
Runtime overrides                              ← dynamic
```

The cache breakpoint (`cache_control: {type: "ephemeral"}`) should be placed at the end
of the "Constraints" or last static section — the last block whose prefix is identical
across every invocation of the agent.

**Confidence: High** — based on official Anthropic and OpenAI documentation, cross-verified
against caching mechanics. Both providers use identical architectural reasoning (prefix
hashing) even though their API surfaces differ.
