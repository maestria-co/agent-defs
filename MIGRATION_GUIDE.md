# Migration Guide: Agents → Patterns

How to replace each agent invocation with the equivalent pattern.

---

## TL;DR

Before: start with Manager, let it route to specialists.
After: read `.context/patterns/GUIDE.md`, pick a pattern, use it directly.

The output quality is equivalent. The routing overhead is gone.

---

## Replacing Each Agent

### Manager → Pattern Selection

**Before:**
```
Use the manager agent.
Goal: [your goal]
```

**After:**
```
Read .context/patterns/GUIDE.md to select the right pattern, then:
Use the [pattern-name] skill.
<task>[your goal]</task>
```

Or just use `QUICK_START.md` — it maps common goals to patterns directly.

**When Manager was used for orchestration (multi-agent workflows):**
Use `coordinating-work` only if you have 3+ interdependent steps and need help sequencing. For 1-2 patterns, use them directly in sequence — no orchestration needed.

---

### Planner → planning-tasks

**Before:**
```
Use the planner agent.
Task: [goal]
```

**After:**
```
Use the planning-tasks skill.
<task>[goal]</task>
<context>
Project: [brief description]
Stack: [language/framework]
Constraints: [any limits]
</context>
```

Key difference: you provide the project context directly in `<context>` instead of the Manager reading `.context/` and passing it via a handoff message.

---

### Researcher → researching-options

**Before:**
```
Use the researcher agent.
Question: [question]
```

**After:**
```
Use the researching-options skill.
<task>[question — ask for a recommendation, not just options]</task>
<context>
Stack: [language/framework]
Constraints: [performance, license, bundle size, etc.]
</context>
```

Key difference: frame the task as "recommend X for Y" not "evaluate options for Y." The pattern is designed to recommend; framing it as evaluation produces weaker output.

---

### Architect → designing-systems

**Before:**
```
Use the architect agent.
Decision needed: [decision]
```

**After:**
```
Use the designing-systems skill.
<task>Decide [decision]</task>
<context>
Existing ADRs: .context/decisions/ (relevant entries)
Reversibility: [one-way or two-way door]
Options in play: [list or "evaluate"]
Constraints: [technical or business constraints]
</context>
```

Key difference: you assess reversibility upfront. One-way doors always get an ADR. Two-way doors may not need one.

---

### Coder → implementing-features

**Before:**
```
Use the coder agent.
Task: [what to implement]
```

**After:**
```
Use the implementing-features skill.
<task>[what to implement]</task>
<context>
Spec:
- [ ] [acceptance criterion 1]
- [ ] [acceptance criterion 2]
Relevant files: [list]
Patterns to follow: [reference or none]
</context>
```

Key difference: provide acceptance criteria as a checklist, not prose. The pattern self-verifies against the checklist before completing.

---

### Tester → writing-tests

**Before:**
```
Use the tester agent.
Target: [what to test]
```

**After:**
```
Use the writing-tests skill.
<task>Write tests for [component]</task>
<context>
Implementation: [file paths]
Test framework: [jest/pytest/etc.]
Special cases: [auth, async, external calls, or none]
</context>
```

Key difference: specify the test framework explicitly. Without it, the pattern will infer from the codebase but may pick wrong if tests are mixed-framework.

---

## Replacing the Handoff Protocol

The old handoff protocol was:
```
<handoff>
  <from>Manager</from>
  <to>Coder</to>
  <task>...</task>
  <context>...</context>
</handoff>
```

In the agentless system, you ARE the router. The `<context>` block in your pattern prompt IS the handoff. Instead of Manager reading `.context/` and packaging it into a handoff message, you read `.context/` yourself and provide what's needed.

**Before (with agents):**
1. You → Manager (goal)
2. Manager reads `.context/`, creates handoff to Planner
3. Planner writes plan, creates handoff to Manager
4. Manager routes to Coder with handoff
5. Coder implements, reports back to Manager
6. Manager synthesizes, reports to you

**After (agentless):**
1. You read `project-overview.md` (30 seconds)
2. You → planning-tasks (goal + context)
3. planning-tasks writes `plan.md`
4. You → implementing-features (spec from plan.md)
5. implementing-features completes, reports to you

Same result. 3 fewer hops.

---

## Preserving What Was Valuable

The handoff protocol had genuinely valuable elements. They're now in the patterns:

| Was in handoff protocol | Now in |
|---|---|
| XML tag conventions (`<task>`, `<context>`, `<constraints>`) | All SKILL.md prompts |
| Self-verify checklist | All patterns (Constraints section) |
| Stopping conditions | `coordinating-work` SKILL.md, `_shared/conventions.md` |
| Reversibility heuristic | `designing-systems` SKILL.md |
| Output format discipline | Each pattern's Output section |

---

## Common Migration Mistakes

**❌ Still routing everything through Manager**

Manager is now a legacy agent. If you're invoking it, you're adding a hop with no benefit.

**Fix:** Use `QUICK_START.md` to pick the right pattern directly.

---

**❌ Running planning-tasks for every task**

A bug fix doesn't need a plan. `implementing-features` is for tasks where the spec is clear. Use `planning-tasks` only when you have a multi-step goal with unknowns.

---

**❌ Skipping `<context>` block**

Patterns without a `<context>` block produce generic output that doesn't match your codebase.

**Fix:** Always fill in the context block, even briefly. "Stack: Node.js, PostgreSQL" is better than nothing.

---

**❌ Using `coordinating-work` for everything**

`coordinating-work` is the meta-pattern — it helps you sequence other patterns. If your workflow is "implement then test," use `implementing-features` and `writing-tests` directly. No coordination pattern needed.

**Rule:** If you can see the sequence, don't use `coordinating-work`.

---

## Rollback

If you run into issues with patterns, **do not revert to agents**. Instead:
1. Identify the specific failure (output too vague? wrong scope? missing context?)
2. Check `TROUBLESHOOTING.md` for the fix
3. Add more context to the prompt and retry
4. If still failing, simplify the task and break it further

The agent files remain in `agents/` (and eventually `agents/_archive/`) as reference. You can still invoke them in edge cases. But the default path is patterns.
