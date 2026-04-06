# Hooks for Task State Management — Feasibility Evaluation

**Date:** 2025-01-20  
**Based on:** [GitHub Copilot CLI Hooks Documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)

---

## Executive Summary

**Verdict: ✅ FEASIBLE with caveats**

Hooks **can** reliably handle the write side of task state management, but with important limitations. The hybrid read-write architecture is sound and aligns well with hooks' capabilities.

### Key Findings

1. **sessionStart** and **sessionEnd** hooks can touch timestamps and manage active-tasks.json
2. **postToolUse** can detect task folder creation and auto-register tasks
3. Hooks receive sufficient context (cwd, timestamp) for basic task tracking
4. **Critical limitation:** Hooks cannot easily determine "which task is active" — they only know current directory
5. **Race conditions:** Low risk if using atomic file operations (see implementation notes)

---

## Question 1: Can hooks update active-tasks.json automatically?

### 1.1 sessionStart Hook

**✅ CAN:**
- Read current active tasks from `~/.copilot/active-tasks.json`
- Touch `last_active` timestamp for tasks matching current repo
- Create session start log entry

**❌ CANNOT:**
- Determine which specific task the user intends to work on
- Parse user intent from `initialPrompt` reliably (too ambiguous)
- Distinguish between "starting new work" vs "checking status"

**Available Data:**
```json
{
  "timestamp": 1704614400000,
  "cwd": "/Users/me/repos/my-project",
  "source": "new",  // or "resume" or "startup"
  "initialPrompt": "Continue working on OAuth"  // OPTIONAL - may be empty
}
```

**Recommendation:**
Use sessionStart for **passive tracking only**:
- Log session starts for analytics
- Touch `last_active` for ALL tasks in current repo (not just one)
- Initialize session-level state if needed

**Do NOT use for:**
- Task selection logic (too unreliable)
- Creating new task entries (no way to generate unique IDs)

---

### 1.2 sessionEnd Hook

**✅ CAN:**
- Update `last_active` timestamp for tasks in current repo
- Archive tasks older than 7 days
- Run cleanup scripts
- Log session duration

**❌ CANNOT:**
- Determine if task is "complete" (no access to task completion signals)
- Know which task was worked on during the session
- Access git branch information directly (but can shell out to `git rev-parse --abbrev-ref HEAD`)

**Available Data:**
```json
{
  "timestamp": 1704618000000,
  "cwd": "/Users/me/repos/my-project",
  "reason": "complete"  // or "error", "abort", "timeout", "user_exit"
}
```

**Recommendation:**
Use sessionEnd for:
- Updating `last_active` for current repo tasks
- Archiving stale tasks (7+ day threshold)
- Session cleanup
- Logging session end reason for debugging

**Implementation Pattern:**
```bash
#!/bin/bash
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
REASON=$(echo "$INPUT" | jq -r '.reason')

# Get current git branch (if in a repo)
BRANCH=$(cd "$CWD" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# Update active-tasks.json
~/.copilot/scripts/update-task-timestamp.sh "$CWD" "$TIMESTAMP" "$BRANCH" "$REASON"
```

---

### 1.3 postToolUse Hook for Task Auto-Registration

**✅ CAN:**
- Detect when Manager creates a new task folder (`.context/tasks/YYYY-MM-DD_task-slug/`)
- Detect when plan.md is created or modified
- Auto-register new tasks in active-tasks.json
- Update timestamps after task modifications

**❌ CANNOT:**
- Distinguish between "Manager creating a task" vs "user manually editing"
- Access structured task metadata (must parse from files)

**Available Data:**
```json
{
  "timestamp": 1704614700000,
  "cwd": "/Users/me/repos/my-project",
  "toolName": "create",  // or "edit", "bash", etc.
  "toolArgs": "{\"path\":\".context/tasks/2025-01-20_oauth-implementation/plan.md\",\"file_text\":\"...\"}",
  "toolResult": {
    "resultType": "success",
    "textResultForLlm": "Created plan.md"
  }
}
```

**Recommendation:**
Use postToolUse with pattern matching:

