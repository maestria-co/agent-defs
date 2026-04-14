---
name: find-context-template
description: >
  Locate the context_template/ directory so initialize-repo and
  initialize-workspace can proceed. Use this whenever those skills need the
  template path and it isn't already known — triggered automatically by
  initialize-repo, initialize-workspace, and initialize-monorepo at startup,
  or directly when a user says "where is the context template", "find the
  skill kit template", or "I can't find context_template".
---

# Skill: Find Context Template

## Purpose

Reliably locate the `context_template/` directory from the installed skill kit,
regardless of which AI tool (Copilot or Claude Code) was used to install it.
Stop at the first valid match and report clearly when none is found.

---

## Search Sequence

Try each location in order — stop at the first match:

1. `~/.copilot/skills/_shared/context_template/` — Copilot install (default)
2. `~/.claude/skills/_shared/context_template/` — Claude Code install
3. `find ~/ -maxdepth 4 -type d -name "context_template"` — home dir search
4. Ask the user for the path

## Detection Logic

Use this safe command pattern that avoids nested command substitution:

```bash
# Method 1: Simple expansion (recommended for most cases)
template_dir=""
if [ -d ~/.copilot/skills/_shared/context_template/ ]; then
  template_dir=~/.copilot/skills/_shared/context_template
  echo "Found at: $template_dir"
elif [ -d ~/.claude/skills/_shared/context_template/ ]; then
  template_dir=~/.claude/skills/_shared/context_template
  echo "Found at: $template_dir"
else
  echo "NOT_FOUND"
fi
```

**Why this is safe:**
- No nested command substitution `$(...)` 
- Tilde expansion happens naturally in the conditional test
- Path is already absolute after tilde expansion
- No external commands needed for simple path detection

**If absolute path normalization is required:**

```bash
# Method 2: Using cd and pwd (POSIX-compliant)
if [ -d ~/.copilot/skills/_shared/context_template/ ]; then
  template_dir=$(cd ~/.copilot/skills/_shared/context_template && pwd)
  echo "Found at: $template_dir"
elif [ -d ~/.claude/skills/_shared/context_template/ ]; then
  template_dir=$(cd ~/.claude/skills/_shared/context_template && pwd)
  echo "Found at: $template_dir"
else
  echo "NOT_FOUND"
fi
```

**Never use:**
- ❌ `$(realpath $(echo ~/.copilot/...))` — nested substitution blocked
- ❌ `${var@P}` — parameter transformation blocked
- ❌ Chained variable assignments building commands

## Verification

A valid `context_template/` must contain all three:

- `overview.md` (or `overview.md.template`)
- `standards.md` directory
- `domains/` directory

If a path exists but fails verification, continue searching.

## Output

**Found:** Return the absolute path. Example:

```
/Users/alice/.copilot/skills/_shared/context_template
```

**Not found:** List every location that was searched and ask the user to
provide the path directly. Never proceed with initialization without a verified
template — context generated from scratch is inconsistent.

## Constraints

- Never fabricate a path.
- Never use a directory that fails verification.
- Report all searched locations so the user can diagnose the issue.
