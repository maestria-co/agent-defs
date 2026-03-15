# Pattern Template Reference

> Reference document for Phase 2 pattern authors.
> Every SKILL.md in `.context/patterns/` must follow this structure.

---

## Canonical SKILL.md Structure

```markdown
---
name: <gerund-verb-object>
description: >
  One sentence: what the pattern does. Use when: [trigger condition 1],
  [trigger condition 2]. Do not use when: [anti-trigger].
degree_of_freedom: high | medium | low
---

# Skill: <Human Readable Title>

## Purpose

One paragraph. What this pattern does, when to reach for it, what it produces.
Include the "anti-pattern" — when NOT to use this pattern.

---

## Pre-flight Checks

Run these checks before starting. If a check fails, stop and resolve before proceeding.

**Check 1 — [Name]**

[What to check and why. Define pass and fail outcomes explicitly.]

- If [condition] → [action]
- If [other condition] → [other action]

**Check 2 — [Name]**

[What to check.]

---

## Execution Steps

Work through each step in order.

### Step 1 — [Verb + Object]

[Imperative instructions. Every branch must have a defined outcome — no "handle as appropriate".]

### Step 2 — [Verb + Object]

[...]

### Step N — Produce Output

Write output to [location]. Use this format:

\`\`\`
[output format template]
\`\`\`

---

## Examples

<examples>

<example>
<scenario>[What task this addresses]</scenario>
<input>
<task>[What the user wants]</task>
<context>[Relevant background]</context>
</input>
<output>
[What this pattern produces — abbreviated but representative]
</output>
</example>

<example>
[Second example — different task type or domain]
</example>

<example>
[Third example — edge case or complex scenario]
</example>

</examples>

---

## Constraints

- [What this pattern must NOT do]
- [Scope boundary: which files/dirs it reads/writes]
- [What to do if blocked: state it explicitly and stop]
```

---

## Required Fields Checklist

| Field | Requirement |
|---|---|
| `name` | Lowercase, alphanumeric + hyphens only. Must match parent directory name. |
| `description` | 1–1024 chars. Must include "Use when" trigger. |
| `degree_of_freedom` | One of: `high`, `medium`, `low` |
| Pre-flight checks | At least 1. Every branch has a defined outcome. |
| Execution steps | Numbered, imperative verbs. No vague language ("handle", "manage"). |
| Examples | 3–5. Use XML `<example>` tags. Use `<task>`, `<context>`, `<output>` inside. |
| Constraints | At least 3 explicit things this pattern must NOT do. |
| File length | Under 500 lines. Move heavy reference material to `references/` subdirectory. |

---

## Naming Conventions

See `PATTERN_NAMING.md` for full naming guide.

**Quick reference:** Directory name = gerund + object, kebab-case.

| Pattern | Directory |
|---|---|
| Planning pattern | `planning-tasks/` |
| Research pattern | `researching-options/` |
| Architecture pattern | `designing-systems/` |
| Implementation pattern | `implementing-features/` |
| Testing pattern | `writing-tests/` |
| Coordination pattern | `coordinating-work/` |
