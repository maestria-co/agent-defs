---
name: find-context-template
description: >
  Locate the agent-defs context_template directory so initialize-repo and
  initialize-workspace can proceed. Use this whenever those skills need the
  template path and it isn't already known — triggered automatically by
  initialize-repo, initialize-workspace, and initialize-monorepo at startup,
  or directly when a user says "where is the context template", "find the
  agent-defs template", or "I can't find context_template".
---

# Skill: Find Context Template

## Purpose

Reliably locate the `context_template/` directory from the agent-defs
installation, regardless of whether it was cloned locally, installed via a VS
Code extension, or placed in a custom tools directory. Stop at the first valid
match and report clearly when none is found.

---

## Search Sequence

Try each location in order — stop at the first match:

1. `../agent-defs/context_template/` — sibling repo (local dev)
2. `../../agent-defs/context_template/` — two levels up
3. `~/tools/agent-defs/context_template/` — shared tools directory
4. `~/.copilot/context_template/` — user-level install
5. `find ~/ -maxdepth 3 -type d -name "context_template" -path "*/agent-defs/*"` — home dir search
6. `find ~/.vscode/extensions -maxdepth 3 -type d -name "context_template"` — VS Code extension

## Verification

A valid `context_template/` must contain all three:
- `overview.md` (or `overview.md.template`)
- `standards/` directory
- `domains/` directory

If a path exists but fails verification, continue searching.

## Output

**Found:** Return the absolute path. Example:
```
/Users/alice/tools/agent-defs/context_template
```

**Not found:** List every location that was searched and ask the user to
provide the path directly. Never proceed with initialization without a verified
template — context generated from scratch is inconsistent.

## Constraints

- Never fabricate a path.
- Never use a directory that fails verification.
- Report all searched locations so the user can diagnose the issue.
