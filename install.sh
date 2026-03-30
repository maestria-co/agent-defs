#!/usr/bin/env bash
# install.sh — copy agent-defs into ~/.copilot (default) or ~/.claude (--claude)
# Run after any git pull to keep your local install current.
#
# Usage:
#   ./install.sh              # GitHub Copilot → ~/.copilot
#   ./install.sh --claude     # Claude Code   → ~/.claude

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_MODE=false

for arg in "$@"; do
  [[ "$arg" == "--claude" ]] && CLAUDE_MODE=true
done

if $CLAUDE_MODE; then
  INSTALL_DIR="${CLAUDE_DIR:-$HOME/.claude}"
else
  INSTALL_DIR="${COPILOT_DIR:-$HOME/.copilot}"
fi

echo "Installing agent-defs → $INSTALL_DIR"
$CLAUDE_MODE && echo "Mode: Claude Code" || echo "Mode: GitHub Copilot"
echo ""

# ── Skills ────────────────────────────────────────────────────────────────────

mkdir -p "$INSTALL_DIR/skills/_shared"

# _shared conventions and shared resources (context_template, etc.)
cp -r "$REPO_DIR/skills/_shared/" "$INSTALL_DIR/skills/_shared/"
echo "  skills/_shared/ ($(find "$REPO_DIR/skills/_shared" -type f | wc -l | tr -d ' ') files)"

# GUIDE.md (skill selection reference)
cp "$REPO_DIR/skills/GUIDE.md" "$INSTALL_DIR/skills/GUIDE.md"
echo "  skills/GUIDE.md"

# Each skill folder
for dir in "$REPO_DIR/skills/"/*/; do
  name=$(basename "$dir")
  [[ "$name" == "_shared" ]] && continue
  dest="$INSTALL_DIR/skills/$name"
  mkdir -p "$dest"
  cp -r "$dir"* "$dest/"
  echo "  skills/$name"
done

echo ""

# ── Agents ────────────────────────────────────────────────────────────────────

mkdir -p "$INSTALL_DIR/agents/_shared"

# _shared conventions (loaded by every agent)
for f in "$REPO_DIR/agents/_shared/"*.md; do
  cp "$f" "$INSTALL_DIR/agents/_shared/$(basename "$f")"
  echo "  agents/_shared/$(basename "$f")"
done

# Each agent file
for f in "$REPO_DIR/agents/"*.agent.md; do
  cp "$f" "$INSTALL_DIR/agents/$(basename "$f")"
  echo "  agents/$(basename "$f")"
done

echo ""

# ── Claude Code: update CLAUDE.md ─────────────────────────────────────────────

if $CLAUDE_MODE; then
  CLAUDE_MD="$INSTALL_DIR/CLAUDE.md"
  MARKER_START="<!-- agent-defs:skills:start -->"
  MARKER_END="<!-- agent-defs:skills:end -->"

  # Build skills table
  SKILLS_BLOCK="$MARKER_START
## Agent-Defs Skills

The following skills are installed at \`~/.claude/skills/\`. When a task matches
a skill's purpose, read the corresponding SKILL.md and follow its instructions.

| Skill | File |
|-------|------|"

  for dir in "$INSTALL_DIR/skills/"/*/; do
    name=$(basename "$dir")
    [[ "$name" == "_shared" ]] && continue
    desc=$(grep -m1 "^description:" "$dir/SKILL.md" 2>/dev/null | sed 's/description: *//;s/^> *//' | tr -d '\n' | cut -c1-80 || echo "")
    SKILLS_BLOCK+="
| \`$name\` | \`~/.claude/skills/$name/SKILL.md\` |"
  done

  SKILLS_BLOCK+="

### Agents

| Agent | File |
|-------|------|"

  for f in "$INSTALL_DIR/agents/"*.agent.md; do
    name=$(basename "$f" .agent.md)
    SKILLS_BLOCK+="
| \`$name\` | \`~/.claude/agents/$(basename "$f")\` |"
  done

  SKILLS_BLOCK+="
$MARKER_END"

  if [ ! -f "$CLAUDE_MD" ]; then
    # Create fresh CLAUDE.md
    echo "# Claude Code — Global Instructions

$SKILLS_BLOCK" > "$CLAUDE_MD"
    echo "  Created $CLAUDE_MD"
  else
    # Update existing — replace block if present, otherwise append
    if grep -q "$MARKER_START" "$CLAUDE_MD"; then
      # Replace between markers using perl (portable across macOS/Linux)
      perl -i -0pe "s/$MARKER_START.*?$MARKER_END/$SKILLS_BLOCK/s" "$CLAUDE_MD"
      echo "  Updated skills block in $CLAUDE_MD"
    else
      printf "\n\n%s" "$SKILLS_BLOCK" >> "$CLAUDE_MD"
      echo "  Appended skills block to $CLAUDE_MD"
    fi
  fi
  echo ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────

SKILL_COUNT=$(find "$INSTALL_DIR/skills" -name 'SKILL.md' | wc -l | tr -d ' ')
AGENT_COUNT=$(find "$INSTALL_DIR/agents" -name '*.agent.md' | wc -l | tr -d ' ')
echo "Done. $SKILL_COUNT skills, $AGENT_COUNT agents installed."
