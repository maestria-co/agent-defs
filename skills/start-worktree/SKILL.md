---
name: start-worktree
description: >
  Use when setting up a git worktree for parallel development work. Triggers on
  "create a worktree", "I need to work on two branches at once", "set up parallel
  work", or when a developer needs to switch context without losing work-in-progress.
---

# Skill: Start Worktree

## Purpose

Set up git worktrees to enable parallel work on multiple branches without stashing
or losing in-progress changes. Worktrees create separate working directories that
share the same .git history, allowing you to have multiple branches checked out
simultaneously. Useful for working on a hotfix while a feature is in progress,
reviewing PRs without disrupting current work, or running tests on different branches.

---

## When to Use Worktrees

### Good Use Cases

| Scenario | Why Worktree Helps |
|----------|-------------------|
| **Hotfix while feature in progress** | Don't lose unstaged changes; switch contexts instantly |
| **Running tests on two branches** | Compare behavior side-by-side without re-running builds |
| **Reviewing a PR** | Test the PR code without disturbing your working branch |
| **Long-running migration** | Keep migration branch alive while doing other work |
| **Bisecting a bug** | Keep your main work untouched while git-bisecting |
| **Multi-version testing** | Test against multiple framework versions simultaneously |

### When NOT to Use Worktrees

| Scenario | Better Alternative |
|----------|-------------------|
| **Quick branch switch** | Use `git stash` or commit WIP |
| **Temporary check** | Use `git show` or `git diff` |
| **Single-branch work** | Just use the main working directory |

---

## Setup Process

### Option 1: Worktree for Existing Branch

Use this when checking out a branch that already exists:

```bash
# Navigate to your main repo
cd /path/to/project

# Create worktree for existing branch
git worktree add ../project-[branch-name] [branch-name]

# Example: Create worktree for hotfix branch
git worktree add ../myapp-hotfix-auth hotfix-auth
```

**Result:** New directory at `../project-[branch-name]` with `[branch-name]` checked out.

### Option 2: Worktree with New Branch

Use this when creating a new branch:

```bash
# Create worktree with a new branch based on main
git worktree add -b [new-branch-name] ../project-[branch-name] main

# Example: Create new feature branch in worktree
git worktree add -b feature-dark-mode ../myapp-dark-mode main
```

**Result:** New directory at `../project-[branch-name]` with new `[new-branch-name]` checked out and based on `main`.

### Option 3: Worktree with Specific Commit

Use this when you need to check out a specific commit:

```bash
# Create worktree at a specific commit
git worktree add ../project-commit-[hash] [commit-hash]

# Example: Check out a specific commit for testing
git worktree add ../myapp-commit-abc123 abc123def456
```

---

## Post-Setup: Install Dependencies

**Important:** Worktrees share `.git` but NOT node_modules, virtual environments, or build artifacts.

After creating the worktree, navigate to it and install dependencies:

```bash
# Navigate to the worktree
cd ../project-[branch-name]

# Install dependencies
npm install                     # Node.js
pip install -r requirements.txt # Python
dotnet restore                  # .NET
bundle install                  # Ruby
go mod download                 # Go
```

### Build the Project

If the project requires a build step:

```bash
npm run build    # Node.js
dotnet build     # .NET
go build         # Go
cargo build      # Rust
```

---

## Working with Worktrees

### Open in Separate Editor

Open each worktree in a separate editor window or workspace:

```bash
# VS Code
code ../project-[branch-name]

# IntelliJ/WebStorm
idea ../project-[branch-name]

# Vim/Neovim (with session support)
nvim -S ../project-[branch-name]/.session.vim
```

### Run Servers on Different Ports

If running development servers, avoid port conflicts:

```bash
# Terminal 1 (main work)
cd /path/to/project
npm run dev  # default port 3000

# Terminal 2 (worktree)
cd ../project-hotfix-auth
PORT=3001 npm run dev  # override to port 3001
```

### Sharing .git

All worktrees share the same Git history:

- Commits made in any worktree are visible in all worktrees
- Tags and branches created in one worktree appear in all worktrees
- `git fetch` / `git pull` in any worktree updates all worktrees

**But:** Each worktree has its own:
- Working directory (different files checked out)
- Staging area (different `git add` state)
- HEAD pointer (different branch checked out)

---

## Managing Worktrees