```bash
#!/bin/bash
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName')
RESULT_TYPE=$(echo "$INPUT" | jq -r '.toolResult.resultType')

# Only process successful creates/edits
if [ "$RESULT_TYPE" != "success" ]; then
  exit 0
fi

if [ "$TOOL_NAME" = "create" ] || [ "$TOOL_NAME" = "edit" ]; then
  TOOL_ARGS=$(echo "$INPUT" | jq -r '.toolArgs')
  FILE_PATH=$(echo "$TOOL_ARGS" | jq -r '.path')
  
  # Detect task folder creation
  if [[ "$FILE_PATH" =~ \.context/tasks/([0-9]{4}-[0-9]{2}-[0-9]{2})_([^/]+)/plan\.md ]]; then
    TASK_DATE="${BASH_REMATCH[1]}"
    TASK_SLUG="${BASH_REMATCH[2]}"
    TASK_ID="${TASK_DATE}_${TASK_SLUG}"
    
    CWD=$(echo "$INPUT" | jq -r '.cwd')
    TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
    
    # Auto-register task
    ~/.copilot/scripts/register-task.sh "$CWD" "$TASK_ID" "$TIMESTAMP"
  fi
fi
```

**Patterns to Detect:**
- ✅ New plan.md creation: `.context/tasks/YYYY-MM-DD_slug/plan.md`
- ✅ New git branch matching pattern: `task/YYYY-MM-DD_slug` or `feature/slug`
- ✅ Commits with specific message format: `[task:YYYY-MM-DD_slug] ...`

---

## Question 2: What data is available to hooks?

### Summary Table

| Hook Type             | timestamp | cwd | prompt/args | git context | task context |
|-----------------------|-----------|-----|-------------|-------------|--------------|
| sessionStart          | ✅        | ✅  | initialPrompt (opt) | ❌ | ❌ |
| sessionEnd            | ✅        | ✅  | reason      | ❌          | ❌           |
| userPromptSubmitted   | ✅        | ✅  | prompt      | ❌          | ❌           |
| preToolUse            | ✅        | ✅  | toolName, toolArgs | ❌ | ❌ |
| postToolUse           | ✅        | ✅  | toolName, toolArgs, result | ❌ | ❌ |
| errorOccurred         | ✅        | ✅  | error object | ❌         | ❌           |

**Key Observations:**

1. **No git context:** Hooks do NOT receive current branch, commit SHA, or repo URL
   - **Workaround:** Shell out to `git` commands within hook scripts
   
2. **No task context:** Hooks do NOT know which task folder is active
   - **Workaround:** Parse task ID from branch name or working directory
   
3. **CWD is the anchor:** All hooks receive the current working directory
   - Can use this to map to repository and filter active-tasks.json
   
4. **Timestamps are precise:** Unix milliseconds allow accurate duration tracking

5. **Tool arguments are JSON strings:** Must parse twice (jq once for INPUT, again for toolArgs)

---

### Example: Extracting Git Context in Hooks

```bash
#!/bin/bash
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Get git context
GIT_BRANCH=$(cd "$CWD" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
GIT_ROOT=$(cd "$CWD" && git rev-parse --show-toplevel 2>/dev/null || echo "")
GIT_COMMIT=$(cd "$CWD" && git rev-parse --short HEAD 2>/dev/null || echo "")

# Extract task ID from branch name (if matches pattern)
if [[ "$GIT_BRANCH" =~ task/([0-9]{4}-[0-9]{2}-[0-9]{2}_[^/]+) ]]; then
  TASK_ID="${BASH_REMATCH[1]}"
fi
```

---

## Question 3: Proposed Hybrid Approach

### Architecture Evaluation: ✅ SOUND

The hybrid approach correctly divides responsibilities:

#### **Read Side (Manager does this):**
✅ Step 0 of Turn Protocol: Read `~/.copilot/active-tasks.json`
✅ Filter by current repo (using git root)
✅ Check user prompt for task ID mentions
✅ Auto-resume if match found
✅ Present task list if multiple matches

**Why Manager handles reads:**
- Needs structured decision-making logic
- Must interact with user for clarification
- Can parse prompts with LLM understanding
- Has context about task structure and conventions

