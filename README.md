# agent-defs

Reusable agents, skills, and prompts for AI-assisted software development. Structured as a `.copilot`-compatible customization kit.

Works with **GitHub Copilot**, **Claude Code**, and any AI assistant that accepts system prompts.

---

## Structure

```
agents/           # Agent definitions (*.agent.md)
skills/           # Composable skills (SKILL.md per folder)
prompts/          # Reusable prompt files (*.prompt.md)
.context/         # Project context (decisions, retrospectives)
context_template/ # Template for generating .context/ in other projects
recipes/          # End-to-end workflow examples
build-guide/      # Build guide documentation
```

---

## Skills

Eight skills cover all software development tasks:

| Skill | When to use | File |
|---|---|---|
| `planning-tasks` | Break a goal into ordered, dependency-aware tasks | `skills/planning-tasks/SKILL.md` |
| `researching-options` | Evaluate libraries, approaches, or technologies | `skills/researching-options/SKILL.md` |
| `designing-systems` | Make an architecture decision and write an ADR | `skills/designing-systems/SKILL.md` |
| `implementing-features` | Write or modify code from a clear spec | `skills/implementing-features/SKILL.md` |
| `writing-tests` | Write and run tests for an implementation | `skills/writing-tests/SKILL.md` |
| `coordinating-work` | Orchestrate 3+ interdependent skills | `skills/coordinating-work/SKILL.md` |
| `context-review` | Sync `.context/` docs with the codebase | `skills/context-review/SKILL.md` |
| `evaluate-skill` | Evaluate a SKILL.md file for quality | `skills/evaluate-skill/SKILL.md` |

**Skill selection guide:** `skills/GUIDE.md`

---

## Agents

| Agent | File | Description |
|---|---|---|
| Manager | `agents/manager.agent.md` | Orchestrates multi-pattern workflows |
| Architect | `agents/architect.agent.md` | System design and architecture decisions |
| Planner | `agents/planner.agent.md` | Task decomposition and planning |
| Researcher | `agents/researcher.agent.md` | Technology evaluation and research |
| Coder | `agents/coder.agent.md` | Code implementation |
| Tester | `agents/tester.agent.md` | Test writing and execution |

All agents follow: [`agents/_shared/conventions.md`](agents/_shared/conventions.md)
Handoff protocol: [`agents/_shared/handoff-protocol.md`](agents/_shared/handoff-protocol.md)

---

## Quick Start

See [`QUICK_START.md`](QUICK_START.md) for copy-paste prompt templates for each skill.

**Basic pattern:**
```
Use the [skill-name] skill.

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

| Recipe | Skills used | File |
|---|---|---|
| Simple bug fix | `implementing-features` + `writing-tests` | `recipes/simple-task.md` |
| Multi-file feature | `planning-tasks` + `implementing-features` + `writing-tests` | `recipes/complex-task.md` |
| Architecture decision | `researching-options` + `designing-systems` | `recipes/design-task.md` |
| Full feature (OAuth example) | All 5 core skills | `recipes/feature-workflow.md` |

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
