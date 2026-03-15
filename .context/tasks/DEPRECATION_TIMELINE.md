# Deprecation Timeline

> Phase 5 deliverable. Documents the timeline and criteria for retiring the legacy agent system.

---

## Current State

| Component | Status |
|---|---|
| Agent files (6 × `.agent.md`) | **Deprecated** — working, but marked legacy |
| `agents/_shared/conventions.md` | **Retained** — still referenced by some agents |
| `agents/_shared/handoff-protocol.md` | **Retained** — historical reference |
| `agents/_shared/README.md` | **Retained** — referenced in CLAUDE.md legacy section |
| `.context/patterns/` (6 SKILL.md) | **Active — primary system** |

---

## Deprecation Stages

### Stage 1: Soft Deprecation (current — Phase 5)
- ✅ All agent files have deprecation notices
- ✅ CLAUDE.md updated: patterns primary, agents as legacy section
- ✅ `MIGRATION_GUIDE.md` created
- Agent files still work — no functionality removed
- Teams can still use agents while migrating

### Stage 2: Validation Complete (Phase 6)
- Patterns proven on 10+ representative tasks
- All 6 patterns produce equal or better outputs vs. agents
- `TROUBLESHOOTING.md` updated with any new issues found during validation
- Gate: validation must pass before moving to Stage 3

### Stage 3: Archive (Phase 7)
- Agent files moved to `agents/_archive/`
- Agent tools removed from custom_instruction
- `agents/_shared/README.md` updated to point to patterns
- CLAUDE.md legacy section shrunk to one line with archive path
- `README.md` updated as hybrid (patterns primary, archive noted)

### Stage 4: Full Retirement (future — not scheduled)
- `agents/_archive/` may be deleted after 6+ months of no use
- Only proceed if: no users reporting agent use, patterns cover all cases
- Never delete without a release note and migration path

---

## Gates for Archive (Phase 7)

Before moving agents to `_archive/`, verify all of these:

- [ ] Phase 6 validation: ≥10 tasks completed across all 6 patterns
- [ ] All 6 patterns produce quality outputs without needing agent fallback
- [ ] `TROUBLESHOOTING.md` covers the top 5 issues found in validation
- [ ] `MIGRATION_GUIDE.md` reviewed and accurate after validation learnings
- [ ] No blocking issues with patterns in edge cases found during validation

---

## Why Not Delete Immediately

1. **Safety net** — teams who have built workflows around agents need a migration path
2. **Reference** — the agent files document the old system's design decisions
3. **Rollback** — if patterns prove insufficient in edge cases, agents are available
4. **History** — the evolution from agents to patterns is worth preserving

Per user decision: **Stay Agentless** — if patterns fail, we refine patterns, not revert to agents. But we keep the archive as reference material.

---

## Notes

- Agent tool definitions (`tools:` in frontmatter) remain unchanged — deprecated agents still work if invoked
- The `_skills/` directory (context-review, evaluate-skill) is unaffected — those are utility skills, not agent replacements
- `agents/_shared/handoff-protocol.md` should be preserved even after archive — it's a design document with lasting value
