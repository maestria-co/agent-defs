---
name: context-specialist-impl
description: Internal backing skill for the @context-specialist agent. NOT for direct invocation. Covers tree-position detection and .context/ initialization for leaf, branch, and root nodes.
user-invocable: false
---

# Context Specialist Implementation

Backing skill for `@context-specialist`. Provides:
1. Tree-position detection from filesystem signals
2. Initialization process per position (leaf / branch / root)

---

## Section 1: Detect Tree Position

When the caller has not supplied an explicit `tree_position`, detect it from filesystem signals.

### context-specialist-impl: Step 1: ROOT check

Check for monorepo/workspace manifests at CWD. Any of these signals → position = `root`:

- `nx.json`, `turbo.json`, or `go.work` exists at CWD
- A `.sln` file exists at CWD
- A `*.code-workspace` file exists at CWD
- `package.json` at CWD contains a `"workspaces"` field
- `pom.xml` at CWD contains `<modules>` AND `src/` directory does NOT exist

### context-specialist-impl: Step 2: LEAF check

Any of these at CWD → position = `leaf`:

`package.json` (without `"workspaces"`), `go.mod`, `Cargo.toml`, `pyproject.toml`,
`requirements.txt`, `Gemfile`, `build.gradle`, `pom.xml` (with `src/`), `*.csproj`

### context-specialist-impl: Step 3: BRANCH check

No local manifest matched. Count subdirectories (depth 1) that contain any build manifest.
If **2 or more** subdirectories contain build manifests → position = `branch`.

### context-specialist-impl: Step 4: Fallback

No signals matched → default to `leaf`. Log a warning:

> "Tree position could not be determined from manifest signals — defaulting to leaf. Review the generated `.context/` for accuracy."

### Detection Summary

| Signal | Position |
|--------|---------|
| `nx.json`, `turbo.json`, `go.work`, `.sln` at CWD | root |
| `*.code-workspace` at CWD | root |
| `package.json` with `"workspaces"` | root |
| `pom.xml` with `<modules>` and no `src/` | root |
| `package.json` (no `workspaces`), `go.mod`, `*.csproj`, etc. at CWD | leaf |
| None of above, but 2+ subdirs contain build manifests | branch |
| No signals match | leaf (fallback + warning) |

---

## Section 2: Initialize Leaf Node

**For `tree_position: leaf`**, invoke the `initialize-repo` skill.
The full leaf initialization process lives there — do not duplicate it.

> Invoke skill: `initialize-repo`

---

## Section 3: Initialize Branch Node

**For `tree_position: branch`** — a grouping directory (e.g., `services/`, `apps/`) with sub-projects but no build manifest of its own.

### Branch `.context/` Structure

```
.context/
├── META.md                     (copy from context_template — verbatim)
├── overview.md                 (what sub-projects live here and how they relate)
├── projects.md                 (sub-project directory map)
├── decisions.md                (decisions affecting 2+ sub-projects)
├── architecture/
│   └── patterns.md             (shared patterns used by 2+ sub-projects)
├── domains/
│   └── <domain>.md             (business/technical domains spanning 2+ sub-projects)
└── .gitignore                  (copy from context_template — verbatim)
```

**Explicitly absent** at branch level:

| Omitted | Reason |
|---------|--------|
| `standards/` | Code style is per-leaf-project |
| `testing/` | Test infrastructure is per-leaf-project |
| `styling/` | Frontend conventions are per-leaf-project |
| `tasks/` | Tasks are tracked against specific projects |
| `retrospectives.md` | Retrospectives are per-project |

### Branch File Content Guide

**`overview.md`** — "what lives here and how do they relate?"
- 1–3 sentences on the group's shared purpose
- Table: sub-project name | path relative to this node | one-sentence description | primary stack
- How sub-projects communicate (shared libraries, events, APIs) — omit if independent

**`projects.md`** — routing map used by `resolve-repo-context`:

```markdown
| Project Name | Path | Description | Primary Language/Stack |
|---|---|---|---|
| api-service | api-service/ | REST API for X | Node.js 20 |
```

**`decisions.md`** — architectural decisions affecting 2+ sub-projects here. Omit if none.

**`architecture/patterns.md`** — cross-project patterns used by 2+ sub-projects (shared libraries, common middleware). Strictly cross-project only. Omit if sub-projects share nothing.

**`domains/<domain>.md`** — domain concepts spanning 2+ sub-projects only. Do not duplicate leaf domain files here.

