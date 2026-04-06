# Task MJE0004: Agent Auto-Skill Invocation at Task Start and Completion

## Problem

### Issue 1 — Skills not auto-running at task start

**Current behavior:** Skills like `context-loader` and `common-constraints` are
referenced in agent instructions but not automatically invoked — agents apply
them as a pattern from memory rather than executing them via the skill tool.

**Expected behavior:** These foundational skills should execute at the start of
every task turn, not just be "applied as a pattern."

### Issue 2 — `context-maintenance` not auto-running after code changes

**Current behavior:** `context-maintenance` is mentioned in "Discipline
Enforcement" but not enforced in the completion workflow — agents skip it unless
explicitly instructed.

**Expected behavior:** After any task that modifies code outside `.context/`,
the agent must automatically run `context-maintenance` to sync documentation.

## Proposed Fix

### Turn Protocol — add to Manager and all specialist agents

```
### 1. Load Foundation Skills

Before any other action, invoke these skills in order:
1. `context-loader` — determines which .context/ files to read for this task
2. `common-constraints` — loads discipline rules (evidence requirement, scope discipline, etc.)

For simple tasks, context-loader will return minimal files.
For complex tasks, it returns domain/architecture/standards files.
```

### Completion Workflow — replace current completion section

```
### Completion Workflow

1. Run `verification-checklist` — every criterion checked with evidence
2. Update `plan.md` — all steps marked complete (if task folder exists)
3. **Run `context-maintenance`** — REQUIRED if any code files modified outside `.context/`
   - Skip only for pure documentation tasks or .context/-only changes
4. Run `task-retrospective` — if the task was medium or complex
5. Report to user
```

## Affected Files

- `agents/manager.agent.md`
- `agents/coder.agent.md`
- `agents/tester.agent.md`
- `agents/architect.agent.md`
- `agents/planner.agent.md`
- `agents/researcher.agent.md`
- `agents/reviewer.agent.md`
- `agents/_shared/conventions.md` (if turn protocol lives there)

## Acceptance Criteria

- [ ] Manager agent invokes `context-loader` and `common-constraints` at the start of every turn
- [ ] All specialist agents follow the same turn protocol
- [ ] `context-maintenance` is listed as REQUIRED (not optional) in the completion workflow
- [ ] Skip condition for `context-maintenance` is explicit: pure doc tasks or `.context/`-only changes
- [ ] No agent instructions contradict the updated protocol

## Status

Pending — scheduled for next session
