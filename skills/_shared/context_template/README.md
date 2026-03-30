# context_template

A portable context system for AI-assisted software development. Run the setup prompt once in any project and your AI agents — Claude Code or VS Code GitHub Copilot — start every task with the project knowledge they need instead of asking questions you've answered before.

---

## What It Produces

Running the setup prompt generates this structure in your project:

```
.context/
├── META.md                    # How to maintain this directory
├── overview.md                # Project purpose, tech stack, current phase
├── architecture.md            # System structure: layers, data flow, integrations
├── standards.md               # Code style, naming, error handling, patterns
├── testing.md                 # Test framework, file conventions, mocking
├── decisions/
│   ├── index.md               # ADR index (all decisions at a glance)
│   └── ADR-NNN-title.md       # Individual Architectural Decision Records
├── retrospectives/
│   ├── README.md              # Format guide for retrospective files
│   └── YYYY-MM-DD-TASK-ID.md  # Individual retrospective per task
├── tasks/                     # Per-task artifacts written by agents
│   └── TASK-ID/
│       ├── plan.md
│       ├── spec.md / story.md
│       └── research-*.md / code-analysis-*.md / architecture-*.md
├── workflows/                 # Optional: branching, CI/CD (if non-obvious)
└── domains/                   # Optional: entities + glossary (if domain-rich)
```

It also creates or updates `CLAUDE.md` and `.github/copilot-instructions.md` so your AI tools load this context automatically.

---

## Works With

**Claude Code (terminal):** Reads `CLAUDE.md` at project root. The `@.context/file.md` import syntax loads context files into every session automatically.

**VS Code GitHub Copilot:** Reads `.github/copilot-instructions.md` for always-on context. Reference specific files in chat with `#.context/overview.md`.

Both tools read the same `.context/` files — write once, works in both.

---

## Quick Start

1. **Install the skill kit** using `install.sh` (macOS/Linux) or `install.ps1` (Windows) from the repo root. This places `context_template/` at the known path automatically.

2. **Navigate to your project:**

   ```bash
   cd ~/my-project
   ```

3. **Paste `SETUP_PROMPT.md` into Claude Code or VS Code Copilot agent mode:**
   ```bash
   cat ~/.copilot/skills/_shared/context_template/SETUP_PROMPT.md | pbcopy
   # Claude Code users:
   cat ~/.claude/skills/_shared/context_template/SETUP_PROMPT.md | pbcopy
   # Then paste into Claude Code or Copilot chat
   ```

---

## What Each Folder Contains

| Folder          | Purpose                                                          |
| --------------- | ---------------------------------------------------------------- |
| `standards/`    | How code should be written: style, naming, error handling        |
| `architecture/` | Structural patterns, ADRs, migration history                     |
| `testing/`      | Test framework, mocking conventions, coverage rules              |
| `domains/`      | Business entities, relationships, project-specific terminology   |
| `styling/`      | UI/CSS conventions, design tokens, component patterns (optional) |
| `workflows/`    | Task execution, branching, CI/CD                                 |
| `tasks/`        | Per-task artifacts: brief, plan, research, retrospective         |

---

## After Setup

1. **Review `.context/overview.md`** — the AI fills in what it can infer from code; you fill in business goals, external links, and compliance requirements
2. **Commit `.context/` to version control** — it's project documentation, treat it like code
3. **Tell your team** — link to `META.md` so everyone knows how to keep it updated

---

## Template vs Generated Content

| Location                              | What it is                                                      |
| ------------------------------------- | --------------------------------------------------------------- |
| `~/.copilot/skills/_shared/context_template/` | Installed templates — skill kit. Not project-specific. |
| `your-project/.context/`              | Generated, project-specific, living documentation. Commit this. |

The templates in `context_template/` are the starting point. The generated `.context/` in your project is the real artifact — it should evolve with your project.

---

## Keeping `.context/` Up to Date

See `.context/META.md` for the full maintenance guide. Short version:

- After each task: create a new `YYYY-MM-DD-TASK-ID.md` in `.context/retrospectives/`
- When making an architecture decision: create a new `ADR-NNN-title.md` in `.context/decisions/` and add a row to `index.md`
- Weekly: promote lessons from retrospectives to the relevant subdirectory files
- Monthly: prune anything that no longer reflects how the project works
