# Agent and Skill File Structure Survey

**Survey Date:** 2026-07-10  
**Purpose:** Understand current content organization patterns before designing cache-friendly structure

---

## Agent Structure Patterns

### `agents/manager.agent.md`
- **Frontmatter + identity**: role summary, model, tools, user-invocable (lines 1-16)
- **Session Start / dynamic orchestration**: active tasks, delegation payload, project context loading, task creation (lines 20-168)
- **Turn Start / ongoing state**: resume current task state, verify stale plan (lines 171-177)
- **Workflow orchestration**: specialist routing table + delegation format (lines 179-220)
- **Static-heavy sections**: workflow rules, role boundaries, constraints, anti-patterns, protocol text
- **Dynamic sections**: active task detection, current plan state, branch/task resume, delegation payload, context loading choices
- **Rough split**: ~80–85% static / ~15–20% dynamic

### `agents/coder.agent.md`
- **Role definition + when to invoke** (lines 17-45)
- **Process** (lines 49-58)
- **Skills to apply** (lines 61-68)
- **Context needs** (lines 71-78)
- **Output format** (lines 81-101)
- **Escalation / behavior tiers / anti-rationalization / scope guard** (lines 105-149)
- **Code output efficiency** (lines 150-208)
- **Constraints** (lines 210-219)
- **Static-heavy**; only mildly dynamic via task-spec/context references
- **Rough split**: ~90–95% static / ~5–10% dynamic

### `agents/tester.agent.md`
- **Role definition + when to invoke** (lines 17-45)
- **Process** (lines 48-57)
- **Skills / coverage targets** (lines 60-77)
- **Output formats** (lines 80-110)
- **Escalation / behavior tiers / anti-rationalization / scope guard** (lines 114-161)
- **Test output guidance** (lines 163-220)
- **Constraints** (lines 222-229)
- **Static-heavy**; dynamic mainly the current implementation/spec/test results
- **Rough split**: ~90% static / ~10% dynamic

---

## Shared Conventions / Shared Files

### Exists
- `agents/_shared/conventions.md` — shared behavioral norms: simplicity, tone, ambiguity handling, tool use, context-window guidance, stopping conditions, role boundaries, security, anti-patterns
- `agents/_shared/README.md` — documents shared resources + how to add agents
- `agents/_shared/handoff-protocol.md` — handoff protocol documentation

### Does NOT exist
- `agents/_shared/agent-template.md` — not found in `agents/_shared/` directory

### All files in `agents/_shared/`
- README.md
- conventions.md
- handoff-protocol.md

---

## Skill Structure Patterns

### `skills/implementing-features/SKILL.md`
- **Metadata + purpose** (lines 1-20)
- **Pre-flight checks** (lines 24-54)
- **Execution steps** (lines 58-103)
- **Output format** (lines 106-123)
- **Constraints** (lines 127-136)
- **Static-heavy**; dynamic is mostly spec/implementation/ADR-specific task context
- **Rough split**: ~85–90% static / ~10–15% dynamic

### `skills/writing-tests/SKILL.md`
- **Metadata + purpose** (lines 1-22)
- **Pre-flight checks** (lines 25-46)
- **Execution steps** (lines 49-116)
- **Output formats** (lines 119-146)
- **Constraints** (lines 150-160)
- **Static-heavy**; dynamic is test target, framework, and failures/coverage results
- **Rough split**: ~85–90% static / ~10–15% dynamic

---

## Key Findings

1. **Agents are already 80-95% static** — most content is reusable workflow, constraints, and role definitions
2. **Manager is the most dynamic** (15-20% dynamic) due to Session Start orchestration, task resume, and context loading
3. **Specialist agents are highly static** (90-95% static) — coder, tester have minimal dynamic content
4. **No agent-template.md exists** — will need to create it as part of MKT-0005
5. **Shared conventions exist** — `agents/_shared/conventions.md` is the natural home for cache-friendly structure guidance

---

## Recommendations

1. **Add cache-friendly guidance to** `agents/_shared/conventions.md` (already the home for shared behavioral norms)
2. **Create** `agents/_shared/agent-template.md` to demonstrate the pattern
3. **Focus pattern on Manager agent** — it has the most dynamic content and will benefit most from reorganization
4. **Keep specialist agents largely as-is** — they're already well-structured for caching
5. **Pattern should emphasize:**
   - Static sections at top: role, capabilities, workflows, constraints, examples
   - Dynamic sections at bottom: current task, session state, task-specific overrides
