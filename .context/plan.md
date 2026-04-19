# agent-defs Improvement Plan
## Source: ICON Changelog Analysis (2026-03-04 → 2026-04-16)

Full analysis and rationale: `.context/possible-changes.md`

## Approach

- Copy from ICON, adapt to this repo — do not write new skills from scratch
- Keep `common-constraints` as a skill (not inlined) — skill reference is more maintainable here without ICON's hook-sync infrastructure
- Keep `implementing-features`, `planning-tasks`, `researching-options`, `writing-tests` — they are the backbone of `skills/GUIDE.md`; add a routing rule to clarify skills vs. agents
- Skip: `initialize-multimodule`, `merge-phase-templates`, `setup-mcp-servers`, `sprint-goals`, `rfc-format`, `rfc-refactor`, `create-iconrc`, `ecological-impact`

---

## Phase 1 — Remove dead weight (no dependencies)

workspace-manager and monorepo-manager are confirmed unused. prompts/ is already empty.
Do this first — it reduces confusion for every phase that follows.

- [ ] Delete `agents/workspace-manager.agent.md`
- [ ] Delete `agents/monorepo-manager.agent.md`
- [ ] Delete `skills/coordinating-work/` — only callers were workspace-manager and monorepo-manager
- [ ] Delete `skills/eli5-extractor/` — general utility, no dev workflow integration, ICON dropped it
- [ ] Delete `prompts/` entirely — directory is already empty (README only); remove from `README.md` and `CLAUDE.md`
- [ ] Update `skills/GUIDE.md` — remove coordinating-work and eli5-extractor from routing table
- [ ] Update `README.md` — remove workspace-manager, monorepo-manager, prompts/ references
- [ ] Update `CLAUDE.md` — same removals

---

## Phase 2 — Update existing skills (targeted patches)

Each item is a specific, bounded change — not a rewrite.

- [ ] `skills/common-constraints/SKILL.md` — replace single banned-pattern rule with shell command self-check: inspect commands for silent-workaround behavior before running
- [ ] `skills/context-maintenance/SKILL.md` — add scope-drift as a pruning trigger alongside age; remove non-standard cross-reference section if present
- [ ] `skills/find-context-template/SKILL.md` — replace `find`-based discovery with `${COPILOT_HOME:-$HOME/.copilot}/...` deterministic path construction; split error handling by tool type
- [ ] `skills/task-plan/SKILL.md` — add plan freshness gate: plan must reflect current step before work continues
- [ ] `skills/initialize-repo/SKILL.md` — wire in `context-document-guidelines` quality bar check; remove stale monorepo-manager references if any
- [ ] `skills/initialize-workspace/SKILL.md` — remove stale @workspace-manager references
- [ ] `skills/initialize-monorepo/SKILL.md` — remove stale @monorepo-manager references
- [ ] `skills/context-document-guidelines/SKILL.md` — add explicit wiring notes: invoked by initialize-repo and manager
- [ ] `skills/upgrade-repo/SKILL.md` — narrow to infrastructure-only; delegate content drift explicitly to context-maintenance
- [ ] `skills/GUIDE.md` — add routing rule: skills = in-context invocation (no new context window), agents = delegated via task tool (separate context window)
- [ ] `skills/task-retrospective/SKILL.md` — delegate `.context/` writes to context-specialist *(depends on Phase 4)*

---

## Phase 3 — Add new skills (copy from ICON, adapt)

Source files are in `/Users/matthewecheverria/Downloads/marketplace-main/plugins/ICON/skills/`.
Strip ICON-specific references (iconrc.json, plugin paths) when adapting.

- [ ] Add `skills/code-quality-rules/SKILL.md` — 5-pass review rubric + 3 severity levels; used by coder + reviewer agents. ICON source: `skills/code-quality-rules/`
- [ ] Add `skills/agent-evaluation/SKILL.md` — agent system design evaluator (overlap, routing clarity, responsibility leakage); distinct from `agentic-evaluation`. ICON source: `skills/agent-evaluation/`
- [ ] Add `skills/writing-skills/SKILL.md` — TDD-for-process discipline for creating skills; directly on-mission for this repo. ICON source: `skills/writing-skills/`
- [ ] Add `skills/resolve-repo-context/SKILL.md` — repo-type detection returning structured context root, instructions path, available skills. `user-invocable: false`. ICON source: `skills/resolve-repo-context/`
- [ ] Add `skills/task-plan-phase-investigation/SKILL.md` — `user-invocable: false`; loaded on-demand by manager. ICON source: `skills/task-plan-phase-investigation/`
- [ ] Add `skills/task-plan-phase-architecture/SKILL.md` — `user-invocable: false`. ICON source: `skills/task-plan-phase-architecture/`
- [ ] Add `skills/task-plan-phase-implementation/SKILL.md` — `user-invocable: false`. ICON source: `skills/task-plan-phase-implementation/`
- [ ] Add `skills/task-plan-phase-completion/SKILL.md` — `user-invocable: false`. ICON source: `skills/task-plan-phase-completion/`
- [ ] Add `skills/task-plan-phase-testing/SKILL.md` — `user-invocable: false`. ICON source: `skills/task-plan-phase-testing/`
- [ ] Add `skills/context-specialist-impl/SKILL.md` — consolidated backing skill for context-specialist agent; merges detect-tree-position logic + leaf/branch/root initialization into one file. ICON sources: `skills/context-specialist-detect-tree-position/`, `skills/context-specialist-impl-leaf/`, `skills/context-specialist-impl-branch/`, `skills/context-specialist-impl-root/`

