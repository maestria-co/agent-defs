---
name: initialize-workspace
description: >
  Bootstrap the agent-system context for every project in a VS Code multi-root
  workspace. Use when setting up the agent system for a workspace with multiple
  projects, or when adding context bootstrapping to a multi-project environment.
user-invocable: true
---

# Skill: Initialize Workspace

## Purpose

Run initialize-repo (or upgrade-repo if .context/ exists) across all projects in
a VS Code multi-root workspace, then generate workspace-level cross-project context
that the workspace-manager agent can use. This skill enables the agent system to
understand multi-project relationships, shared dependencies, and cross-project workflows.

---

## Phase 1: Locate Workspace File

**Goal:** Find and parse the VS Code workspace configuration.

### Step 1: Find .code-workspace File

```bash
# Search in current directory and one level up
find . -name "*.code-workspace" -maxdepth 2
```

### Step 2: Parse Workspace Folders

Extract the `folders` array from the workspace JSON:

```bash
# Pretty-print the workspace file
cat workspace.code-workspace | jq '.folders'
```

**Expected format:**

```json
{
  "folders": [
    { "path": "frontend" },
    { "path": "backend" },
    { "path": "shared-lib" },
    { "path": "docs" }
  ]
}
```

### Step 3: Classify Each Folder

For each folder, determine its type:

| Type | Indicators | Treatment |
|------|-----------|-----------|
| **Project** | Has source code (src/, lib/, app/) | Initialize context |
| **Resource** | Only docs, config, or shared assets | Document in overview, skip initialization |
| **Submodule** | Is a git submodule | Initialize independently |

**Check each folder:**

```bash
# Navigate to folder
cd [folder-path]

# Check for source code indicators
ls -la | grep -E "src|lib|app|package.json|requirements.txt|go.mod"

# Check if it's a git repository
git rev-parse --git-dir 2>/dev/null
```

---

## Phase 2: Branch Guard

**Goal:** Protect main branches from direct commits.

### For Each Git Repository

```bash
cd [project-folder]

# Check current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# If on protected branch, create context-bootstrap branch
if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
  echo "Protected branch detected. Creating context-bootstrap branch."
  git checkout -b context-bootstrap-$(date +%Y%m%d)
fi
```

**Protected branches:**
- main
- master
- production
- release/*

---

## Phase 3: Initialize Each Project

**Goal:** Bootstrap .context/ for each project.

### Decision Flow

```
For each project folder:
  ├─ Does .context/ exist?
  │  ├─ No  → Apply initialize-repo skill
  │  └─ Yes → Apply upgrade-repo skill (update context, not code)
  └─ Run in isolation to prevent context pollution
```

### Process Per Project

```bash
cd [project-folder]

# Check for existing context
if [ ! -d ".context" ]; then
  echo "Initializing context for [project-name]..."
  # Apply initialize-repo skill
  # (Copy context_template, customize for project)
else
  echo "Context exists. Checking for updates..."
  # Apply upgrade-repo skill
  # (Update context files with new templates)
fi
```

### Isolation Rule

**Each project must be initialized independently.**

- Do not mix project-level context with workspace-level context
- Do not let one project's decisions influence another project's context
- Each project gets its own `.context/overview.md`, `.context/standards/`, etc.

---

## Phase 4: Generate Workspace Overview

**Goal:** Create workspace-level context that describes cross-project relationships.

### Create `.context/workspace-overview.md`

Place this file at the **workspace root** (not inside any project folder).

```markdown
# Workspace Overview

**Workspace:** [workspace-name]  
**Generated:** [date]

---

## Projects

| Name | Tech Stack | Purpose | Entry Point |
|------|-----------|---------|-------------|
| [project-1] | [Node.js, React] | [Frontend application] | `src/index.tsx` |
| [project-2] | [Python, FastAPI] | [Backend API] | `app/main.py` |
| [project-3] | [TypeScript] | [Shared types library] | `index.ts` |

---

## Cross-Project Dependencies

### [project-1] → [project-3]

- **Type:** Shared types
- **Direction:** Frontend imports shared types
- **Files:** `frontend/src/types/` references `shared-lib/types/`

### [project-2] → [project-3]

- **Type:** Shared types
- **Direction:** Backend imports shared types for API contracts
- **Files:** `backend/app/schemas/` references `shared-lib/types/`

---

## Shared Resources

### Shared Configuration

- **ESLint config:** `.eslintrc.workspace.json` (used by all TS/JS projects)
- **TypeScript config:** `tsconfig.base.json` (extended by frontend and shared-lib)
- **Docker Compose:** `docker-compose.yml` (orchestrates all services)

### Shared Libraries

- `shared-lib/` — TypeScript types shared by frontend and backend
- `common-utils/` — Utility functions used across projects

---

## Development Workflow

### Starting All Services

```bash
# From workspace root
docker-compose up
```

### Running Tests Across Projects

```bash
# Test all projects
npm run test:all

# Test specific project
npm run test --workspace=frontend
```

### Building for Production

```bash
# Build all projects
npm run build:all

# Build order (due to dependencies)
1. shared-lib
2. backend
3. frontend
```

---

## Agent Entry Point

For tasks spanning multiple projects, use:

```
@workspace-manager [task description]
```

The workspace-manager agent understands cross-project dependencies and will
coordinate work across projects when needed.

---

## Maintenance

This workspace overview should be updated when:

- [ ] A new project is added to the workspace
- [ ] Cross-project dependencies change
- [ ] Shared resources are added or removed
- [ ] Build or test workflows change
```

---

## Phase 5: Document Cross-Project Relationships

**Goal:** Identify and document how projects interact.

### Relationship Types

| Type | Description | Example |
|------|-------------|---------|
| **Shared Library** | Project imports code from another project | Frontend imports types from shared-lib |
| **API Contract** | Projects communicate via API | Frontend calls backend REST API |
| **Event Bus** | Projects communicate via events | Services publish/subscribe to message queue |
| **Shared Config** | Projects use common configuration | All use same ESLint config |
| **Build Dependency** | One project must build before another | Shared-lib must build before frontend |

### Discovery Process

```bash
# Find import statements referencing other workspace projects
grep -r "from '@workspace/" frontend/src/
grep -r "import.*\.\./" backend/app/

# Find API calls to other services
grep -r "fetch.*localhost:3000" frontend/src/
grep -r "http://.*:.*" */src/ */app/

