#!/bin/bash
# Auto-register new tasks when plan.md files are created

INPUT=$(timeout 5 cat 2>/dev/null || echo '{}')

# Check if a plan.md was created in .context/tasks/
TOOL_OUTPUT=$(echo "$INPUT" | jq -r '.toolOutput // empty')

if echo "$TOOL_OUTPUT" | grep -q "Created.*\.context/tasks/.*/plan\.md"; then
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
  source ~/.copilot/scripts/task-state.sh || exit 0
  
  # Extract task ID from path
  TASK_ID=$(echo "$TOOL_OUTPUT" | sed -n 's/.*\.context\/tasks\/\([^/]*\).*/\1/p' | head -1)
  
  if [[ -n "$TASK_ID" ]]; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    task_state_auto_register --id "$TASK_ID" --repo "$REPO_ROOT" --branch "$BRANCH"
  fi
fi

exit 0
