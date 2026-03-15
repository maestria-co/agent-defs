# Pattern Naming Conventions

> Reference for naming `.context/patterns/` directories and SKILL.md files.
> Consistent naming ensures patterns are discoverable and self-describing.

---

## Rule: Gerund Verb + Object, Kebab-Case

Pattern directory names follow the form **`<gerund-verb>-<object>`** in lowercase kebab-case.

A gerund is the `-ing` form of a verb. It describes *what the pattern does*, not what it *is*.

**Format:** `[gerund-verb]-[object]`  
**Examples:**

| ✅ Correct | ❌ Incorrect | Why it's wrong |
|---|---|---|
| `planning-tasks` | `planner` | Noun, not action |
| `researching-options` | `research` | Not gerund |
| `designing-systems` | `architect` | Role name, not action |
| `implementing-features` | `coder` | Role name |
| `writing-tests` | `tester` | Role name |
| `coordinating-work` | `manager` | Role name |
| `evaluating-libraries` | `library-evaluation` | Object before verb |
| `reviewing-code` | `code-review` | Object before verb |

---

## Character Rules

These rules are required by the AgentSkills specification:

- **Lowercase only** — no uppercase letters
- **Alphanumeric + hyphens** — no underscores, spaces, or special characters
- **1–64 characters** in total
- **No leading or trailing hyphens** — `planning-` is invalid
- **No consecutive hyphens** — `planning--tasks` is invalid
- **`name` field must match directory name exactly** — if directory is `planning-tasks`, `name: planning-tasks`

---

## Object Noun Guidelines

The object after the gerund should be:

- **Plural** when the pattern typically processes multiple items: `planning-tasks`, `researching-options`
- **Singular** when the pattern processes one thing at a time: `designing-systems` (one design decision), `coordinating-work` (one workflow)
- **General** — prefer `implementing-features` over `implementing-user-stories` (too narrow) or `implementing` (too vague)

---

## Description Naming Cues

The `description` field in YAML frontmatter should start with a gerund phrase that mirrors the name:

```yaml
# Good
name: planning-tasks
description: >
  Breaks an ambiguous goal into ordered, concrete tasks with acceptance criteria.
  Use when: goal has 3+ distinct steps, scope is unclear, or multiple areas of the
  codebase will be touched. Do not use when: task is a single well-defined action.

# Bad — doesn't mirror the gerund convention
name: planning-tasks
description: >
  The planner helps you organize work.
```

---

## Current Pattern Registry

| Directory | `name` field | Replaces |
|---|---|---|
| `.context/patterns/planning-tasks/` | `planning-tasks` | `agents/planner.agent.md` |
| `.context/patterns/researching-options/` | `researching-options` | `agents/researcher.agent.md` |
| `.context/patterns/designing-systems/` | `designing-systems` | `agents/architect.agent.md` |
| `.context/patterns/implementing-features/` | `implementing-features` | `agents/coder.agent.md` |
| `.context/patterns/writing-tests/` | `writing-tests` | `agents/tester.agent.md` |
| `.context/patterns/coordinating-work/` | `coordinating-work` | `agents/manager.agent.md` |

---

## Existing `_skills/` Naming (For Reference)

The existing `_skills/` utility skills use noun-phrase naming:

| Directory | Style |
|---|---|
| `_skills/context-review/` | Noun phrase (`context` + verb-as-noun `review`) |
| `_skills/evaluate-skill/` | Verb + noun (`evaluate` + `skill`) |

**Note:** These predate the gerund convention. New patterns in `.context/patterns/` use the
gerund convention. Do not rename the existing `_skills/` entries.
