# Possible Changes from ICON Changelog

## Purpose

Capture the highest-value changes from `@/Users/matthewecheverria/Downloads/marketplace-main/plugins/ICON/CHANGELOG.md` since `2026-03-04` that look worth porting into this repo.

This list is intentionally selective. The goal is to reduce surface area in `agent-defs`, not to copy ICON's full complexity.

## Selection Criteria

- Prefer changes that remove duplication or reduce the number of top-level concepts.
- Prefer changes that harden orchestration, task tracking, or `.context/` quality.
- Skip changes that would add more specialist agents or phase-specific skills unless they replace larger complexity elsewhere.

## Major Update Themes in ICON

### Context-named skills that exist here and received ICON updates

This repo already has `context-loader`, `context-maintenance`, `context-document-guidelines`,
`context-review`, and `find-context-template`. All but `context-loader` and `context-review`
received meaningful changes in ICON since `2026-03-04`.

#### `context-maintenance`

**ICON source**

- `1.2.0` removed non-standard "Integration" cross-reference section
- `1.6.0` added Scope and Size subsection to Pruning — context files grow through accretion;
  check scope drift alongside staleness, not just age

**Why this matters here**

The current `skills/context-maintenance/SKILL.md` may still carry the older pruning rules.
Adding scope-drift as a pruning trigger (not just time) is a low-risk improvement.

**Likely touchpoints in this repo**

- `skills/context-maintenance/SKILL.md`

---

#### `context-document-guidelines`

**ICON source**

- `1.6.0` first introduced the skill — atomicity standards, size heuristics by file type,
  when-to-split signals, naming guidance for split files, anti-patterns table
- `1.6.0` wired it into `initialize-repo`, `manager`, and `context-maintenance`

**Why this matters here**

This repo already has `skills/context-document-guidelines/SKILL.md`. The key question is
whether it is wired into `initialize-repo` quality bar checks and the manager's domain
documentation guidance — ICON added those integration points explicitly.

**Likely touchpoints in this repo**

- `skills/context-document-guidelines/SKILL.md`
- `skills/initialize-repo/SKILL.md`
- `agents/manager.agent.md`

---

#### `find-context-template`

**ICON source**

- `1.3.0` created the skill to replace hardcoded path lists
- `1.11.0` updated install path after plugin rename
- `1.13.3-beta.2` replaced fragile `find`-based discovery with deterministic path construction
  (`${COPILOT_HOME:-$HOME/.copilot}/...`); split error handling by tool type

**Why this matters here**

This repo already has `skills/find-context-template/SKILL.md`. The deterministic path
construction approach is a real reliability improvement over `find`-based lookup, especially
when both Copilot CLI and Claude Code must work.

**Likely touchpoints in this repo**

- `skills/find-context-template/SKILL.md`
- `skills/initialize-repo/SKILL.md`
- `skills/upgrade-repo/SKILL.md`
- `skills/initialize-monorepo/SKILL.md`
- `skills/initialize-workspace/SKILL.md`

---

#### `context-loader` and `context-review`

No material changelog entries for either since `2026-03-04`. The versions in this repo are
likely current relative to ICON.

---

### Context-named skills this repo does not have (new additions)

#### `context-specialist` agent (new)

**ICON source**

- `1.13.3-beta.2` — added `*.code-workspace` ROOT detection, explicit Input Parameters
  section (`working_directory`, `git_root`, `feature_branch`, `tree_position`, `mode`),
  and wired these into steps 2–6 so delegation parameters are never silently ignored
- `initialize-workspace` switched dispatch to `ICON:context-specialist`

**What it does**

A dedicated agent whose sole job is performing `.context/` reads and writes as delegated
by the manager and `task-retrospective`. Keeps context write operations out of general
specialist agents so they stay focused on their own domain.

**Why this matters here**

Currently, `.context/` writes happen inside `task-retrospective` and informally inside
agents. A `context-specialist` would give a clean, testable delegation target for any
agent that needs to write context docs without doing it inline.

**Likely new files**

- `agents/context-specialist.agent.md`
- updates to `skills/task-retrospective/SKILL.md`
- updates to `agents/manager.agent.md`

