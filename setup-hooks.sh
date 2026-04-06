#!/bin/bash
# Install Copilot CLI hooks for task tracking

SCRIPT_DIR="$HOME/.copilot/scripts"
REPO_ROOT=$(git rev-parse --show-toplevel)

# Create script directory
mkdir -p "$SCRIPT_DIR"

# Copy task-state library
cp "$REPO_ROOT/scripts/task-state.sh" "$SCRIPT_DIR/task-state.sh"
chmod +x "$SCRIPT_DIR/task-state.sh"

# Make hook scripts executable
chmod +x "$REPO_ROOT/scripts/hooks/"*.sh

# Initialize state files
if [[ ! -f "$HOME/.copilot/active-tasks.json" ]]; then
  echo '{"version":"1.0","tasks":[]}' > "$HOME/.copilot/active-tasks.json"
fi

if [[ ! -f "$HOME/.copilot/archived-tasks.json" ]]; then
  echo '{"version":"1.0","tasks":[]}' > "$HOME/.copilot/archived-tasks.json"
fi

echo "✅ Copilot CLI hooks installed successfully"
echo "   Hook config: .github/hooks/hooks.json"
echo "   Task state library: $SCRIPT_DIR/task-state.sh"
echo ""
echo "Hooks will activate automatically in this repository."
