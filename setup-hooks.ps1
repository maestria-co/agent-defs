# PowerShell equivalent
$scriptDir = "$env:USERPROFILE\.copilot\scripts"
$repoRoot = git rev-parse --show-toplevel

New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null

# Copy task-state library
Copy-Item "$repoRoot\scripts\task-state.ps1" "$scriptDir\task-state.ps1" -Force

# Install git pre-commit hook for context graph sync
$gitHooksDir = "$repoRoot\.git\hooks"
New-Item -ItemType Directory -Force -Path $gitHooksDir | Out-Null

$preCommitHook = "$gitHooksDir\pre-commit"
$graphHookLine = 'bash "$(git rev-parse --show-toplevel)/scripts/hooks/sync-context-graph.sh"'

if (Test-Path $preCommitHook) {
  $content = Get-Content $preCommitHook -Raw
  if ($content -notmatch "sync-context-graph") {
    Add-Content $preCommitHook "`n# Context graph sync`n$graphHookLine"
    Write-Host "   Appended context graph sync to existing pre-commit hook."
  }
} else {
  @("#!/bin/bash", $graphHookLine) | Out-File $preCommitHook -Encoding utf8
  Write-Host "   Created pre-commit hook for context graph sync."
}

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
Write-Host "   Pre-commit hook: $gitHooksDir\pre-commit (context graph sync)"
Write-Host ""
Write-Host "Hooks will activate automatically in this repository."
