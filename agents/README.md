# Agent Definitions

This directory contains reusable, platform-agnostic AI agent definitions for software development teams. Each agent is a markdown file with a detailed system prompt, designed to be loaded into any AI assistant (GitHub Copilot, Claude, ChatGPT, etc.).

---

## What Are Agents?

An agent is an AI assistant operating under a specific role with clear responsibilities, constraints, and behaviors. Rather than using a single general-purpose AI for everything, agents give the AI a focused identity and set of rules — making outputs more consistent, predictable, and high-quality.

Think of agents like specialized team members:
- You wouldn't ask your QA engineer to design your database schema.
- You wouldn't ask your architect to write unit tests.
- Same principle applies here.

---

## Agent Roster

| Agent | Reference Doc | Operational Agent | One-Sentence Role |
|---|---|---|---|
| **Manager** | `manager.md` | `manager.agent.md` | Coordinates all agents, interfaces with the user, and synthesizes final outputs. |
| **Architect** | `architect.md` | `architect.agent.md` | Makes system design and technology decisions, and documents them as ADRs. |
| **Planner** | `planner.md` | `planner.agent.md` | Breaks goals into concrete, ordered tasks with clear inputs and outputs. |
| **Researcher** | `researcher.md` | `researcher.agent.md` | Gathers information, evaluates options, and produces written research reports. |
| **Coder** | `coder.md` | `coder.agent.md` | Implements code from specifications, following team conventions and patterns. |
| **Tester** | `tester.md` | `tester.agent.md` | Writes tests, validates implementations, and reports on quality and coverage. |

> **`.agent.md` files** — condensed operational definitions in VS Code `chatagent` format (YAML frontmatter with `description`, `model`, `tools`, `agents`, `handoffs`). Use these when invoking agents directly in VS Code Copilot Chat.  
> **`.md` files** — full reference documentation with detailed workflows, examples, anti-patterns, and changelogs. Use these as the source of truth when refining agent behavior.

---

## Workflow Overview

All user requests flow through the **Manager**. The Manager decides which specialists to invoke and in what order.

```
User Request
    │
    ▼
 Manager  ◄──────────────────────────────────────────┐
    │                                                 │
    ├──► Planner      (decompose the work)            │
    │       └──► Researcher  (if unknowns exist)      │
    │                                                 │
    ├──► Architect    (design decisions needed)       │
    │                                                 │
    ├──► Coder        (implementation)                │
    │                                                 │
    └──► Tester       (validation & quality)          │
              └──► Report back to Manager ────────────┘
```

**Typical flow for a new feature:**
1. User describes the goal to **Manager**
2. **Manager** asks **Planner** to break it down
3. **Planner** identifies unknowns → **Researcher** fills gaps
4. **Manager** asks **Architect** to review design decisions
5. **Manager** asks **Coder** to implement
6. **Coder** signals done → **Tester** validates
7. **Manager** reports outcome to user

---

## How to Use These Agents

### Option A: Direct invocation (Copilot / Claude chat)
Paste the contents of an agent file at the start of your conversation as a system prompt, then proceed with your request.

```
[paste contents of agents/manager.md]

Hi, I need to add user authentication to my Express app.
```

### Option B: Reference in your project's copilot-instructions.md
Add a reference to these agents so Copilot knows they exist:

```markdown
# Agent Roles
This project uses a multi-agent system. See agents/ for role definitions.
When handling complex tasks, follow the workflow defined in agents/README.md.
```

### Option C: Invoke by role name
In a Copilot or Claude conversation, reference an agent by role:

```
Act as the Planner agent (see agents/planner.md) and break down this task: ...
```

---

## Shared Resources

All agents follow the rules in `_shared/`:

| File | Purpose |
|---|---|
| `_shared/conventions.md` | Tone, format, tool-use rules shared by all agents |
| `_shared/handoff-protocol.md` | How agents hand work off to each other |

---

## Context & Memory

Agents use the `.context/` directory to persist knowledge across sessions:

| Path | Purpose |
|---|---|
| `.context/project-overview.md` | High-level project description, goals, tech stack |
| `.context/decisions/` | Architecture Decision Records (ADRs) |
| `.context/retrospectives/` | Rolling learning log — agents append, humans promote |

**Before starting work**, agents should read `.context/project-overview.md` if it exists.  
**After significant decisions**, agents should write to `.context/decisions/`.  
**After completing tasks**, agents should append to the current retrospective log.

---

## Adding New Agents

When a new specialized role is needed:

1. Copy the structure from an existing agent file
2. Fill in all sections: Purpose, Triggers, Inputs, Outputs, Responsibilities, Handoffs, Constraints, Anti-patterns, Example
3. Add the agent to the roster table in this README
4. Update the workflow diagram if the agent changes the flow
5. Add a shared conventions reference in the agent's preamble

---

## Versioning

These agent definitions are version-controlled alongside your code. When you make significant changes to an agent's behavior:
- Update the agent file
- Note the change reason in the file's changelog section (bottom of each agent file)
- Append a retrospective entry explaining what changed and why
