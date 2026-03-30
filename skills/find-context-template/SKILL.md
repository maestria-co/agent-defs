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

## Verification

A valid `context_template/` must contain all three:
- `overview.md` (or `overview.md.template`)
- `standards/` directory
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
