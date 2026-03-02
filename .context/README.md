# .context/

This directory is the persistent memory of the AI agent system. It stores project knowledge, architectural decisions, and learnings that agents read at the start of tasks and write to after completing significant work.

Unlike code, this directory captures the **why** behind decisions and the **what was learned** from doing the work.

---

## Structure

```
.context/
  README.md               ← This file: how the context system works
  project-overview.md     ← High-level project description (start here)
  decisions/
    README.md             ← ADR index and format guide
    ADR-001-*.md          ← Architecture Decision Records
  retrospectives/
    README.md             ← How the retro log works
    template.md           ← Template for new retro entries
    YYYY-MM-DD.md         ← Daily/weekly retro log entries
```

---

## State Management for Long Tasks

For tasks that span multiple sessions or long context windows, use structured state files alongside the `.context/` markdown:

| State type | Format | Location | Purpose |
|---|---|---|---|
| Task progress | `progress.json` | `.context/` | Machine-readable list of completed/pending steps |
| Test tracking | `tests.json` | `.context/` | Test results and coverage status per task |
| Freeform notes | `YYYY-MM-DD.md` | `.context/retrospectives/` | General progress notes, blockers, decisions |
| Code state | git commits | repo | What changed and when — always commit completed work |

**When context is about to clear:**
1. Write current progress to a state file
2. Commit completed work via git
3. Note the next step explicitly in the state file
4. A fresh context can read `git log --oneline`, the state file, and `project-overview.md` to resume exactly

**Starting from a fresh context:**
```
1. git log --oneline -10       # What was recently done
2. cat .context/project-overview.md  # Project facts
3. cat .context/progress.json  # Current task state (if exists)
4. cat .context/retrospectives/[latest].md  # Recent learnings
```

---

## How Agents Use This Directory

### Reading (before starting work)
Agents should read relevant context before beginning any non-trivial task:
- Always read `project-overview.md` for project-level context
- Read `decisions/` entries relevant to the area being worked in
- Skim recent `retrospectives/` entries for recent learnings

### Writing (after completing work)
Agents write back to `.context/` when they:
- Make a significant architecture or design decision → `decisions/ADR-NNN-title.md`
- Complete a task with learnings worth preserving → `retrospectives/YYYY-MM-DD.md`
- Discover facts about the project that aren't documented → `project-overview.md`

---

## The Learning Loop

```
Agent does work
      │
      ▼
Agent appends to retrospectives/YYYY-MM-DD.md
      │
      ▼
Human reviews retrospective entries periodically
      │
      ▼
Valuable learnings are promoted:
  - Patterns → agent definition files (agents/*.md)
  - Decisions → decisions/ADR-NNN-*.md
  - Project facts → project-overview.md
      │
      ▼
Agents are smarter next time
```

This loop is how the system improves over time without requiring manual updates to every agent file.

---

## Rules

- **Never delete entries** from decisions/ or retrospectives/. Superseded ADRs are marked "Superseded" but kept.
- **Keep project-overview.md current.** It's the first thing every agent reads.
- **Be specific in retro entries.** Vague entries ("things went well") have no learning value.
- **Humans promote, agents append.** Agents write raw learnings. Humans decide what gets elevated to permanent documentation.
