#!/usr/bin/env bash
# Global task state management library for agent-defs
# Manages active and archived tasks stored in ~/.copilot/
#
# Functions:
#   task_state_init           - Create state files if missing
#   task_state_add            - Add/update task in active state
#   task_state_update         - Touch last_active timestamp
#   task_state_complete       - Move task to archive
#   task_state_list           - List active tasks for repo
#   task_state_archive_old    - Archive tasks older than N days
#   task_state_get            - Get task details by ID
#   task_state_touch_repo     - Touch all tasks in repo
#   task_state_auto_register  - Auto-register task from plan.md

set -euo pipefail

# Configuration
readonly COPILOT_DIR="${HOME}/.copilot"
readonly ACTIVE_TASKS_FILE="${COPILOT_DIR}/active-tasks.json"
readonly ARCHIVED_TASKS_FILE="${COPILOT_DIR}/archived-tasks.json"
readonly LOCK_FILE="${COPILOT_DIR}/.task-state.lock"
readonly LOCK_TIMEOUT=10

# Check dependencies
_check_dependencies() {
  if ! command -v jq &> /dev/null; then
    echo "Warning: jq not installed. Task state tracking disabled." >&2
    return 1
  fi
  return 0
}

# Get current timestamp in ISO 8601 format
_get_timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Acquire file lock with timeout (simple lockfile approach)
_acquire_lock() {
  local timeout="${LOCK_TIMEOUT}"
  
  # Create lock file directory if it doesn't exist
  mkdir -p "${COPILOT_DIR}"
  
  local count=0
  while [[ $count -lt $((timeout * 10)) ]]; do
    # Try to create lock file atomically
    if mkdir "${LOCK_FILE}" 2>/dev/null; then
      # Store PID for debugging
      echo $$ > "${LOCK_FILE}/pid"
      return 0
    fi
    
    # Check if lock is stale (>60s old)
    if [[ -d "${LOCK_FILE}" ]] && [[ -f "${LOCK_FILE}/pid" ]]; then
      # Try to get lock modification time (BSD or GNU stat)
      local lock_mtime
      if lock_mtime=$(stat -f %m "${LOCK_FILE}" 2>/dev/null); then
        # BSD stat (macOS)
        local lock_age=$(($(date +%s) - lock_mtime))
      elif lock_mtime=$(stat -c %Y "${LOCK_FILE}" 2>/dev/null); then
        # GNU stat (Linux)
        local lock_age=$(($(date +%s) - lock_mtime))
      else
        # Can't determine age, skip stale check
        lock_age=0
      fi
      
      if [[ ${lock_age:-0} -gt 60 ]]; then
        echo "Warning: Removing stale lock (age: ${lock_age}s)" >&2
        rm -rf "${LOCK_FILE}"
        continue
      fi
    fi
    
    sleep 0.1
    count=$((count + 1))
  done
  
  echo "Error: Failed to acquire lock after ${timeout}s" >&2
  return 1
}

# Release file lock
_release_lock() {
  rm -rf "${LOCK_FILE}" 2>/dev/null || true
}

# Atomic file write: write to temp, then move
_atomic_write() {
  local file="$1"
  local content="$2"
  local temp_file="${file}.tmp.$$"
  
  echo "$content" > "$temp_file"
  mv "$temp_file" "$file"
}

# Validate and fix JSON file
_validate_json() {
  local file="$1"
  
  if [[ ! -f "$file" ]]; then
    return 1
  fi
  
  if ! jq empty "$file" 2>/dev/null; then
    # Corrupted JSON - backup and recreate
    local backup="${file}.bak.$(date +%s)"
    echo "Warning: Corrupted JSON detected in $file, backing up to $backup" >&2
    cp "$file" "$backup"
    return 1
  fi
  
  return 0
}

# Initialize task state files
task_state_init() {
  if ! _check_dependencies; then
    return 0
  fi
  
  mkdir -p "${COPILOT_DIR}"
  
  # Initialize active tasks file
  if [[ ! -f "$ACTIVE_TASKS_FILE" ]] || ! _validate_json "$ACTIVE_TASKS_FILE"; then
    _atomic_write "$ACTIVE_TASKS_FILE" '{"version":"1.0","tasks":[]}'
  fi
  
  # Initialize archived tasks file
  if [[ ! -f "$ARCHIVED_TASKS_FILE" ]] || ! _validate_json "$ARCHIVED_TASKS_FILE"; then
    _atomic_write "$ARCHIVED_TASKS_FILE" '{"version":"1.0","tasks":[]}'
  fi
  
  return 0
}