---

#### **Write Side (Hooks do this automatically):**

**✅ sessionStart Hook:**
```json
{
  "type": "command",
  "bash": "~/.copilot/scripts/session-start-tracker.sh",
  "cwd": ".",
  "timeoutSec": 5
}
```
**Actions:**
- Log session start to analytics file
- Touch `last_active` for all tasks in current repo (passive tracking)
- Initialize session state if needed

**✅ sessionEnd Hook:**
```json
{
  "type": "command",
  "bash": "~/.copilot/scripts/session-end-tracker.sh",
  "cwd": ".",
  "timeoutSec": 10
}
```
**Actions:**
- Update `last_active` for tasks in current repo
- Archive tasks with `last_active > 7 days ago`
- Log session duration and end reason
- Cleanup temporary session files

**✅ postToolUse Hook:**
```json
{
  "type": "command",
  "bash": "~/.copilot/scripts/task-auto-register.sh",
  "cwd": ".",
  "timeoutSec": 5
}
```
**Actions:**
- Detect new task folder creation (plan.md pattern)
- Auto-register task in active-tasks.json
- Update task timestamp on modifications
- Optionally: detect git branch creation matching task pattern

---

## Specific Hook Configurations

### Complete hooks.json for CLI

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "type": "command",
        "bash": "~/.copilot/scripts/session-start-tracker.sh",
        "powershell": "$env:USERPROFILE\\.copilot\\scripts\\session-start-tracker.ps1",
        "cwd": ".",
        "timeoutSec": 5
      }
    ],
    "sessionEnd": [
      {
        "type": "command",
        "bash": "~/.copilot/scripts/session-end-tracker.sh",
        "powershell": "$env:USERPROFILE\\.copilot\\scripts\\session-end-tracker.ps1",
        "cwd": ".",
        "timeoutSec": 10
      }
    ],
    "postToolUse": [
      {
        "type": "command",
        "bash": "~/.copilot/scripts/task-auto-register.sh",
        "powershell": "$env:USERPROFILE\\.copilot\\scripts\\task-auto-register.ps1",
        "cwd": ".",
        "timeoutSec": 5
      }
    ]
  }
}
```

**Installation Location:**
- CLI: `.github/hooks/task-tracking.json` in each repo OR `~/.copilot/hooks/global.json` (if global hooks supported)
- Loaded from current working directory

---

### Script 1: session-start-tracker.sh

```bash
#!/bin/bash
set -e

INPUT=$(cat)
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
CWD=$(echo "$INPUT" | jq -r '.cwd')
SOURCE=$(echo "$INPUT" | jq -r '.source')

ACTIVE_TASKS_FILE="$HOME/.copilot/active-tasks.json"

# Get git root to identify repository
GIT_ROOT=$(cd "$CWD" && git rev-parse --show-toplevel 2>/dev/null || echo "")

if [ -z "$GIT_ROOT" ]; then
  # Not in a git repo, skip
  exit 0
fi

# Ensure active-tasks.json exists
if [ ! -f "$ACTIVE_TASKS_FILE" ]; then
  echo '{"tasks":[]}' > "$ACTIVE_TASKS_FILE"
fi

# Touch last_active for all tasks in current repo
# (Using jq to update in place atomically)
TEMP_FILE=$(mktemp)
jq --arg repo "$GIT_ROOT" --arg ts "$TIMESTAMP" '
  .tasks |= map(
    if .repo == $repo then
      .last_active = ($ts | tonumber)
    else
      .
    end
  )
' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"

# Log session start
echo "[$(date -Iseconds)] Session started in $GIT_ROOT (source: $SOURCE)" >> "$HOME/.copilot/logs/sessions.log"
```

---

### Script 2: session-end-tracker.sh

```bash
#!/bin/bash
set -e

INPUT=$(cat)
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
CWD=$(echo "$INPUT" | jq -r '.cwd')
REASON=$(echo "$INPUT" | jq -r '.reason')

ACTIVE_TASKS_FILE="$HOME/.copilot/active-tasks.json"
SEVEN_DAYS_MS=$((7 * 24 * 60 * 60 * 1000))

