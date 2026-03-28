---
name: common-constraints
description: >
  Universal rules that all agents must follow to prevent rationalization, infinite loops,
  and unchecked work. Referenced by every other skill implicitly. Use when: any agent
  is performing work — these constraints are always active.
user-invocable: false
---

# Skill: Common Constraints

## Purpose

Non-negotiable rules that prevent catastrophic agent failures. These are not guidelines —
they are hard constraints. Every agent, every skill, every task.

This skill extends what `skills/_shared/conventions.md` covers (tone, format, simplicity)
with behavioral constraints that prevent specific failure modes.

---

## Constraint 1: Evidence Requirement

**"It should work" is not verification.**

Never claim success without proof. Proof means:

- Command output showing the test passed
- File contents showing the change was applied
- Build output showing no errors
- Screenshot or log showing the feature works

### Violations

```
BAD:  "I've updated the config file. The server should now start correctly."
GOOD: "I've updated the config file. Running `npm start` produces: 'Server listening on port 3000'."

BAD:  "Tests are passing."
GOOD: "Running `npm test` — 47 tests passed, 0 failed. Output: [paste]"
```

### Rule

Before reporting a task as complete, show at least one piece of concrete evidence
that the acceptance criteria are met.

---

## Constraint 2: Failure Escalation

**After 3 failed attempts at the same approach, stop.**

Agents can get stuck in loops — trying the same fix repeatedly, each time believing
"this time it will work." This constraint breaks the loop.

### Protocol

1. **Attempt 1:** Try the approach
2. **Attempt 2:** If it fails, adjust and try again
3. **Attempt 3:** If it fails again, make one more targeted attempt
4. **After 3 failures:** Stop. Report to user with:
   - What was attempted (all 3 approaches)
   - What failed and why
   - What you think the root cause might be
   - Suggested next steps (that you haven't tried)

### When to Reset the Counter

The counter resets when you try a **fundamentally different approach** — not a tweak
of the same approach. Changing a parameter is not a new approach. Switching from
"fix the config" to "replace the dependency" is.

---

## Constraint 3: Read-First Discipline

**Never modify code without reading surrounding context first.**

### Before Modifying a File

1. Read the file (at least the relevant section + 20 lines above and below)
2. Read related files (imports, callers, tests)
3. Check `.context/standards/` for project-specific patterns
4. Only then make changes

### Before Modifying Configuration

1. Read the current config file completely
2. Check if other config files reference it
3. Check `.context/` for any documented configuration patterns
4. Only then make changes

### Violations

```
BAD:  Adding a new function to a file without reading the existing functions
GOOD: Reading the file first, noticing the existing patterns, then adding
      a function that follows the same patterns

BAD:  Changing a build config without reading what it currently does
GOOD: Reading the config, understanding each section, then making targeted changes
```

---

## Constraint 4: Convention Adherence

**Check `.context/standards/` before implementing.**

Project conventions exist for consistency. Don't invent new patterns when the project
already has established ones.

### Lookup Order

1. `.context/standards/code-style.md` — formatting, structure, imports
2. `.context/standards/naming-conventions.md` — how things are named
3. `.context/standards/error-handling.md` — how errors are handled
4. Existing code in the same module — match the local style
5. Language/framework defaults — only if no project conventions exist

### When Conventions Conflict

If you notice a conflict between documented conventions and actual code:

- Follow the **documented convention** in your new code
- Note the conflict in your progress log or retrospective
- Do not silently adopt the non-conforming pattern

---

## Constraint 5: Self-Review Gate

**Review your own work before declaring completion.**

Before reporting a task as done, run through these questions:

1. **Does it work?** (Evidence Requirement — Constraint 1)
2. **Does it follow conventions?** (Convention Adherence — Constraint 4)
3. **Did I read before modifying?** (Read-First — Constraint 3)
4. **Are there edge cases I haven't considered?**
5. **Would I approve this in a code review?**

If any answer is "no" or "I'm not sure," fix it before reporting completion.

---

## Constraint 6: Scope Discipline

**Do only what was asked. Do not gold-plate.**

- Fix the bug that was reported — don't refactor the entire module
- Implement the feature as specified — don't add "nice to have" extras
- If you notice something that should be fixed but is out of scope,
  note it in the progress log — don't fix it silently

### Exceptions

You may expand scope when:

- The original fix would introduce a bug without the additional change
- A function you're touching has an obvious error (off-by-one, null deref)
- The user explicitly asked you to "clean up as you go"

---

## Quick Reference

| Constraint  | One-liner                   |
| ----------- | --------------------------- |
| Evidence    | Show proof, not claims      |
| Escalation  | 3 strikes → stop and report |
| Read-first  | Understand before changing  |
| Conventions | Follow project patterns     |
| Self-review | Check your own work         |
| Scope       | Do what was asked, no more  |
