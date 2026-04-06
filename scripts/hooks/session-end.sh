#!/bin/bash
# Update timestamps and auto-archive old tasks

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  exit 0
fi

source ~/.copilot/scripts/task-state.sh || exit 0

# Touch timestamps
task_state_touch_repo --repo "$REPO_ROOT"

# Archive tasks older than 7 days
task_state_archive_old --days 7

exit 0
