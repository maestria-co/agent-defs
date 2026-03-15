# Agentless Conversion: Pre-Start Checklist

Before beginning Phase 1, confirm all items below are addressed.

---

## Understanding & Alignment

- [x] **You understand the shift:** From 6 specialized agents with routing logic → 5 composable patterns with direct selection
- [x] **You agree with the approach:** Break into 7 phases, validate patterns before retiring agents, keep systems parallel during transition
- [x] **You've reviewed the main plan:** Read `AGENTLESS_CONVERSION_PLAN.md` completely
- [x] **You've reviewed the visual roadmap:** Understand the before/after architecture in `VISUAL_ROADMAP.md`
- [x] **You've reviewed the executive summary:** Know the high-level goals and timeline approach in `EXECUTIVE_SUMMARY.md`

---

## Scope & Constraints

- [x] **Context template unchanged?** (Confirm: do we convert `context_template/` or leave as-is?) - Leave it as is.
- [x] **Backward compatibility required?** (Should agents stay available for old projects after conversion?) - Yes do not remove the agents.
- [ ] **Team size:** Who will work on the conversion? Are they available for phases 1–7?
- [x] **Stakeholders identified:** Any teams/users who need to approve the conversion before starting? - No

---

## Resources & Support

- [ ] **Plan location confirmed:** All outputs go to `.context/tasks/`
- [ ] **SQL tracking set up:** Phase tracking database created ✓
- [ ] **Documentation access:** All current agent/pattern docs are accessible
- [ ] **Review checkpoint scheduled:** After Phase 1, before Phase 2 (to review analysis)

---

## Questions Resolved

Before proceeding, answer these:

### Architectural

1. **Should the Coordination Pattern (lightweight Manager replacement) be included?**
   - YES: Include it for complex multi-pattern tasks
   - NO: Users compose patterns directly without coordination agent
   - **Decision:** **\_\_**YES\***\*\_\*\***

2. **How "agentless" should the final README be?**
   - Fully agentless: No mention of old agents except in migration guide
   - Hybrid: Reference patterns as primary, agents as legacy alternative
   - **Decision:** \_**\_Hybrid\*\***\_**\*\***

3. **Should context_template/ remain unchanged or be updated for agentless patterns?**
   - Leave as-is: Projects using context_template can opt-in to agentless
   - Update it: New projects should follow agentless patterns from start
   - **Decision:** **\_**Update it\***\*\_\_\*\***

### Timeline & Effort

4. **Is there a deadline for conversion completion?**
   - No deadline: Work through phases as time allows
   - Soft target: Goal to complete by [DATE]
   - Hard deadline: Must be done by [DATE]
   - **Decision:** **\_\_\_**ASAP**\_\_\_\_**

5. **How much validation rigor for Phase 6?**
   - Light: Test patterns on 3–5 representative tasks
   - Standard: Test on 10+ tasks, collect metrics
   - Rigorous: Extensive testing, compare against baseline agents
   - **Decision:** **\_\_\_**Standard**\_\_\_\_**

### Rollback & Risk

6. **If Phase 6 validation fails, should we:**
   - Refine patterns and re-test (stay agentless)
   - Revert to agents as primary system (abandon agentless)
   - Hybrid: Support both, let teams choose
   - **Decision:** **\_\_**Stay Agentless\***\*\_\*\***

7. **Should archived agents be kept in repo or removed entirely?**
   - Keep in `agents/_archive/`: Available for reference
   - Remove from repo: Only available in git history
   - **Decision:** **\_\_**Keep\***\*\_\*\***

---

## Go/No-Go: Start Phase 1?

Once all checkboxes are marked and questions answered:

- [ ] **I confirm all above items are addressed**
- [ ] **I'm ready to begin Phase 1 (Analysis & Assessment)**

---

## Phase 1 Kickoff

When ready, run:

```bash
# Start Phase 1 tasks
cd /Users/matthewecheverria/Repos/maestria/agent-defs

# Phase 1 deliverables will be written to:
# - .context/tasks/CURRENT_SYSTEM_ANALYSIS.md
# - .context/tasks/AGENTLESS_MAPPING.md
# - .context/tasks/HANDOFF_ANALYSIS.md

# Progress tracked in SQL database (phases table)
```

---

## Document Reference

| Document                         | Purpose                                        | Location          |
| -------------------------------- | ---------------------------------------------- | ----------------- |
| **AGENTLESS_CONVERSION_PLAN.md** | Full plan with all phases, tasks, deliverables | `.context/tasks/` |
| **EXECUTIVE_SUMMARY.md**         | High-level overview and context                | `.context/tasks/` |
| **VISUAL_ROADMAP.md**            | Architecture diagrams and phase flow           | `.context/tasks/` |
| **PRE_START_CHECKLIST.md**       | This file — questions before starting          | `.context/tasks/` |

---

## Notes

- **No time estimates** are provided. Each phase is a logical unit that can be completed and reviewed.
- **Phases 1–4 are safe:** No breaking changes, documentation/analysis only.
- **Phase 5 introduces parallel systems:** Both agents and patterns available.
- **Phase 6 is the validation gate:** Patterns must pass before agent retirement.
- **Phase 7 is cleanup:** Only proceed if Phase 6 passes validation.

---

## Questions Before Starting?

If any answers above are unclear, clarify now before proceeding to Phase 1.

Once confirmed, the first task is **Phase 1: Analyze Current System**.

**Status:** Ready for Phase 1? **\_** (Yes / No / Need clarification)
