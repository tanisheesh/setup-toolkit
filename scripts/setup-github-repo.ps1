# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-github-repo.ps1
# Sets description, homepage URL, and topics for ONE GitHub repo.
# Requires a GitHub PAT with `repo` scope.
# Get one at: github.com/settings/tokens → Generate new token (classic) → check `repo`
#
# Usage:
#   .\setup-github-repo.ps1 -Repo "<repo-name>" `
#       -Description "<one-line description>" `
#       -Homepage "https://<subdomain>.tanisheesh.in" `
#       -Topics "nextjs","typescript","ai"
#
# Token: pass -GitHubToken, or set $env:GITHUB_TOKEN, or it will prompt.

param(
    [Parameter(Mandatory)][string]$Repo,
    [Parameter(Mandatory)][string]$Description,
    [string]$Homepage = "",
    [string[]]$Topics = @(),
    [string]$Owner = "tanisheesh",
    [string]$GitHubToken = $env:GITHUB_TOKEN
)

# ── Functions ─────────────────────────────────────────────────────────────────

function Get-Headers {
    @{
        "Authorization" = "Bearer $GitHubToken"
        "Accept"        = "application/vnd.github+json"
        "Content-Type"  = "application/json"
    }
}

function Update-RepoMeta($repo, $homepage, $description) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repo))"
    $body = @{ description = $description }
    if ($homepage -ne "") { $body.homepage = $homepage }
    try {
        Invoke-RestMethod -Method PATCH -Uri $uri -Headers (Get-Headers) -Body ($body | ConvertTo-Json) | Out-Null
        Write-Host "    [Meta]   Description + homepage set" -ForegroundColor Green
    } catch {
        Write-Host "    [Meta]   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Update-RepoTopics($repo, $topics) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repo))/topics"
    $body = @{ names = @($topics) } | ConvertTo-Json
    try {
        Invoke-RestMethod -Method PUT -Uri $uri -Headers (Get-Headers) -Body $body | Out-Null
        Write-Host "    [Topics] $($topics -join ', ')" -ForegroundColor Green
    } catch {
        Write-Host "    [Topics] ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ── Main ──────────────────────────────────────────────────────────────────────

if (-not $GitHubToken) { $GitHubToken = Read-Host "GitHub PAT (github.com/settings/tokens → repo scope)" }

Write-Host "`n━━━ $Owner/$Repo ━━━`n" -ForegroundColor Cyan

Update-RepoMeta $Repo $Homepage $Description
if ($Topics.Count -gt 0) { Update-RepoTopics $Repo $Topics }

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hey@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
