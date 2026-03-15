# Pre-Start Review: Full Plan Reconciliation

> Reviewed against all 8 planning documents, PRE_START_CHECKLIST.md answers, and actual
> repository state before Phase 1 begins.

---

## Summary

Found **3 blocking conflicts** that require your decision before the plan can be updated and Phase 1
can start. Found **10 non-blocking issues** that will be fixed in the updated plan automatically.

---

## 🔴 Blocking Conflicts (Need Your Decision)

### CONFLICT 1 — `context_template/` Scope

Two answers in the checklist directly contradict each other:

| Location | Answer |
|---|---|
| Checklist item 1 (line 19) | "Leave it as is" |
| Question 3 (line 54) | "Update it" |

**They cannot both be true.** The VISUAL_ROADMAP.md currently shows `context_template/ (unchanged)`.

**Which decision applies?**
- **Leave as-is** → No `context_template/` changes needed. Zero new tasks required.
- **Update it** → Phase 3 or 4 gets new tasks to update `context_template/` for agentless patterns.

---

### CONFLICT 2 — Where Should Patterns Live?

**Critical discovery:** The repository already has two proper Anthropic-format SKILL.md files:
- `_skills/context-review/SKILL.md`
- `_skills/evaluate-skill/SKILL.md`

The plan currently proposes creating a **new** `patterns/` directory, but three documents
disagree on where that is. Here are the three proposals vs. the existing repo convention:

| Source | Location | Format |
|---|---|---|
| AGENTLESS_CONVERSION_PLAN.md | `patterns/planning.md` (repo root, flat) | Plain markdown |
| PHASE_2_ENHANCED.md | `.context/patterns/planning-tasks/SKILL.md` | SKILL.md |
| VISUAL_ROADMAP.md | `patterns/` at root with subdirs | Mixed |
| **Existing repo convention** | `_skills/<name>/SKILL.md` | **SKILL.md ✓** |

**The case for `_skills/`:** The repo already established this convention with two real skills. Both
use proper Anthropic SKILL.md format (YAML frontmatter + Pre-flight checks + Execution steps +
Constraints). Adding new skills to `_skills/` is the most consistent choice and means no new
directory structure needs to be explained or justified.

**Pick one home for all new patterns:**

Option A — `_skills/` *(recommended: consistent with existing repo, already Anthropic format)*
```
_skills/
  context-review/SKILL.md    ← already exists
  evaluate-skill/SKILL.md    ← already exists
  planning-tasks/SKILL.md    ← new (replaces Planner agent)
  researching-options/SKILL.md ← new
  architecting/SKILL.md       ← new
  coding/SKILL.md             ← new
  testing/SKILL.md            ← new
  coordinating/SKILL.md       ← new (Coordination pattern)
```

Option B — `patterns/` at repo root *(new directory, original plan, different from `_skills/`)*
```
patterns/
  planning-tasks/SKILL.md
  researching-options/SKILL.md
  ...
```

Option C — `.context/patterns/` *(inside .context/, hidden from primary navigation)*
```
.context/patterns/
  planning-tasks/SKILL.md
  ...
```

---

### CONFLICT 3 — CLAUDE.md Has Broken References Today

This is a pre-existing bug, but it matters because several plan phases reference CLAUDE.md updates.
The current CLAUDE.md points to files that don't exist:

| CLAUDE.md references | Actual filename |
|---|---|
| `agents/manager.md` | `agents/manager.agent.md` |
| `agents/architect.md` | `agents/architect.agent.md` |
| `agents/planner.md` | `agents/planner.agent.md` |
| `agents/researcher.md` | `agents/researcher.agent.md` |
| `agents/coder.md` | `agents/coder.agent.md` |
| `agents/tester.md` | `agents/tester.agent.md` |
| `agents/README.md` | Does not exist (only `agents/_shared/README.md`) |

**Should we fix CLAUDE.md references as part of Phase 1, or defer to a later phase?**
- This is safe to fix early since it's purely corrective (not breaking)
- Phase 5 currently handles CLAUDE.md updates, but fixing the broken paths could go in Phase 1

---

## 🟡 Non-Blocking Issues (Will Be Fixed In Updated Plan)

These will be updated in the plan automatically once blocking conflicts above are resolved:

| # | Issue | Fix |
|---|---|---|
| 4 | Phase 7 README says "Remove agent routing logic" but decision is HYBRID README | Soften to "Reorganize README to lead with patterns, retain agents as legacy" |
| 5 | Phase 6 validation: 10+ task minimum not specified | Add "minimum 10 representative tasks" to Phase 6 |
| 6 | Rollback section lists revert-to-agents as option, decision is Stay Agentless | Remove revert option, clarify rollback = refine and retest only |
| 7 | Existing `_skills/` not catalogued in Phase 1 deliverables | Add existing skills inventory to Phase 1 scope |
| 8 | Enhancement recommendation files never created (PATTERN_TEMPLATE.md, PATTERN_NAMING.md, PROMPT_ENGINEERING_GUIDE.md) | Create during Phase 2 |
| 9 | Phase 2 deliverable naming inconsistent (planning.md vs planning-tasks/SKILL.md vs gerund naming) | Standardize to gerund + SKILL.md format once location decided |
| 10 | PHASE_2_ENHANCED.md changes not incorporated into AGENTLESS_CONVERSION_PLAN.md | Merge changes into master plan |
| 11 | ANTHROPIC_STANDARDS_REVIEW.md enhancements not reflected in Phase tasks | Update Phase 2 and 3 tasks with SKILL.md requirements |
| 12 | context_template update (if decided) has no tasks in any phase | Add tasks if Update decision confirmed |
| 13 | Go/No-Go checkboxes not checked (cosmetic) | Update checklist after decisions confirmed |

---

## ✅ Confirmed Decisions (No Conflict)

These are clear from the checklist and will be carried forward as-is:

| Decision | Answer |
|---|---|
| Coordination Pattern | Include it |
| Backward compatibility | Keep agents working (never delete) |
| Archive location | `agents/_archive/` |
| Timeline | ASAP — move quickly, do not over-plan |
| Validation rigor | Standard: 10+ tasks |
| Rollback strategy | Stay agentless: refine and retest |
| README style | Hybrid: patterns primary, agents as legacy |

---

## What Happens After You Answer

Once you answer the 3 blocking conflicts:

1. **Updated `AGENTLESS_CONVERSION_PLAN.md`** — incorporates all checklist decisions, enhancement
   recommendations, and the resolved conflicts
2. **Updated `VISUAL_ROADMAP.md`** — correct final file structure using chosen pattern location
3. **Phase 1 tasks finalized** — with correct deliverable paths and `_skills/` inventory scope
4. **Phase 1 can begin immediately**

---

## Decisions Needed

| # | Question | Options |
|---|---|---|
| Q1 | `context_template/`: leave unchanged or update for agentless? | Leave as-is / Update it |
| Q2 | Pattern location? | A: `_skills/` / B: `patterns/` / C: `.context/patterns/` |
| Q3 | CLAUDE.md broken refs: fix in Phase 1 or wait for Phase 5? | Phase 1 / Phase 5 |
