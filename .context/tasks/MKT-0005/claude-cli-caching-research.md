# Claude CLI (Claude Code) Caching Research

**Date:** 2026-07-10  
**Purpose:** Verify if Claude CLI implements prompt caching and how MKT-0005 applies

---

## Summary

**"Claude CLI" = Claude Code** — Anthropic's official agentic coding CLI. Claude Code has **fully automatic, transparent prompt caching** with user-visible metrics and documented behavior. The MKT-0005 cache-friendly structure pattern applies **MORE directly** to Claude Code than to GitHub Copilot CLI.

---

## Key Findings

### 1. Claude Code Caching Mechanics

Claude Code uses **prefix-match caching** with a layered context model:

| Layer | Content | Cache Invalidation Triggers |
|---|---|---|
| System prompt | Core instructions, tool definitions | Tool set changes, Claude Code upgrades |
| **Project context** | **CLAUDE.md**, auto memory, rules | Session start, `/clear`, `/compact` |
| Conversation | Messages, responses, tool results | Every turn |

**Cache TTL:**
- Subscription users (Pro/Max/Team): **1-hour TTL** automatically, no extra cost
- API key users: 5-minute default; opt into 1-hour with `ENABLE_PROMPT_CACHING_1H=1`

**Cache pricing (API key users):**
- Cache writes: 1.25× base input price
- Cache reads: 0.1× base input price (90% savings)

### 2. Agent Definition Files (CLAUDE.md)

Agent definitions use **CLAUDE.md files** (not `*.agent.md` by default):

| Scope | Location | When Loaded |
|---|---|---|
| User global | `~/.claude/CLAUDE.md` | Every session |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Every session at launch |
| Local (gitignored) | `./CLAUDE.local.md` | Every session |
| Subdirectory | `./subdir/CLAUDE.md` | On-demand when reading files in that directory |

**CLAUDE.md is loaded into the "Project context" layer** — meaning:
- Content is cached across turns within a session
- Read once at session start (mid-session edits don't apply until restart)
- Recommendation: keep under 200 lines for best cache and adherence

### 3. User Visibility & Control

Claude Code provides **full cache transparency**:

✅ **Metrics available:**
- `/usage` command shows `cache_creation_input_tokens` and `cache_read_input_tokens`
- Configurable statusline shows cache stats per turn
- OpenTelemetry exporter for org-level visibility

✅ **User controls:**
- `DISABLE_PROMPT_CACHING=1` — disable caching entirely
- `ENABLE_PROMPT_CACHING_1H=1` — opt into 1-hour TTL
- Strategic `/compact` timing — user decision affecting cache warmth
- Model/effort choice at session start (switching mid-session = cache bust)
- MCP server deferral (deferred tools don't invalidate cache)

### 4. Cache Invalidation Triggers

**What breaks the cache:**
- Switching models mid-session
- Changing effort level
- Connecting/disconnecting MCP servers (unless deferred)
- `/compact` command
- Upgrading Claude Code version
- Any change to CLAUDE.md (applies on next session)

**What preserves the cache:**
- Editing files in the project
- Editing CLAUDE.md mid-session (no effect until restart)
- Invoking skills
- `/rewind` command
- Spawning subagents

---

## Impact on MKT-0005 Cache-Friendly Structure Pattern

### HIGH Applicability to Claude Code

MKT-0005's pattern applies **more directly** to Claude Code than GitHub Copilot CLI because:

1. **Transparent caching** — users can see cache hit/miss via `/usage`
2. **CLAUDE.md = agent definition** — structuring it well directly affects cache
3. **User-influenceable** — choices about structure, `/compact` timing, model selection affect cache performance
4. **1-hour TTL for subscription users** — well-structured CLAUDE.md stays cached across breaks
5. **Documented behavior** — users can validate that good structure = better cache hits

### Specific MKT-0005 Wins for Claude Code

✅ **Keep CLAUDE.md under 200 lines** — Anthropic recommendation  
✅ **Put stable rules first** — they stay in cached prefix  
✅ **No dynamic content** — don't embed branch names, dates, task IDs in CLAUDE.md  
✅ **Minimize imports** — imported content loads into cache prefix  
✅ **Defer MCP servers when possible** — prevents cache invalidation

### Comparison: Claude Code vs Copilot CLI

| Aspect | Claude Code | GitHub Copilot CLI |
|---|---|---|
| **Cache visibility** | `/usage` shows metrics | No user-visible metrics |
| **Cache control** | Environment vars, strategic `/compact` | Harness-controlled |
| **User leverage** | High — structure choices matter | Low — automatic |
| **MKT-0005 applicability** | Direct — affects cache prefix | Indirect — prevents corruption |
| **Who pays for cache** | User (API key) or included (subscription) | User (AI credits) |
| **Cache TTL** | 1-hour (subscription) / 5-min (API default) | Unknown (harness-controlled) |

---

## Recommendations for MKT-0005

1. **Update conventions.md** to explicitly mention Claude Code (Claude CLI)
2. **Add CLAUDE.md guidance** alongside agent-template.md
3. **Reference `/usage` command** in "Measuring Cache Effectiveness" section
4. **Emphasize 200-line guideline** from Claude Code docs
5. **Document cache invalidation triggers** specific to Claude Code

---

## Sources

- `code.claude.com/docs/en/prompt-caching` — Full caching documentation
- `code.claude.com/docs/en/memory` — CLAUDE.md file scopes and loading
- `code.claude.com/docs/en/costs` — `/usage` command and cost tracking
- `code.claude.com/docs/en/context-window` — Context layer visualization
- Anthropic blog: *"Lessons from building Claude Code: Prompt caching is everything"*

---

## Gap: *.agent.md Files

**Question:** How are `agents/*.agent.md` files in this repo used with Claude Code?

Claude Code natively uses `CLAUDE.md` naming convention, not `*.agent.md`. Possible scenarios:
1. Files are imported via `@import` in CLAUDE.md
2. Custom skill/plugin architecture loads them on demand
3. Used with GitHub Copilot CLI, not Claude Code
4. User has custom loading mechanism

**Recommendation:** Verify with user how `*.agent.md` files are loaded and update MKT-0005 guidance accordingly.
