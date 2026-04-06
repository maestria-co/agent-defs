# Implementation Plan: Global Task Tracking with Copilot CLI Hooks

## Plan Revision History

**2026-04-05 - Architecture Correction:**
- Corrected hook path: `.github/hooks/hooks.json` (not `~/.config/github-copilot/hooks/`)
- Clarified Manager reads file directly (hooks cannot export env vars)
- Added hybrid architecture: Manager reads, hooks write
- Removed incorrect assumptions about `$COPILOT_AGENT` filtering
- Updated Phase 2 with correct hook configurations
- Updated Phase 3 to remove environment variable assumptions

**2026-04-05 - Phase 2 Complete:**
- ✅ Created `.github/hooks/hooks.json` with 3 lifecycle hooks (sessionStart, sessionEnd, postToolUse)
- ✅ Implemented 6 hook scripts (3 bash + 3 PowerShell) in `scripts/hooks/`
- ✅ Created `setup-hooks.sh` and `setup-hooks.ps1` installation scripts
- ✅ All scripts validated (JSON syntax, bash syntax, executable permissions)
- ✅ Cross-platform implementation verified
- Next: Phase 3 (Manager agent updates) pending user approval

**2026-04-05 - Phase 3 Complete:**
- ✅ 3.1: Step 0 added with auto-resume logic (lines 23-45 in manager.agent.md)
- ✅ 3.2: Task registration added after task creation (lines 109-119)
- ✅ 3.3: Task archival added to completion workflow (lines 295-300)
- ✅ 3.4: Task Management Commands section added (lines 364-379)
- ✅ Turn Protocol now has steps 0-4 (previously 1-4)
- ✅ Completion Workflow now has steps 1-6 (previously 1-5)
- ✅ All 4 deliverables implemented with correct insertion points
- ✅ No syntax errors, all existing functionality preserved
- Next: Phase 4 (Documentation and Testing)

---

## Task: Global Task Tracking with Copilot CLI Hooks

## Architecture Summary

**Hybrid Architecture:**
- **Manager (Read side):** Reads `~/.copilot/active-tasks.json` directly in Step 0, filters by repo, detects task ID mentions, handles task selection
- **Hooks (Write side):** Automate timestamp updates, auto-register new tasks, auto-archive stale tasks

**What hooks CANNOT do:**
- Export environment variables to agents
- Modify user prompts
- Filter by agent type (no `$COPILOT_AGENT` variable)
- Make decisions about which task to resume

**What hooks CAN do:**
- Update `last_active` timestamps on sessionStart/sessionEnd
- Auto-register tasks when `.context/tasks/TASK-ID/plan.md` is created
- Auto-archive tasks >7 days old
- Run side-effect scripts that modify files

### User Requirements Summary

**Problem:** Users must manually select `@manager` every time to get proper task infrastructure (branches, task folders, plan.md). Forgetting to do this results in lost context and missing documentation.

**Solution:** Implement global task tracking with Copilot CLI pre-request hooks to make task management automatic and transparent.

### Key Decisions from User

1. **Hook installation:** Separate `setup-hooks.sh` / `setup-hooks.ps1` scripts (not integrated into install.sh)
2. **Task ID detection:** Auto-resume if task ID mentioned anywhere in request (not explicit `resume` command required)
3. **Archive storage:** Separate `~/.copilot/archived-tasks.json` file (not mixed with active tasks)
4. **Multiple active tasks:** Do nothing, assume new work (no hints or interruptions)
5. **Global storage:** `~/.copilot/active-tasks.json` with repo_path per task
6. **Auto-archive:** 7 days of inactivity
7. **Multiple tasks per repo:** Allowed (1-3 concurrent tasks for coding/research/planning)

### Current Codebase State

**Exists:**
- Manager agent with comprehensive turn protocol (12.4 KB, 333 lines)
- Task folder structure `.context/tasks/TASK-ID/plan.md`
- Task classification rules (4 triggers: 2+ files, specialist handoff, research tracking, code changes)
- Install scripts (`install.sh`, `install.ps1`) deploying to `~/.copilot` and `~/.claude`
- 3 active tasks in `.context/tasks/` (mje0003, mje0004, mje0005)
- No existing hooks (only git sample files)
- No global task tracking file
- `CLAUDE.md` exists; `.github/copilot-instructions.md` does not

