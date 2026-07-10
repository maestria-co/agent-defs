# 2026-07-10 — MKT-0005: Cache-Friendly Structure

## What Went Well

- **User questions expanded scope productively**: User's "how do we prove benefits?" and "will this reduce my token use?" questions revealed critical gaps (measurement guidance, CLI applicability). Each question improved the deliverable.
- **Parallel background agents efficient**: Launched explore + research agents simultaneously while user confirmed Trello fetch — saved ~3 minutes of wall-clock time.
- **CLI research revealed unexpected value**: Discovered both Copilot CLI (94% hit rate, harness-controlled) and Claude Code (transparent caching, 1-hour TTL) actively cache. Pattern applies MORE to Claude Code than originally assumed.

## What Could Be Improved

- **Assumptions about CLI caching**: Started with assumption that pattern was "documentation only" without verifying if CLIs actually use caching. User's question "will this reduce tokens?" exposed the gap. → Always verify infrastructure capabilities before scoping documentation tasks.
- **Measurement guidance added reactively**: Should have anticipated "how do we prove this works?" during planning. Validation is a natural follow-up to any optimization pattern. → Include measurement/validation as default acceptance criterion for optimization patterns.
- **Research scope grew**: Original plan: document pattern. Final: pattern + measurement + CLI research + platform-specific guidance. Scope tripled but user approved each expansion. → No issue, but highlights importance of early "how will we validate?" conversation.

## Lessons Learned

- **Claude Code has superior caching visibility**: `/usage` command shows per-turn cache metrics; 1-hour TTL for subscription users; documented invalidation triggers. Copilot CLI caches automatically but provides no user-facing metrics. When documenting patterns that depend on platform features, research both platforms' implementations.
- **"Preventive" vs "optimization" value**: Same pattern, different framing depending on platform. Copilot CLI = "don't break existing caching" (preventive). Claude Code = "structure to maximize cache hits" (optimization). Frame guidance according to user's leverage.
- **User questions are feature requests**: Every "how do we prove?" or "will this work for X?" question revealed missing acceptance criteria. Treat clarifying questions as scope expansions requiring explicit user approval, not just answers.
- **Harness-controlled vs user-controlled caching**: GitHub places cache breakpoints automatically (users benefit passively). Claude Code exposes controls (users optimize actively). Document the control surface, not just the mechanism.

## Promotion Items

- [ ] "Include measurement guidance for optimization patterns" → promote to `.context/standards.md` under documentation standards
- [ ] "Research platform implementations before documenting patterns" → promote to `skills/researching-options/SKILL.md` as pre-documentation checkpoint
- [ ] Claude Code `/usage` command → add to `.context/domains/claude-code.md` (create if doesn't exist)
- [ ] Copilot CLI harness architecture (4 breakpoints) → add to `.context/domains/copilot-cli.md` (create if doesn't exist)