---

#### `resolve-repo-context` skill (new)

**ICON source**

- `1.13.0` added as a non-user-invocable skill invoked by manager during Session Start
- Determines correct context root, instructions path, and available skills for monorepo,
  workspace, and multi-module repos
- Returns structured JSON: `repo_type`, `resolved_context`, `available_skills`, `projects`
- Replaced the `workspace-manager`/`monorepo-manager` delegation chain

**Why this matters here**

If candidate change #1 (collapsing workspace/monorepo agents) is adopted, this skill or a
simpler equivalent is required. Without it, the manager has no reliable way to detect repo
type and resolve context root at session start.

**Likely new files**

- `skills/resolve-repo-context/SKILL.md`
- updates to `agents/manager.agent.md`

### `initialize-repo` evolved into the canonical bootstrap path

**ICON source**

- `1.0.0` introduced `context-setup`
- `1.1.1` renamed `context-setup` to `initial-setup` and merged setup prompt guidance into the skill
- `1.2.0` renamed `initial-setup` to `initialize-repo`
- `1.3.0` routed template discovery through `find-context-template`
- `1.6.0` added atomicity guidance to the quality bar
- `1.13.0` added `create-iconrc`
- `1.13.3-beta.2` updated it to install richer workflow templates and prefer `.claude/claude.md`

**Pattern**

ICON steadily moved setup knowledge out of prompts and into a single bootstrap skill. That skill became responsible not just for creating files, but for detecting conventions, copying the right templates, and setting up local structure that later agents can rely on.

**Why this matters here**

This repo already has `skills/initialize-repo/SKILL.md`, but ICON's history suggests a stronger target state: one clearly authoritative bootstrap skill with fewer parallel onboarding concepts and more deterministic repo setup behavior.

**Likely touchpoints in this repo**

- `skills/initialize-repo/SKILL.md`
- `skills/find-context-template/SKILL.md`
- `README.md`
- `CLAUDE.md`
- `context_template/`

### `upgrade-repo` narrowed into infrastructure sync instead of content refresh

**ICON source**

- `1.2.0` introduced `upgrade-repo`
- `1.3.0` switched it to `find-context-template`
- `1.6.0` narrowed it to infrastructure-only and delegated content drift to `context-maintenance`
- `1.13.0` added `.context/iconrc.json` and `.context/.gitignore` handling
- `1.13.1` fixed backfill of missing `iconrc`
- `1.13.3-beta.2` added migration to `.claude/claude.md` and richer workflow template installation

**Pattern**

ICON learned to separate "bring repo infrastructure up to spec" from "rewrite project content." That reduced the risk of upgrade logic becoming a second context-maintenance system with overlapping rules.

**Why this matters here**

This repo already has `skills/upgrade-repo/SKILL.md`. ICON's evolution suggests it should stay tightly scoped: copy/update infrastructure, migrate expected paths, and leave actual content stewardship to `context-maintenance`.

**Likely touchpoints in this repo**

- `skills/upgrade-repo/SKILL.md`
- `skills/context-maintenance/SKILL.md`
- `context_template/`
- future `.context/workflows/`

### Agents moved toward stronger orchestration and less duplicated inline guidance

**ICON source**

- `1.1.0` added stronger discipline skills and pushed them into agent workflows
- `1.4.0` made `common-constraints` invocation mandatory
- `1.7.0` added behavior tiers and anti-rationalization structures to specialist agents
- `1.8.0` inlined shared constraints into all agents
- `1.10.0` and `1.12.x` tightened manager planning, research, and routing behavior
- `1.13.0` retired `workspace-manager` and `monorepo-manager` in favor of manager-level context resolution
- `1.13.3-beta.2` moved review rules out of agents and into `code-quality-rules`

**Pattern**

The agent definitions became more disciplined, but also more modular. Shared rules were centralized or synced, manager orchestration got stricter, and specialist agents were trimmed by pushing reusable guidance into skills.

**Why this matters here**

This repo already has many of the same pieces — `common-constraints`, `verification-checklist`, `testing-discipline`, `systematic-debugging`, plus multiple orchestration agents. ICON's later changes are useful because they point to where this repo can likely shrink: less duplicated text in agents, stronger manager control points, fewer orchestration entry points.

