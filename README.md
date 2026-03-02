# agent-defs

A reusable, platform-agnostic multi-agent system for AI-assisted software development. Drop it into any project to give your AI tools specialized roles, consistent workflows, and persistent project context.

Works with **GitHub Copilot**, **Claude Code**, and any AI assistant that accepts system prompts.

---

## What's Inside

| Directory | Purpose |
|---|---|
| `agents/` | Agent role definitions (system prompts + VS Code `.agent.md` files) |
| `agents/_shared/` | Shared conventions and handoff protocol all agents follow |
| `context_template/` | Portable `.context/` setup system for new projects |
| `planning/` | Guide for rebuilding or extending the agent system |
| `.context/` | This repo's own project context (overview, ADRs, retrospectives) |

---

## Agents

| Agent | Role |
|---|---|
| **Manager** | Coordinates all agents, interfaces with the user, synthesizes outputs |
| **Architect** | Makes system design and technology decisions, writes ADRs |
| **Planner** | Breaks goals into concrete, ordered tasks |
| **Researcher** | Gathers information, evaluates options, produces research reports |
| **Coder** | Implements code from specifications |
| **Tester** | Writes tests, validates implementations, reports on quality |

Full documentation: [`agents/README.md`](agents/README.md)

---

## Workflow

All requests flow through the **Manager**, which routes to specialists as needed:

```
User → Manager → (Planner → Researcher?) → Architect? → Coder → Tester → Manager
```

---

## Quick Start

### Option A: Direct invocation
Paste an agent file into your AI chat as a system prompt:

```
[paste contents of agents/manager.agent.md]

Hi, I need to add user authentication to my Express app.
```

### Option B: VS Code Copilot Chat
The `.agent.md` files use VS Code's `chatagent` format. Reference them directly in Copilot Chat using `@agent-name` once added to your workspace.

### Option C: Project-wide context
Reference the agents from your project's `CLAUDE.md` or `.github/copilot-instructions.md`:

```markdown
## Agent System
This project uses a multi-agent system. See agents/ for role definitions.
When handling complex tasks, follow the workflow in agents/README.md.
```

---

## Context Template

The `context_template/` directory contains a portable setup system that generates a `.context/` directory in any project — giving AI agents persistent knowledge about your codebase.

**One-time setup:**
```bash
# From your target project directory:
cat ~/tools/agent-defs/context_template/SETUP_PROMPT.md | pbcopy
# Paste into Claude Code or Copilot agent mode
```

This generates structured documentation for standards, architecture, testing, domains, and workflows — loaded automatically by both Claude Code and VS Code Copilot.

Full documentation: [`context_template/README.md`](context_template/README.md)

---

## Key Principles

- **Earn your place** — every line in an agent definition must prevent a concrete mistake
- **Simplicity first** — add complexity only when it demonstrably improves outcomes
- **File-based context** — use `.context/` for knowledge that should persist across sessions
- **Human checkpoints** — agents stop and check in before irreversible actions

---

## Adding New Agents

1. Copy an existing agent file as a starting point
2. Fill in: Purpose, Triggers, Inputs, Outputs, Responsibilities, Handoffs, Constraints, Anti-patterns
3. Add it to the roster table in [`agents/README.md`](agents/README.md)
4. Update the workflow diagram if it changes the flow