**Gaps:**
- No hooks to automate task timestamp updates
- No global `active-tasks.json` state file
- Manager doesn't check for active tasks in Step 0
- No task lifecycle management (create/update/complete/archive)
- No hook configuration or scripts

---

## Implementation Plan

### Phase 1: Global Task State Infrastructure

**1.1 Create Global Task State Schema**

File: `~/.copilot/active-tasks.json`

```json
{
  "version": "1.0",
  "tasks": [
    {
      "id": "mje0006",
      "repo": "/Users/you/repos/agent-defs",
      "branch": "feature/mje0006-auto-routing",
      "type": "coding",
      "title": "Global task tracking implementation",
      "status": "active",
      "last_active": "2026-04-04T18:00:00Z",
      "created": "2026-04-04T10:00:00Z"
    }
  ]
}
```

**Fields:**
- `id` — Task identifier (matches `.context/tasks/TASK-ID/`)
- `repo` — Absolute path to repository root
- `branch` — Git branch name
- `type` — `coding | research | planning | bugfix | refactor`
- `title` — Human-readable task summary
- `status` — `active | paused | complete`
- `last_active` — ISO 8601 timestamp of last update
- `created` — ISO 8601 timestamp of task creation

**Acceptance criteria:**
- Schema versioned for future compatibility
- File created automatically if missing
- Invalid JSON handled gracefully (recreate with warning)

---

**1.2 Create Archive State File**

File: `~/.copilot/archived-tasks.json`

Same schema as active-tasks.json, but for completed/old tasks.

**Archive triggers:**
- User runs `@manager complete TASK-ID` → move to archive
- User runs `@manager wrap up` → complete current task, move to archive
- Auto-archive cron: tasks with `last_active > 7 days` → move to archive

---

**1.3 Create Task State Management Library**

File: `~/.copilot/scripts/task-state.sh` (sourced by hooks)

Functions:
```bash
task_state_init()           # Create active-tasks.json if missing
task_state_add()            # Add new task
task_state_update()         # Touch last_active timestamp
task_state_complete()       # Move task to archive
task_state_list()           # List active tasks for current repo
task_state_archive_old()    # Move 7d+ old tasks to archive
task_state_get()            # Get task details by ID
task_state_touch_repo()     # Touch last_active for all tasks in given repo
task_state_auto_register()  # Auto-register task when plan.md created
```

**Acceptance criteria:**
- Atomic file updates (write to temp, then mv)
- Concurrent access safe (file locking)
- Handles missing/corrupted JSON gracefully
- Cross-platform compatible (bash + PowerShell versions)

---

### Phase 2: Copilot CLI Hooks (Write-Side Automation)

**2.1 Create Hook Configuration**

File: `.github/hooks/hooks.json`

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [{
      "type": "command",
      "bash": "./scripts/hooks/session-start.sh",
      "powershell": "./scripts/hooks/session-start.ps1",
      "cwd": ".",
      "timeoutSec": 5
    }],
    "sessionEnd": [{
      "type": "command",
      "bash": "./scripts/hooks/session-end.sh",
      "powershell": "./scripts/hooks/session-end.ps1",
      "cwd": ".",
      "timeoutSec": 10
    }],
    "postToolUse": [{
      "type": "command",
      "bash": "./scripts/hooks/post-tool-use.sh",
      "powershell": "./scripts/hooks/post-tool-use.ps1",
      "cwd": ".",
      "timeoutSec": 5
    }]
  }
}
```

**Acceptance criteria:**
- Hooks located in `.github/hooks/hooks.json` (NOT `~/.config`)
- Hook scripts executable and handle errors gracefully
- Scripts execute in <5s (no blocking)
- Cross-platform (bash + PowerShell versions)

---

**2.2 Session Start Hook**

File: `scripts/hooks/session-start.sh`

```bash
#!/bin/bash
# Touch last_active timestamps for all tasks in current repo

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  exit 0
fi

# Source task state library
source ~/.copilot/scripts/task-state.sh || exit 0

# Update timestamps for all active tasks in this repo
task_state_touch_repo "$REPO_ROOT"

exit 0
```

File: `scripts/hooks/session-start.ps1`

```powershell
# PowerShell equivalent
$ErrorActionPreference = "SilentlyContinue"

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
  exit 0
}

# Source task state library
. "$env:USERPROFILE\.copilot\scripts\task-state.ps1"