**Likely touchpoints in this repo**

- `agents/manager.agent.md`
- `agents/coder.agent.md`
- `agents/reviewer.agent.md`
- `agents/tester.agent.md`
- `agents/workspace-manager.agent.md`
- `agents/monorepo-manager.agent.md`
- `skills/common-constraints/SKILL.md`
- `skills/verification-checklist/SKILL.md`
- `skills/testing-discipline/SKILL.md`

## Candidate Changes

### 1. Collapse workspace/monorepo orchestration into `Manager` plus context resolution

**ICON source**

- `1.13.0` removed `workspace-manager` and `monorepo-manager`
- `1.13.0` added `resolve-repo-context` and `invoke-sub-project-skill`

**Why this matters here**

This repo still carries dedicated orchestration agents in `agents/workspace-manager.agent.md` and `agents/monorepo-manager.agent.md`, and `agents/manager.agent.md` routes work to both. If the goal is a smaller, easier-to-explain system, ICON's move toward a single manager with repo-context resolution is one of the biggest simplifications in the changelog.

**Likely touchpoints in this repo**

- `agents/manager.agent.md`
- `agents/workspace-manager.agent.md`
- `agents/monorepo-manager.agent.md`
- `skills/initialize-workspace/SKILL.md`
- `skills/initialize-monorepo/SKILL.md`
- `README.md`
- `CLAUDE.md`

### 2. Make `plan.md` local, canonical, and actively kept current

**ICON source**

- `1.7.2` added `task-plan` as the canonical `plan.md` format
- `1.10.0` tightened manager turn/start handling around planning
- `1.13.2` added a write gate so `plan.md` must reflect the current step before work continues
- `1.13.3-beta.2` moved plan/workflow structure into repo-local `.context/workflows/` templates

**Why this matters here**

This repo already has `skills/task-plan/SKILL.md`, and `agents/manager.agent.md` already says to write `plan.md` immediately. But the current `.context/` tree does not have a local `workflows/` area, and the manager file does not appear to enforce plan freshness on each turn. ICON's changes make the plan less abstract and more durable across resumes.

**Likely touchpoints in this repo**

- `skills/task-plan/SKILL.md`
- `agents/manager.agent.md`
- `.context/tasks/`
- future `.context/workflows/` templates

### 3. Extract code-review standards into a dedicated reusable skill

**ICON source**

- `1.13.3-beta.2` added `skills/code-quality-rules/SKILL.md`
- `1.13.3-beta.2` slimmed `agents/reviewer.agent.md` and `agents/coder.agent.md` by deferring to that skill

**Why this matters here**

Right now this repo spreads quality expectations across `agents/reviewer.agent.md`, `agents/coder.agent.md`, `skills/verification-checklist/SKILL.md`, and `skills/testing-discipline/SKILL.md`. A dedicated review-rules skill would centralize the review rubric and remove duplicated checklist language from agent definitions.

**Likely touchpoints in this repo**

- new `skills/code-quality-rules/SKILL.md`
- `agents/reviewer.agent.md`
- `agents/coder.agent.md`
- `README.md`
- `CLAUDE.md`
- `skills/GUIDE.md`

### 4. Add an explicit manager research gate before planning or coding

**ICON source**

- `1.10.0` fixed unknown-cause bug routing to use `@coder` plus `systematic-debugging`
- `1.12.3` added an explicit research assessment gate
- `1.12.4` split that gate into codebase exploration vs. external research

**Why this matters here**

`agents/manager.agent.md` already has strong delegation rules, but it does not appear to force a distinct "do we need codebase exploration or external research first?" decision before planning or implementation. This is a high-leverage control point because it reduces premature delegation and rework without adding many new moving parts.

**Likely touchpoints in this repo**

- `agents/manager.agent.md`
- `skills/systematic-debugging/SKILL.md`
- `skills/researching-options/SKILL.md`
- `agents/code-researcher.agent.md`

### 5. Tighten shell-command discipline in `common-constraints`

**ICON source**

