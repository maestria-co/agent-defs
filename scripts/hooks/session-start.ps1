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