# Update timestamps for all active tasks in this repo
Task-State-Touch-Repo -RepoRoot $repoRoot

exit 0
```

**Acceptance criteria:**
- Updates timestamps for all active tasks in current repo
- Fails gracefully if not in git repo
- No output unless errors occur
- Executes in <3s

---

**2.3 Session End Hook**

File: `scripts/hooks/session-end.sh`

```bash
#!/bin/bash
# Update timestamps and auto-archive old tasks

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
  exit 0
fi

source ~/.copilot/scripts/task-state.sh || exit 0

# Touch timestamps
task_state_touch_repo "$REPO_ROOT"

# Archive tasks older than 7 days
task_state_archive_old 7

exit 0
```

File: `scripts/hooks/session-end.ps1`

```powershell
# PowerShell equivalent
$ErrorActionPreference = "SilentlyContinue"

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
  exit 0
}

. "$env:USERPROFILE\.copilot\scripts\task-state.ps1"

Task-State-Touch-Repo -RepoRoot $repoRoot
Task-State-Archive-Old -DaysOld 7

exit 0
```

**Acceptance criteria:**
- Updates timestamps on session end
- Archives tasks >7 days old
- Executes in <5s
- Handles concurrent access safely

---

**2.4 Post-Tool-Use Hook**

File: `scripts/hooks/post-tool-use.sh`

```bash
#!/bin/bash
# Auto-register new tasks when plan.md files are created

INPUT=$(cat)

# Check if a plan.md was created in .context/tasks/
TOOL_OUTPUT=$(echo "$INPUT" | jq -r '.toolOutput // empty')

if echo "$TOOL_OUTPUT" | grep -q "Created.*\.context/tasks/.*/plan\.md"; then
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
  source ~/.copilot/scripts/task-state.sh || exit 0
  
  # Extract task ID from path
  TASK_ID=$(echo "$TOOL_OUTPUT" | grep -oP '\.context/tasks/\K[^/]+' | head -1)
  
  if [[ -n "$TASK_ID" ]]; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    task_state_auto_register "$TASK_ID" "$REPO_ROOT" "$BRANCH"
  fi
fi

exit 0
```

File: `scripts/hooks/post-tool-use.ps1`

```powershell
# PowerShell equivalent
$ErrorActionPreference = "SilentlyContinue"

$input = [Console]::In.ReadToEnd()
$toolOutput = ($input | ConvertFrom-Json).toolOutput

if ($toolOutput -match "Created.*\.context/tasks/.*/plan\.md") {
  $repoRoot = git rev-parse --show-toplevel 2>$null
  . "$env:USERPROFILE\.copilot\scripts\task-state.ps1"
  
  if ($toolOutput -match '\.context/tasks/([^/]+)/') {
    $taskId = $matches[1]
    $branch = git branch --show-current 2>$null
    Task-State-Auto-Register -TaskId $taskId -RepoRoot $repoRoot -Branch $branch
  }
}

exit 0
```

**Acceptance criteria:**
- Detects plan.md creation from tool output
- Extracts task ID from path
- Auto-registers task in active-tasks.json
- Handles missing data gracefully

---

**2.5 Create Hook Setup Scripts**

**File:** `setup-hooks.sh` (Linux/macOS)

```bash
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
```

**File:** `setup-hooks.ps1` (Windows/PowerShell)

```powershell
# PowerShell equivalent
$scriptDir = "$env:USERPROFILE\.copilot\scripts"
$repoRoot = git rev-parse --show-toplevel

New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null

# Copy task-state library
Copy-Item "$repoRoot\scripts\task-state.ps1" "$scriptDir\task-state.ps1" -Force

# Initialize state files
if (-not (Test-Path "$env:USERPROFILE\.copilot\active-tasks.json")) {
  '{"version":"1.0","tasks":[]}' | Out-File "$env:USERPROFILE\.copilot\active-tasks.json"
}

if (-not (Test-Path "$env:USERPROFILE\.copilot\archived-tasks.json")) {
  '{"version":"1.0","tasks":[]}' | Out-File "$env:USERPROFILE\.copilot\archived-tasks.json"
}

