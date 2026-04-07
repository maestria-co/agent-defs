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

# Install git pre-commit hook for context graph sync
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"
mkdir -p "$GIT_HOOKS_DIR"

PRE_COMMIT_HOOK="$GIT_HOOKS_DIR/pre-commit"
GRAPH_HOOK="$REPO_ROOT/scripts/hooks/sync-context-graph.sh"

if [[ -f "$PRE_COMMIT_HOOK" ]]; then
  # Append to existing pre-commit hook if not already registered
  if ! grep -q "sync-context-graph" "$PRE_COMMIT_HOOK"; then
    echo "" >> "$PRE_COMMIT_HOOK"
    echo "# Context graph sync" >> "$PRE_COMMIT_HOOK"
    echo "bash \"\$(git rev-parse --show-toplevel)/scripts/hooks/sync-context-graph.sh\"" >> "$PRE_COMMIT_HOOK"
    echo "   Appended context graph sync to existing pre-commit hook."
  fi
else
  cat > "$PRE_COMMIT_HOOK" <<'HOOK'
#!/bin/bash
bash "$(git rev-parse --show-toplevel)/scripts/hooks/sync-context-graph.sh"
HOOK
  chmod +x "$PRE_COMMIT_HOOK"
  echo "   Created pre-commit hook for context graph sync."
fi

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
echo "   Pre-commit hook: $GIT_HOOKS_DIR/pre-commit (context graph sync)"
echo ""
echo "Hooks will activate automatically in this repository."
