# Setup Prompt for .context/

> Generate project-specific context files that give AI agents the information they need to work effectively in your codebase.

## Before You Run

- [ ] You are in the root directory of your project (not `agent-defs`)
- [ ] The project has at least some existing source files to scan
- [ ] You know the path where `agent-defs` is cloned (needed in Step 3)
- [ ] You have write access to the repository

## How to Use

Copy the prompt below and paste it into **Claude Code** (terminal, agent mode) or **VS Code Copilot** (agent mode). It works verbatim in both tools and generates populated `.context/` files tailored to your codebase.

## Setup Prompt

```
You are setting up the `.context/` memory system for this project. Complete all steps without stopping.

## Step 1 — Scan the Project

Read the following to understand the project:
- `package.json` / `requirements.txt` / `Cargo.toml` / `go.mod` (whichever exists) — detect language, framework, key libraries, test framework
- The top-level directory structure (`ls` or equivalent)
- 3-5 representative source files from the main application logic
- 2-3 existing test files
- Any existing `README.md`

From this scan, identify:
- Primary language and version
- Web framework (if any)
- Database and ORM/query library (if any)
- Test framework and how tests are run
- Directory structure pattern (feature-based? layer-based? monorepo?)
- Key third-party dependencies worth documenting
- Actual file paths to use as examples (e.g., a real service file, a real test file)

## Step 2 — Create Directory Structure

Create the following directories if they don't exist:
```
.context/
.context/standards/
.context/architecture/
.context/testing/
.context/domains/
.context/workflows/
.context/tasks/
```

## Step 3 — Copy Universal Files Verbatim

These files are universal (not project-specific). Copy them exactly from the agent-defs template.

Replace `[AGENT_DEFS_PATH]` with the actual path to the agent-defs repo on this machine:

- Copy `[AGENT_DEFS_PATH]/context_template/context/META.md` → `.context/META.md`
- Copy `[AGENT_DEFS_PATH]/context_template/context/retrospectives.md` → `.context/retrospectives.md`
- Copy `[AGENT_DEFS_PATH]/context_template/context/workflows/task-workflow-template.md` → `.context/workflows/task-workflow-template.md`

## Step 4 — Generate Project-Specific Files

For each file below, generate project-specific content based on Step 1. Replace every [PLACEHOLDER] with actual content. Use real file paths from this codebase as examples — never generic ones.

| File | How to fill it |
|---|---|
| `.context/overview.md` | Infer from package.json + directory structure. Leave a `<!-- TODO: [reason] -->` note for anything you cannot determine. |
| `.context/decisions.md` | Document 1–2 visible architectural choices as ADR entries (monorepo structure, framework choice, specific patterns). |
| `.context/standards/code-style.md` | Infer from reading 3+ source files: file organization, import order, comment style. |
| `.context/standards/naming-conventions.md` | Infer from actual file names and code read in Step 1. Use real file names as examples. |
| `.context/standards/error-handling.md` | Find error handling in existing code. Document the actual pattern. Note inconsistencies if present. |
| `.context/architecture/patterns-template.md` | Identify 1–2 recurring patterns (e.g., data access structure). Document with real code file paths. |
| `.context/architecture/migration-guide-template.md` | If a `migrations/` folder exists, document the most recent migration as example. Otherwise keep the placeholder. |
| `.context/testing/unit-testing.md` | Read 2–3 test files. Document actual framework, file naming, mocking approach. Use real test paths. |
| `.context/testing/integration-testing.md` | If integration tests exist, document how they're structured. If not, fill with unit test framework as baseline suggestion. |
| `.context/domains/entities.md` | Find main data models (schema files, TypeScript interfaces, ORM models). Document 2–3 key entities with business rules you can infer. |
| `.context/domains/glossary.md` | Infer terms from model names, function names, README, and comments. Add any word with a project-specific meaning. |
| `.context/workflows/branching.md` | Check `.github/`, `git branch -a`, or CONTRIBUTING.md. Document what you find; use sensible defaults if nothing exists. |
| `.context/workflows/ci-cd.md` | Check `.github/workflows/` or other CI config. Document what's there; fall back to local commands if no CI exists. |

## Step 5 — Update AI Configuration Files

**For Claude Code — create or update `CLAUDE.md`:**
If `CLAUDE.md` exists, add the following block at the top (do not remove existing content):
```
## Project Context

See @.context/overview.md for project overview and tech stack.
See @.context/standards/ for coding standards and conventions.
See @.context/architecture/ for architectural patterns and decisions.
See @.context/domains/ for domain entities and terminology.
See @.context/workflows/ for task workflow and branching strategy.
```

If `CLAUDE.md` does not exist, create it at the project root with the block above.

**For VS Code GitHub Copilot — create or update `.github/copilot-instructions.md`:**
Create `.github/` if it doesn't exist. Create or update `.github/copilot-instructions.md`:
```
## Project Context

Read `.context/overview.md` for project overview and tech stack before starting any task.
Read `.context/standards/` files for coding conventions.
Read `.context/architecture/` files for structural patterns.
Read `.context/domains/entities.md` for domain model and business rules.
Read `.context/workflows/task-workflow-template.md` for how tasks should be executed.

Reference specific context files in your prompts with `#` (e.g., `#.context/overview.md`).
```

**If agent-defs patterns are available**, also add to both files:
```
## Pattern System

Agentless task patterns are in `skills/`. Select a pattern by task type:
- planning-tasks: break a goal into ordered steps
- researching-options: evaluate libraries or approaches
- designing-systems: architecture decisions and ADRs
- implementing-features: write or modify code
- writing-tests: write and run tests
- coordinating-work: orchestrate multi-pattern workflows
See `skills/GUIDE.md` for the full selection guide.
```

## Step 6 — Final Review Request

After creating all files:
1. List every file created and any sections left as `<!-- TODO -->`
2. Ask the user to review `.context/overview.md` and fill in: business goals, external links, compliance constraints, and current development phase — these cannot be inferred from code alone.

Do not stop before completing all 6 steps.
```
