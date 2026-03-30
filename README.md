# agent-defs

Reusable agents, skills, and prompts for AI-assisted software development. Structured as a `.copilot`-compatible customization kit.

Works with **GitHub Copilot**, **Claude Code**, and any AI assistant that accepts system prompts.

---

## Structure

```
agents/           # Agent definitions (*.agent.md)
skills/           # Composable skills (SKILL.md per folder)
                  #   _shared/context_template/ — .context/ template used by initialize-* skills
prompts/          # Reusable prompt files (*.prompt.md)
.context/         # Project context (decisions, retrospectives)
context_template/ # Template for generating .context/ in other projects
recipes/          # End-to-end workflow examples
build-guide/      # Build guide documentation
```

---

## Skills

21 skills organized into four categories:

### Infrastructure Skills

| Skill                 | When to use                                 | File                                  |
| --------------------- | ------------------------------------------- | ------------------------------------- |
| `initialize-repo`     | Set up `.context/` for a new project        | `skills/initialize-repo/SKILL.md`     |
| `context-loader`      | Load project context at task start          | `skills/context-loader/SKILL.md`      |
| `context-maintenance` | Update `.context/` after a task             | `skills/context-maintenance/SKILL.md` |
| `context-review`      | Full codebase scan to sync `.context/` docs | `skills/context-review/SKILL.md`      |
| `using-skills`        | Discover and select the right skill         | `skills/using-skills/SKILL.md`        |

### Planning & Design Skills

| Skill                 | When to use                                       | File                                  |
| --------------------- | ------------------------------------------------- | ------------------------------------- |
| `planning-tasks`      | Break a goal into ordered, dependency-aware tasks | `skills/planning-tasks/SKILL.md`      |
| `task-plan`           | Create/update canonical plan.md handoff documents | `skills/task-plan/SKILL.md`           |
| `design-first`        | Triage: design first or implement directly        | `skills/design-first/SKILL.md`        |
| `researching-options` | Evaluate libraries, approaches, or technologies   | `skills/researching-options/SKILL.md` |
| `designing-systems`   | Make an architecture decision and write an ADR    | `skills/designing-systems/SKILL.md`   |

### Implementation Skills

| Skill                   | When to use                               | File                                    |
| ----------------------- | ----------------------------------------- | --------------------------------------- |
| `implementing-features` | Write or modify code from a clear spec    | `skills/implementing-features/SKILL.md` |
| `writing-tests`         | Write and run tests for an implementation | `skills/writing-tests/SKILL.md`         |
| `systematic-debugging`  | Structured 4-phase debugging process      | `skills/systematic-debugging/SKILL.md`  |

### Discipline & Process Skills

| Skill                    | When to use                                   | File                                     |
| ------------------------ | --------------------------------------------- | ---------------------------------------- |
| `common-constraints`     | Universal agent rules (always active)         | `skills/common-constraints/SKILL.md`     |
| `verification-checklist` | Pre-completion verification with evidence     | `skills/verification-checklist/SKILL.md` |
| `testing-discipline`     | TDD practices and test quality standards      | `skills/testing-discipline/SKILL.md`     |
| `commit-discipline`      | Git commit conventions and branch management  | `skills/commit-discipline/SKILL.md`      |
| `task-retrospective`     | Structured reflection after completing tasks  | `skills/task-retrospective/SKILL.md`     |
| `knowledge-graduation`   | Promote validated patterns to reusable skills | `skills/knowledge-graduation/SKILL.md`   |
| `coordinating-work`      | Orchestrate 3+ interdependent skills          | `skills/coordinating-work/SKILL.md`      |
| `evaluate-skill`         | Evaluate a SKILL.md file for quality          | `skills/evaluate-skill/SKILL.md`         |

**Skill selection guide:** `skills/GUIDE.md`

---

## Agents

