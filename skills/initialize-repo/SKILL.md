---
name: initialize-repo
description: >
  Automates the setup of `.context/` for a new project. Use this skill whenever
  someone mentions setting up a new repository, onboarding a project to the agent
  system, bootstrapping context, or when you detect a project has no `.context/`
  directory. Also use when someone says "initialize", "set up", or "configure" in
  relation to project context, or when cloning agent-defs for the first time.
  Skip only when `.context/` already exists and is populated — in that case use
  `context-review` instead.
user-invocable: true
---

# Skill: Initialize Repository

## Purpose

Set up the `.context/` knowledge base for a project so that AI agents and developers
start every task informed. This skill runs once per repository. It detects the project's
characteristics, copies the context template, populates it with inferred details, and
configures AI tool integration files.

If `.context/` already exists with content, do not overwrite — use `context-review` instead.

---

## Pre-flight Checks

**Check 1 — Verify no existing context**

Look for `.context/overview.md` in the current working directory.

- If it exists and has content beyond placeholders → **Abort.** Report: "`.context/` already exists. Use `context-review` to update it."
- If it does not exist, or contains only `[PLACEHOLDER]` markers → proceed.

**Check 2 — Locate the agent-defs template**

Find the `context_template/` directory. Check these locations in order:

1. `../agent-defs/context_template/` (sibling directory)
2. `~/tools/agent-defs/context_template/`
3. `~/.copilot/context_template/`
4. Ask the user for the path

- If found → note the path.
- If not found → **fall back** to generating files from scratch using the structure in Step 2.

---

## Execution Steps

### Step 1 — Detect Project Characteristics

Scan the project to identify its stack. Check these files:

| File                                  | Detects                                            |
| ------------------------------------- | -------------------------------------------------- |
| `package.json`                        | Node.js — framework, test runner, key dependencies |
| `requirements.txt` / `pyproject.toml` | Python — framework, testing library                |
| `*.csproj` / `*.sln`                  | .NET — framework, target version                   |
| `pom.xml` / `build.gradle`            | Java/Kotlin — framework, build tool                |
| `Cargo.toml`                          | Rust — edition, key crates                         |
| `go.mod`                              | Go — module path, dependencies                     |

Also scan:

- **Top-level directory structure** — identify feature-based vs. layer-based organization
- **3–5 representative source files** — infer naming conventions, code style, error handling patterns
- **2–3 test files** — identify test framework, mocking approach, file naming pattern
- **`.github/workflows/`** or other CI config — identify CI/CD pipeline
- **Git history** — `git log --oneline -20` for recent activity; `git branch -a` for branching patterns

Record findings. These feed into Step 3.

### Step 2 — Create Directory Structure

Create the following directories:

```bash
mkdir -p .context/{standards,architecture,testing,domains,styling,workflows,tasks}
```

### Step 3 — Copy and Populate Files

**Universal files (copy verbatim from template):**

- `META.md`
- `retrospectives.md`
- `workflows/task-workflow-template.md`

**Project-specific files (generate from Step 1 scan):**

| File                                       | Generation approach                                                                                                  |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| `overview.md`                              | Infer from manifest + directory structure. Leave `<!-- TODO -->` for unknowable fields (business goals, compliance). |
| `decisions.md`                             | Document 1–2 visible architectural choices (monorepo structure, framework choice, patterns).                         |
| `standards/code-style.md`                  | Infer from reading 3+ source files: file organization, import order, comment style.                                  |
| `standards/naming-conventions.md`          | Infer from actual file/variable/function names. Use real file names as examples.                                     |
| `standards/error-handling.md`              | Find error handling in existing code. Document the actual pattern.                                                   |
| `architecture/patterns-template.md`        | Identify 1–2 recurring patterns. Document with real code file paths.                                                 |
| `architecture/migration-guide-template.md` | If `migrations/` exists, document the most recent one. Otherwise keep placeholder.                                   |
| `testing/unit-testing.md`                  | Read test files. Document actual framework, naming, mocking approach.                                                |
| `testing/integration-testing.md`           | If integration tests exist, document structure. Otherwise, baseline suggestion.                                      |
| `domains/entities.md`                      | Find main data models. Document 2–3 key entities with inferred business rules.                                       |
| `domains/glossary.md`                      | Infer terms from model names, function names, README, comments.                                                      |
| `workflows/branching.md`                   | Check git branches, `.github/`, CONTRIBUTING.md. Sensible defaults if nothing exists.                                |
| `workflows/ci-cd.md`                       | Check CI config. Document what's there; fall back to local commands.                                                 |
| `styling/style-guide-template.md`          | If frontend exists (React, Vue, etc.), scan for CSS approach. Skip for backend-only.                                 |

### Step 4 — Configure AI Tool Integration

**For Claude Code — create or update `CLAUDE.md`:**

Add at the top (preserve existing content):

```markdown
## Project Context

See @.context/overview.md for project overview and tech stack.
See @.context/standards/ for coding standards and conventions.
See @.context/architecture/ for architectural patterns and decisions.
See @.context/domains/ for domain entities and terminology.
See @.context/workflows/ for task workflow and branching strategy.
```

**For VS Code Copilot — create or update `.github/copilot-instructions.md`:**

```markdown
## Project Context

Read `.context/overview.md` for project overview and tech stack before starting any task.
Read `.context/standards/` files for coding conventions.
Read `.context/architecture/` files for structural patterns.
Read `.context/domains/entities.md` for domain model and business rules.
Read `.context/workflows/task-workflow-template.md` for how tasks should be executed.
```

### Step 5 — Verification

Confirm all required files exist and are non-empty:

```bash
# Check all expected files exist
for f in .context/META.md .context/overview.md .context/decisions.md \
         .context/retrospectives.md .context/standards/code-style.md \
         .context/standards/naming-conventions.md .context/standards/error-handling.md \
         .context/testing/unit-testing.md .context/domains/entities.md \
         .context/workflows/branching.md; do
  [ -s "$f" ] && echo "✅ $f" || echo "❌ $f — missing or empty"
done
```

---

## Output Format

```
Initialized: .context/ for [project name]

Tech stack detected: [language, framework, test runner]
Files created: [count]
Files with TODOs: [count] — these need human input

Next steps:
1. Review .context/overview.md — fill in business goals, external links, compliance
2. Commit .context/ to version control
3. Tell your team — link to META.md
```

---

## Constraints

- Never overwrite existing `.context/` files that have content beyond placeholders
- Use real file paths from the codebase in examples — never generic ones
- Leave `<!-- TODO: [reason] -->` for anything that cannot be inferred from code
- Do not invent business rules — only document what's visible in the code
- Do not modify source code during this skill — only `.context/`, `CLAUDE.md`, and `copilot-instructions.md`