# Find shared config references
find . -name "*.json" -exec grep -l "extends.*tsconfig.base" {} \;
```

### Document Each Relationship

For each discovered relationship:

```markdown
### [source-project] → [target-project]

- **Type:** [relationship type]
- **Direction:** [which way the dependency flows]
- **Interface:** [how they communicate: imports, HTTP, events, etc.]
- **Files:** [specific files involved]
- **Breaking change risk:** [High/Medium/Low — how likely changes break the relationship]
```

---

## Phase 6: Create Pull/Merge Requests

**Goal:** Submit .context/ changes for review.

### Per-Repository PR

Create a separate PR for each repository:

```bash
cd [project-folder]

# Stage context changes
git add .context/

# Commit
git commit -m "docs: bootstrap agent context for [project-name]

Initialized .context/ directory with:
- overview.md
- standards/
- domains/
- architecture/

This enables agent system to understand project structure and conventions."

# Push branch
git push origin context-bootstrap-$(date +%Y%m%d)

# Create PR (using gh CLI)
gh pr create --title "Bootstrap agent context" \
             --body "Initialized .context/ directory to enable agent system. See commit for details."
```

### Workspace-Level PR

If the workspace root is also a git repository:

```bash
cd [workspace-root]

# Stage workspace overview
git add .context/workspace-overview.md

# Commit
git commit -m "docs: add workspace-level context overview

Documents cross-project relationships, shared resources, and workspace-level
workflows for agent system."

# Push and create PR
git push origin context-bootstrap-workspace
gh pr create --title "Add workspace context overview" \
             --body "Workspace-level context for multi-project agent coordination."
```

---

## Workspace Initialization Checklist

### Pre-Initialization

- [ ] Workspace file (*.code-workspace) located
- [ ] Workspace folders parsed
- [ ] Projects vs. resources classified
- [ ] Git repositories identified

### Per-Project Initialization

For each project:

- [ ] Branch guard applied (on protected branch → create context-bootstrap branch)
- [ ] .context/ initialized or upgraded
- [ ] Project-specific context populated
- [ ] No cross-contamination between projects

### Workspace-Level Context

- [ ] `.context/workspace-overview.md` created at workspace root
- [ ] All projects listed with tech stacks and purposes
- [ ] Cross-project dependencies documented
- [ ] Shared resources listed
- [ ] Development workflows documented

### Pull Request Creation

- [ ] One PR per repository with .context/ changes
- [ ] Workspace-level PR created (if applicable)
- [ ] PR descriptions explain purpose and contents
- [ ] PRs ready for review

---

## Output Template

After completion, provide this summary:

```markdown
# Workspace Initialization Complete

## Workspace: [workspace-name]

### Projects Initialized: [N]

| Project | Status | Branch | PR |
|---------|--------|--------|-----|
| [project-1] | ✅ Initialized | context-bootstrap-[date] | #[PR-number] |
| [project-2] | ✅ Upgraded | context-bootstrap-[date] | #[PR-number] |
| [project-3] | ⏭️ Skipped (resource folder) | — | — |

### Workspace Overview

- **Location:** `.context/workspace-overview.md`
- **Projects documented:** [N]
- **Cross-project dependencies:** [N]
- **Shared resources:** [N]

### Next Steps

1. Review PRs in each repository
2. Merge context changes
3. Use `@workspace-manager` for cross-project tasks

### Agent Entry Point

For tasks spanning multiple projects:
```
@workspace-manager [task description]
```
```

---

## Constraints

- **Each project must be initialized independently** — Do not let one project's context influence another
- **Do not mix workspace-level context with project-level context** — `.context/workspace-overview.md` lives at workspace root, not inside projects
- **Always use a branch for context initialization** — Never commit directly to main/master
- **Create one PR per repository** — Do not bundle changes from multiple repos
- **Document relationships, not assumptions** — Only record cross-project dependencies you can verify in code
- **Do not initialize resource folders** — Only projects with source code get .context/
- **Workspace overview must reference real files** — Every documented relationship must point to actual code