### List All Worktrees

```bash
git worktree list
```

**Example output:**
```
/Users/dev/project        abc123d [main]
/Users/dev/project-hotfix def456e [hotfix-auth]
/Users/dev/project-dark   789abcd [feature-dark-mode]
```

### Remove a Worktree

When the branch is merged or no longer needed:

```bash
# First, ensure you're not inside the worktree
cd /path/to/main-project

# Remove the worktree
git worktree remove ../project-[branch-name]

# Example
git worktree remove ../project-hotfix-auth
```

**Or manually delete and prune:**

```bash
# Delete the directory
rm -rf ../project-[branch-name]

# Clean up Git's internal records
git worktree prune
```

### Prune Stale Worktrees

If you manually deleted worktree directories:

```bash
# Clean up Git's internal worktree records
git worktree prune
```

### Move a Worktree

If you need to relocate a worktree directory:

```bash
# Move the directory
mv ../project-hotfix-auth ../new-location/project-hotfix-auth

# Update Git's records
git worktree repair ../new-location/project-hotfix-auth
```

---

## Workflow Examples

### Example 1: Hotfix During Feature Work

```bash
# You're working on a feature with uncommitted changes
cd /path/to/project
git status  # shows modified files on feature-payment

# Urgent bug report comes in
git worktree add -b hotfix-login-bug ../project-hotfix main
cd ../project-hotfix

# Install dependencies
npm install

# Fix the bug
# ... make changes ...
git add .
git commit -m "fix: resolve login redirect bug"
git push origin hotfix-login-bug

# Return to feature work
cd /path/to/project
# Your uncommitted changes are still here
```

### Example 2: Reviewing a PR

```bash
# PR #123 needs review
git fetch origin pull/123/head:pr-123
git worktree add ../project-pr-123 pr-123

cd ../project-pr-123
npm install
npm test

# Review the code in this directory
# When done:
cd /path/to/project
git worktree remove ../project-pr-123
git branch -d pr-123
```

### Example 3: Testing Against Multiple Versions

```bash
# Main work on latest framework
cd /path/to/project  # Using framework v5

# Create worktree with downgraded version
git worktree add -b test-framework-v4 ../project-framework-v4 main
cd ../project-framework-v4

# Downgrade framework in this worktree only
npm install framework@4
npm test

# Compare results between v4 and v5
```

---

## Worktree Checklist

Before creating a worktree:

- [ ] Do I need parallel work, or can I just switch branches?
- [ ] Is the branch already created, or do I need a new one?
- [ ] Do I have disk space for another copy of dependencies?

After creating a worktree:

- [ ] Installed dependencies
- [ ] Built the project (if needed)
- [ ] Configured port/environment to avoid conflicts with main worktree
- [ ] Opened in separate editor window

Before removing a worktree:

- [ ] Branch is merged or abandoned
- [ ] No uncommitted changes (or committed/stashed)
- [ ] Not currently inside the worktree directory
- [ ] Branch can be deleted (if applicable)

---

## Common Issues

### Issue: "Cannot create worktree: branch already checked out"

**Cause:** The branch is already checked out in another worktree (or the main repo).

**Solution:**

```bash
# Check which worktree has the branch
git worktree list

# Either switch the existing worktree to a different branch, or delete it
```

### Issue: "Module not found" errors after creating worktree

**Cause:** Dependencies not installed in the worktree.

**Solution:**

```bash
cd ../project-[branch-name]
npm install  # or equivalent
```

### Issue: Port already in use

**Cause:** Main worktree and new worktree trying to use the same port.

**Solution:**

```bash
# Run dev server on different port
PORT=3001 npm run dev
```

### Issue: Worktree still listed after manual deletion

**Cause:** Deleted directory manually without telling Git.

**Solution:**

```bash
git worktree prune
```

---

## Constraints

- **Each worktree must be on a different branch** — Two worktrees cannot check out the same branch simultaneously
- **Do not nest worktrees inside the main repo** — Create them as siblings: `../project-[branch]`
- **Always install dependencies** — The worktree directory starts with only source files, no node_modules/venv
- **Remove worktrees when done** — Stale worktrees consume disk space and clutter `git worktree list`
- **Do not use worktrees for quick checks** — Use `git show` or `git diff` instead
- **Always check `git worktree list`** — Know what worktrees exist before creating new ones