# Add or update task in active state
# Usage: task_state_add --id TASK_ID --repo REPO_PATH --branch BRANCH --type TYPE --title TITLE
task_state_add() {
  if ! _check_dependencies; then
    return 0
  fi
  
  # Parse arguments
  local task_id="" repo_path="" branch_name="" task_type="" task_title=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --id) task_id="$2"; shift 2 ;;
      --repo) repo_path="$2"; shift 2 ;;
      --branch) branch_name="$2"; shift 2 ;;
      --type) task_type="$2"; shift 2 ;;
      --title) task_title="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  # Validate required arguments
  if [[ -z "$task_id" ]] || [[ -z "$repo_path" ]] || [[ -z "$branch_name" ]] || [[ -z "$task_type" ]] || [[ -z "$task_title" ]]; then
    echo "Error: Missing required arguments" >&2
    echo "Usage: task_state_add --id TASK_ID --repo REPO_PATH --branch BRANCH --type TYPE --title TITLE" >&2
    return 1
  fi
  
  task_state_init
  
  if ! _acquire_lock; then
    return 1
  fi
  
  local timestamp
  timestamp=$(_get_timestamp)
  
  # Read existing tasks
  local tasks
  tasks=$(jq -c '.tasks' "$ACTIVE_TASKS_FILE")
  
  # Check if task already exists
  local existing_task
  existing_task=$(echo "$tasks" | jq -c --arg id "$task_id" 'map(select(.id == $id)) | .[0] // null')
  
  local new_tasks
  if [[ "$existing_task" != "null" ]]; then
    # Update existing task (preserve created timestamp)
    local created
    created=$(echo "$existing_task" | jq -r '.created')
    new_tasks=$(echo "$tasks" | jq -c --arg id "$task_id" \
      --arg repo "$repo_path" \
      --arg branch "$branch_name" \
      --arg type "$task_type" \
      --arg title "$task_title" \
      --arg timestamp "$timestamp" \
      --arg created "$created" \
      'map(if .id == $id then {
        "id": $id,
        "repo": $repo,
        "branch": $branch,
        "type": $type,
        "title": $title,
        "status": "active",
        "last_active": $timestamp,
        "created": $created
      } else . end)')
  else
    # Add new task
    new_tasks=$(echo "$tasks" | jq -c --arg id "$task_id" \
      --arg repo "$repo_path" \
      --arg branch "$branch_name" \
      --arg type "$task_type" \
      --arg title "$task_title" \
      --arg timestamp "$timestamp" \
      '. + [{
        "id": $id,
        "repo": $repo,
        "branch": $branch,
        "type": $type,
        "title": $title,
        "status": "active",
        "last_active": $timestamp,
        "created": $timestamp
      }]')
  fi
  
  # Write back to file
  local new_content
  new_content=$(jq -c --argjson tasks "$new_tasks" '.tasks = $tasks' "$ACTIVE_TASKS_FILE")
  _atomic_write "$ACTIVE_TASKS_FILE" "$new_content"
  
  _release_lock
  return 0
}

# Update last_active timestamp for a task
# Usage: task_state_update --id TASK_ID
task_state_update() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local task_id=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --id) task_id="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$task_id" ]]; then
    echo "Error: Missing required argument: --id" >&2
    echo "Usage: task_state_update --id TASK_ID" >&2
    return 1
  fi
  
  task_state_init
  
  if ! _acquire_lock; then
    return 1
  fi
  
  local timestamp
  timestamp=$(_get_timestamp)
  
  # Update task timestamp
  local new_content
  new_content=$(jq -c --arg id "$task_id" --arg timestamp "$timestamp" \
    '.tasks |= map(if .id == $id then .last_active = $timestamp else . end)' \
    "$ACTIVE_TASKS_FILE")
  
  _atomic_write "$ACTIVE_TASKS_FILE" "$new_content"
  
  _release_lock
  return 0
}