GIT_ROOT=$(cd "$CWD" && git rev-parse --show-toplevel 2>/dev/null || echo "")

if [ -z "$GIT_ROOT" ] || [ ! -f "$ACTIVE_TASKS_FILE" ]; then
  exit 0
fi

# Update last_active for tasks in current repo
TEMP_FILE=$(mktemp)
jq --arg repo "$GIT_ROOT" --arg ts "$TIMESTAMP" '
  .tasks |= map(
    if .repo == $repo then
      .last_active = ($ts | tonumber)
    else
      .
    end
  )
' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"

# Archive stale tasks (last_active > 7 days ago)
CUTOFF=$((TIMESTAMP - SEVEN_DAYS_MS))
TEMP_FILE2=$(mktemp)
jq --arg cutoff "$CUTOFF" '
  .tasks |= map(
    if .last_active < ($cutoff | tonumber) and .status != "archived" then
      .status = "archived" | .archived_at = ($cutoff | tonumber)
    else
      .
    end
  )
' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE2" && mv "$TEMP_FILE2" "$ACTIVE_TASKS_FILE"

# Log session end
echo "[$(date -Iseconds)] Session ended in $GIT_ROOT (reason: $REASON)" >> "$HOME/.copilot/logs/sessions.log"
```

---

### Script 3: task-auto-register.sh

```bash
#!/bin/bash
set -e

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName')
RESULT_TYPE=$(echo "$INPUT" | jq -r '.toolResult.resultType')

# Only process successful creates
if [ "$RESULT_TYPE" != "success" ] || [ "$TOOL_NAME" != "create" ]; then
  exit 0
fi

TOOL_ARGS=$(echo "$INPUT" | jq -r '.toolArgs')
FILE_PATH=$(echo "$TOOL_ARGS" | jq -r '.path')

# Check if this is a task plan.md creation
if [[ "$FILE_PATH" =~ \.context/tasks/([0-9]{4}-[0-9]{2}-[0-9]{2})_([^/]+)/plan\.md ]]; then
  TASK_DATE="${BASH_REMATCH[1]}"
  TASK_SLUG="${BASH_REMATCH[2]}"
  TASK_ID="${TASK_DATE}_${TASK_SLUG}"
  
  CWD=$(echo "$INPUT" | jq -r '.cwd')
  TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp')
  
  GIT_ROOT=$(cd "$CWD" && git rev-parse --show-toplevel 2>/dev/null || echo "")
  GIT_BRANCH=$(cd "$CWD" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
  
  if [ -z "$GIT_ROOT" ]; then
    exit 0
  fi
  
  ACTIVE_TASKS_FILE="$HOME/.copilot/active-tasks.json"
  
  # Ensure file exists
  if [ ! -f "$ACTIVE_TASKS_FILE" ]; then
    echo '{"tasks":[]}' > "$ACTIVE_TASKS_FILE"
  fi
  
  # Check if task already exists
  EXISTING=$(jq --arg id "$TASK_ID" '.tasks[] | select(.id == $id)' "$ACTIVE_TASKS_FILE")
  
  if [ -z "$EXISTING" ]; then
    # Create new task entry
    TEMP_FILE=$(mktemp)
    jq --arg id "$TASK_ID" \
       --arg repo "$GIT_ROOT" \
       --arg branch "$GIT_BRANCH" \
       --arg ts "$TIMESTAMP" \
       '.tasks += [{
         "id": $id,
         "repo": $repo,
         "branch": $branch,
         "status": "active",
         "created_at": ($ts | tonumber),
         "last_active": ($ts | tonumber)
       }]' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"
    
    echo "[$(date -Iseconds)] Auto-registered task: $TASK_ID in $GIT_ROOT" >> "$HOME/.copilot/logs/tasks.log"
  fi
