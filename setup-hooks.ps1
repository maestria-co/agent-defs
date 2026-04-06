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