The **Manager** is the primary entry point for all multi-step development tasks. It reads project context, delegates to specialist agents, tracks progress, and enforces discipline constraints.

### Core Agents (12 total)

| Agent      | File                         | Description                                      |
| ---------- | ---------------------------- | ------------------------------------------------ |
| Manager    | `agents/manager.agent.md`    | Orchestrates workflows, delegates to specialists |
| Planner    | `agents/planner.agent.md`    | Task decomposition and planning                  |
| Researcher | `agents/researcher.agent.md` | Technology evaluation and research               |
| Architect  | `agents/architect.agent.md`  | System design and architecture decisions         |
| Coder      | `agents/coder.agent.md`      | Code implementation from specs                   |
| Tester     | `agents/tester.agent.md`     | Test writing and execution                       |
| Reviewer   | `agents/reviewer.agent.md`   | Code review for correctness and quality          |

### Orchestration Agents

| Agent             | File                                | Description                   |
| ----------------- | ----------------------------------- | ----------------------------- |
| Workspace-Manager | `agents/workspace-manager.agent.md` | Multi-project workspace tasks |
| Monorepo-Manager  | `agents/monorepo-manager.agent.md`  | Cross-package monorepo tasks  |

### Specialized Support Agents

| Agent              | File                                 | Description                     |
| ------------------ | ------------------------------------ | ------------------------------- |
| Dev-Support-Triage | `agents/dev-support-triage.agent.md` | Bug report and support triage   |
| Product-Manager    | `agents/product-manager.agent.md`    | Requirements and specifications |
| Code-Researcher    | `agents/code-researcher.agent.md`    | Deep codebase analysis          |

All agents follow: [`agents/_shared/conventions.md`](agents/_shared/conventions.md)
Handoff protocol: [`agents/_shared/handoff-protocol.md`](agents/_shared/handoff-protocol.md)

---

## Installation

Copy all skills and agents into your AI tool's config folder:

**macOS / Linux — GitHub Copilot**
```bash
./install.sh
```

**macOS / Linux — Claude Code**
```bash
./install.sh --claude
```

**Windows — GitHub Copilot**
```powershell
.\install.ps1
```

**Windows — Claude Code**
```powershell
.\install.ps1 -Claude
```

Re-run after any `git pull` to pick up updates. The `--claude` / `-Claude` flag installs to `~/.claude/skills/` and `~/.claude/agents/`, then automatically updates your `~/.claude/CLAUDE.md` with a skills reference table so Claude Code knows what's available.

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

| Recipe                       | Skills used                                                  | File                          |
| ---------------------------- | ------------------------------------------------------------ | ----------------------------- |
| Simple bug fix               | `implementing-features` + `writing-tests`                    | `recipes/simple-task.md`      |
| Multi-file feature           | `planning-tasks` + `implementing-features` + `writing-tests` | `recipes/complex-task.md`     |
| Architecture decision        | `researching-options` + `designing-systems`                  | `recipes/design-task.md`      |
| Full feature (OAuth example) | All 5 core skills                                            | `recipes/feature-workflow.md` |

---

## Context System

`skills/_shared/context_template/` contains a setup system that generates a `.context/` directory in any project — giving AI tools persistent knowledge about your codebase (standards, decisions, domain entities, workflows).

**One-time setup:**

```bash
# From your target project directory:
cat ~/.copilot/skills/_shared/context_template/SETUP_PROMPT.md | pbcopy
# Paste into Claude Code or Copilot agent mode
```

Full documentation: [`skills/_shared/context_template/README.md`](skills/_shared/context_template/README.md)

---

## Troubleshooting

Pattern output too vague? Wrong scope? Test blocked? See [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

---

## Key Principles

- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **Context awareness** — write state to `.context/` before context clears; use git as checkpoints
- **Human checkpoints** — stop and check in after 3–5 major actions or before irreversible changes
- **Verify before done** — check each acceptance criterion explicitly before signaling completion