### Branch Process

1. Scan depth 1–2 for build manifests to discover sub-projects
2. Read each sub-project's `.context/overview.md` first sentence (if it exists); otherwise scan build manifest + README first paragraph
3. Invoke `find-context-template` to locate `$TEMPLATE_DIR`; copy `META.md` and `.gitignore` verbatim
4. Generate `projects.md` from discovered sub-projects
5. Generate `overview.md` (group purpose + sub-project table)
6. Generate `decisions.md` only if cross-project decisions are identifiable
7. Generate `architecture/patterns.md` only if 2+ sub-projects share patterns
8. Generate `domains/<domain>.md` only for concepts spanning 2+ sub-projects
9. Commit all created files

---

## Section 4: Initialize Root Node

**For `tree_position: root`** — top-level of a monorepo or workspace.

**Do not modify sub-project `.context/` folders.** Root context covers what is shared across projects — not what is specific to any one project.

### Root `.context/` Structure

```
.context/
├── META.md                           (copy from context_template — verbatim)
├── retrospectives.md                 (copy from context_template — verbatim)
├── overview.md                       (what the monorepo is, how areas relate)
├── projects.md                       (canonical area map — most important file)
├── decisions.md                      (decisions affecting 2+ areas)
├── architecture/
│   └── patterns.md                   (cross-area patterns and shared abstractions)
├── domains/
│   └── <domain>.md                   (domains spanning 2+ areas)
└── workflows/
    ├── ci-cd.md                      (root-level pipeline and deployment)
    ├── branching.md                  (branching strategy and merge process)
    └── commit-conventions.md         (detected from git log)
```

### Root Initialization Process

**Step A — Read sub-project context**: Before generating anything, read each area's `.context/overview.md` first sentence. Record primary stack and any shared libraries mentioned.

**Step B — Generate `projects.md`**: Canonical area map. Derive names from area `overview.md` first sentence; fall back to build manifest + README. Paths relative to repo root. Include every area — omit none.

```markdown
| Project Name | Path | Description | Primary Language/Stack |
|---|---|---|---|
| api | services/api | REST API gateway | Node.js 20 |
```

**Step C — Scan root infrastructure**: Check for CI/CD files (`.github/workflows/`, `Jenkinsfile`, `azure-pipelines.yml`), IaC (`terraform/`, `cdk/`), shared scripts (`Makefile`, `scripts/`), monorepo build coordinators (`nx.json`, `turbo.json`, `go.work`, `Directory.Build.props`).

**Step D — Generate `overview.md`**: What the monorepo is, how areas relate, shared libraries and event buses, cross-cutting concepts. Reference area paths — do not duplicate area content.

**Step E — Generate `decisions.md`**: Cross-area architectural decisions (shared auth libraries, locked framework versions, patterns not used and why). Omit if no cross-area decisions exist.

**Step F — Generate `architecture/patterns.md`**: Cross-area patterns only — how services communicate, shared packages used by 2+ areas, module dependency graph.

**Step G — Generate `domains/` files**: One file per domain spanning 2+ areas. Format mirrors leaf domain files. Skip domains internal to a single area.

**Step H — Generate `workflows/ci-cd.md`**: CI system, pipeline stages, deployment environments, manual gates, per-area divergences.

**Step I — Generate `workflows/branching.md`**: Detect from `git branch -r` and `git log`. Primary integration branch(es), feature branch naming with real examples, merge strategy.

**Step J — Generate `workflows/commit-conventions.md`**: Detect from `git log --oneline -50`. Format pattern with 3–5 real examples from the log.

**Step K — Copy infrastructure files**: Invoke `find-context-template` for `$TEMPLATE_DIR`; copy `META.md`, `retrospectives.md`, `.gitignore` verbatim.

**Step L — Verify and commit**: Confirm all required files exist; flag any gaps as "needs attention." Commit with a message following repo conventions.

### Root Content Quality Standard

Root context is **cross-project and infrastructure-level**. Reference area paths rather than duplicating area content.

| Shallow (bad) | Thorough (good) |
|---|---|
| "Areas communicate via REST" | Table: which service calls which, shared client libraries, auth method |
| "Uses GitHub Actions" | Pipeline stages, triggers, deploy environments, manual gates |
| "Monorepo with multiple services" | projects.md with paths, descriptions, stacks, and cross-project decisions |
