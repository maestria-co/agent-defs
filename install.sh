#!/usr/bin/env bash
# install.sh — copy agent-defs into ~/.copilot
# Run after any git pull to keep your local install current.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_DIR="${COPILOT_DIR:-$HOME/.copilot}"

echo "Installing agent-defs → $COPILOT_DIR"
echo ""

# ── Skills ────────────────────────────────────────────────────────────────────

mkdir -p "$COPILOT_DIR/skills/_shared"

# _shared conventions (loaded by every skill)
for f in "$REPO_DIR/skills/_shared/"*.md; do
  dest="$COPILOT_DIR/skills/_shared/$(basename "$f")"
  cp "$f" "$dest"
  echo "  skills/_shared/$(basename "$f")"
done

# GUIDE.md (skill selection reference)
cp "$REPO_DIR/skills/GUIDE.md" "$COPILOT_DIR/skills/GUIDE.md"
echo "  skills/GUIDE.md"

# Each skill folder
for dir in "$REPO_DIR/skills/"/*/; do
  name=$(basename "$dir")
  [[ "$name" == "_shared" ]] && continue
  dest="$COPILOT_DIR/skills/$name"
  mkdir -p "$dest"
  cp -r "$dir"* "$dest/"
  echo "  skills/$name"
done

echo ""

# ── Agents ────────────────────────────────────────────────────────────────────

mkdir -p "$COPILOT_DIR/agents/_shared"

# _shared conventions (loaded by every agent)
for f in "$REPO_DIR/agents/_shared/"*.md; do
  dest="$COPILOT_DIR/agents/_shared/$(basename "$f")"
  cp "$f" "$dest"
  echo "  agents/_shared/$(basename "$f")"
done

# Each agent file
for f in "$REPO_DIR/agents/"*.agent.md; do
  dest="$COPILOT_DIR/agents/$(basename "$f")"
  cp "$f" "$dest"
  echo "  agents/$(basename "$f")"
done

echo ""
echo "Done. $(find "$COPILOT_DIR/skills" -name 'SKILL.md' | wc -l | tr -d ' ') skills, $(find "$COPILOT_DIR/agents" -name '*.agent.md' | wc -l | tr -d ' ') agents installed."
