# install.ps1 — copy agent-defs into $env:USERPROFILE\.copilot (default) or \.claude (--claude)
# Run after any git pull to keep your local install current.
#
# Usage:
#   .\install.ps1              # GitHub Copilot -> %USERPROFILE%\.copilot
#   .\install.ps1 -Claude      # Claude Code   -> %USERPROFILE%\.claude

param(
    [switch]$Claude
)

$ErrorActionPreference = "Stop"

$RepoDir = $PSScriptRoot

if ($Claude) {
    $InstallDir = if ($env:CLAUDE_DIR) { $env:CLAUDE_DIR } else { Join-Path $env:USERPROFILE ".claude" }
    Write-Host "Installing agent-defs -> $InstallDir"
    Write-Host "Mode: Claude Code"
} else {
    $InstallDir = if ($env:COPILOT_DIR) { $env:COPILOT_DIR } else { Join-Path $env:USERPROFILE ".copilot" }
    Write-Host "Installing agent-defs -> $InstallDir"
    Write-Host "Mode: GitHub Copilot"
}
Write-Host ""

# ── Skills ────────────────────────────────────────────────────────────────────

New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "skills\_shared") | Out-Null

# _shared conventions (loaded by every skill)
Get-ChildItem (Join-Path $RepoDir "skills\_shared\*.md") | ForEach-Object {
    Copy-Item $_.FullName -Destination (Join-Path $InstallDir "skills\_shared\$($_.Name)") -Force
    Write-Host "  skills\_shared\$($_.Name)"
}

# GUIDE.md (skill selection reference)
Copy-Item (Join-Path $RepoDir "skills\GUIDE.md") -Destination (Join-Path $InstallDir "skills\GUIDE.md") -Force
Write-Host "  skills\GUIDE.md"

# Each skill folder
Get-ChildItem (Join-Path $RepoDir "skills") -Directory | Where-Object { $_.Name -ne "_shared" } | ForEach-Object {
    $destSkill = Join-Path $InstallDir "skills\$($_.Name)"
    New-Item -ItemType Directory -Force -Path $destSkill | Out-Null
    Copy-Item "$($_.FullName)\*" -Destination $destSkill -Recurse -Force
    Write-Host "  skills\$($_.Name)"
}

Write-Host ""

# ── Agents ────────────────────────────────────────────────────────────────────

New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "agents\_shared") | Out-Null

# _shared conventions (loaded by every agent)
Get-ChildItem (Join-Path $RepoDir "agents\_shared\*.md") | ForEach-Object {
    Copy-Item $_.FullName -Destination (Join-Path $InstallDir "agents\_shared\$($_.Name)") -Force
    Write-Host "  agents\_shared\$($_.Name)"
}

# Each agent file
Get-ChildItem (Join-Path $RepoDir "agents\*.agent.md") | ForEach-Object {
    Copy-Item $_.FullName -Destination (Join-Path $InstallDir "agents\$($_.Name)") -Force
    Write-Host "  agents\$($_.Name)"
}

Write-Host ""

# ── Claude Code: update CLAUDE.md ─────────────────────────────────────────────

if ($Claude) {
    $ClaudeMd = Join-Path $InstallDir "CLAUDE.md"
    $MarkerStart = "<!-- agent-defs:skills:start -->"
    $MarkerEnd   = "<!-- agent-defs:skills:end -->"

    # Build skills table
    $rows = Get-ChildItem (Join-Path $InstallDir "skills") -Directory |
        Where-Object { $_.Name -ne "_shared" } |
        ForEach-Object { "| ``$($_.Name)`` | ``~/.claude/skills/$($_.Name)/SKILL.md`` |" }

    $agentRows = Get-ChildItem (Join-Path $InstallDir "agents\*.agent.md") |
        ForEach-Object {
            $n = $_.Name -replace '\.agent\.md$', ''
            "| ``$n`` | ``~/.claude/agents/$($_.Name)`` |"
        }

    $block = @"
$MarkerStart
## Agent-Defs Skills

The following skills are installed at ``~/.claude/skills/``. When a task matches
a skill's purpose, read the corresponding SKILL.md and follow its instructions.

| Skill | File |
|-------|------|
$($rows -join "`n")

### Agents

| Agent | File |
|-------|------|
$($agentRows -join "`n")
$MarkerEnd
"@

    if (-not (Test-Path $ClaudeMd)) {
        "# Claude Code — Global Instructions`n`n$block" | Set-Content $ClaudeMd -Encoding UTF8
        Write-Host "  Created $ClaudeMd"
    } else {
        $content = Get-Content $ClaudeMd -Raw
        if ($content -match [regex]::Escape($MarkerStart)) {
            $pattern = "(?s)$([regex]::Escape($MarkerStart)).*?$([regex]::Escape($MarkerEnd))"
            $content = $content -replace $pattern, $block
            $content | Set-Content $ClaudeMd -Encoding UTF8
            Write-Host "  Updated skills block in $ClaudeMd"
        } else {
            "`n`n$block" | Add-Content $ClaudeMd -Encoding UTF8
            Write-Host "  Appended skills block to $ClaudeMd"
        }
    }
    Write-Host ""
}

# ── Summary ───────────────────────────────────────────────────────────────────

$skillCount = (Get-ChildItem (Join-Path $InstallDir "skills") -Recurse -Filter "SKILL.md").Count
$agentCount = (Get-ChildItem (Join-Path $InstallDir "agents") -Filter "*.agent.md").Count
Write-Host "Done. $skillCount skills, $agentCount agents installed."