fi
```

---

## Limitations: What Hooks CAN'T Do

### 1. **Task Selection Logic**
❌ Hooks cannot determine which task the user wants to work on
- **Why:** No access to user intent or LLM reasoning
- **Workaround:** Manager handles task selection via Turn Protocol Step 0

### 2. **Complex Decision Making**
❌ Hooks cannot make multi-factor decisions (e.g., "should I create a new task vs resume existing?")
- **Why:** Hooks are stateless shell scripts
- **Workaround:** Manager uses structured logic with fallback to user prompts

### 3. **Interactive User Prompts**
❌ Hooks cannot ask users for input
- **Why:** Hooks run in background, no stdin/stdout to user
- **Workaround:** Manager handles all user interaction

### 4. **Prompt Modification**
❌ Hooks cannot modify user prompts or agent behavior
- **Why:** `userPromptSubmitted` hook output is ignored
- **Note:** Only `preToolUse` can deny actions, not modify them

### 5. **Accessing Manager's Internal State**
❌ Hooks cannot read what task Manager selected or which agent is active
- **Why:** No shared memory or IPC between hooks and agent
- **Workaround:** Use file-based state (active-tasks.json) as single source of truth

### 6. **Reliable Task Completion Detection**
❌ Hooks cannot definitively know when a task is "complete"
- **Why:** Completion is a human judgment, not a file system event
- **Workaround:** Manager explicitly marks tasks complete via Turn Protocol Step 4

---

## Risks and Mitigations

### Risk 1: Race Conditions
**Scenario:** Multiple CLI sessions in same repo updating active-tasks.json simultaneously

**Likelihood:** Low (users rarely run multiple CLI sessions in same repo)

**Mitigation:**
- Use atomic file operations (write to temp, then `mv`)
- Use file locking if available (`flock` on Linux)
- Keep updates simple (timestamp touches are idempotent)

**Example with flock:**
```bash
(
  flock -x 200
  # Critical section - update active-tasks.json
  jq '...' "$ACTIVE_TASKS_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"
) 200>"/tmp/active-tasks.lock"
```

---

### Risk 2: Hook Execution Failures
**Scenario:** Hook script errors out, leaving state inconsistent

**Likelihood:** Medium during development, Low in production

**Mitigation:**
- Use `set -e` to fail fast
- Validate input before making changes
- Log all operations to debug file
- Use try-catch in PowerShell
- Keep hooks under 5 seconds (per docs recommendation)

**Example error handling:**
```bash
#!/bin/bash
set -e

INPUT=$(cat)

# Validate input
if ! echo "$INPUT" | jq empty 2>/dev/null; then
  echo "ERROR: Invalid JSON input" >&2
  exit 1
fi

# ... rest of script
```

---

### Risk 3: Performance Impact
**Scenario:** Hooks slow down agent responsiveness

**Likelihood:** Low if scripts are optimized

**Mitigation:**
- Keep hook execution under 5 seconds (docs recommend this)
- Use background processing for expensive ops
- Cache results where possible
- Set reasonable timeouts (5-10 seconds)

**Measurement:**
```bash
# Log execution time
START=$(date +%s%N)
# ... hook logic ...
END=$(date +%s%N)
DURATION_MS=$(( (END - START) / 1000000 ))
echo "Hook took ${DURATION_MS}ms" >> "$HOME/.copilot/logs/hook-perf.log"
```

---

### Risk 4: Cross-Platform Compatibility
**Scenario:** Bash scripts don't work on Windows, PowerShell scripts don't work on Unix

**Likelihood:** High if only one script provided

**Mitigation:**
- Always provide both `bash` and `powershell` variants
- Test on multiple platforms
- Use portable tools (jq available on all platforms)
- Document platform-specific behavior

---

### Risk 5: Data Corruption
**Scenario:** Malformed JSON written to active-tasks.json

**Likelihood:** Low if using jq correctly

**Mitigation:**
- Always use jq for JSON manipulation (never string concatenation)
- Validate JSON before writing
- Keep backups of active-tasks.json
- Use atomic writes (temp file + mv)

**Example validation:**
```bash
# Validate before replacing
if jq empty "$TEMP_FILE" 2>/dev/null; then
  mv "$TEMP_FILE" "$ACTIVE_TASKS_FILE"
else
  echo "ERROR: Generated invalid JSON" >&2
  rm "$TEMP_FILE"
  exit 1
