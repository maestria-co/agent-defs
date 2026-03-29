# install.ps1 — copy agent-defs into $env:USERPROFILE\.copilot
# Run after any git pull to keep your local install current.
#
# Usage:
#   .\install.ps1
#
# Optional: override install destination
#   $env:COPILOT_DIR = "C:\custom\path" ; .\install.ps1

$ErrorActionPreference = "Stop"

$RepoDir = $PSScriptRoot
$CopilotDir = if ($env:COPILOT_DIR) { $env:COPILOT_DIR } else { Join-Path $env:USERPROFILE ".copilot" }

Write-Host "Installing agent-defs -> $CopilotDir"
Write-Host ""

# ── Skills ────────────────────────────────────────────────────────────────────

New-Item -ItemType Directory -Force -Path (Join-Path $CopilotDir "skills\_shared") | Out-Null

# _shared conventions (loaded by every skill)
Get-ChildItem (Join-Path $RepoDir "skills\_shared\*.md") | ForEach-Object {
    $dest = Join-Path $CopilotDir "skills\_shared\$($_.Name)"
    Copy-Item $_.FullName -Destination $dest -Force
    Write-Host "  skills\_shared\$($_.Name)"
}

# GUIDE.md (skill selection reference)
Copy-Item (Join-Path $RepoDir "skills\GUIDE.md") -Destination (Join-Path $CopilotDir "skills\GUIDE.md") -Force
Write-Host "  skills\GUIDE.md"

# Each skill folder
Get-ChildItem (Join-Path $RepoDir "skills") -Directory | Where-Object { $_.Name -ne "_shared" } | ForEach-Object {
    $destSkill = Join-Path $CopilotDir "skills\$($_.Name)"
    New-Item -ItemType Directory -Force -Path $destSkill | Out-Null
    Copy-Item "$($_.FullName)\*" -Destination $destSkill -Recurse -Force
    Write-Host "  skills\$($_.Name)"
}

Write-Host ""

# ── Agents ────────────────────────────────────────────────────────────────────

New-Item -ItemType Directory -Force -Path (Join-Path $CopilotDir "agents\_shared") | Out-Null

# _shared conventions (loaded by every agent)
Get-ChildItem (Join-Path $RepoDir "agents\_shared\*.md") | ForEach-Object {
    $dest = Join-Path $CopilotDir "agents\_shared\$($_.Name)"
    Copy-Item $_.FullName -Destination $dest -Force
    Write-Host "  agents\_shared\$($_.Name)"
}

# Each agent file
Get-ChildItem (Join-Path $RepoDir "agents\*.agent.md") | ForEach-Object {
    $dest = Join-Path $CopilotDir "agents\$($_.Name)"
    Copy-Item $_.FullName -Destination $dest -Force
    Write-Host "  agents\$($_.Name)"
}

Write-Host ""

$skillCount = (Get-ChildItem (Join-Path $CopilotDir "skills") -Recurse -Filter "SKILL.md").Count
$agentCount = (Get-ChildItem (Join-Path $CopilotDir "agents") -Filter "*.agent.md").Count
Write-Host "Done. $skillCount skills, $agentCount agents installed."
