# agent-defs

Composable task patterns for AI-assisted software development. Pick a pattern for your task, run it directly, get expert-quality output — no routing, no orchestration overhead.

Works with **GitHub Copilot**, **Claude Code**, and any AI assistant that accepts system prompts.

---

## Patterns

Six patterns cover all software development tasks:

| Pattern | When to use | File |
|---|---|---|
| `planning-tasks` | Break a goal into ordered, dependency-aware tasks | `.context/patterns/planning-tasks/SKILL.md` |
| `researching-options` | Evaluate libraries, approaches, or technologies | `.context/patterns/researching-options/SKILL.md` |
| `designing-systems` | Make an architecture decision and write an ADR | `.context/patterns/designing-systems/SKILL.md` |
| `implementing-features` | Write or modify code from a clear spec | `.context/patterns/implementing-features/SKILL.md` |
| `writing-tests` | Write and run tests for an implementation | `.context/patterns/writing-tests/SKILL.md` |
| `coordinating-work` | Orchestrate 3+ interdependent patterns | `.context/patterns/coordinating-work/SKILL.md` |

**Pattern selection guide:** `.context/patterns/GUIDE.md`

---

## Quick Start

See [`QUICK_START.md`](QUICK_START.md) for copy-paste prompt templates for each pattern.

**Basic pattern:**
```
Use the [pattern-name] skill.

<task>[what you want to do]</task>
<context>
Stack: [language/framework]
Relevant files: [paths]
Constraints: [any limits]
</context>
```

---

## Workflow Recipes

End-to-end examples for common development tasks:

| Recipe | Patterns used | File |
|---|---|---|
| Simple bug fix | `implementing-features` + `writing-tests` | `recipes/simple-task.md` |
| Multi-file feature | `planning-tasks` + `implementing-features` + `writing-tests` | `recipes/complex-task.md` |
| Architecture decision | `researching-options` + `designing-systems` | `recipes/design-task.md` |
| Full feature (OAuth example) | All 5 patterns | `recipes/feature-workflow.md` |

---

## Context System

`context_template/` contains a setup system that generates a `.context/` directory in any project — giving AI tools persistent knowledge about your codebase (standards, decisions, domain entities, workflows).

**One-time setup:**
```bash
# From your target project directory:
cat ~/tools/agent-defs/context_template/SETUP_PROMPT.md | pbcopy
# Paste into Claude Code or Copilot agent mode
```

Full documentation: [`context_template/README.md`](context_template/README.md)

---

## Troubleshooting

Pattern output too vague? Wrong scope? Test blocked? See [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

---

## Key Principles

- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **Context awareness** — write state to `.context/` before context clears; use git as checkpoints
- **Human checkpoints** — stop and check in after 3–5 major actions or before irreversible changes
- **Verify before done** — check each acceptance criterion explicitly before signaling completion

---

## Legacy: Multi-Agent System

> The original agent-based system (Manager, Planner, Researcher, Architect, Coder, Tester) has been archived. It still works but is no longer the recommended approach.

Agent files: `agents/_archive/`  
Migration guide: [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md)  
Why patterns instead: See `MIGRATION_GUIDE.md#Replacing the Handoff Protocol`
