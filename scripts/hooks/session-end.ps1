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