# Move task from active to archived
# Usage: task_state_complete --id TASK_ID
task_state_complete() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local task_id=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --id) task_id="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$task_id" ]]; then
    echo "Error: Missing required argument: --id" >&2
    echo "Usage: task_state_complete --id TASK_ID" >&2
    return 1
  fi
  
  task_state_init
  
  if ! _acquire_lock; then
    return 1
  fi
  
  # Find task in active tasks
  local task
  task=$(jq -c --arg id "$task_id" '.tasks | map(select(.id == $id)) | .[0] // null' "$ACTIVE_TASKS_FILE")
  
  if [[ "$task" == "null" ]]; then
    echo "Warning: Task $task_id not found in active tasks" >&2
    _release_lock
    return 1
  fi
  
  # Update task status to complete
  local timestamp
  timestamp=$(_get_timestamp)
  task=$(echo "$task" | jq -c --arg timestamp "$timestamp" \
    '.status = "complete" | .last_active = $timestamp')
  
  # Remove from active tasks
  local new_active
  new_active=$(jq -c --arg id "$task_id" \
    '.tasks |= map(select(.id != $id))' \
    "$ACTIVE_TASKS_FILE")
  
  # Add to archived tasks
  local new_archived
  new_archived=$(jq -c --argjson task "$task" \
    '.tasks += [$task]' \
    "$ARCHIVED_TASKS_FILE")
  
  # Write both files
  _atomic_write "$ACTIVE_TASKS_FILE" "$new_active"
  _atomic_write "$ARCHIVED_TASKS_FILE" "$new_archived"
  
  _release_lock
  return 0
}

# List active tasks for a repository
# Usage: task_state_list --repo REPO_PATH
task_state_list() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local repo_path=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo) repo_path="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$repo_path" ]]; then
    echo "Error: Missing required argument: --repo" >&2
    echo "Usage: task_state_list --repo REPO_PATH" >&2
    return 1
  fi
  
  task_state_init
  
  # Filter tasks by repo and output JSON
  jq -c --arg repo "$repo_path" \
    '.tasks | map(select(.repo == $repo))' \
    "$ACTIVE_TASKS_FILE"
  
  return 0
}

# Archive tasks older than N days
# Usage: task_state_archive_old --days N
task_state_archive_old() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local days=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --days) days="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$days" ]]; then
    echo "Error: Missing required argument: --days" >&2
    echo "Usage: task_state_archive_old --days N" >&2
    return 1
  fi
  
  task_state_init
  
  if ! _acquire_lock; then
    return 1
  fi
  
  # Calculate cutoff timestamp (N days ago)
  local cutoff_timestamp
  if date --version &>/dev/null 2>&1; then
    # GNU date
    cutoff_timestamp=$(date -u -d "${days} days ago" +"%Y-%m-%dT%H:%M:%SZ")
  else
    # BSD date (macOS)
    cutoff_timestamp=$(date -u -v-"${days}"d +"%Y-%m-%dT%H:%M:%SZ")
  fi
  
  # Find old tasks
  local old_tasks
  old_tasks=$(jq -c --arg cutoff "$cutoff_timestamp" \
    '.tasks | map(select(.last_active < $cutoff))' \
    "$ACTIVE_TASKS_FILE")
  
  local old_count
  old_count=$(echo "$old_tasks" | jq 'length')
  
  if [[ "$old_count" -eq 0 ]]; then
    _release_lock
    return 0
  fi
  
  # Update status to complete for old tasks
  local timestamp
  timestamp=$(_get_timestamp)
  old_tasks=$(echo "$old_tasks" | jq -c --arg timestamp "$timestamp" \
    'map(.status = "complete" | .last_active = $timestamp)')
  
  # Remove old tasks from active
  local new_active
  new_active=$(jq -c --arg cutoff "$cutoff_timestamp" \
    '.tasks |= map(select(.last_active >= $cutoff))' \
    "$ACTIVE_TASKS_FILE")
  
  # Add old tasks to archive
  local new_archived
  new_archived=$(jq -c --argjson old_tasks "$old_tasks" \
    '.tasks += $old_tasks' \
    "$ARCHIVED_TASKS_FILE")
  
  # Write both files
  _atomic_write "$ACTIVE_TASKS_FILE" "$new_active"
  _atomic_write "$ARCHIVED_TASKS_FILE" "$new_archived"
  
  _release_lock
  return 0
}

