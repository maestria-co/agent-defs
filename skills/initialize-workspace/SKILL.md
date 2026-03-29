---
name: initialize-workspace
description: |
  Bootstrap the agent-system context for every project in a VS Code multi-root workspace.
  Use when setting up the agent system for a workspace with multiple projects, or when
  adding context bootstrapping to a multi-project environment.
user-invocable: true
---

# Skill: Initialize Workspace

## Purpose

Run `initialize-repo` (or `upgrade-repo` if `.context/` already exists) across all
projects in a VS Code multi-root workspace, then generate workspace-level cross-project
context for the workspace-manager agent to use.

## Process

1. **Locate the workspace file** — `find . -name "*.code-workspace" -maxdepth 2`
2. **Parse** the `folders` array from the JSON file
3. **Classify each folder** — Is it a project (has source code) or a resource (docs, shared config)?
4. **Branch guard** — For each git repository, check current branch. If on `main`/`master`, create a `context-bootstrap` branch before making any changes.
5. **Per-project initialization:**
   - No `.context/` exists → apply `initialize-repo` skill
   - `.context/` exists → review and update using `context-maintenance` skill
   - Each project runs independently to prevent context pollution
6. **Workspace-level context** (after all projects are initialized):
   - Create `.context/workspace-overview.md` at the workspace root
   - Document cross-project relationships: shared libraries, API contracts, shared config
   - List all projects with tech stacks and entry points
7. **Create a PR per repository** with the `.context/` changes

## Workspace Overview Template

```markdown
# Workspace Overview

## Projects
| Project | Tech Stack | Purpose |
|---|---|---|
| [name] | [stack] | [what it does] |

## Cross-project dependencies
- [project-a] → [project-b]: [dependency type]

## Shared resources
- [shared config / libraries / types]

## Agent entry point
Use @workspace-manager for tasks spanning multiple projects.
```

## Constraints

- Each project must be initialized independently — do not let one project's context influence another.
- Do not mix workspace-level context with project-level context.
- Always use a branch for context changes — never commit directly to `main`.