- `1.12.2` and `1.12.3` replaced a simple `2>/dev/null` prohibition with a shell command self-check rule
- `1.13.3-beta.2` removed stderr silencing from shell examples in setup skills

**Why this matters here**

This repo already treats `skills/common-constraints/SKILL.md` as foundational. ICON's later changes show a useful refinement: do not just ban one shell pattern, force the agent to inspect commands for silent-workaround behavior before running them. That is a small change with outsized reliability benefits.

**Likely touchpoints in this repo**

- `skills/common-constraints/SKILL.md`
- `skills/initialize-repo/SKILL.md`
- `skills/initialize-workspace/SKILL.md`
- `skills/initialize-monorepo/SKILL.md`
- `skills/start-worktree/SKILL.md`

### 6. Remove the prompt layer where a skill already owns the behavior

**ICON source**

- `1.0.0` converted prompt assets into skills and removed `prompts/`

**Why this matters here**

This repo still exposes `prompts/` alongside a large `skills/` catalog. If any prompt is only a weaker or older form of an existing skill, removing that extra layer would make the kit easier to navigate and explain. Given the current concern that the repo already has too many moving parts, this is one of the most direct simplifications available.

**Likely touchpoints in this repo**

- `prompts/`
- matching skill definitions in `skills/`
- `README.md`
- `CLAUDE.md`

### 7. Add scope-drift as a pruning trigger to `context-maintenance`

**ICON source**

- `1.6.0` added a Scope and Size subsection to the Pruning section

**Why this matters here**

The current pruning logic in `skills/context-maintenance/SKILL.md` likely covers staleness by age only. Context files also go stale by scope — sections written for a feature that has since been refactored remain technically "recent" but are wrong. Adding scope-drift as a distinct pruning signal is a small change with a reliable quality payoff.

**Likely touchpoints in this repo**

- `skills/context-maintenance/SKILL.md`

---

### 8. Wire `context-document-guidelines` into `initialize-repo` and `manager`

**ICON source**

- `1.6.0` wired `context-document-guidelines` into `initialize-repo` quality bar checks
  and added manager guidance on domain documentation

**Why this matters here**

This repo has the skill but the integration points may be missing. Adding it to `initialize-repo` ensures new repos start with quality context docs, not placeholder docs. Adding it to `manager` ensures it is invoked whenever the manager creates or reviews `.context/` docs inline.

**Likely touchpoints in this repo**

- `skills/initialize-repo/SKILL.md`
- `agents/manager.agent.md`

---

### 9. Upgrade `find-context-template` to deterministic path construction

**ICON source**

- `1.13.3-beta.2` replaced `find`-based discovery with `${COPILOT_HOME:-$HOME/.copilot}/...`
  deterministic path construction; split error handling by tool type

**Why this matters here**

Fragile `find` calls cause silent failures when running with both Copilot CLI and Claude Code. Deterministic construction is both faster and easier to reason about across tool contexts.

**Likely touchpoints in this repo**

- `skills/find-context-template/SKILL.md`

---

### 10. Add `context-specialist` agent for delegated `.context/` writes

**ICON source**

- `1.13.3-beta.2` — introduced `agents/context-specialist.agent.md` as the sole delegated
  owner of `.context/` write operations; `task-retrospective` was updated to delegate writes
  to it rather than writing inline

**Why this matters here**

Currently `.context/` writes happen informally inside `task-retrospective` and inside manager inline guidance. A dedicated `context-specialist` creates a clean delegation contract: any agent that needs to write context docs passes that work to the specialist instead of doing it inline. This reduces duplicated `.context/` write logic and gives context quality guarantees a single enforcement point.

**Likely touchpoints in this repo**

- new `agents/context-specialist.agent.md`
- `skills/task-retrospective/SKILL.md`
- `agents/manager.agent.md`
- `README.md`
- `CLAUDE.md`

---

## Suggested Order

