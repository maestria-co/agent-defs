# Agentless Conversion: Executive Summary

## What We're Doing

Converting the **agent-defs** repository from a **multi-agent system** (6 specialized agents with complex routing and handoff protocols) to **agentless patterns** (simpler, composable prompt templates that are more direct and maintainable).

**Why:** Anthropic research shows that the most successful AI implementations use simple, composable patterns rather than complex agent frameworks. This conversion makes the system more maintainable, easier to understand, and more effective.

---

## At a Glance

| Aspect | Current (Agents) | Target (Agentless) |
|---|---|---|
| **Structure** | 6 agent roles with routing logic | 5 reusable prompt patterns |
| **Workflow** | User → Manager → Specialists → User | User → Pattern(s) → Result |
| **Coordination** | Complex handoff protocol | Direct pattern composition |
| **State Management** | Agent-to-agent handoff state | Context from `.context/` files |
| **Entry Point** | Understand which agent to choose | Pick which pattern(s) for your task |
| **Maintenance** | Update 6+ agent files | Update 5 pattern files |
| **Learning Curve** | Learn agent roles and workflows | Learn 5 patterns and when to use them |

---

## The 7 Phases (Quick View)

| Phase | Goal | Outcome | Risk |
|---|---|---|---|
| **1** | Analyze current system | Mapping document | None (analysis only) |
| **2** | Extract patterns | Pattern template files | None (docs only) |
| **3** | Update context system | `.context/` ready for patterns | Low (additive) |
| **4** | Create user guides | Quick-start and recipes | Low (reference docs) |
| **5** | Soft deprecation | Agents still work, marked legacy | Low (parallel systems) |
| **6** | Validate at scale | Proven patterns work | Medium (real validation) |
| **7** | Complete migration | Old system archived | None (if phase 6 passes) |

**Total:** 7 discrete, sequential phases. Each is a logical unit that can be reviewed before proceeding.

---

## Key Files Generated

**Main Plan:**
- `.context/tasks/AGENTLESS_CONVERSION_PLAN.md` — Full plan with all tasks, deliverables, and criteria

**Supporting Docs (to be created):**
- `.context/tasks/CURRENT_SYSTEM_ANALYSIS.md` — Phase 1 output
- `.context/tasks/AGENTLESS_MAPPING.md` — How old agents map to new patterns
- `.context/tasks/PATTERN_EXAMPLES.md` — Real examples of each pattern
- `.context/tasks/VALIDATION_TESTS.md` — How we'll test agentless patterns
- `QUICK_START.md` — For users (Phase 4 output)
- `MIGRATION_GUIDE.md` — For teams converting (Phase 5 output)
- And more, created as each phase completes

---

## Success Looks Like

✅ All current workflows work with patterns alone (no routing logic)  
✅ Patterns are simpler than agents (fewer files, clearer prompts)  
✅ Quality/efficiency match or exceed current agent system  
✅ New users can learn patterns faster than agent roles  
✅ Old agents archived, new system primary  
✅ Teams can migrate in a weekend with provided guides  

---

## Next Steps

1. **Review this plan** — Ensure you agree with the approach and phasing
2. **Start Phase 1** — Analyze current system (analysis/documentation only)
3. **Checkpoint after Phase 1** — Review findings before proceeding
4. **Continue phases 2-7** — Sequential, with checkpoint after Phase 3 and Phase 6

**Estimated Flow:**
- Phases 1–4: High confidence, mostly documentation and guides (low risk)
- Phase 5: Parallel systems, agents marked legacy (low-medium risk)
- Phase 6: Real validation on actual tasks (medium risk; refine if needed)
- Phase 7: Archive and final cleanup (low risk, only if Phase 6 passes)

---

## File Locations

All phase outputs stored in: `.context/tasks/`

This keeps them organized, persistent, and accessible to all team members as they work through the conversion.

---

## Questions Before Starting?

Before we begin Phase 1, confirm:

1. ✅ Do you agree with converting from agents → patterns?
2. ✅ Does the 7-phase breakdown make sense?
3. ✅ Should we include the context_template/ in the conversion, or leave it as-is?
4. ✅ Any other stakeholders who should review this plan first?

Once confirmed, proceed with **Phase 1: Analysis & Assessment**.
