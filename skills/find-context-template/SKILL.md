---
name: find-context-template
description: |
  Locate the context_template directory in the agent-defs installation. Use when the
  initialize-repo or initialize-workspace skill needs to find the template but the path
  is unknown.
---

# Skill: Find Context Template

## Purpose

Reliably locate the agent-defs `context_template/` directory across different installation
layouts (local clone, VS Code extension, npm install, etc.).

## Search Sequence

Try in order — stop at the first match:

1. `../agent-defs/context_template/` — sibling directory (local development)
2. `../../agent-defs/context_template/` — two levels up
3. `~/tools/agent-defs/context_template/` — conventional tools directory
4. `~/.copilot/context_template/` — user-level install
5. Search for any `context_template/` within `~/` limited to 3 levels deep:
   ```bash
   find ~/ -maxdepth 3 -name "context_template" -type d 2>/dev/null
   ```
6. Check VS Code extension storage:
   ```bash
   find ~/.vscode/extensions -maxdepth 3 -name "context_template" -type d 2>/dev/null
   ```

## Verification

After finding a candidate path, verify it contains the expected structure:
- `overview.md` or `overview.md.template`
- `standards/` directory
- `domains/` directory

## Output

- **Found:** Return the absolute path to the verified `context_template/` directory.
- **Not found:** Ask the user to provide the path. List all locations that were searched.

## Constraints

- Do not fabricate a path.
- Do not proceed with a directory that fails the verification check.
- Report all searched locations when asking the user for help.
- Never proceed with initialization without the template — files generated from scratch without it produce inconsistent results.
