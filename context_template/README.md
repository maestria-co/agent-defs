# context_template

A portable context system for AI-assisted software development. Run the setup prompt once in any project and your AI agents — Claude Code or VS Code GitHub Copilot — start every task with the project knowledge they need instead of asking questions you've answered before.

---

## What It Produces

Running the setup prompt generates this structure in your project:

```
.context/
├── META.md                          # How to maintain this directory
├── overview.md                      # Project overview, tech stack, team conventions
├── decisions.md                     # Architectural Decision Records (ADRs)
├── retrospectives.md                # Rolling lessons-learned log
├── standards/
│   ├── code-style.md                # File organization, imports, comments, formatting
│   ├── naming-conventions.md        # File, variable, function, class, test naming
│   └── error-handling.md            # Error types, logging, validation patterns
├── architecture/
│   ├── patterns-template.md         # Structural patterns agents must follow
│   └── migration-guide-template.md  # DB/API migration documentation
├── testing/
│   ├── unit-testing.md              # Framework, mocking strategy, test structure
│   └── integration-testing.md       # What to integration test and how
├── domains/
│   ├── entities.md                  # Core domain models and business rules
│   └── glossary.md                  # Project-specific terminology
├── workflows/
│   ├── task-workflow-template.md    # 8-phase task execution workflow
│   ├── branching.md                 # Git branching strategy
│   └── ci-cd.md                     # CI/CD pipeline documentation
└── tasks/                           # Per-task artifacts (brief, plan, retro)
```

It also creates or updates `CLAUDE.md` and `.github/copilot-instructions.md` so your AI tools load this context automatically.

---

## Works With

**Claude Code (terminal):** Reads `CLAUDE.md` at project root. The `@.context/file.md` import syntax loads context files into every session automatically.

**VS Code GitHub Copilot:** Reads `.github/copilot-instructions.md` for always-on context. Reference specific files in chat with `#.context/overview.md`.

Both tools read the same `.context/` files — write once, works in both.

---

## Quick Start

1. **Clone or install agent-defs** somewhere on your machine:
   ```bash
   git clone https://github.com/[org]/agent-defs ~/tools/agent-defs
   ```

2. **Navigate to your project:**
   ```bash
   cd ~/my-project
   ```

3. **Paste `SETUP_PROMPT.md` into Claude Code or VS Code Copilot agent mode:**
   ```bash
   cat ~/tools/agent-defs/context_template/SETUP_PROMPT.md | pbcopy
   # Then paste into Claude Code or Copilot chat
   ```
   Update `[AGENT_DEFS_PATH]` in the prompt to the actual path before running.

---

## What Each Folder Contains

| Folder | Purpose |
|---|---|
| `standards/` | How code should be written: style, naming, error handling |
| `architecture/` | Structural patterns, ADRs, migration history |
| `testing/` | Test framework, mocking conventions, coverage rules |
| `domains/` | Business entities, relationships, project-specific terminology |
| `workflows/` | Task execution, branching, CI/CD |
| `tasks/` | Per-task artifacts: brief, plan, research, retrospective |

---

## After Setup

1. **Review `.context/overview.md`** — the AI fills in what it can infer from code; you fill in business goals, external links, and compliance requirements
2. **Commit `.context/` to version control** — it's project documentation, treat it like code
3. **Tell your team** — link to `META.md` so everyone knows how to keep it updated

---

## Template vs Generated Content

| Location | What it is |
|---|---|
| `agent-defs/context_template/` | Generic templates — this repository. Not project-specific. |
| `your-project/.context/` | Generated, project-specific, living documentation. Commit this. |

The templates in `context_template/` are the starting point. The generated `.context/` in your project is the real artifact — it should evolve with your project.

---

## Keeping `.context/` Up to Date

See `.context/META.md` for the full maintenance guide. Short version:
- After each task: add a retrospective entry
- Weekly: promote lessons from retrospectives to subdirectory files
- Monthly: prune anything that no longer reflects how the project works