Write-Host "✅ Copilot CLI hooks installed successfully"
Write-Host "   Hook config: .github/hooks/hooks.json"
Write-Host "   Task state library: $scriptDir\task-state.ps1"
Write-Host ""
Write-Host "Hooks will activate automatically in this repository."
```

**Acceptance criteria:**
- Copies task-state library to `~/.copilot/scripts/`
- Sets executable permissions on hook scripts
- Initializes state files with valid empty JSON
- Idempotent (safe to run multiple times)
- Prints installation confirmation

---

### Phase 3: Manager Agent Turn Protocol Updates ✅ Complete

**3.1 Add Step 0: Check Active Tasks**

Insert before existing Step 1 in `agents/manager.agent.md`:

```markdown
### 0. Check Active Tasks

Read `~/.copilot/active-tasks.json` directly (hooks cannot pass this data via environment variables).

**Implementation:**
1. Load and parse `~/.copilot/active-tasks.json`
2. Filter tasks where `repo` matches `$(git rev-parse --show-toplevel)`
3. Parse user prompt for task ID mentions (regex: `\b([a-z]+\d+)\b`)

**If task ID mentioned in prompt:**
- Load `.context/tasks/TASK-ID/plan.md`
- Checkout branch
- Announce: "Resuming TASK-ID on branch [branch-name]. Current step: [step]."

**If user said "show active":**
- List all active tasks for current repo
- Wait for user selection

**Otherwise:**
- Proceed silently (no interruption)
```

**Acceptance criteria:**
- Manager reads file directly (not from environment variables)
- Regex correctly matches task IDs (case-insensitive)
- Auto-resume works with task ID anywhere in request ("fix bug in mje0006")
- `show active` command lists tasks in human-readable format
- No interruptions if user doesn't mention tasks

---

**3.2 Update Task Creation to Register Globally**

In existing "Set Active Task" section, add after creating task folder:

```markdown
**After creating task folder and branch:**
- Manager manually registers task in global state:
  ```bash
  # Call task-state library function directly
  source ~/.copilot/scripts/task-state.sh
  task_state_add \
    --id "TASK-ID" \
    --repo "$(git rev-parse --show-toplevel)" \
    --branch "$(git branch --show-current)" \
    --type "[coding|research|planning|bugfix]" \
    --title "[task title from plan.md]"
  ```
- Note: postToolUse hook will also auto-register when plan.md is created (idempotent)
- Store current task ID in session state for reference
```

---

**3.3 Update Task Completion to Archive Globally**

In "Task Completion" section, add after updating `plan.md`:

```markdown
**After marking task complete:**
- Manager archives task in global state:
  ```bash
  source ~/.copilot/scripts/task-state.sh
  task_state_complete --id "TASK-ID"
  ```
- Move task folder to `.context/tasks/archive/TASK-ID/` (optional, for repo cleanup)
```

---

**3.4 Add New User Commands**

Add to Manager agent documentation:

```markdown
## Task Management Commands

| Command | Behavior |
|---------|----------|
| `@manager show active` | List all active tasks for current repo |
| `@manager resume TASK-ID` | Explicit resume (redundant, auto-resume works) |
| `@manager complete TASK-ID` | Mark task done, archive, no checkout |
| `@manager wrap up` | Complete current active task, write retrospective |
```

---

### Phase 4: Documentation & Integration

**4.1 Update README.md**

Add new section:

```markdown
## Task Tracking with Hooks

Agent-defs now includes **global task tracking** using a hybrid architecture.

### Setup

Run once to install hooks:
```bash
./setup-hooks.sh    # Linux/macOS
./setup-hooks.ps1   # Windows
```

### How It Works

1. **Manager reads state:** Step 0 loads `~/.copilot/active-tasks.json` and checks for task ID mentions
2. **Hooks write state:** Update timestamps on session start/end, auto-register new tasks, auto-archive old tasks
3. **Mention task ID anywhere:** Manager auto-resumes that task
4. **No interruptions:** Manager never blocks your workflow unless you explicitly ask
5. **Auto-cleanup:** Tasks inactive for 7+ days automatically archive via sessionEnd hook

### Task Lifecycle

- **Create:** `@manager [request]` → Manager creates task folder + registers globally
- **Update:** Every plan.md update → `last_active` timestamp refreshed
- **Complete:** `@manager wrap up` → Task archived + retrospective written
- **Resume:** Mention task ID in any request → Auto-checkout + load plan.md

### Commands