---

## Phase 4 — Add new agent

- [ ] Add `agents/context-specialist.agent.md` — sole delegated owner of `.context/` write operations; accepts `working_directory`, `git_root`, `feature_branch`, `tree_position`, `mode`. ICON source: `agents/context-specialist.agent.md`. Backs `skills/context-specialist-impl/` (Phase 3). Unblocks task-retrospective update in Phase 2.

---

## Phase 5 — Agent cross-cutting updates

Apply to every `.agent.md` file that remains after Phase 1. Do these as a batch — they are
mechanical changes, not judgment calls.

- [ ] Bump `model: claude-sonnet-4.5` → `claude-sonnet-4.6` in all agent frontmatter
- [ ] Add `user-invocable: false` to all specialist agent frontmatter (manager stays user-invocable)
- [ ] Add **Behavior Tiers** table (Hardcoded / Default / Discretionary) to all specialist agents
- [ ] Add **Anti-Rationalization** table to all specialist agents
- [ ] Add **Scope Guard** table to all specialist agents
- [ ] Remove `## Task Artifacts` section from any agents that still carry it

Agents affected: manager, coder, reviewer, tester, researcher, architect, planner,
product-manager, dev-support-triage, code-researcher

---

## Phase 6 — Agent per-agent targeted updates

Do these after Phase 5 so the structural tables are already in place.

**manager.agent.md** (most changes):
- [ ] Split Turn Protocol into Session Start (one-time) and Turn Start (per-turn) sections
- [ ] Add plan.md write exemption from always-delegate rule — 3-layer enforcement: inline exception note, Hardcoded Tier row, Anti-Rationalization row
- [ ] Add git operations carveout — manager may run git commands directly
- [ ] Split research gate into two branches: codebase exploration (explore agent) vs. external research (@researcher)
- [ ] Add raw-source rule — manager delegates source file reads to sub-agents; writes results to `.context/domains/`
- [ ] Add Anti-Rationalization row for execution-context loophole ("I'm the CLI agent" does not bypass always-delegate)
- [ ] Wire `resolve-repo-context` into Session Start for non-project repos *(depends on Phase 3)*

**Specialist agents:**
- [ ] `coder` — reference `code-quality-rules`; remove hardcoded 3-attempt retry limit *(depends on Phase 3)*
- [ ] `reviewer` — extract inline quality criteria to `code-quality-rules`; expand security checklist *(depends on Phase 3)*
- [ ] `tester` — remove inline TDD cycle; defer to `testing-discipline`; add iteration-vs-full-suite rule
- [ ] `researcher` — replace "When to Use This Agent" routing list with `## Scope`; remove `### Next Steps` output block
- [ ] `architect` — add constraint blocking user story writing and task decomposition; clarify escalation as manager → architect only
- [ ] `planner` — add task granularity requirement: exact file paths, independently verifiable steps per task
- [ ] `product-manager` — add missing `common-constraints` invocation at session start (bug fix)
- [ ] `dev-support-triage` — cross-cutting changes only (Phase 5)
- [ ] `code-researcher` — cross-cutting changes only (Phase 5)

---

## Decisions made

| Decision | Rationale |
|----------|-----------|
| workspace-manager / monorepo-manager retired in Phase 1, not last | Confirmed unused — no risk |
| prompts/ deleted entirely | Already empty; just a README with no prompt files |
| context-specialist sub-skills consolidated into one | Sub-skills are generic; 4 files for what can be sections in 1 is unnecessary overhead |
| common-constraints stays as a skill | Hook-sync infrastructure not available here; skill reference is more maintainable |
| task-plan-phase-* added despite being "overhead" | ICON's manager is shorter despite more features because of these; they are internal machinery |
| New skills copied from ICON and adapted | Writing from scratch risks guessing at content we've only seen in changelog summaries |
