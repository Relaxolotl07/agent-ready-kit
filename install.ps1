<#
.SYNOPSIS
  Install the Agent-Ready Kit. Two independent, additive modes — safe by default.

.EXAMPLE
  ./install.ps1 -Global
      Copies the inert /agent-ready skill + reusable subagents into ~/.claude.
      Does NOT install a global CLAUDE.md. They do nothing until invoked.

.EXAMPLE
  ./install.ps1 -Target "C:\path\to\repo"
      Adds CLAUDE.md, ARCHITECTURE.md, and docs/specs + docs/adr scaffolding to a
      repo. Skips files that already exist (use -Force to overwrite).
#>
param(
  [switch]$Global,
  [string]$Target,
  [switch]$Force
)
$ErrorActionPreference = "Stop"
$kit = $PSScriptRoot

function Copy-IfAbsent($src, $dst) {
  if ((Test-Path $dst) -and -not $Force) { Write-Host "  skip (exists): $dst"; return }
  New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
  Copy-Item -Path $src -Destination $dst -Force
  Write-Host "  wrote: $dst"
}

if (-not $Global -and -not $Target) {
  Write-Host "Nothing to do. Use -Global and/or -Target <repo>. See: ./install.ps1 -?"
  exit 0
}

if ($Global) {
  $claude = Join-Path $HOME ".claude"
  Write-Host "Installing global (inert) pieces into $claude ..."
  $skillSrc = Join-Path $kit "claude\skills\agent-ready\SKILL.md"
  Copy-IfAbsent $skillSrc (Join-Path $claude "skills\agent-ready\SKILL.md")
  Get-ChildItem (Join-Path $kit "claude\agents") -Filter *.md | ForEach-Object {
    Copy-IfAbsent $_.FullName (Join-Path $claude "agents\$($_.Name)")
  }
  Write-Host "Done. `/agent-ready` + subagents are available across repos (inert until invoked)."
  Write-Host "NOTE: global ~/.claude/CLAUDE.md was NOT touched. To adopt cross-project rules,"
  Write-Host "      review and copy claude/global-CLAUDE.md there yourself."
}

if ($Target) {
  if (-not (Test-Path $Target)) { throw "Target not found: $Target" }
  Write-Host "Scaffolding templates into $Target ..."
  Copy-IfAbsent (Join-Path $kit "templates\CLAUDE.md")       (Join-Path $Target "CLAUDE.md")
  Copy-IfAbsent (Join-Path $kit "templates\ARCHITECTURE.md") (Join-Path $Target "ARCHITECTURE.md")
  Get-ChildItem (Join-Path $kit "templates\docs") -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring((Join-Path $kit "templates").Length).TrimStart('\','/')
    Copy-IfAbsent $_.FullName (Join-Path $Target $rel)
  }
  Write-Host "Done. Fill the <PLACEHOLDERS>, add a ci/*-gates.yml, and follow PLAYBOOK.md."
  Write-Host "TIP: with Claude Code installed globally, run `/agent-ready` in the repo to fill these from the actual code."
}