- `@manager show active` — List active tasks
- `@manager complete TASK-ID` — Mark done without resuming
- `@manager wrap up` — Complete current task
```

---

**4.2 Update CLAUDE.md**

Add section after existing project instructions:

```markdown
## Global Task Tracking

Before processing any request, check for active tasks:

1. Read `~/.copilot/active-tasks.json` directly (load file and parse JSON)
2. Filter tasks where `repo` matches current repository root
3. If user mentioned a task ID (e.g., "mje0006") → auto-resume that task
4. If user said "show active" → list all active tasks for current repo
5. Otherwise → proceed normally

Active tasks are stored globally in `~/.copilot/active-tasks.json` and filtered by repository path.
Hooks automatically update timestamps and archive old tasks, but Manager makes all task selection decisions.
```

---

**4.3 Create .github/copilot-instructions.md**

New file (same content as addition to CLAUDE.md above).

---

**4.4 Update install.sh and install.ps1**

Add notification at end:

```bash
echo ""
echo "📋 Next step: Install task tracking hooks"
echo "   Run: ./setup-hooks.sh"
echo ""
```

---

### Phase 5: Testing & Validation

**5.1 Test Scenarios**

| Scenario | Expected Behavior | Verify |
|----------|-------------------|--------|
| First time setup | Hook installs, state files created | Files exist, hooks.json valid |
| Create new task | Task folder + global registration | Entry in active-tasks.json |
| Session start | Timestamps updated | last_active refreshed |
| Mention task ID | Auto-resume, checkout branch | Branch switched, plan.md loaded |
| `show active` command | List all active tasks | Correct repo filtering |
| Complete task | Archived, removed from active | Moved to archived-tasks.json |
| Session end + 7d old | Auto-archived | Old tasks moved to archive |
| Multiple active tasks | All tracked, no auto-pausing | Multiple entries in JSON |
| Non-git directory | Hooks exit gracefully | No errors, no state changes |
| Corrupted JSON | Recreated with warning | User notified, state reset |
| postToolUse plan.md | Task auto-registered | Entry added to active-tasks.json |

**5.2 Performance Benchmarks**

- sessionStart hook: < 3s
- sessionEnd hook: < 5s  
- postToolUse hook: < 5s
- Task state operations: < 100ms
- No blocking on Manager invocation

---

## Acceptance Criteria (Overall)

- [ ] `setup-hooks.sh` and `setup-hooks.ps1` scripts created and tested
- [ ] Hook configuration in `.github/hooks/hooks.json`
- [ ] Hook scripts in `scripts/hooks/` (session-start, session-end, post-tool-use)
- [ ] Task state library (`~/.copilot/scripts/task-state.sh`) with all 9 functions working
- [x] Manager agent Turn Protocol updated with Step 0 (reads file directly)
- [x] Task creation registers globally with all required fields
- [x] Task completion archives to separate file
- [x] `show active`, `complete TASK-ID`, `wrap up` commands implemented
- [ ] README.md updated with hook setup instructions
- [ ] CLAUDE.md and .github/copilot-instructions.md updated
- [ ] install.sh/install.ps1 notify user about hook setup
- [ ] All test scenarios pass
- [ ] Performance benchmarks met (hooks <5s, no blocking)

---

## Open Questions / Risks

1. **Hook execution environment:** Verify hooks can access git commands and file system in expected location
2. **postToolUse data format:** Confirm JSON structure of toolOutput to reliably detect plan.md creation
3. **Concurrent access:** File locking for active-tasks.json when hooks and Manager both update
4. **Cross-platform paths:** Windows path handling in PowerShell hook scripts
5. **Hook installation:** Users must have hooks enabled in Copilot CLI settings
6. **Task ID collisions:** If two repos use same task ID format, need repo path filtering to prevent conflicts

---

## Implementation Order

1. **Phase 1:** Task state infrastructure (library + JSON schema) ✅ Complete
2. **Phase 2:** Hook scripts (pre-request + setup scripts) ✅ Complete
3. **Phase 3:** Manager agent updates (Step 0 + lifecycle hooks) ✅ Complete
4. **Phase 4:** Documentation (README, CLAUDE.md, instructions) ⏳ Next
5. **Phase 5:** Testing and validation

**Estimated effort:** 3-4 focused sessions across 2-3 days

---

This plan is ready for execution. Start with Phase 1 to build the foundation, then layer in hooks and agent integration.