1. Collapse `workspace-manager` and `monorepo-manager` into manager-level context resolution.
2. Strengthen `plan.md` handling with repo-local workflow templates and a freshness gate.
3. Consolidate review logic into a `code-quality-rules` skill.
4. Add the research gate to `agents/manager.agent.md`.
5. Tighten shell-command rules in `skills/common-constraints/SKILL.md`.
6. Audit `prompts/` for removals or skill conversions.
7. Add scope-drift pruning to `context-maintenance`.
8. Wire `context-document-guidelines` into `initialize-repo` and `manager`.
9. Upgrade `find-context-template` to deterministic path construction.
10. Add `context-specialist` agent for delegated `.context/` writes.

---

## Agent Updates

The following tracks ICON changelog changes for each agent that exists in this repo.
Changes are grouped as **cross-cutting** (affect all or most agents) and **per-agent**.

### Cross-cutting changes (all specialist agents)

All of these gaps apply to every file in `agents/` unless noted otherwise.

| Gap | ICON source | Impact |
|-----|-------------|--------|
| `model: claude-sonnet-4.5` → `claude-sonnet-4.6` | `1.9.0` | All agents are on a stale model version |
| Missing `user-invocable: false` in frontmatter | `1.2.0` + `1.13.3-beta.2` fix | Specialist agents can be surfaced as user-invocable in some UIs; manager should be the entry point |
| No **Behavior Tiers** table (Hardcoded / Default / Discretionary) | `1.4.0` | Without explicit tiers, agents treat all constraints as equally overridable |
| No **Anti-Rationalization** table | `1.4.0` | Agents can construct plausible-sounding exceptions to core constraints |
| No **Scope Guard** table | `1.4.0` | Boundary violations (e.g., tester writing code, coder making arch decisions) have no enforcement row |
| `## Task Artifacts` section present in some agents | `1.3.0` removed | Section only deferred to `common-constraints`; ~120 words of pure overhead |

**Note**: `manager.agent.md` should receive Behavior Tiers and Anti-Rationalization too — but
its tables require a git-operations carveout and plan.md write exemption row that the
specialist agents do not need (see manager-specific section below).

---

### `manager.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| `Turn Protocol` is a flat list — no split between one-time Session Start steps and per-turn Turn Start steps | `1.7.0` | Agents re-run setup steps on every turn; Session Start / Turn Start split prevents that |
| No explicit `plan.md` write exemption from the always-delegate rule | `1.11.0` | Manager currently may route plan.md writes to @coder unnecessarily |
| No git operations carveout | `1.13.3-beta.2` | Manager should be able to run git commands directly without delegating |
| Research gate exists but is not split into codebase exploration vs. external research branches | `1.12.4` | Single-branch gate causes codebase exploration to be skipped in favor of @researcher |
| No raw-source rule (manager reads source files directly instead of delegating to sub-agents or explore) | `1.7.1` | Manager builds stale in-context code understanding; should delegate reads and write results to `.context/domains/` |
| No Anti-Rationalization row for the execution-context loophole | `1.12.3` | "I'm operating as the CLI agent" gets used to bypass always-delegate |
| No `resolve-repo-context` invocation at Session Start for non-project repos | `1.13.0` | Monorepo and workspace detection is implicit; required if workspace/monorepo agents are collapsed |

---

### `coder.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| No reference to `code-quality-rules` skill | `1.13.3-beta.2` | Quality standards are currently inline; extracting to a shared skill would reduce duplication with `reviewer` |
| Hardcoded 3-attempt retry limit | `1.13.3-beta.2` removed | Encourages premature escalation instead of methodical debugging |
| No explicit self-review step in the workflow | `1.0.0` | ICON added a self-review pass before returning; `systematic-debugging` reference should be explicit |

---

### `reviewer.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| Quality review criteria is inline | `1.13.3-beta.2` | ICON extracted to `code-quality-rules` skill with a 5-pass approach and 3 severity levels |
| Security checklist may be narrower | `1.2.0` | ICON expanded: trust boundaries, output encoding for XSS, authz at service layer, access controls on new endpoints, extra scrutiny for auth/authz changes |

---

### `tester.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| TDD cycle may be inline | `1.13.3-beta.2` | ICON removed inline TDD cycle; agent defers to `testing-discipline` skill |
| No iteration-vs-full-suite guidance | `1.3.0` | During RED-GREEN-REFACTOR run only the specific test being worked; full suite reserved for final validation |

