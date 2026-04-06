#!/bin/bash
# Touch last_active timestamps for all tasks in current repo

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  exit 0
fi

# Source task state library
source ~/.copilot/scripts/task-state.sh || exit 0

# Update timestamps for all active tasks in this repo
task_state_touch_repo --repo "$REPO_ROOT"

exit 0
