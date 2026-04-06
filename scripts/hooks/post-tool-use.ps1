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