---

### `researcher.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| May contain "When to Use This Agent" routing trigger list | `1.8.0` | Routing decisions belong to the orchestrator, not the specialist; replace with `## Scope` section |
| May contain `### Next Steps` block in output format | `1.8.0` | Removed in ICON — researcher should not recommend which agent acts on findings |

---

### `architect.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| No constraint preventing user story writing or task decomposition | `1.13.3-beta.2` | Architect should defer story creation to @planner and @product-manager |
| Escalation path may not be explicit as `manager → architect` | `1.8.0` | ICON reframed routing to prevent coder/tester → architect direct delegation |

---

### `planner.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| Task granularity guidance may lack file-path specificity requirement | `1.0.0` | ICON added requirement for exact file paths and independently verifiable steps per task |

---

### `product-manager.agent.md`

| Gap | ICON source | Notes |
|-----|-------------|-------|
| Missing `common-constraints` invocation at session start | `1.2.0` (bug fix) | All other agents had it; product-manager was the only one missing it |

---

### `dev-support-triage.agent.md` and `code-researcher.agent.md`

No targeted ICON changelog entries found for either agent since `2026-03-04`.
Apply the cross-cutting changes (model version, `user-invocable: false`, Behavior Tiers tables).

---

## Examples

- Current multi-orchestrator surface area: `agents/manager.agent.md`, `agents/workspace-manager.agent.md`, `agents/monorepo-manager.agent.md`
- Current reusable discipline surface area: `skills/common-constraints/SKILL.md`, `skills/task-plan/SKILL.md`, `skills/verification-checklist/SKILL.md`, `skills/testing-discipline/SKILL.md`
- Current repo context layout: `.context/project-overview.md`, `.context/standards.md`, `.context/tasks/`
- Source changelog reviewed: `@/Users/matthewecheverria/Downloads/marketplace-main/plugins/ICON/CHANGELOG.md`

## Pitfalls

- Do not import ICON's added phase-specific skills or specialist agents unless they replace more complexity than they add.
- Do not copy changelog items mechanically; prefer changes that let this repo delete files, delete routing rules, or centralize duplicated guidance.
- Do not add generic `.context/` notes with no repo touchpoints. Any follow-up proposal should name the specific `agent-defs` files it would simplify or replace.

---

## Implementation Plan

### Phase 1 — Delete (lowest risk, no dependencies)

| Todo | Files |
|------|-------|
| Delete `coordinating-work` skill | `skills/coordinating-work/` |
| Delete `eli5-extractor` skill | `skills/eli5-extractor/` |
| Update GUIDE.md for deleted skills | `skills/GUIDE.md` |

### Phase 2 — Update existing skills

| Todo | Files |
|------|-------|
| `common-constraints`: replace banned-pattern rule with shell command self-check | `skills/common-constraints/SKILL.md` |
| `context-maintenance`: add scope-drift pruning trigger | `skills/context-maintenance/SKILL.md` |
| `find-context-template`: deterministic path construction | `skills/find-context-template/SKILL.md` |
| `task-plan`: add plan freshness gate | `skills/task-plan/SKILL.md` |
| `task-retrospective`: delegate `.context/` writes to context-specialist | `skills/task-retrospective/SKILL.md` *(depends on Phase 6)* |
| `initialize-repo`: wire in context-document-guidelines quality bar | `skills/initialize-repo/SKILL.md` |
| `context-document-guidelines`: add integration wiring points | `skills/context-document-guidelines/SKILL.md` |
| `upgrade-repo`: narrow to infrastructure-only scope | `skills/upgrade-repo/SKILL.md` |
| `GUIDE.md`: add skills-vs-agents routing rule | `skills/GUIDE.md` |

### Phase 3 — Add new skills