# Get task details by ID (searches active then archived)
# Usage: task_state_get --id TASK_ID
task_state_get() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local task_id=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --id) task_id="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$task_id" ]]; then
    echo "Error: Missing required argument: --id" >&2
    echo "Usage: task_state_get --id TASK_ID" >&2
    return 1
  fi
  
  task_state_init
  
  # Search in active tasks first
  local task
  task=$(jq -c --arg id "$task_id" \
    '.tasks | map(select(.id == $id)) | .[0] // null' \
    "$ACTIVE_TASKS_FILE")
  
  if [[ "$task" != "null" ]]; then
    echo "$task"
    return 0
  fi
  
  # Search in archived tasks
  task=$(jq -c --arg id "$task_id" \
    '.tasks | map(select(.id == $id)) | .[0] // null' \
    "$ARCHIVED_TASKS_FILE")
  
  if [[ "$task" != "null" ]]; then
    echo "$task"
    return 0
  fi
  
  echo "null"
  return 1
}

# Touch last_active for all tasks in a repository
# Usage: task_state_touch_repo --repo REPO_PATH
task_state_touch_repo() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local repo_path=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo) repo_path="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$repo_path" ]]; then
    echo "Error: Missing required argument: --repo" >&2
    echo "Usage: task_state_touch_repo --repo REPO_PATH" >&2
    return 1
  fi
  
  task_state_init
  
  if ! _acquire_lock; then
    return 1
  fi
  
  local timestamp
  timestamp=$(_get_timestamp)
  
  # Update last_active for all tasks in repo
  local new_content
  new_content=$(jq -c --arg repo "$repo_path" --arg timestamp "$timestamp" \
    '.tasks |= map(if .repo == $repo then .last_active = $timestamp else . end)' \
    "$ACTIVE_TASKS_FILE")
  
  _atomic_write "$ACTIVE_TASKS_FILE" "$new_content"
  
  _release_lock
  return 0
}

# Auto-register task when plan.md is created
# Usage: task_state_auto_register --id TASK_ID --repo REPO_PATH --branch BRANCH_NAME
task_state_auto_register() {
  if ! _check_dependencies; then
    return 0
  fi
  
  local task_id="" repo_path="" branch_name=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --id) task_id="$2"; shift 2 ;;
      --repo) repo_path="$2"; shift 2 ;;
      --branch) branch_name="$2"; shift 2 ;;
      *) echo "Error: Unknown argument: $1" >&2; return 1 ;;
    esac
  done
  
  if [[ -z "$task_id" ]] || [[ -z "$repo_path" ]] || [[ -z "$branch_name" ]]; then
    echo "Error: Missing required arguments" >&2
    echo "Usage: task_state_auto_register --id TASK_ID --repo REPO_PATH --branch BRANCH_NAME" >&2
    return 1
  fi
  
  # Infer task type from task ID pattern
  local task_type="coding"
  if [[ "$task_id" =~ ^research ]]; then
    task_type="research"
  elif [[ "$task_id" =~ ^plan ]]; then
    task_type="planning"
  elif [[ "$task_id" =~ ^bug ]]; then
    task_type="bugfix"
  elif [[ "$task_id" =~ ^refactor ]]; then
    task_type="refactor"
  fi
  
  # Try to read title from plan.md
  local task_title="$task_id"
  local plan_file="${repo_path}/.context/tasks/${task_id}/plan.md"
  
  if [[ -f "$plan_file" ]]; then
    # Read first non-empty line that starts with # (markdown heading)
    task_title=$(grep -m 1 '^#' "$plan_file" 2>/dev/null | sed -E 's/^#+[[:space:]]*//' || echo "$task_id")
  fi
  
  # Add task using task_state_add (idempotent)
  task_state_add \
    --id "$task_id" \
    --repo "$repo_path" \
    --branch "$branch_name" \
    --type "$task_type" \
    --title "$task_title"
  
  return 0
}

# Export functions for sourcing
export -f task_state_init
export -f task_state_add
export -f task_state_update
export -f task_state_complete
export -f task_state_list
export -f task_state_archive_old
export -f task_state_get
export -f task_state_touch_repo
export -f task_state_auto_register
