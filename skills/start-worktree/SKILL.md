---
name: start-worktree
description: >
  Set up a git worktree to work on multiple branches in parallel without stashing
  or losing in-progress changes. Use when someone says "create a worktree", "I need
  to work on two branches at once", "set up parallel development", "I got a hotfix
  while my feature is still in progress", "how do I review this PR without disrupting
  my work", or "can I run tests on both branches simultaneously?". Each worktree is a
  separate directory sharing the same git history.
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

| Scenario | Why Worktree Helps |
|----------|-------------------|
| Hotfix while feature in progress | No stash needed; switch contexts instantly |
| Reviewing a PR | Test PR code without disturbing your working branch |
| Running tests on two branches | Compare behavior side-by-side |
| Long-running migration | Keep migration branch alive while doing other work |

---

## Setup

### Existing Branch

```bash
git worktree add ../project-[branch-name] [branch-name]
```

### New Branch

```bash
git worktree add -b [new-branch] ../project-[new-branch] main
```

### Specific Commit (detached HEAD)

```bash
git worktree add ../project-[hash] [commit-hash]
```

The new directory is placed as a **sibling** to the main repo (`../`) — never inside it.

---

## After Creating

Worktrees share `.git` history but **not** dependencies or build artifacts. After creating:

```bash
cd ../project-[branch-name]
# Install dependencies
npm install             # Node.js
pip install -r requirements.txt  # Python
dotnet restore         # .NET

# If dev server conflicts with main worktree's port:
PORT=3001 npm run dev
```

---

## Management

```bash
# See all worktrees
git worktree list

# Remove when done
git worktree remove ../project-[branch-name]

# Clean up after manual directory deletion
git worktree prune

# Repair after moving a worktree directory
git worktree repair ../new-location/project-[branch]
```

---

## Checklist

**Before creating:**
- [ ] Do I need parallel work, or will `git stash` suffice?
- [ ] Is the branch already created, or do I need a new one?

**After creating:**
- [ ] Dependencies installed
- [ ] Port/environment configured to avoid conflicts
- [ ] Opened in a separate editor window

**Before removing:**
- [ ] Branch is merged or abandoned
- [ ] No uncommitted changes
- [ ] Not currently `cd`'d into the worktree directory

---

## Constraints

- Two worktrees cannot check out the same branch simultaneously
- Create worktrees as siblings (`../`) — never nested inside the main repo
- Remove worktrees when done; stale ones consume disk space