fi
```

---

## Recommendations

### ✅ DO Use Hooks For:
1. **Passive timestamp tracking** (sessionStart, sessionEnd)
2. **Auto-archiving stale tasks** (sessionEnd)
3. **Auto-registering new tasks** (postToolUse on plan.md creation)
4. **Session analytics and logging**
5. **Cleanup operations** (sessionEnd)

### ❌ DON'T Use Hooks For:
1. **Task selection logic** (Manager does this)
2. **User interaction** (Manager does this)
3. **Complex decision-making** (Manager does this)
4. **Modifying agent behavior** (not supported)
5. **Real-time task status updates** (unreliable)

### 🎯 Hybrid Architecture Final Design:

**Manager (Read + Decide):**
- Step 0: Read active-tasks.json
- Filter by repo
- Parse user prompt for task mentions
- Present options or auto-select
- Explicitly write task completions

**Hooks (Write + Automate):**
- sessionStart: Touch timestamps (passive)
- sessionEnd: Archive stale, update timestamps
- postToolUse: Auto-register new tasks
- All hooks: Log for analytics

---

## Next Steps

1. **Create hook scripts** in `~/.copilot/scripts/`
2. **Create hooks.json** in project `.github/hooks/`
3. **Initialize active-tasks.json** schema
4. **Update Manager Turn Protocol** to read from active-tasks.json
5. **Test with multiple scenarios:**
   - New task creation
   - Task resumption
   - Stale task archival
   - Concurrent sessions

---

## Appendix: active-tasks.json Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "tasks": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "pattern": "^[0-9]{4}-[0-9]{2}-[0-9]{2}_[a-z0-9-]+$",
            "description": "Task ID in format YYYY-MM-DD_slug"
          },
          "repo": {
            "type": "string",
            "description": "Absolute path to git repository root"
          },
          "branch": {
            "type": "string",
            "description": "Git branch associated with task"
          },
          "status": {
            "type": "string",
            "enum": ["active", "paused", "completed", "archived"],
            "description": "Current task status"
          },
          "created_at": {
            "type": "number",
            "description": "Unix timestamp (ms) when task was created"
          },
          "last_active": {
            "type": "number",
            "description": "Unix timestamp (ms) of last activity"
          },
          "completed_at": {
            "type": "number",
            "description": "Unix timestamp (ms) when task completed (optional)"
          },
          "archived_at": {
            "type": "number",
            "description": "Unix timestamp (ms) when task archived (optional)"
          }
        },
        "required": ["id", "repo", "status", "created_at", "last_active"]
      }
    }
  },
  "required": ["tasks"]
}
```

**Example:**
```json
{
  "tasks": [
    {
      "id": "2025-01-20_oauth-implementation",
      "repo": "/Users/me/repos/my-api",
      "branch": "feature/oauth",
      "status": "active",
      "created_at": 1737388800000,
      "last_active": 1737475200000
    },
    {
      "id": "2025-01-15_fix-login-bug",
      "repo": "/Users/me/repos/my-api",
      "branch": "bugfix/login",
      "status": "completed",
      "created_at": 1737100800000,
      "last_active": 1737388700000,
      "completed_at": 1737388700000
    },
    {
      "id": "2025-01-05_refactor-auth",
      "repo": "/Users/me/repos/my-api",
      "branch": "refactor/auth",
      "status": "archived",
      "created_at": 1736035200000,
      "last_active": 1736380800000,
      "archived_at": 1737475200000
    }
  ]
}
```

---

## Conclusion

**The hybrid architecture is sound and feasible.**

Hooks provide reliable automation for the write-heavy operations (timestamps, archival, auto-registration), while Manager retains control over task selection and user interaction.

**Implementation Confidence: HIGH**

The documentation provides sufficient detail, and the proposed scripts address the main use cases with appropriate error handling and mitigation strategies.

**Recommended Timeline:**
1. Week 1: Implement and test hook scripts
2. Week 2: Update Manager Turn Protocol
3. Week 3: End-to-end testing with real workflows
4. Week 4: Refinement based on usage patterns

