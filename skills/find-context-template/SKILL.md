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
3. `${COPILOT_HOME:-$HOME/.copilot}/skills/_shared/context_template/` — COPILOT_HOME override
4. `${CLAUDE_HOME:-$HOME/.claude}/skills/_shared/context_template/` — CLAUDE_HOME override
5. Ask the user for the path directly — do not use `find`

## Detection Logic

Use this safe command pattern that avoids nested command substitution:

```bash
template_dir=""
copilot_path="${COPILOT_HOME:-$HOME/.copilot}/skills/_shared/context_template"
claude_path="${CLAUDE_HOME:-$HOME/.claude}/skills/_shared/context_template"

if [ -d "$copilot_path" ]; then
  template_dir="$copilot_path"
  echo "Found at: $template_dir (Copilot)"
elif [ -d "$claude_path" ]; then
  template_dir="$claude_path"
  echo "Found at: $template_dir (Claude)"
else
  echo "NOT_FOUND"
fi
```

**Why this is safe:**
- No `find` — deterministic paths only; `find` introduces non-determinism and is slow
- Uses `${VAR:-default}` expansion — respects user-set overrides
- No nested command substitution `$(...)` inside `$()`
- Tilde expansion happens naturally in variable assignment

**If absolute path normalization is required:**

```bash
# Using cd and pwd (POSIX-compliant)
copilot_path="${COPILOT_HOME:-$HOME/.copilot}/skills/_shared/context_template"
if [ -d "$copilot_path" ]; then
  template_dir=$(cd "$copilot_path" && pwd)
  echo "Found at: $template_dir"
fi
```

**Never use:**
- ❌ `find ~/ -name "context_template"` — non-deterministic, slow, matches wrong directories
- ❌ `$(realpath $(echo ~/.copilot/...))` — nested substitution blocked
- ❌ `${var@P}` — parameter transformation blocked
- ❌ Chained variable assignments building commands

## Tool-Specific Error Handling

When the template is **not found**, report by tool:

- **Copilot users:** "Run `./install.sh` from the agent-defs repo to install the skill kit to `~/.copilot/`"
- **Claude Code users:** "Run `./install.sh --claude` from the agent-defs repo to install to `~/.claude/`"
- **Unknown tool:** Ask the user which tool they use and which install command they ran

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