| Todo | Files | Notes |
|------|-------|-------|
| Add `code-quality-rules` | `skills/code-quality-rules/SKILL.md` | 5-pass rubric, 3 severity levels; used by coder + reviewer |
| Add `agent-evaluation` | `skills/agent-evaluation/SKILL.md` | System design evaluator; distinct from `agentic-evaluation` |
| Add `writing-skills` | `skills/writing-skills/SKILL.md` | TDD-for-process skill authoring; on-mission for this repo |
| Add `resolve-repo-context` | `skills/resolve-repo-context/SKILL.md` | Repo-type detection; required for Phase 7 |
| Add `task-plan-phase-investigation` | `skills/task-plan-phase-investigation/SKILL.md` | `user-invocable: false` |
| Add `task-plan-phase-architecture` | `skills/task-plan-phase-architecture/SKILL.md` | `user-invocable: false` |
| Add `task-plan-phase-implementation` | `skills/task-plan-phase-implementation/SKILL.md` | `user-invocable: false` |
| Add `task-plan-phase-completion` | `skills/task-plan-phase-completion/SKILL.md` | `user-invocable: false` |
| Add `task-plan-phase-testing` | `skills/task-plan-phase-testing/SKILL.md` | `user-invocable: false` |

### Phase 4 — Agent cross-cutting updates (all agents)

| Todo | Scope |
|------|-------|
| Bump model `claude-sonnet-4.5` → `claude-sonnet-4.6` | All agent frontmatter |
| Add `user-invocable: false` | All specialist agents (not manager) |
| Add Behavior Tiers table (Hardcoded / Default / Discretionary) | All specialist agents |
| Add Anti-Rationalization table | All specialist agents |
| Add Scope Guard table | All specialist agents |
| Remove `## Task Artifacts` section | Any agents still carrying it |

### Phase 5 — Agent per-agent updates

| Agent | Changes |
|-------|---------|
| `manager` | Session Start / Turn Start split; plan.md write exemption; git carveout; split research gate; raw-source rule; execution-context Anti-Rationalization row; wire `resolve-repo-context` *(depends on Phase 3)* |
| `coder` | Reference `code-quality-rules`; remove 3-attempt retry limit *(depends on Phase 3)* |
| `reviewer` | Extract to `code-quality-rules`; expand security checklist *(depends on Phase 3)* |
| `tester` | Remove inline TDD cycle; defer to `testing-discipline`; add iteration-vs-full-suite rule |
| `researcher` | Replace routing list with `## Scope`; remove `### Next Steps` output block |
| `architect` | Add no-user-story / no-task-decomposition constraint; clarify escalation path |
| `planner` | Add exact-file-path granularity requirement per task |
| `product-manager` | Add missing `common-constraints` invocation at session start |
| `dev-support-triage` | Cross-cutting changes only |
| `code-researcher` | Cross-cutting changes only |

### Phase 6 — New agent

| Todo | Files |
|------|-------|
| Add `context-specialist` agent — sole owner of `.context/` write operations | `agents/context-specialist.agent.md` |

### Phase 7 — Orchestration collapse (highest risk, do last)

*Depends on: `resolve-repo-context` (Phase 3) + manager wiring (Phase 5)*

| Todo | Files |
|------|-------|
| Retire `workspace-manager` agent | `agents/workspace-manager.agent.md` |
| Retire `monorepo-manager` agent | `agents/monorepo-manager.agent.md` |
| Update `initialize-workspace`: remove stale agent references | `skills/initialize-workspace/SKILL.md` |
| Update `initialize-monorepo`: remove stale agent references | `skills/initialize-monorepo/SKILL.md` |
| Update `README.md` and `CLAUDE.md`: remove retired agents from tables | `README.md`, `CLAUDE.md` |

### What to skip

The following ICON skills were reviewed and explicitly excluded:

| Skill | Reason |
|-------|--------|
| `initialize-multimodule` | Too ICON-specific; not a common pattern in this repo's target projects |
| `merge-phase-templates` | Internal plumbing for ICON's template system |
| `setup-mcp-servers` | Out of scope for this repo's dev-workflow mission |
| `sprint-goals` | Project management tooling; not a dev workflow skill |
| `rfc-format` / `rfc-refactor` | Only relevant if the team uses RFCs; not universal |
| `create-iconrc` | Tied to ICON's `.context/iconrc.json` metadata format |
| `ecological-impact` | Already available globally via `~/.copilot/skills`; no need to duplicate |
